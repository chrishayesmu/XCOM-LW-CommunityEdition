class HighlanderModLoader extends Mutator
    config(HighlanderMods)
    dependson(HighlanderModBase);

var config array<string> arrModClasses;

var privatewrite bool bInited;
var privatewrite array<HighlanderModBase> LoadedMods;

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
    local string ModClassName;

    if (!bInited)
    {
        bInited = true;
        `HL_LOG_CLS("Initializing with " $ arrModClasses.Length $ " mod(s) to load");

        foreach arrModClasses(ModClassName)
        {
            LoadMod(ModClassName);
        }
    }

    super.InitMutator(Options, ErrorMessage);
}

function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    `HL_LOG_CLS("In GetSeamlessTravelActorList", bEnableDebugLogging);

    // Always keep the mod loader mutator loaded
    ActorList[ActorList.length] = self;

	if (NextMutator != None)
	{
		NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
	}
}

// #region Mod event entry points

// These functions should be called by the Highlander (or sometimes, by mods) to indicate that an event has occurred which mods
// would be interested in or can modify in some way. Each of these will cause a matching function in HighlanderModBase to be called
// in each enabled mod.

function OnFoundryProjectAddedToQueue(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderModBase kModBase;

    `HL_LOG_CLS("OnFoundryProjectAddedToQueue", bEnableDebugLogging);

    foreach LoadedMods(kModBase)
    {
        kModBase.OnFoundryProjectAddedToQueue(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCanceled(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderModBase kModBase;

    `HL_LOG_CLS("OnFoundryProjectCanceled", bEnableDebugLogging);

    foreach LoadedMods(kModBase)
    {
        kModBase.OnFoundryProjectCanceled(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCompleted(TFoundryProject kProject, HL_TFoundryTech kFoundryTech)
{
    local HighlanderModBase kModBase;

    `HL_LOG_CLS("OnFoundryProjectCompleted", bEnableDebugLogging);

    foreach LoadedMods(kModBase)
    {
        kModBase.OnFoundryProjectCompleted(kProject, kFoundryTech);
    }
}

function OnFoundryTechsBuilt(out array<HL_TFoundryTech> Techs)
{
    local HighlanderModBase kModBase;

    `HL_LOG_CLS("OnFoundryTechsBuilt", bEnableDebugLogging);

    foreach LoadedMods(kModBase)
    {
        kModBase.OnFoundryTechsBuilt(Techs);
    }
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, Highlander_XGFacility_Engineering kEngineering)
{
    local HighlanderModBase kModBase;

    // Logging disabled for this one because it fires for every soldier in the barracks
    // `HL_LOG_CLS("UpdateFoundryPerksForSoldier", bEnableDebugLogging);

    foreach LoadedMods(kModBase)
    {
        kModBase.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
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