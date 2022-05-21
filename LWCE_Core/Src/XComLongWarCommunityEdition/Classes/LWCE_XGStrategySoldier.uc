class LWCE_XGStrategySoldier extends XGStrategySoldier;

struct CheckpointRecord_LWCE_XGStrategySoldier extends CheckpointRecord
{
    var int m_iPsionicClassId;
    var LWCE_TCharacter m_kCEChar;
    var LWCE_TSoldier m_kCESoldier;
};

var int m_iPsionicClassId;

// An LWCE version of the underlying character, including perks, abilities, etc.
// NOTE: While you can freely read from this struct, it is CRITICAL that you do not modify the
// struct directly! Use functions within this class to do so. The struct's fields must be
// kept in sync with the game's original version which is used extensively in native code;
// failure to do so can cause broken behavior or even game crashes.
var LWCE_TCharacter m_kCEChar;
var LWCE_TSoldier m_kCESoldier;

function Init()
{
    // Called after the soldier is first spawned and set up; use this opportunity
    // to sync vanilla game data into our structs

    CopyFromVanillaCharacter();

    // Syncing soldier data
    m_kCESoldier.iID = m_kSoldier.iID;
    m_kCESoldier.strFirstName = m_kSoldier.strFirstName;
    m_kCESoldier.strLastName = m_kSoldier.strLastName;
    m_kCESoldier.strNickName = m_kSoldier.strNickName;
    m_kCESoldier.iRank = m_kSoldier.iRank;
    m_kCESoldier.iPsiRank = m_kSoldier.iPsiRank;
    m_kCESoldier.iCountry = m_kSoldier.iCountry;
    m_kCESoldier.iXP = m_kSoldier.iXP;
    m_kCESoldier.iPsiXP = m_kSoldier.iPsiXP;
    m_kCESoldier.iNumKills = m_kSoldier.iNumKills;
    m_kCESoldier.kAppearance = m_kSoldier.kAppearance;
    m_kCESoldier.bBlueshirt = m_kSoldier.bBlueshirt;
    m_kCESoldier.iSoldierClassId = m_kSoldier.kClass.eType;
}

function DEMOUltimateSoldier()
{
    `LWCE_LOG_CLS("XGStrategySoldier.DEMOUltimateSoldier is deprecated in LWCE. Use LWCE_XGStrategySoldier.CheckForDamagedOrLostItems instead. Stack trace follows.");
    ScriptTrace();
}

function ApplyCheckpointRecord()
{
    // Needs to be on a slight delay; game core must be set before running
    SetTimer(0.5, /* inBLoop */ false, nameof(DelayedApplyCheckpointRecord));
}

protected function DelayedApplyCheckpointRecord()
{
    // Base game code would remove soldiers from the Skyranger here, but there's
    // no reason to undo squad selections just for loading the game

    if (m_iHQLocation == eSoldierLoc_Armory)
    {
        m_iHQLocation = eSoldierLoc_Barracks;
    }

    SetHQLocation(ESoldierLocation(m_iHQLocation), true);
}

/// <summary>
/// Applies the stat changes given to this soldier permanently. Note that not all stat types are valid
/// for soldiers, and any that are not applicable will be ignored.
/// </summary>
function ApplyPermanentStatChanges(LWCE_TCharacterStats kStatChanges)
{
    // TODO, figure out a system to make floats work for DR
    m_kChar.aStats[eStat_HP] += kStatChanges.iHP;
    m_kChar.aStats[eStat_Offense] += kStatChanges.iAim;
    m_kChar.aStats[eStat_Defense] += kStatChanges.iDefense;
    m_kChar.aStats[eStat_Mobility] += kStatChanges.iMobility;
    m_kChar.aStats[eStat_DamageReduction] += 100 * kStatChanges.fDamageReduction;
    m_kChar.aStats[eStat_Will] += kStatChanges.iWill;
    m_kChar.aStats[eStat_Damage] += kStatChanges.iDamage;
    m_kChar.aStats[eStat_CriticalShot] += kStatChanges.iCriticalChance;
    m_kChar.aStats[eStat_FlightFuel] += kStatChanges.iFlightFuel;

    SyncCharacterStatsFromVanilla();
}

function LWCE_TTransferSoldier LWCE_BuildTransferSoldier(TTransferSoldier kTransfer)
{
    local LWCE_TTransferSoldier kCETransfer;
    local int iStat;

    // A lot of soldier customization is hard to override, so just sync our appearance up
    // before sending anyone out on any missions
    m_kCESoldier.kAppearance = m_kSoldier.kAppearance;

    kCETransfer.kChar = m_kCEChar;
    kCETransfer.kSoldier = m_kCESoldier;
    kCETransfer.kChar.kInventory = kTransfer.kChar.kInventory;

    for (iStat = 0; iStat < 19; iStat++)
    {
        kCETransfer.aStatModifiers[iStat] = m_aStatModifiers[iStat];
    }

    kCETransfer.kSoldier.iSoldierClassId = m_kCEChar.iClassId;

    return kCETransfer;
}

function bool CanBeAugmented()
{
    local int iMecClassId;

    iMecClassId = `LWCE_BARRACKS.GetResultingMecClass(m_kCEChar.iClassId);

    if (iMecClassId < 0)
    {
        return false;
    }

    switch (GetStatus())
    {
        case eStatus_Active:
        case eStatus_Healing:
        case 8: // Fatigued?
            if (IsAugmented())
            {
                return false;
            }

            if (GetPsiRank() > 0) // Psions can't become MECs
            {
                return false;
            }

            if (IsATank())
            {
                return false;
            }

            if (MedalCount() > 0) // Officers can't become MECs
            {
                return false;
            }

            if (GetRank() < 2)
            {
                return false;
            }

            return true;
        default:
            return false;
    }
}

