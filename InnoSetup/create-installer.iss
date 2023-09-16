; Inno Setup Script file for generating the LWCE installer for Windows.
;
; To use this, you must set the environment variable LWCE_UDKGAME_PATH. It
; should point to the UDKGame folder in your UDK installation, such that
; $LWCE_UDKGAME_PATH/Script/XComLongWarCommunityEdition.u is a valid path.
;
; Be sure to manually build an up-to-date .u file before executing this script.                         

#define MyAppName "Long War Community Edition"
#define MyAppVersion "0.0.2"
#define MyAppPublisher "SwfDelicious"
#define MyAppURL "https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/"

; Bytestring replacements in XComEW.exe.
; All bytes are specified

; PURPOSE: forgotten
; ORIGINAL:  0xA9 0xCE 0x07 0x00 0x00 0x0F 0x84 0xCC 0x01 0x00 0x00
; NEW VALUE: 0xA9 0xCE 0x07 0x00 0x00 0x0F 0x89 0xCC 0x01 0x00 0x00
; #define REPLACE_BYTESTRING_1 [ ]

; ORIGINAL:  0x39 0x7E 0xFC 0x75 0x43 0x8B 0x0D 0xEC 0x7D 
; NEW VALUE: 0x39 0x7E 0xFC 0xEB 0x43 0x8B 0x0D 0xEC 0x7D

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{4B2BF6E7-F4B9-4420-9C9D-BF23EA007FB8}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\Long War Community Edition
DefaultGroupName={#MyAppName}
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputBaseFilename=long-war-community-edition-setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\LWCE_Core\Config\*"; DestDir: "{app}\Config"; Flags: ignoreversion 
Source: "..\LWCE_Core\Localization\*"; DestDir: "{app}\Localization"; Flags: ignoreversion  recursesubdirs createallsubdirs
Source: "..\LWCE_Core\Patches\*.upatch"; DestDir: "{app}\UPK patches"; Flags: ignoreversion 
Source: "{#GetEnv('LWCE_UDKGAME_PATH')}\Script\XComLongWarCommunityEdition.u"; DestDir: "{app}\CookedPCConsole"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]
var 
  XComDirPage: TInputDirWizardPage;

function ModifyGameExecutable(PathToExe: String): Boolean; forward;

{ Add our custom page to the install wizard }
procedure InitializeWizard();
var 
  RegKey: integer;
  XComDir: string;
begin
  XComDirPage := CreateInputDirPage(wpSelectDir,
    'Select XCOM Game Directory', 'Where is XCOM: Enemy Within installed?',
    'Select the folder where XCOM: Enemy Within is installed, then click Next. (This should be the top-level XCom-Enemy-Unknown folder.)',
    False, '');
  XComDirPage.Add('');

  { Restore values from the last time we ran, otherwise try to find smart defaults } 
  XComDirPage.Values[0] := GetPreviousData('XComDir', '');

  if IsWin64 Then RegKey := HKEY_LOCAL_MACHINE_64 Else RegKey := HKEY_LOCAL_MACHINE_32;

  if (XComDirPage.Values[0] = '') then begin
    if RegQueryStringValue(RegKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 200510', 'InstallLocation', XComDir) then begin
      XComDirPage.Values[0] := XComDir;
    end;
  end;
end;

{ Store the user's input so it can auto-populate if they run install again, e.g. to update }
procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'XComDir', XComDirPage.Values[0]); 
end;

{ Validate that we can move past our custom pages }
function NextButtonClick(CurPageID: Integer): Boolean;
var 
  XComDir: string;
begin
  Result := True;

  if (CurPageID = XComDirPage.ID) then begin
    XComDir := AddBackslash(XComDirPage.Values[0]);

    if not DirExists(XComDir) then begin
      MsgBox('You must select the XCOM installation directory to continue.', mbError, MB_OK);
      Result := False;
    end else if not DirExists(XComDir + 'XEW') then begin
      MsgBox('Directory is invalid, or you do not have the Enemy Within expansion, which is required to install.', mbError, MB_OK);
      Result := False;
    end else if not FileExists(XComDir + 'XEW\XComGame\CookedPCConsole\LongWar.upk') then begin
      MsgBox('Long War does not appear to be installed. You must install Long War 1.0 from Nexus Mods before installing LWCE.', mbError, MB_OK);
      Result := False;
    end
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
    if (CurStep = ssInstall) then begin
      ModifyGameExecutable(AddBackslash(XComDirPage.Values[0]) + 'XEW\Binaries\Win32\XComEW.exe');
    end;
end;

{ Copied from https://stackoverflow.com/a/38618255 
  External function definition to convert a hex string to a byte buffer }
function CryptStringToBinary(
  sz: String; cch: LongWord; flags: LongWord; binary: String; var size: LongWord;
  skip: LongWord; flagsused: LongWord): Integer;
  external 'CryptStringToBinaryW@crypt32.dll stdcall';

const CRYPT_STRING_HEX = $04; { Pass to CryptStringToBinary as the flags argument }

function HexToBinaryBuffer(Hex: String; var Size: LongWord): String;
var
  Buffer: String;
  BufferSize: Integer;
begin
  { Divide hex string by 4 (2 hex characters per byte, 2 bytes per character due to UTF-8 encoding
    Add one character for null terminator }
  BufferSize := (Length(Hex) div 4) + 1;
  SetLength(Buffer, BufferSize);

  Size := Length(Hex) div 2;

  if (CryptStringToBinary(Hex, Length(Hex), CRYPT_STRING_HEX, Buffer, Size, 0, 0) = 0) or (Size <> Length(Hex) div 2) then begin
    RaiseException('Failed to convert hex string to binary buffer');
  end;

  Result := Buffer;
end;

{ Modifies XComEW.exe with the necessary binary changes to support LWCE features }
function ModifyGameExecutable(PathToExe: String): Boolean;
var 
  Stream: TFileStream;
  Buffer: String;
  Offset: Integer;
  Size: LongWord;
begin
  Stream := TFileStream.Create(PathToExe, fmOpenReadWrite);

  try
    { Original hex:              A9CE0700000F84CC010000 }
    Buffer := HexToBinaryBuffer('A9CE0700000F89CC010000', Size);
    Offset := $8701AA;

    Stream.Seek(Offset, soFromBeginning);
    Stream.WriteBuffer(Buffer, Size);
  finally
    Stream.Free;
  end;

  Result := True;
end;