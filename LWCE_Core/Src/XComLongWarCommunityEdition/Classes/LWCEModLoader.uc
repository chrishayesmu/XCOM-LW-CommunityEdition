class LWCEModLoader extends Object
    dependson(LWCEModBase);

var array<LWCEModBase> LoadedMods;

function LoadMods()
{
    local DownloadableContentEnumerator kDLCEnum;

    // We need to do FindDLC again, even though we could get the DLCBundles data that has
    // already been loaded when we installed mods in the first place. The reason is that after
    // FindDLC, something tries to localize the mod names and fails, leaving mangled data behind
    // that we can't make use of.
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

    `LWCE_LOG_CLS("Initializing with " $ kDLCEnum.DLCBundles.Length $ " mod(s) to load");

    for (Index = 0; Index < kDLCEnum.DLCBundles.Length; Index++)
    {
        LoadMod(kDLCEnum.DLCBundles[Index].FriendlyName);
    }

    `LWCE_LOG_CLS(LoadedMods.Length $ " mod(s) were loaded successfully");
}

private function LoadMod(string ModPackageName)
{
    local Class ModClass;
    local LWCEModBase Mod;
    local string ModClassName;

    ModClassName = ModPackageName $ "." $ ModPackageName $ "Mod";
    ModClass = class<LWCEModBase>(DynamicLoadObject(ModClassName, class'Class'));

    if (ModClass == none)
    {
        `LWCE_LOG_CLS("ERROR, could not load mod by class name " $ ModClassName);
        return;
    }

    `LWCE_LOG_CLS("Successfully loaded mod package " $ ModPackageName);

    Mod = LWCEModBase(new (self) ModClass);

    if (Mod == none)
    {
        `LWCE_LOG_CLS("ERROR, failed to create mod object from class variable!");
        return;
    }

    `LWCE_LOG_CLS("Mod's friendly name is " $ Mod.ModFriendlyName $ ", " $ VersionToString(Mod.VersionInfo));

    Mod.OnModLoaded();
    LoadedMods.AddItem(Mod);
}

private function string VersionToString(TModVersion Version)
{
    return "v" $ Version.Major $ "." $ Version.Minor $ "." $ Version.Revision;
}