/// <summary>
/// Rolls each of the soldier's eligible equipped items to see if any were damaged or lost in the previous mission.
/// Should only be called immediately after a mission ends, while the soldier still has their gear equipped. Calling at
/// other times, or multiple times, may result in extra gear being lost unnecessarily.
/// </summary>
function CheckForDamagedOrLostItems()
{
    local LWCE_XGStorage kStorage;
    local int Index, iItemId;

    kStorage = `LWCE_STORAGE;

    iItemId = GetInventory().iPistol;

    if (iItemId != 0 && !kStorage.LWCE_IsInfinite(iItemId))
    {
        if (ShouldItemBeLost(iItemId))
        {
            LOCKERS().EquipPistol(self, `LW_ITEM_ID(Pistol));
            LoseItem(iItemId, kStorage);
        }
        else if (ShouldItemBeDamaged(iItemId))
        {
            LOCKERS().EquipPistol(self, `LW_ITEM_ID(Pistol));
            DamageItem(iItemId, kStorage);
        }
    }

    for (Index = 0; Index < GetInventory().iNumLargeItems; Index++)
    {
        iItemId = GetInventory().arrLargeItems[Index];

        if (iItemId != 0 && !kStorage.LWCE_IsInfinite(iItemId))
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().UnequipLargeItem(self, Index);
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().UnequipLargeItem(self, Index);
                DamageItem(iItemId, kStorage);
            }
        }
    }

    for (Index = 0; Index < GetInventory().iNumSmallItems; Index++)
    {
        iItemId = GetInventory().arrSmallItems[Index];

        if (iItemId != 0 && !kStorage.LWCE_IsInfinite(iItemId))
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().UnequipSmallItem(self, Index);
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().UnequipSmallItem(self, Index);
                DamageItem(iItemId, kStorage);
            }
        }
    }

    if (GetPsiRank() != 7 && !IsATank())
    {
        iItemId = GetInventory().iArmor;

        if (!kStorage.LWCE_IsInfinite(iItemId))
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().EquipArmor(self, IsAugmented() ? `LW_ITEM_ID(BaseAugments) : `LW_ITEM_ID(TacArmor));
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().EquipArmor(self, IsAugmented() ? `LW_ITEM_ID(BaseAugments) : `LW_ITEM_ID(TacArmor));
                DamageItem(iItemId, kStorage);
            }
        }
    }

    if (GetInventory().arrLargeItems[0] == 0)
    {
        LOCKERS().EquipLargeItem(self, kStorage.LWCE_GetInfinitePrimary(self), 0);
    }

    if (GetInventory().arrLargeItems[1] == 0)
    {
        LOCKERS().EquipLargeItem(self, kStorage.LWCE_GetInfiniteSecondary(self), 1);
    }

    if (GetCurrentStat(eStat_HP) == 0)
    {
        kStorage.ReleaseLoadout(self);
    }
}

/// <summary>
/// Deletes all of the soldier's perks. The optional parameter is deprecated and unused.
/// </summary>
function ClearPerks(optional bool /* unused */ _bClearMedalPerks = false)
{
    local int iPerkId;

    for (iPerkId = 0; iPerkId < ePerk_MAX; iPerkId++)
    {
        m_kChar.aUpgrades[iPerkId] = 0;
    }

    m_kCEChar.arrPerks.Length = 0;
}

/// <summary>
/// Converts this soldier into whichever MEC class their class augments into. This is instantaneous;
/// it does not queue them for augmentation in the Cybernetics Lab. If this soldier's class does not
/// have a MEC version set, this function does nothing.
/// </summary>
function ConvertToMecClass()
{
    local int iMecClassId;

    iMecClassId = `LWCE_BARRACKS.GetResultingMecClass(LWCE_GetClass());

    if (iMecClassId <= 0)
    {
        return;
    }

    LWCE_SetSoldierClass(eSC_Mec);
}

/// <summary>
/// Removes the soldier's pistol and equips a standard rocket launcher in its place.
/// </summary>
function EquipRocketLauncher()
{
    // Largely copied from XGStrategySoldier.GivePsiPerks, which was rewritten to do this
    local int iArmorItemId;

    LOCKERS().UnequipPistol(self);

    iArmorItemId = m_kChar.kInventory.iArmor;

    if (iArmorItemId == `LW_ITEM_ID(TacArmor))
    {
        LOCKERS().EquipArmor(self, `LW_ITEM_ID(TacVest));
    }
    else
    {
        LOCKERS().EquipArmor(self, `LW_ITEM_ID(TacArmor));
    }

    // Forcibly re-equips the current armor for some reason (maybe to force the pawn to update?)
    LOCKERS().EquipArmor(self, iArmorItemId);
    LOCKERS().EquipLargeItem(self, `LW_ITEM_ID(RocketLauncher), 1);
    OnLoadoutChange();
}

function int LWCE_GetBaseClass()
{
    return m_kCEChar.iBaseClassId;
}

function string GetClassIcon()
{
    return `LWCE_BARRACKS.GetClassIcon(m_kCEChar.iClassId, class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar), m_kCEChar.bHasPsiGift);

}

function string GetClassName()
{
    return `LWCE_BARRACKS.GetClassName(m_kCEChar.iClassId);
}

function ESoldierClass GetClass()
{
    `LWCE_LOG_DEPRECATED_CLS(GetClass);
    return eSC_None;
}

/// <summary>
/// Retrieves the soldier's class. Note that unlike GetClass in LW 1.0, which returned the *base* class (e.g. Scout-Sniper, or MEC),
/// this returns the *current* class (e.g. Sniper, or Jaeger). If you want the base class, which is the first non-rookie class that this
/// soldier had (or the first MEC class they had, if a MEC), use LWCE_GetBaseClass.
/// </summary>
function int LWCE_GetClass()
{
    return m_kCEChar.iClassId;
}

/// <summary>
/// Long War adapted this function to return the soldier's class, and it has been modified for
/// LWCE to do the same. Mod authors should prefer using LWCE_GetClass directly.
/// </summary>
function int GetEnergy()
{
    return LWCE_GetClass();
}

function EPerkType GetPerkInClassTree(int branch, int Option, optional bool bIsPsiTree)
{
    `LWCE_LOG_DEPRECATED_CLS(GetPerkInClassTree);
    return 0;
}

function int LWCE_GetPerkInClassTree(int iRow, int iColumn, optional bool bIsPsiTree)
{
    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier() && iRow != 0)
    {
        return m_arrRandomPerks[(3 * (iRow - 1)) + iColumn];
    }

    return `LWCE_PERKS_STRAT.LWCE_GetPerkInTree(self, iRow, iColumn, bIsPsiTree);
}

/// <summary>
/// Gives the soldier the specified perk. Note that calling this function alone will not give them
/// any stat bonuses associated with the perk (unless those stat bonuses are built into the perk itself,
/// e.g. Sprinter).
/// </summary>
function GivePerk(int iPerkId)
{
    local bool bHadGeneMod, bIsGeneMod;
    local LWCE_TIDWithSource kPerkData;

    if (HasPerk(iPerkId))
    {
        return;
    }

    bHadGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar);

    if (iPerkId < ePerk_MAX)
    {
        ++m_kChar.aUpgrades[iPerkId];
    }

    kPerkData.Id = iPerkId;
    kPerkData.SourceId = 0; // Marks perk as innate to the character
    kPerkData.SourceType = 0;
    m_kCEChar.arrPerks.AddItem(kPerkData);

    bIsGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar);

    if (iPerkId == `LW_PERK_ID(FireRocket))
    {
        // Remove soldier's pistol and give them a rocket launcher
        EquipRocketLauncher();
    }

    if (!bHadGeneMod && bIsGeneMod)
    {
        if (m_kPawn != none)
        {
            XComHumanPawn(m_kPawn).Init(m_kChar, m_kChar.kInventory, m_kSoldier.kAppearance);
        }
    }

    if (m_kPawn != none)
    {
        if (`CONTENTMGR.GetPerkContent(EPerkType(iPerkId)) != none)
        {
            m_kPawn.InitPawnPerkContent(m_kChar);
        }
    }
}

function GivePsiPerks()
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GivePsiPerks was called. This needs to be replaced with EquipRocketLauncher. Stack trace follows.");
    ScriptTrace();
}

function bool HasAvailablePerksToAssign(optional bool CheckForPsiPromotion = false)
{
    local int I, J, iPerkId;
    local LWCE_XComPerkManager kPerkMgr;

    if (GetRank() == 0 && GetPsiRank() == 0)
    {
        return false;
    }

    kPerkMgr = `LWCE_PERKS_STRAT;

    if (CheckForPsiPromotion)
    {
        if (IsReadyToPsiLevelUp())
        {
            for (I = 0; I < kPerkMgr.GetNumRowsInTree(self, /* bIsPsiTree */ true); I++)
            {
                for (J = 0; J < kPerkMgr.GetNumColumnsInTreeRow(self, I, /* bIsPsiTree */ true); J++)
                {
                    iPerkId = kPerkMgr.LWCE_GetPerkInTree(self, I, J, /* bIsPsiTree */ true);

                    if (!PerkLockedOut(iPerkId, I, /* isPsiPerk */ true))
                    {
                        return true;
                    }
                }
            }
        }
    }
    else
    {
        for (I = 0; I < GetRank(); I++)
        {
            for (J = 0; J < kPerkMgr.GetNumColumnsInTreeRow(self, I, /* bIsPsiTree */ false); J++)
            {
                iPerkId = LWCE_GetPerkInClassTree(I, J);

                if (!PerkLockedOut(iPerkId, I))
                {
                    return true;
                }
            }
        }
    }

    return false;
}

// Rewritten in LW: seems to return true if the soldier is ineligible to be augmented into a MEC.
function bool HasMedal(int iMedal)
{
    return !CanBeAugmented();
}

/// <summary>
/// Returns true if this soldier has the given perk innately (i.e. not from equipment).
/// </summary>
function bool HasPerk(int iPerk)
{
    local int Index;

    if (iPerk < ePerk_MAX)
    {
        return super.HasPerk(iPerk);
    }

    for (Index = 0; Index < m_kCEChar.arrPerks.Length; Index++)
    {
        if (m_kCEChar.arrPerks[Index].Id == iPerk && m_kCEChar.arrPerks[Index].SourceType == 0)
        {
            return true;
        }
    }

    return false;
}

function bool IsAugmented()
{
    return `LWCE_BARRACKS.GetClassDefinition(m_kCEChar.iClassId).bIsAugmented;
}

function LevelUp(optional ESoldierClass eClass, optional out string statsString)
{
    `LWCE_LOG_DEPRECATED_CLS(LevelUp);
}

function LWCE_LevelUp(optional int iClassId)
{
    local LWCE_XGFacility_Barracks kBarracks;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());

    if (m_kSoldier.iRank == 0)
    {
        if (iClassId == 0)
        {
            iClassId = kBarracks.LWCE_PickAClass();
        }

        m_kCESoldier.iSoldierClassId = iClassId;
        m_kCEChar.iBaseClassId = iClassId;
        m_kCEChar.iClassId = iClassId;
    }

    m_kSoldier.iRank += 1;

    if (GetRank() == 3)
    {
        kBarracks.GenerateNewNickname(self);
    }

    if (m_kSoldier.iXP < TACTICAL().GetXPRequired(GetRank()))
    {
        m_kSoldier.iXP = TACTICAL().GetXPRequired(GetRank());
    }

    kBarracks.ReorderRanks();

    if (m_kSoldier.iRank > kBarracks.m_iHighestRank)
    {
        kBarracks.m_iHighestRank = m_kSoldier.iRank;

        if (m_kSoldier.iRank == 7)
        {
            STAT_SetStat(eRecap_FirstColonel, Game().GetDays());
        }
    }

    if (IsAugmented())
    {
        if (m_kSoldier.iRank > kBarracks.m_iHighestMecRank)
        {
            kBarracks.m_iHighestMecRank = m_kSoldier.iRank;
        }
    }

    if (STAT_GetStat(eRecap_MaxLeveledSoldiers) < kBarracks.GetNumVeterans())
    {
        STAT_SetStat(eRecap_MaxLeveledSoldiers, kBarracks.GetNumVeterans());
    }
}

