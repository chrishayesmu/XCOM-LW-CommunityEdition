class LWCEModLoader extends Object
    config(LWCEEngine)
    dependson(LWCEModBase, LWCETypes);

// List of which mods to load (by name), in the order they should be loaded.
var config array<name> arrEnabledMods;

var array<LWCEModBase> LoadedMods;
var array<name> LoadedModNames; // simple cache for speedy lookup

var private bool m_bModsLoaded;

/// <summary>
/// Checks whether a mod with the given identifier is both installed and enabled by the player.
/// </summary>
function bool IsModEnabled(name ModName)
{
    return LoadedModNames.Find(ModName) != INDEX_NONE;
}

/// <summary>
/// Loads all of the enabled mods. Mods should never call this function.
/// </summary>
function LoadMods()
{
    local DownloadableContentEnumerator kDLCEnum;

    if (m_bModsLoaded)
    {
        `LWCE_LOG_ERROR("Something is trying to load mods more than once!");
        ScriptTrace();
        return;
    }

    m_bModsLoaded = true;
    kDLCEnum = class'LWCE_XComEngine'.static.LWCE_GetDLCEnumerator();
    kDLCEnum.AddFindDLCDelegate(OnFindDLCComplete);
    kDLCEnum.FindDLC();
}

protected function OnFindDLCComplete()
{
    local int Index;
    local DownloadableContentEnumerator kDLCEnum;

    kDLCEnum = class'LWCE_XComEngine'.static.LWCE_GetDLCEnumerator();
    kDLCEnum.ClearFindDLCDelegate(OnFindDLCComplete);

    `LWCE_LOG("Initializing with " $ kDLCEnum.DLCBundles.Length $ " mod(s) to load");

    // TODO: sort and filter mods using arrEnabledMods, to control load order
    // TODO: use DownloadableContentManager.InstallDLCs to do them all at once after filtering
    for (Index = 0; Index < kDLCEnum.DLCBundles.Length; Index++)
    {
        `LWCE_LOG_VERBOSE("DLCBundle " $ Index $
                          ": FriendlyName = " $ kDLCEnum.DLCBundles[Index].FriendlyName $
                          "; Filename = " $ kDLCEnum.DLCBundles[Index].Filename $
                          "; UserIndex = " $ kDLCEnum.DLCBundles[Index].UserIndex $
                          "; bIsCorrupt = " $ kDLCEnum.DLCBundles[Index].bIsCorrupt $
                          "; DeviceID = " $ kDLCEnum.DLCBundles[Index].DeviceID $
                          "; LicenseMask = " $ kDLCEnum.DLCBundles[Index].LicenseMask $
                          "; ContentType = " $ kDLCEnum.DLCBundles[Index].ContentType $
                          "; ContentPath = " $ kDLCEnum.DLCBundles[Index].ContentPath $
                          "; contains " $ kDLCEnum.DLCBundles[Index].ContentFiles.Length $ " content files" $
                          "; contains " $ kDLCEnum.DLCBundles[Index].ContentPackages.Length $ " content packages");

        LoadMod(kDLCEnum.DLCBundles[Index].FriendlyName);
    }

    `LWCE_LOG(LoadedMods.Length $ " mod(s) were loaded successfully");
}

private function LoadMod(string ModPackageName)
{
    local Class ModClass;
    local LWCEModBase Mod;
    local string ModClassName;

    // Start the actual installation. By default, this won't work. The native functions will calculate a
    // CRC for the "DLC" files, and when it doesn't match, those mods will be ignored and never get installed.
    // To make this work, you need the corresponding exe modifications performed in the installation process,
    // which simply make the outcome of the CRC check irrelevant.

    ModClassName = ModPackageName $ "." $ ModPackageName $ "Mod";
    ModClass = class<LWCEModBase>(DynamicLoadObject(ModClassName, class'Class'));

    if (ModClass == none)
    {
        `LWCE_LOG_ERROR("ERROR, could not load mod by class name " $ ModClassName);
        return;
    }

    `LWCE_LOG_VERBOSE("Successfully loaded mod package " $ ModPackageName);

    Mod = LWCEModBase(new (self) ModClass);

    if (Mod == none)
    {
        `LWCE_LOG_ERROR("ERROR, failed to create mod object from class variable!");
        return;
    }

    `LWCE_LOG_VERBOSE("Mod's friendly name is " $ Mod.ModFriendlyName $ ", " $ VersionToString(Mod.VersionInfo));

    Mod.OnModLoaded();
    LoadedMods.AddItem(Mod);
}

private function string VersionToString(TModVersion Version)
{
    return "v" $ Version.Major $ "." $ Version.Minor $ "." $ Version.Revision;
}