#Requires -RunAsAdministrator
# We have to run as admin because you can't make directory junction symlinks without it

$folders = @("Core", "Engine", "GFxUI", "UDKBase", "XComGame", "XComUIShell", "XComStrategyGame", "XComMutator", "XComLZMutator")

Write-Output ""
Write-Output "+------------------------------------------------------------------------------------------------------+"
Write-Output "| Welcome to the Long War: Community Edition developer setup script. This script will modify your UDK  |"
Write-Output "| installation so that you're ready to build LWCE from scratch.                                        |"
Write-Output "|                                                                                                      |"
Write-Output "| It will also modify your XCOM: Enemy Within installation directory, setting up symlinks for LWCE.    |"
Write-Output "| If you also want an ordinary Long War install, you may wish to back up the folder before proceeding. |"
Write-Output "|                                                                                                      |"
Write-Host   "+=========================================== Prerequisites ============================================+" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "|                                                                                                      |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "|                              Install the UDK as per the project README.                              |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "|                             Install LWCE as if you were going to play it.                            |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "|                              Cancel this script if prereqs are not met.                              |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "|                                                                                                      |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host   "+------------------------------------------------------------------------------------------------------+" -ForegroundColor Yellow -BackgroundColor Black
Write-Output ""

#######################################################
# Validating script setup and UDK/game location
#######################################################

$stubsFolder = Get-Item "../Stubs/"

if (!($stubsFolder -is [System.IO.DirectoryInfo]))
{
    Write-Error "Couldn't find LWCE's Stubs folder (make sure to run this script from its containing folder)"
    exit
}

$udkSrcPath = Read-Host "Enter path to the UDK's Src directory (e.g. C:\UDK\Development\Src)"

if ([string]::IsNullOrWhiteSpace($udkSrcPath))
{
    exit
}

$udkSrcFolder = Get-Item -LiteralPath $udkSrcPath -ErrorAction "ignore"

if (!($udkSrcFolder -is [System.IO.DirectoryInfo]))
{
    Write-Error "Path given is not a directory: ${udkSrcPath}"
    exit
}

if ($udkSrcFolder.FullName -notmatch "\\Src$")
{
    Write-Error "Path given doesn't appear to be the Src directory: $($udkSrcFolder.FullName)" -
    exit
}

$udkIniPath = Join-Path -Path $udkSrcPath -ChildPath "../../UDKGame/Config/DefaultEngine.ini" | Convert-Path
$udkIni = Get-Item -LiteralPath $udkIniPath -ErrorAction "ignore"

if (!($udkIni -is [System.IO.FileInfo]))
{
    Write-Error "Failed to find DefaultEngine.ini at ${udkIniPath}"
    exit
}

$udkScriptPath = Join-Path -Path $udkSrcPath -ChildPath "../../UDKGame/Script/" | Convert-Path
$xcomGamePath = Read-Host "Enter path to the XComGame directory (e.g. C:\Steam\steamapps\common\XCom-Enemy-Unknown\XEW\XComGame)"
$xcomGameFolder = Get-Item -LiteralPath $xcomGamePath -ErrorAction "ignore"

if (!($xcomGameFolder -is [System.IO.DirectoryInfo]))
{
    Write-Error "Path given is not a directory: ${xcomGamePath}"
    exit
}

if (!$xcomGamePath.Contains("XEW"))
{
    Write-Error "XComGame path doesn't appear to be for Enemy Within. Double check that you're using the path with 'XEW' in it."
    exit
}

#######################################################
# Creating symlinks to our stubs
#######################################################

Write-Output ""
Write-Output "==== Creating symlinks to LWCE stubs and source code ===="

foreach ($folder in $folders)
{
    $newSourcePath = Join-Path -Path $stubsFolder.FullName -ChildPath $folder
    $newDestPath = Join-Path -Path $udkSrcFolder.FullName -ChildPath $folder

    if (Test-Path $newDestPath)
    {
        $backupPath = "${newDestPath}-backup"

        if (Test-Path $backupPath)
        {
            Write-Warning "Destination path $newDestPath already exists, as does a backup at $(Split-Path $backupPath -Leaf). Ignoring this folder."
            continue
        }

        Write-Output "Making backup of existing folder ${newDestPath}"
        Rename-Item -Path $newDestPath -NewName $backupPath
    }

    Write-Output ""
    Write-Output "Symlinking from ${newSourcePath} to ${newDestPath}"

    New-Item -ItemType Junction -Target $newSourcePath -Path $newDestPath | Out-Null
}

Write-Output ""
Write-Host "All symlinks have been created." -ForegroundColor Green

