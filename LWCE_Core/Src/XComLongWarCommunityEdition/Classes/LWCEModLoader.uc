class LWCEModLoader extends Mutator
    dependson(LWCEModBase);

var array<LWCEModBase> LoadedMods;

var array<LWCEStrategyListener> StrategyListeners;
var array<LWCETacticalListener> TacticalListeners;

const bEnableDebugLogging = true;

static function LWCEModLoader GetModLoader()
{
    local LWCEModLoader ModLoader;

    foreach `WORLDINFO.DynamicActors(class'LWCEModLoader', ModLoader)
    {
        return ModLoader;
    }

    return none;
}

function InitMutator(string Options, out string ErrorMessage)
{
    local DownloadableContentEnumerator kDLCEnum;

    // We need to do FindDLC again, even though we could get the DLCBundles data that has
    // already been loaded when we installed mods in the first place. The reason is that after
    // FindDLC, something tries to localize the mod names and fails, leaving mangled data behind
    // that we can't make use of.
    kDLCEnum = class'LWCE_XComEngine'.static.LWCE_GetDLCEnumerator();
    kDLCEnum.AddFindDLCDelegate(OnFindDLCComplete);
    kDLCEnum.FindDLC();

    super.InitMutator(Options, ErrorMessage);
}

function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    local LWCEStrategyListener kStrategyListener;
    local LWCETacticalListener kTacticalListener;

    foreach StrategyListeners(kStrategyListener)
    {
        ActorList[ActorList.Length] = kStrategyListener;
    }

    foreach TacticalListeners(kTacticalListener)
    {
        ActorList[ActorList.Length] = kTacticalListener;
    }

	if (NextMutator != None)
	{
		NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
	}
}

function LoadStrategyListeners()
{
    local bool bAlreadyLoaded;
    local LWCEModBase kMod;
    local LWCEStrategyListener kStrategyListener;

    // The listeners are seamless actors, but the mod loader isn't. We need to find any
    // already-created listeners in the level before we create new ones.
    // TODO: this probably isn't respecting the mod load order, need to sort them
    StrategyListeners.Length = 0;

    foreach AllActors(class'LWCEStrategyListener', kStrategyListener)
    {
        StrategyListeners.AddItem(kStrategyListener);
    }

    foreach LoadedMods(kMod)
    {
        bAlreadyLoaded = false;

        if (kMod.StrategyListenerClass != none)
        {
            foreach StrategyListeners(kStrategyListener)
            {
                if (kStrategyListener != none && kStrategyListener.Class == kMod.StrategyListenerClass)
                {
                    bAlreadyLoaded = true;
                    break;
                }
            }

            if (bAlreadyLoaded)
            {
                continue;
            }

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
    local bool bAlreadyLoaded;
    local LWCEModBase kMod;
    local LWCETacticalListener kTacticalListener;

    TacticalListeners.Length = 0;

    foreach AllActors(class'LWCETacticalListener', kTacticalListener)
    {
        TacticalListeners.AddItem(kTacticalListener);
    }

    foreach LoadedMods(kMod)
    {
        bAlreadyLoaded = false;

        if (kMod.TacticalListenerClass != none)
        {
            foreach TacticalListeners(kTacticalListener)
            {
                if (kTacticalListener != none && kTacticalListener.Class == kMod.TacticalListenerClass)
                {
                    bAlreadyLoaded = true;
                    break;
                }
            }

            if (bAlreadyLoaded)
            {
                continue;
            }

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

    `LWCE_LOG_CLS("Loading strategy listeners");
    LoadStrategyListeners();
    `LWCE_LOG_CLS("Loaded " $ StrategyListeners.Length $ " strategy listener(s)");

    `LWCE_LOG_CLS("Loading tactical listeners");
    LoadTacticalListeners();
    `LWCE_LOG_CLS("Loaded " $ TacticalListeners.Length $ " tactical listener(s)");
}

// #region Mod event entry points

// These functions should be called by LWCE (or sometimes, by mods) to indicate that an event has occurred which mods
// would be interested in or can modify in some way. Each of these will cause a matching function in LWCEModBase to be called
// in each enabled mod.

// #region Foundry-related events

function bool Override_HasFoundryPrereqs(LWCE_TFoundryTech kTech)
{
    local int iHasPrereqs;
    local LWCEStrategyListener kStrategyListener;

    iHasPrereqs = 1;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_HasFoundryPrereqs(kTech, iHasPrereqs);
    }

    return iHasPrereqs != 0;
}

function OnFoundryProjectAddedToQueue(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectAddedToQueue(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCanceled(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectCanceled(kProject, kFoundryTech);
    }
}

function OnFoundryProjectCompleted(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryProjectCompleted(kProject, kFoundryTech);
    }
}

function OnFoundryTechsBuilt(out array<LWCE_TFoundryTech> arrTechs)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnFoundryTechsBuilt(arrTechs);
    }
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, LWCE_XGFacility_Engineering kEngineering)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
    }
}

// #endregion

// #region Item-related events

function Override_GetItem(out LWCE_TItem kItem, int iTransactionType)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_GetItem(kItem, iTransactionType);
    }
}

function bool Override_GetInfinitePistol(XGStrategySoldier kSoldier, out int iItemId)
{
    local bool bAnyTrue;
    local LWCEStrategyListener kStrategyListener;

    bAnyTrue = false;

    foreach StrategyListeners(kStrategyListener)
    {
        bAnyTrue = kStrategyListener.Override_GetInfinitePistol(kSoldier, iItemId) || bAnyTrue;
    }

    return bAnyTrue;
}

function bool Override_GetInfinitePrimary(XGStrategySoldier kSoldier, out int iItemId)
{
    local bool bAnyTrue;
    local LWCEStrategyListener kStrategyListener;

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
    local LWCEStrategyListener kStrategyListener;

    bAnyTrue = false;

    foreach StrategyListeners(kStrategyListener)
    {
        bAnyTrue = kStrategyListener.Override_GetInfiniteSecondary(kSoldier, iItemId) || bAnyTrue;
    }

    return bAnyTrue;
}

function OnItemCompleted(LWCE_TItemProject kItemProject, int iQuantity, optional bool bInstant)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnItemCompleted(kItemProject, iQuantity, bInstant);
    }
}

function OnItemsBuilt(out array<LWCE_TItem> arrItems)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnItemsBuilt(arrItems);
    }
}

// #endregion

// #region Perk-and-class-related events

function OnClassDefinitionsBuilt(out array<LWCE_TClassDefinition> arrSoldierClasses)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnClassDefinitionsBuilt(arrSoldierClasses);
    }
}

function OnPerksBuilt(out array<LWCE_TPerk> arrPerks)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnPerksBuilt(arrPerks);
    }
}

function OnPerkTreesBuilt(out array<LWCE_TPerkTree> arrSoldierPerkTrees, out array<LWCE_TPerkTree> arrPsionicPerkTrees)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnPerkTreesBuilt(arrSoldierPerkTrees, arrPsionicPerkTrees);
    }
}

// #endregion

// #region Research-related events

function Override_GetTech(out LWCE_TTech kTech, bool bIncludesProgress)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_GetTech(kTech, bIncludesProgress);
    }
}

function bool Override_HasPrereqs(LWCE_TTech kTech)
{
    local int iHasPrereqs;
    local LWCEStrategyListener kStrategyListener;

    iHasPrereqs = 1;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.Override_HasPrereqs(kTech, iHasPrereqs);
    }

    return iHasPrereqs != 0;
}

function OnResearchCompleted(int iTech)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchCompleted(iTech);
    }
}

function OnResearchStarted(int iTech)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchStarted(iTech);
    }
}

function OnResearchTechsBuilt(out array<LWCE_TTech> Techs)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnResearchTechsBuilt(Techs);
    }
}

// #endregion

// #region Miscellaneous strategy events

function bool OnMissionCreated(XGMission kMission)
{
    local bool bAllTrue;
    local LWCEStrategyListener kStrategyListener;

    bAllTrue = true;

    foreach StrategyListeners(kStrategyListener)
    {
        bAllTrue = kStrategyListener.OnMissionCreated(kMission) && bAllTrue;
    }

    // TODO: XGFundingCouncil still shows an alert for council missions
    return bAllTrue;
}

function OnMissionAddedToGeoscape(XGMission kMission)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.OnMissionAddedToGeoscape(kMission);
    }
}

function PopulateAlert(int iAlertId, TGeoscapeAlert kGeoAlert, out TMCAlert kAlert)
{
    local LWCEStrategyListener kStrategyListener;

    foreach StrategyListeners(kStrategyListener)
    {
        kStrategyListener.PopulateAlert(iAlertId, kGeoAlert, kAlert);
    }
}

// #endregion

// #region Ability-related tactical events

function OnAbilitiesBuilt(array<TAbility> arrAbilities)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnAbilitiesBuilt(arrAbilities);
    }
}

function AddCritChanceModifiers(XGAbility_Targeted kAbility, out TShotInfo kInfo)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.AddCritChanceModifiers(kAbility, kInfo);
    }
}

function AddHitChanceModifiers(XGAbility_Targeted kAbility, out TShotInfo kInfo)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.AddHitChanceModifiers(kAbility, kInfo);
    }
}

// #endregion

// #region Item-related tactical events

simulated function Override_GetTWeapon(out LWCE_TWeapon kWeapon)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.Override_GetTWeapon(kWeapon);
    }
}

// #endregion

// #region Miscellaneous tactical events

function string GetDynamicBonusDescription(int iPerkId, LWCE_XGUnit kUnit)
{
    local string strCurrentText;
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        strCurrentText = kTacticalListener.GetDynamicBonusDescription(iPerkId, strCurrentText, kUnit);
    }

    return strCurrentText;
}

function string GetDynamicPenaltyDescription(int iPerkId, LWCE_XGUnit kUnit)
{
    local string strCurrentText;
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        strCurrentText = kTacticalListener.GetDynamicPenaltyDescription(iPerkId, strCurrentText, kUnit);
    }

    return strCurrentText;
}

function OnBattleBegin(XGBattle kBattle)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnBattleBegin(kBattle);
    }
}

/// <summary>
/// Unlike most functions in this class, this does not directly call any mod listener methods. Instead, any LWCETacticalListener
/// which implements XComProjectileEventListener will be subscribed to events for the projectile.
/// </summary>
function OnInitProjectile(XComProjectile kSelf)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        if (XComProjectileEventListener(kTacticalListener) != none)
        {
            kSelf.AddProjectileEventListenter(XComProjectileEventListener(kTacticalListener));
        }
    }
}

function OnRegenBonusPerks(LWCE_XGUnit kUnit, XGAbility ContextAbility)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnRegenBonusPerks(kUnit, ContextAbility);
    }
}

function OnRegenPassivePerks(LWCE_XGUnit kUnit)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnRegenPassivePerks(kUnit);
    }
}

function OnRegenPenaltyPerks(LWCE_XGUnit kUnit)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnRegenPenaltyPerks(kUnit);
    }
}

function OnUpdateItemCharges(XGUnit kUnit)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnUpdateItemCharges(LWCE_XGUnit(kUnit));
    }
}

function OnUnitSpawned(XGUnit kUnit)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnUnitSpawned(LWCE_XGUnit(kUnit));
    }
}

function OnVolumeCreated(XGVolume kVolume)
{
    local LWCETacticalListener kTacticalListener;

    foreach TacticalListeners(kTacticalListener)
    {
        kTacticalListener.OnVolumeCreated(kVolume);
    }
}

// #endregion

private function LoadMod(string ModPackageName)
{
    local Class ModClass;
    local LWCEModBase Mod;
    local string ErrorMsg, ModClassName;

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
    `LWCE_LOG_CLS("Mod's registered ID range is " $ RangeToString(Mod.ModIDRange));

    if (!ValidateModIDRange(Mod.ModIDRange, ErrorMsg))
    {
        `LWCE_LOG_CLS("ERROR, mod's ID range is not valid and this mod will not be enabled! " $ ErrorMsg);
        return;
    }

    Mod.OnModLoaded();
    LoadedMods.AddItem(Mod);
}

private function string RangeToString(LWCE_TRange Range)
{
    return "[" $ Range.MinInclusive $ "-" $ Range.MaxInclusive $ "]";
}

private function bool ValidateModIDRange(LWCE_TRange Range, out string Error)
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
        Error = "IDs from 0 to 99999 are reserved by LWCE.";
        return false;
    }

    if (Range.MaxInclusive >= 2147000000)
    {
        Error = "IDs from 2,147,000,000 to 2,147,483,647 are reserved by LWCE.";
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