function LevelUpStats(optional int statsString)
{
    `LWCE_LOG_DEPRECATED_CLS(LevelUpStats);
}

function LWCE_LevelUpStats(LWCE_TPerkTreeChoice kSelectedPerk, int iRank)
{
    local int statOffense, statWill, statHealth;
    local bool bRand;
    local int iStatProgression;

    bRand = IsOptionEnabled(`LW_SECOND_WAVE_ID(HiddenPotential));

    // TODO: move these to new config that's easier to write and includes all stat types
    for (iStatProgression = 0; iStatProgression < class'XGTacticalGameCore'.default.SoldierStatProgression.Length; iStatProgression++)
    {
        if (class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].eClass == m_kCEChar.iClassId)
        {
            if (class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].eRank == iRank)
            {
                statWill = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iWill;
                statHealth = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iHP;
                statOffense = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iAim;
            }
        }
    }

    if (bRand)
    {
        statWill = Rand((statWill / 100) % 100) + ((statWill / 10000) % 10000);
        statHealth = ((Roll(statHealth / 100)) ? 1 : 0);
        statOffense = Rand((statOffense / 100) % 100) + ((statOffense / 10000) % 10000);
    }
    else
    {
        statWill = (statWill % 100) + Rand(class'XGTacticalGameCore'.default.iRandWillIncrease);
        statHealth = statHealth % 100;
        statOffense = statOffense % 100;
    }

    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)))
    {
        if (kSelectedPerk.iPerkId > 0 && kSelectedPerk.iPerkId != `LW_PERK_ID(RandomSubclass))
        {
            ApplyPermanentStatChanges(kSelectedPerk.kStatChanges);
        }
    }

    m_kChar.aStats[eStat_HP] += statHealth;
    m_kChar.aStats[eStat_Offense] += statOffense;
    m_kChar.aStats[eStat_Will] += statWill;

    SyncCharacterStatsFromVanilla();
}

function bool PerkLockedOut(int iPerkId, int iRow, optional bool bIsPsiPerk = false)
{
    local bool bMeetsPrereqs;
    local int iColumn, iRequiredRank;
    local LWCE_TPerkTreeChoice kPerkChoice, kRequestedPerkChoice;
    local LWCE_XComPerkManager kPerkMgr;

    kPerkMgr = `LWCE_PERKS_STRAT;
    iRequiredRank = iRow + 1;

    if (bIsPsiPerk)
    {
        if (IsReadyToPsiLevelUp())
        {
            if (iRequiredRank > GetPsiRank() + 1)
            {
                return true;
            }
        }
        else if (iRequiredRank > GetPsiRank())
        {
            return true;
        }
    }
    else
    {
        if (iRequiredRank > GetRank())
        {
            return true;
        }

        if (GetRank() == 0)
        {
            return true;
        }
    }

    for (iColumn = 0; iColumn < kPerkMgr.GetNumColumnsInTreeRow(self, iRow, bIsPsiPerk); iColumn++)
    {
        if (!kPerkMgr.TryGetPerkChoiceInTree(kPerkChoice, self, iRow, iColumn, bIsPsiPerk))
        {
            `LWCE_LOG_CLS("Error: couldn't retrieve perk choice at row " $ iRow $ " and column " $ iColumn);
            continue;
        }

        if (HasPerk(kPerkChoice.iPerkId))
        {
            return true;
        }

        if (kPerkChoice.iPerkId == iPerkId)
        {
            kRequestedPerkChoice = kPerkChoice;
        }
    }

    if (bIsPsiPerk)
    {
        bMeetsPrereqs = true;

        if (iPerkId == ePerk_Rift)
        {
            bMeetsPrereqs = (m_kChar.aUpgrades[ePerk_MindControl] & 254) == 1;
        }

        bMeetsPrereqs = bMeetsPrereqs && `LWCE_HQ.ArePrereqsFulfilled(kRequestedPerkChoice.kPrereqs);
        return !bMeetsPrereqs;
    }

    return false;
}

function RebuildAfterCombat(TTransferSoldier kTransfer)
{
    `LWCE_LOG_DEPRECATED_CLS(RebuildAfterCombat);
}

function LWCE_RebuildAfterCombat(TTransferSoldier kTransfer, LWCE_TTransferSoldier kCETransfer)
{
    m_kChar = kTransfer.kChar;
    m_kCEChar = kCETransfer.kChar;
    m_kSoldier = kTransfer.kSoldier;
    m_kCESoldier = kCETransfer.kSoldier;
    m_aStatModifiers[0] = kTransfer.iHPAfterCombat - GetMaxStat(eStat_HP);
    m_bMIA = kTransfer.bLeftBehind;
    m_strCauseOfDeath = kTransfer.CauseOfDeathString;
}

function SetSoldierClass(ESoldierClass eNewClass)
{
    `LWCE_LOG_DEPRECATED_CLS(SetSoldierClass);
}

function LWCE_SetSoldierClass(int iNewClassId)
{
    local int iCarryOverWill, iEquipmentGroup, iMecClassId, iOriginalWill, iPerkColumn, iPreviousClassId;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStorage kStorage;
    local LWCE_XGTacticalGameCore kGameCore;
    local LWCE_TClassDefinition kNewClassDef;
    local LWCE_TPerkTreeChoice kPerkChoice;
    local TInventory kNewLoadout;
    local array<ECharacterVoice> PossibleVoices;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());
    kGameCore = LWCE_XGTacticalGameCore(TACTICAL());
    kHQ = LWCE_XGHeadquarters(HQ());
    kStorage = `LWCE_STORAGE;
    iPreviousClassId = m_kCEChar.iClassId;
    kNewLoadout = m_kChar.kInventory;

    if (iNewClassId == eSC_Mec)
    {
        iMecClassId = kBarracks.GetResultingMecClass(LWCE_GetClass());
        kNewClassDef = kBarracks.GetClassDefinition(iMecClassId);

        m_kCEChar.iBaseClassId = iMecClassId;
        m_kCEChar.iClassId = iMecClassId;
        m_kCESoldier.iSoldierClassId = iMecClassId;
    }
    else if (iNewClassId != 0)
    {
        kNewClassDef = kBarracks.GetClassDefinition(iNewClassId);

        m_kCEChar.iClassId = iNewClassId;
        m_kCESoldier.iSoldierClassId = iNewClassId;

        if (m_kCEChar.iBaseClassId == 0 && kNewClassDef.bIsBaseClass)
        {
            `LWCE_LOG_CLS("Setting base class to " $ iNewClassId);
            m_kCEChar.iBaseClassId = iNewClassId;
        }
    }

    iEquipmentGroup = kNewClassDef.iWeaponType;

    switch (iNewClassId)
    {
        case eSC_Sniper: // Scout-Sniper
            if (kHQ.HasBonus(`LW_HQ_BONUS_ID(FirstRecce)) > 0)
            {
                m_kChar.aStats[eStat_Defense] += kHQ.HasBonus(`LW_HQ_BONUS_ID(FirstRecce));
            }

            break;
        case eSC_HeavyWeapons: // Weapons
            if (kHQ.HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += kHQ.HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross));
            }
            break;
        case eSC_Support: // Support
            if (kHQ.HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead)) > 0)
            {
                m_kChar.aStats[eStat_Will] += kHQ.HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead));
            }

            break;
        case eSC_Assault: // Tactical
            if (kHQ.HasBonus(`LW_HQ_BONUS_ID(Spetznaz)) > 0)
            {
                m_kChar.aStats[eStat_HP] += kHQ.HasBonus(`LW_HQ_BONUS_ID(Spetznaz));
            }

            break;
        case eSC_Mec:
            LOCKERS().UnequipArmor(self);

            m_bPsiTested = true;
            iOriginalWill = m_kChar.aStats[eStat_Will];
            m_kChar = kGameCore.GetTCharacter(eChar_Soldier);
            m_kSoldier.iPsiRank = 0;

            ClearPerks();
            GivePerk(`LW_PERK_ID(OneForAll));
            GivePerk(`LW_PERK_ID(CombinedArms));

            ApplyPermanentStatChanges(`LWCE_STRATCFG(BaseStatsChangeWhenAugmented));

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CinematicMode)))
            {
                m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
            }

            if (kHQ.HasBonus(`LW_HQ_BONUS_ID(Robotics)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += kHQ.HasBonus(`LW_HQ_BONUS_ID(Robotics));
            }

            // Carry over some will from the non-MEC unit
            iCarryOverWill = iOriginalWill - m_kChar.aStats[eStat_Will] - 4 * GetRank();
            if (iCarryOverWill > 0)
            {
                m_kChar.aStats[eStat_Will] += iCarryOverWill;
            }

            m_kSoldier.iPsiXP = 0;
            kBarracks.UpdateFoundryPerksForSoldier(self);
            kNewLoadout = m_kChar.kInventory;
            kNewLoadout.iArmor = eItem_MecCivvies;

            m_kCEChar.iClassId = iMecClassId;
            m_kCESoldier.iSoldierClassId = m_kCEChar.iClassId;

            if (GetRank() < 7)
            {
                m_kSoldier.iXP = kGameCore.GetXPRequired(GetRank() - 1) + int(float(kGameCore.GetXPRequired(GetRank()) - kGameCore.GetXPRequired(GetRank() - 1)) * (float(1) - (float(kGameCore.GetXPRequired(GetRank() + 1) - m_kSoldier.iXP) / float(kGameCore.GetXPRequired(GetRank() + 1) - kGameCore.GetXPRequired(GetRank())))));
            }
            else
            {
                m_kSoldier.iXP = kGameCore.GetXPRequired(GetRank() - 1);
            }

            m_kSoldier.iRank -= 1;

            if (m_kSoldier.iRank > kBarracks.m_iHighestMecRank)
            {
                kBarracks.m_iHighestMecRank = m_kSoldier.iRank;
            }

            if (!IsASpecialSoldier())
            {
                `CONTENTMGR.GetPossibleVoices(EGender(m_kSoldier.kAppearance.iGender), m_kSoldier.kAppearance.iLanguage, true, PossibleVoices);
                m_kSoldier.kAppearance.iVoice = PossibleVoices[Rand(PossibleVoices.Length)];
            }

            m_bAllIn = false;
            break;
        case 0:
            // TODO: incorporate classes from mods
            iNewClassId = 1 + Rand(4);

            while (iPreviousClassId == iNewClassId)
            {
                iNewClassId = 1 + Rand(4);
            }

            m_kCEChar.iClassId = iNewClassId;
            m_kCESoldier.iSoldierClassId = iNewClassId;

            // Choose column  0 or 2; have to avoid column 1, that's Random Subclass
            // TODO: this should be more generic since there's no guarantee a tree contains Random Subclass
            iPerkColumn = 2 * Rand(2);
            `LWCE_PERKS_STRAT.TryGetPerkChoiceInTree(kPerkChoice, self, 0, iPerkColumn);
            GivePerk(kPerkChoice.iPerkId);
            LWCE_SetSoldierClass(kPerkChoice.iNewClassId);

            return;
    }

    m_kSoldier.kClass.eWeaponType = EWeaponProperty(iEquipmentGroup);
    m_kSoldier.kClass.strName = GetClassName();

    kGameCore.TInventoryLargeItemsSetItem(kNewLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));
    kGameCore.TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));

    if (iNewClassId != eSC_Mec)
    {
        if (HasPerk(`LW_PERK_ID(FireRocket)))
        {
            kGameCore.TInventoryLargeItemsSetItem(kNewLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
            kGameCore.TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
        }
        else
        {
            kNewLoadout.iPistol = kStorage.LWCE_GetInfinitePistol(self);
            m_kBackedUpLoadout.iPistol = kStorage.LWCE_GetInfinitePistol(self);
        }
    }

    LOCKERS().ApplySoldierLoadout(self, kNewLoadout);

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier())
    {
        AssignRandomPerks();
    }

    SetCosmeticsByClass();
    OnLoadoutChange();
    CopyFromVanillaCharacter();
}