#######################################################
# TODO: we should set up the directories for all of our bundled mods here,
# but since they don't actually build right now, we're skipping it
#######################################################


#######################################################
# Updating DefaultEngine.ini to point to our packages
#######################################################

Write-Output ""
Write-Output "==== Modifying UDK configuration to include XCom packages ===="
Write-Output ""

$sourceIniPath = Join-Path -Path $stubsFolder -ChildPath "DefaultEngine.ini"
Write-Output "Replacing the ini file located at $($udkIni.FullName) with the file at ${sourceIniPath}"
Copy-Item -Path $sourceIniPath -Destination $udkIniPath

Write-Output ""
Write-Host "UDK is now configured." -ForegroundColor Green

#######################################################
# Kick off the initial build. We need our script file to exist
# in order to symlink it in the game directory.
#######################################################

Write-Output ""
Write-Output "To proceed, we must build Long War: Community Edition now. This generates the script file (XComLongWarCommunityEdition.u) which we need for the next setup step."

$makePath = Join-Path -Path $udkSrcPath -ChildPath "../../Binaries/Win32/udk.exe" | Convert-Path

Write-Output ""
Write-Output "Building involves executing the following command:"
Write-Output ""
Write-Output "        ${makePath} make"
Write-Output ""
Write-Output "After the command completes, you can return to this window to continue the setup script."
Write-Output ""

$confirmation = Read-Host "Do you want to run this now? (y/n; n will end setup)"

if ($confirmation -ne "y")
{
    Write-Output ""
    Write-Output "Cannot proceed without running make. Ending setup now."
    Write-Output ""
    exit

}

Write-Output ""
Write-Output "UDK output will open in a new window. After it completes successfully, return to this window and press any key."
& "${makePath}" "make"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); # wait for any key press

#######################################################
# Create symlinks within the game directory
#######################################################

Write-Output ""
Write-Output "==== Setting up LWCE files within the XComGame folder ===="
Write-Output ""

# Script file

Write-Output "Adding symlink for XComLongWarCommunityEdition.u within XComGame/CookedPCConsole"
$target = Join-Path -Path $udkScriptPath -ChildPath "XComLongWarCommunityEdition.u"
$destination = Join-Path -Path $xcomGamePath -ChildPath "CookedPCConsole/XComLongWarCommunityEdition.u"
New-Item -ItemType SymbolicLink -Target $target -Path $destination -Force | Out-Null

# ini files
Write-Output ""

$lwceConfigDir = Join-Path -Path $stubsFolder -ChildPath "../LWCE_Core/Config/" | Convert-Path
$xcomConfigDir = Join-Path -Path $xcomGamePath -ChildPath "Config"

Get-ChildItem -Path "${lwceConfigDir}*" -Include *.ini |
ForEach-Object {
    $iniName = Split-Path $_.FullName -Leaf
    $target = Join-Path -Path $lwceConfigDir -ChildPath $iniName
    $destination = Join-Path -Path $xcomConfigDir -ChildPath $iniName
    Write-Output "Linking config file ${iniName}"
    New-Item -ItemType SymbolicLink -Target $target -Path $destination -Force | Out-Null
}

# Localization files
Write-Output ""
$lwceLocalizationDir = Join-Path -Path $stubsFolder -ChildPath "../LWCE_Core/Localization/" | Convert-Path
$xcomLocalizationDir = Join-Path -Path $xcomGamePath -ChildPath "Localization"

Get-ChildItem -Path "${lwceLocalizationDir}*" -Directory |
ForEach-Object {
    $language = Split-Path $_.FullName -Leaf
    $childPath = "${language}/XComLongWarCommunityEdition.$($language.ToLower())"
    $target = Join-Path -Path $lwceLocalizationDir -ChildPath $childPath
    $destination = Join-Path -Path $xcomLocalizationDir -ChildPath $childPath

    Write-Output "Linking localization file ${childPath}"
    New-Item -ItemType SymbolicLink -Target $target -Path $destination -Force | Out-Null
}

Write-Output ""
Write-Host "XComGame has been set up with LWCE assets." -ForegroundColor Green

#######################################################
# Complete: display status and next steps
#######################################################


Write-Output ""
Write-Host   "+------------------------------------------------------------------------------------------------------+" -ForegroundColor Green
Write-Host   "|                                            Setup complete!                                           |" -ForegroundColor Green
Write-Host   "+------------------------------------------------------------------------------------------------------+" -ForegroundColor Green
Write-Output ""
Write-Output "If you launch the game, you should now be using all local assets! Config and localization changes will be automatically reflected the next time you boot the game. UnrealScript changes will require you to build."
Write-Output ""