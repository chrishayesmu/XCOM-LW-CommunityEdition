class HighlanderModLoader extends Mutator
    config(HighlanderMods)
    dependson(HighlanderModBase);

var config array<string> arrModClasses;

var privatewrite bool bInited;
var privatewrite array<HighlanderModBase> LoadedMods;

var private array<HighlanderStrategyListener> StrategyListeners;
var private array<HighlanderTacticalListener> TacticalListeners;

const bEnableDebugLogging = true;

static function HighlanderModLoader GetModLoader()
{
    local HighlanderModLoader ModLoader;

    foreach class'Engine'.static.GetCurrentWorldInfo().DynamicActors(class'HighlanderModLoader', ModLoader)
    {
        return ModLoader;
    }

    return none;
}

function InitMutator(string Options, out string ErrorMessage)
{
    local bool bStrategy, bTactical;
    local string ModClassName;

    bStrategy = IsInStrategyGame();
    bTactical = IsInTacticalGame();

    if (!bInited)
    {
        bInited = true;
        `HL_LOG_CLS("Initializing with " $ arrModClasses.Length $ " mod(s) to load");

        foreach arrModClasses(ModClassName)
        {
            LoadMod(ModClassName);
        }

        `HL_LOG_CLS(LoadedMods.Length $ " mods were loaded successfully");

        if (bStrategy)
        {
            `HL_LOG_CLS("Loading strategy listeners");
            LoadStrategyListeners();
            `HL_LOG_CLS("Loaded " $ StrategyListeners.Length $ " strategy listeners");
        }
        else if (bTactical)
        {
            `HL_LOG_CLS("Loading tactical listeners");
            LoadTacticalListeners();
            `HL_LOG_CLS("Loaded " $ TacticalListeners.Length $ " tactical listeners");
        }
    }

    super.InitMutator(Options, ErrorMessage);
}

function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    // Always keep the mod loader mutator loaded
    // TODO: I'm not sure this is doing anything at all, might not be respected by XCOM
    ActorList[ActorList.length] = self;

	if (NextMutator != None)
	{
		NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
	}
}

function LoadStrategyListeners()
{
    local HighlanderModBase kMod;
    local HighlanderStrategyListener kStrategyListener;

    StrategyListeners.Remove(0, StrategyListeners.Length);

    foreach LoadedMods(kMod)
    {
        if (kMod.StrategyListenerClass != none)
        {
            kStrategyListener = Spawn(kMod.StrategyListenerClass);

            if (kStrategyListener != none)
            {
                StrategyListeners.AddItem(kStrategyListener);
            }
        }
    }
}

function LoadTacticalListeners()
{
    local HighlanderModBase kMod;
    local HighlanderTacticalListener kTacticalListener;

    TacticalListeners.Remove(0, TacticalListeners.Length);

    foreach LoadedMods(kMod)
    {
        if (kMod.TacticalListenerClass != none)
        {
            kTacticalListener = Spawn(kMod.TacticalListenerClass);

            if (kTacticalListener != none)
            {
                TacticalListeners.AddItem(kTacticalListener);
            }
        }
    }
}