protected function CopyFromVanillaCharacter()
{
    local int Index;
    local LWCE_TIDWithSource kIdWithSource;

    m_kCEChar.strName = m_kChar.strName;
    m_kCEChar.iCharacterType = m_kChar.iType;
    m_kCEChar.fBioElectricParticleScale = m_kChar.fBioElectricParticleScale;
    m_kCEChar.bHasPsiGift = m_kChar.bHasPsiGift;
    m_kCEChar.kInventory = m_kChar.kInventory;

    m_kCEChar.arrAbilities.Length = 0;
    m_kCEChar.arrPerks.Length = 0;
    m_kCEChar.arrProperties.Length = 0;
    m_kCEChar.arrTraversals.Length = 0;

    // Assume for now that anything the soldier has at this point is innate, i.e. has no source
    for (Index = 0; Index < eAbility_MAX; Index++)
    {
        if (m_kChar.aAbilities[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = 0;
            kIdWithSource.SourceType = 0;

            m_kCEChar.arrAbilities.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < ePerk_MAX; Index++)
    {
        if (m_kChar.aUpgrades[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = 0;
            kIdWithSource.SourceType = 0;

            m_kCEChar.arrPerks.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < eCP_MAX; Index++)
    {
        if (m_kChar.aProperties[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = 0;
            kIdWithSource.SourceType = 0;

            m_kCEChar.arrProperties.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < eTraversal_MAX; Index++)
    {
        if (m_kChar.aTraversals[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = 0;
            kIdWithSource.SourceType = 0;

            m_kCEChar.arrTraversals.AddItem(kIdWithSource);
        }
    }

    SyncCharacterStatsFromVanilla();
}

protected function DamageItem(int iItemId, LWCE_XGStorage kStorage)
{
    kStorage.LWCE_DamageItem(iItemId, 1);

    // Mark that an item was damaged, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsDamagedLastMission, iItemId, 1);
}

protected function LoseItem(int iItemId, LWCE_XGStorage kStorage)
{
    kStorage.RemoveItem(iItemId, 1);

    // Mark that an item was lost, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsLostLastMission, iItemId, 1);
}

protected function SetCosmeticsByClass()
{
    local int Index;

    switch (m_kCEChar.iClassId)
    {
        case 11: // Sniper
            Index = 4;
            break;
        case 21: // Scout
            Index = 6;
            break;
        case 12: // Rocketeer
            Index = 8;
            break;
        case 22: // Gunner
            Index = 10;
            break;
        case 13: // Medic
            Index = 12;
            break;
        case 23: // Engineer
            Index = 14;
            break;
        case 14: // Assault
            Index = 16;
            break;
        case 24: // Infantry
            Index = 18;
            break;
    }

    if (Index != 0)
    {
        if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[Index] >= 1)
        {
            m_kSoldier.kAppearance.iArmorTint = class'XGTacticalGameCore'.default.HQ_BASE_POWER[Index] - 1;

            if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[Index + 1] >= 1)
            {
                m_kSoldier.kAppearance.iHaircut = class'XGTacticalGameCore'.default.HQ_BASE_POWER[Index + 1];
            }
        }
    }
}

protected function bool ShouldItemBeDamaged(int iItemId)
{
    local float fPercentHPMissing;
    local int iBaseDamageChance, iScaledDamageChance;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(Durability)))
    {
        return false;
    }

    // TODO: need a new data source for damage chance
    iBaseDamageChance = int(class'XGGameData'.static.GetMecBaseArmor(EItemType(iItemId)));

    if (iBaseDamageChance <= 0)
    {
        return false;
    }

    // Damage chance is scaled by how much HP the soldier is missing, maxing out at the value in config when a soldier dies
    fPercentHPMissing = 1.0 - (float(GetCurrentStat(eStat_HP)) / float(GetMaxStat(eStat_HP)));
    iScaledDamageChance = int(fPercentHPMissing * iBaseDamageChance);

    if (Roll(iScaledDamageChance))
    {
        return true;
    }

    // Without Wear and Tear enabled, there's no other chance for items to be damaged
    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(WearAndTear)))
    {
        return false;
    }

    return Roll(int(class'XGTacticalGameCore'.default.SW_RARE_PSI));
}

protected function bool ShouldItemBeLost(int iItemId)
{
    // Items are only lost when a soldier dies
    if (GetCurrentStat(eStat_HP) > 0)
    {
        return false;
    }

    // If the Total Loss second wave option is on, items can be lost any time a soldier dies;
    // otherwise, they're only lost if the mission is failed (aka the soldier is marked MIA)
    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(TotalLoss)) && !m_bMIA)
    {
        return false;
    }

    // TODO: potential place to add a mod hook

    return Roll(BLUESHIRT_HP_MOD);
}

protected function SyncCharacterStatsFromVanilla()
{
    local int Index;

    for (Index = 0; Index < eStat_MAX; Index++)
    {
        m_kCEChar.aStats[Index] = m_kChar.aStats[Index];
    }
}

defaultproperties
{
    m_iPsionicClassId=1
}