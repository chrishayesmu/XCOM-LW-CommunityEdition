class LWCE_XComEngine extends XComEngine;

var private bool m_bInitialized;

static function DownloadableContentEnumerator LWCE_GetDLCEnumerator()
{
    local LWCE_XComEngine kEngine;

    kEngine = LWCE_XComEngine(GetEngine());

    if (kEngine.DLCEnumerator == none)
    {
        kEngine.DLCEnumerator = new (kEngine) class'DownloadableContentEnumerator';
        kEngine.DLCEnumerator.DLCRootDir = "../../XComGame/Mods/";
    }

    return kEngine.DLCEnumerator;
}

static function DownloadableContentManager LWCE_GetDLCManager()
{
    local LWCE_XComEngine kEngine;

    kEngine = LWCE_XComEngine(GetEngine());

    if (kEngine.DLCManager == none)
    {
        // We need to make sure the enumerator is initialized first, because the DLCManager will look for it
        LWCE_GetDLCEnumerator();

        kEngine.DLCManager = new (kEngine) class'DownloadableContentManager';
        kEngine.DLCManager.Init();
    }

    return kEngine.DLCManager;
}

// There aren't really any good hooks for us to initialize the engine, but building localization happens pretty
// early on, so we just go ahead and ride on this.
event BuildLocalization()
{
    super.BuildLocalization();

    LWCE_Init();
}

function LWCE_Init()
{
    // The engine doesn't like installing mods more than once, so be careful that we don't
    if (m_bInitialized)
    {
        return;
    }

    m_bInitialized = true;

    `LWCE_LOG_CLS("Beginning initialization of LWCE engine...");

    `LWCE_LOG_CLS("Searching for mods to install...");
    InstallMods();
}

/// <summary>
/// Starts the installation process for LWCE mods. All mods are expected to be subdirectories of XEW/XComGame/Mods.
/// Currently, any mod listed under there will be installed;
/// </summary>
private function InstallMods()
{
    local DownloadableContentEnumerator kDLCEnum;
    local DownloadableContentManager kDLCManager;

    // Add our delegate just for some logging; the actual installation is completely
    // handled by RefreshDLC below. Eventually we can extend this to only loading mods
    // we want active, based on some external input.
    kDLCEnum = LWCE_GetDLCEnumerator();
    kDLCEnum.AddFindDLCDelegate(OnFindDLCComplete);

    // Start the actual installation. By default, this won't work. The native functions will calculate a
    // CRC for the "DLC" files, and when it doesn't match, those mods will be ignored and never get installed.
    // To make this work, you need the corresponding exe modifications performed in the installation process,
    // which simply make the outcome of the CRC check irrelevant.
    kDLCManager = LWCE_GetDLCManager();
    kDLCManager.RefreshDLC();
}

private function OnFindDLCComplete()
{
    local int Index;
    local DownloadableContentEnumerator kDLCEnum;

    // We just do a little logging here for user friendliness, the mods are already fully installed at this point
    kDLCEnum = LWCE_GetDLCEnumerator();

    `LWCE_LOG_CLS("Found " $ kDLCEnum.DLCBundles.Length $ " mods to load.");

    for (Index = 0; Index < kDLCEnum.DLCBundles.Length;  Index++)
    {
        `LWCE_LOG_CLS("Found mod #" $ (Index + 1) $ ": " $ kDLCEnum.DLCBundles[Index].FriendlyName $ ". Path is " $ kDLCEnum.DLCBundles[Index].ContentPath);
    }

    // Extremely important to clear this delegate; otherwise when we change maps, garbage collection will fail due to
    // lingering references to old map objects, because DLCEnum is owned by the engine
    kDLCEnum.ClearFindDLCDelegate(OnFindDLCComplete);
}

defaultproperties
{
    OnlineEventMgrClassName="XComLongWarCommunityEdition.LWCE_XComOnlineEventMgr"
}