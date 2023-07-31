class LWCE_XComEngine extends XComEngine
    config(LWCEEngine);

var config array<string> arrDataSets;
var config array<string> arrDataTemplateManagers;

var LWCEContentManager m_kCEContentMgr;
var LWCEModLoader m_kModLoader;

var private array< class<LWCEDataSet> > m_arrDataSets;
var private array<LWCEDataTemplateManager> m_arrDataTemplateManagers;
var private LWCEEventManager m_kEventManager;
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

static function LWCEEventManager GetEventManager()
{
    return LWCE_XComEngine(GetEngine()).m_kEventManager;
}

static function LWCEModLoader GetModLoader()
{
    return LWCE_XComEngine(GetEngine()).m_kModLoader;
}

static function LWCEDataTemplateManager GetTemplateManager(class<LWCEDataTemplateManager> TemplateManagerClass)
{
    local int Index;
    local LWCE_XComEngine kEngine;

    kEngine = LWCE_XComEngine(GetEngine());

    for (Index = 0; Index < kEngine.m_arrDataTemplateManagers.Length; Index++)
    {
        if (kEngine.m_arrDataTemplateManagers[Index].IsA(TemplateManagerClass.name))
        {
            return kEngine.m_arrDataTemplateManagers[Index];
        }
    }

    return none;
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

    `LWCE_LOG_CLS("Initializing data template managers...");
    CreateDataTemplateManagers();

    `LWCE_LOG_CLS("Initializing datasets...");
    LoadDataSetClasses();

    `LWCE_LOG_CLS("Calling CreateTemplates on all datasets...");
    CreateDataSetTemplates();

    `LWCE_LOG_CLS("Calling OnPostTemplatesCreated on all datasets...");
    OnPostTemplatesCreated();

    `LWCE_LOG_CLS("Validating data template managers...");
    ValidateDataTemplateManagers();

    `LWCE_LOG_CLS("Creating content manager...");
    m_kCEContentMgr = new (self) class'LWCEContentManager';
    m_kCEContentMgr.Init();

    `LWCE_LOG_CLS("Creating event manager...");
    m_kEventManager = new (self) class'LWCEEventManager';
}

private function AssignTemplateToManager(LWCEDataTemplate kTemplate)
{
    local bool bAdded;
    local int Index;

    for (Index = 0; Index < m_arrDataTemplateManagers.Length; Index++)
    {
        if (ClassIsChildOf(kTemplate.Class, m_arrDataTemplateManagers[Index].ManagedTemplateClass))
        {
            m_arrDataTemplateManagers[Index].AddDataTemplate(kTemplate);
            bAdded = true;
            break;
        }
    }

    if (!bAdded)
    {
        `LWCE_LOG_CLS("ERROR: could not locate an appropriate template manager for template " $ kTemplate.DataName $ " of class " $ kTemplate.Class.Name $ ". This template will not be usable.");
    }
}

private function CreateDataTemplateManagers()
{
    local int Index;
    local class<LWCEDataTemplateManager> kClass;
    local LWCEDataTemplateManager kTemplateManager;

    `LWCE_LOG_CLS("Attempting to load " $ arrDataTemplateManagers.Length $ " data template managers");

    for (Index = 0; Index < arrDataTemplateManagers.Length; Index++)
    {
        kClass = class<LWCEDataTemplateManager>(DynamicLoadObject(arrDataTemplateManagers[Index], class'Class'));

        if (kClass == none)
        {
            `LWCE_LOG_CLS("ERROR: failed to load template manager with class name '" $ arrDataTemplateManagers[Index] $ "'");
            continue;
        }

        kTemplateManager = new (none) kClass;
        kTemplateManager.InitTemplates();

        m_arrDataTemplateManagers.AddItem(kTemplateManager);
    }

    `LWCE_LOG_CLS("Finished loading " $ m_arrDataTemplateManagers.Length $ " data template managers");
}

private function CreateDataSetTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;
    local int iDataSet, iTemplate;

    for (iDataSet = 0; iDataSet < m_arrDataSets.Length; iDataSet++)
    {
        arrTemplates = m_arrDataSets[iDataSet].static.CreateTemplates();

        `LWCE_LOG_CLS("DataSet class " $ m_arrDataSets[iDataSet].Name $ " generated " $ arrTemplates.Length $ " templates");

        for (iTemplate = 0; iTemplate < arrTemplates.Length; iTemplate++)
        {
            AssignTemplateToManager(arrTemplates[iTemplate]);
        }
    }
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

/// <summary>
/// Loads all of the classes configured in arrDataSets without any further processing.
/// </summary>
private function LoadDataSetClasses()
{
    local class<LWCEDataSet> kDataSet;
    local int Index;

    for (Index = 0; Index < arrDataSets.Length; Index++)
    {
        kDataSet = class<LWCEDataSet>(DynamicLoadObject(arrDataSets[Index], class'Class'));

        if (kDataSet == none)
        {
            `LWCE_LOG_CLS("ERROR: could not load configured LWCEDataSet class " $ arrDataSets[Index]);
            continue;
        }

        m_arrDataSets.AddItem(kDataSet);
    }
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

private function OnPostTemplatesCreated()
{
    local int Index;

    for (Index = 0; Index < m_arrDataSets.Length; Index++)
    {
        m_arrDataSets[Index].static.OnPostTemplatesCreated();
    }
}

private function ValidateDataTemplateManagers()
{
    local bool bAnyInvalid;
    local int Index;

    bAnyInvalid = true;

    while (bAnyInvalid)
    {
        bAnyInvalid = false;

        for (Index = 0; Index < m_arrDataTemplateManagers.Length; Index++)
        {
            bAnyInvalid = !m_arrDataTemplateManagers[Index].ValidateAndFilterTemplates() || bAnyInvalid;
        }

        if (bAnyInvalid)
        {
            `LWCE_LOG_CLS("One or more template managers had invalid templates. Validating all template managers again to check for newly-invalidated dependencies.");
        }
    }
}

defaultproperties
{
    OnlineEventMgrClassName="XComLongWarCommunityEdition.LWCE_XComOnlineEventMgr"
}