static function bool IsInStrategyGame()
{
    return `HQGAME != none;
}

static function bool IsInTacticalGame()
{
    return XComTacticalGRI(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI)) != none;
}

// #region Mod event entry points

// These functions should be called by the Highlander (or sometimes, by mods) to indicate that an event has occurred which mods
// would be interested in or can modify in some way. Each of these will cause a matching function in HighlanderModBase to be called
// in each enabled mod.

// #region Foundry-related events

function bool Override_HasFoundryPrereqs(HL_TFoundryTech kTech)
{
    local int iHasPrereqs;
    local HighlanderStrategyListener kStrategyListener;

    iHasPrereqs = 1;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_HasFoundryPrereqs(kTech, iHasPrereqs);
    }

    return iHasPrereqs != 0;
}

function OnFoundryProjectAddedToQueue(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectAddedToQueue(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCanceled(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectCanceled(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCompleted(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectCompleted(kProject, kFoundryTech);
    }
}

function OnFoundryTechsBuilt(out array<HL_TFoundryTech> arrTechs)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryTechsBuilt(arrTechs);
    }
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, Highlander_XGFacility_Engineering kEngineering)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
    }
}

// #endregion

// #region Item-related events

function Override_GetItem(out HL_TItem kItem, int iTransactionType)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_GetItem(kItem, iTransactionType);
    }
}

function bool Override_GetInfinitePrimary(XGStrategySoldier kSoldier, out int iItemId)
{
    local bool bAnyTrue;
    local HighlanderStrategyListener kStrategyListener;

    bAnyTrue = false;

    foreach StrategyListeners(kStrategyListener)
    {
        bAnyTrue = kStrategyListener.Override_GetInfinitePrimary(kSoldier, iItemId) || bAnyTrue;
    }

    return bAnyTrue;
}

function bool Override_GetInfiniteSecondary(XGStrategySoldier kSoldier, out int iItemId)
{
    local bool bAnyTrue;
    local HighlanderStrategyListener kStrategyListener;

    bAnyTrue = false;

    foreach StrategyListeners(kStrategyListener)
    {
        bAnyTrue = kStrategyListener.Override_GetInfiniteSecondary(kSoldier, iItemId) || bAnyTrue;
    }

    return bAnyTrue;
}

function OnItemCompleted(HL_TItemProject kItemProject, int iQuantity, optional bool bInstant)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnItemCompleted(kItemProject, iQuantity, bInstant);
    }
}

function OnItemsBuilt(out array<HL_TItem> arrItems)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnItemsBuilt(arrItems);
    }
}

// #endregion

// #region Research-related events

function Override_GetTech(out HL_TTech kTech, bool bIncludesProgress)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_GetTech(kTech, bIncludesProgress);
    }
}

function bool Override_HasPrereqs(HL_TTech kTech)
{
    local int iHasPrereqs;
    local HighlanderStrategyListener kStrategyListener;

    iHasPrereqs = 1;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_HasPrereqs(kTech, iHasPrereqs);
    }

    return iHasPrereqs != 0;
}

function OnResearchCompleted(int iTech)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchCompleted(iTech);
    }
}

function OnResearchStarted(int iTech)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchStarted(iTech);
    }
}

function OnResearchTechsBuilt(out array<HL_TTech> Techs)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchTechsBuilt(Techs);
    }
}

// #endregion

// #region Miscellaneous events

function PopulateAlert(int iAlertId, TGeoscapeAlert kGeoAlert, out TMCAlert kAlert)
{
    local HighlanderStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.PopulateAlert(iAlertId, kGeoAlert, kAlert);
    }
}


// #endregion

private function LoadMod(string ModClassName)
{
    local Class ModClass;
    local HighlanderModBase Mod;
    local string ErrorMsg;

    ModClass = class<HighlanderModBase>(DynamicLoadObject(ModClassName, class'Class'));

    if (ModClass == none)
    {
        `HL_LOG_CLS("ERROR, could not load mod by class name " $ ModClassName);
        return;
    }

    `HL_LOG_CLS("Successfully loaded mod class " $ ModClassName);

    Mod = HighlanderModBase(new (self) ModClass);

    if (Mod == none)
    {
        `HL_LOG_CLS("ERROR, failed to create mod object from class variable!");
        return;
    }

    `HL_LOG_CLS("Mod's friendly name is " $ Mod.ModFriendlyName $ ", " $ VersionToString(Mod.VersionInfo));
    `HL_LOG_CLS("Mod's registered ID range is " $ RangeToString(Mod.ModIDRange));

    if (!ValidateModIDRange(Mod.ModIDRange, ErrorMsg))
    {
        `HL_LOG_CLS("ERROR, mod's ID range is not valid and this mod will not be enabled! " $ ErrorMsg);
        return;
    }

    Mod.OnModLoaded();
    LoadedMods.AddItem(Mod);
}

private function string RangeToString(HL_TRange Range)
{
    return "[" $ Range.MinInclusive $ "-" $ Range.MaxInclusive $ "]";
}

private function bool ValidateModIDRange(HL_TRange Range, out string Error)
{
    local int RangeSize;

    if (Range.MinInclusive >= Range.MaxInclusive)
    {
        Error = "Range is improperly defined (Min >= Max).";
        return false;
    }

    if (Range.MinInclusive < 0 || Range.MaxInclusive < 0)
    {
        Error = "Negative values are not allowed in ID ranges.";
        return false;
    }

    if (Range.MinInclusive <= 99999)
    {
        Error = "IDs from 0 to 99999 are reserved by the Highlander.";
        return false;
    }

    if (Range.MaxInclusive >= 2147000000)
    {
        Error = "IDs from 2,147,000,000 to 2,147,483,647 are reserved by the Highlander.";
        return false;
    }

    RangeSize = Range.MaxInclusive - Range.MinInclusive + 1;

    if ( (RangeSize % 10000) != 0)
    {
        Error = "All ID ranges must be in increments of 10,000.";
        return false;
    }

    return true;
}

private function string VersionToString(TModVersion Version)
{
    return "v" $ Version.Major $ "." $ Version.Minor $ "." $ Version.Revision;
}