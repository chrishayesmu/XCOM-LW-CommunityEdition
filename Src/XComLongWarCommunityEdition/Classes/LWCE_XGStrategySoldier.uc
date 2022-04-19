class LWCE_XGStrategySoldier extends XGStrategySoldier;

struct CheckpointRecord_LWCE_XGStrategySoldier extends CheckpointRecord
{
    var int m_iPsionicClassId;
    var LWCE_TCharacter m_kCEChar;
    var LWCE_TSoldier m_kCESoldier;
    var array<LWCE_TIDWithSource> m_arrPerks;
};

var int m_iPsionicClassId;

// An LWCE version of the underlying character, including perks, abilities, etc.
// NOTE: While you can freely read from this struct, it is CRITICAL that you do not modify the
// struct directly! Use functions within this class to do so. The struct's fields must be
// kept in sync with the game's original version which is used extensively in native code;
// failure to do so can cause broken behavior or even game crashes.
var LWCE_TCharacter m_kCEChar;
var LWCE_TSoldier m_kCESoldier;

// Perks this soldier has, and where they came from. For the SourceType field, valid values are:
//     0 - Innate perk (e.g. from promotions, the Foundry, or starting perk for hero units like Zhang)
//     1 - Perk from an equipped item
var array<LWCE_TIDWithSource> m_arrPerks;

static function string GetSoldierClassName(int iClassId)
{
    local string strName;

    if (iClassId == 0)
    {
        return "";
    }

    if (iClassId <= 44) // Long War's highest class ID, for the Valkyrie
    {
        strName = class'XGLocalizedData'.default.SoldierClassNames[iClassId];
    }

    // TODO insert mod hook here

    return strName;
}

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
    m_kCESoldier.kClass.strName = m_kSoldier.kClass.strName;
    m_kCESoldier.kClass.iSoldierClassId = m_kSoldier.kClass.eType;
    m_kCESoldier.kClass.iWeaponType = m_kSoldier.kClass.eWeaponType;
}

function DEMOUltimateSoldier()
{
    `LWCE_LOG_CLS("XGStrategySoldier.DEMOUltimateSoldier is deprecated in LWCE. Use LWCE_XGStrategySoldier.CheckForDamagedOrLostItems instead. Stack trace follows.");
    ScriptTrace();
}

/// <summary>
/// TODO
/// </summary>
function ApplyStatChanges(LWCE_TCharacterStats kStatChanges)
{
    // TODO
}

function LWCE_TTransferSoldier LWCE_BuildTransferSoldier(TTransferSoldier kTransfer)
{
    local LWCE_TTransferSoldier kCETransfer;
    local int iStat;

    kCETransfer.kChar = m_kCEChar;
    kCETransfer.kSoldier = m_kCESoldier;
    kCETransfer.kChar.kInventory = kTransfer.kChar.kInventory;

    for (iStat = 0; iStat < 19; iStat++)
    {
        kCETransfer.aStatModifiers[iStat] = m_aStatModifiers[iStat];
    }

    kCETransfer.kSoldier.kClass.iSoldierClassId = m_kCEChar.iClassId;
    kCETransfer.kSoldier.kClass.iWeaponType = kTransfer.kSoldier.kClass.eWeaponType;

    return kCETransfer;
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

function string GetClassName()
{
    return GetSoldierClassName(m_kCEChar.iClassId);
}

function SetSoldierClass(ESoldierClass eNewClass)
{
    `LWCE_LOG_DEPRECATED_CLS(SetSoldierClass);
}

function LWCE_SetSoldierClass(int iNewClassId)
{
    local LWCE_XGStorage kStorage;
    local TInventory kNewLoadout;
    local int iPreviousClassId;
    local array<ECharacterVoice> PossibleVoices;
    local int iEquipmentGroup;

    kStorage = `LWCE_STORAGE;
    iPreviousClassId = m_kCEChar.iClassId;
    m_kCEChar.iClassId = iNewClassId;
    m_kCESoldier.kClass.iSoldierClassId = iNewClassId;
    kNewLoadout = m_kChar.kInventory;

    switch (iNewClassId)
    {
        case eSC_Sniper: // Scout-Sniper
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(FirstRecce)) > 0)
            {
                m_kChar.aStats[eStat_Defense] += HQ().HasBonus(`LW_HQ_BONUS_ID(FirstRecce));
            }

            break;
        case eSC_HeavyWeapons: // Weapons
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross));
            }
            break;
        case eSC_Support: // Support
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead)) > 0)
            {
                m_kChar.aStats[eStat_Will] += HQ().HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead));
            }

            break;
        case eSC_Assault: // Tactical
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Spetznaz)) > 0)
            {
                m_kChar.aStats[eStat_HP] += HQ().HasBonus(`LW_HQ_BONUS_ID(Spetznaz));
            }

            break;
        case eSC_Mec:
            m_bPsiTested = true;
            LOCKERS().UnequipArmor(self);
            m_kSoldier.iPsiXP = m_kChar.aStats[eStat_Will];
            m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);

            CopyFromVanillaCharacter();
            m_kCEChar.iClassId = iNewClassId;
            m_kSoldier.iPsiRank = 0;

            ClearPerks(true);
            GivePerk(ePerk_OneForAll);
            GivePerk(/* Combined Arms */ 138);

            m_kChar.aStats[eStat_HP] += 4;

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CinematicMode)))
            {
                m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
            }

            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics));
            }

            // Carry over some will from the non-MEC unit
            if ( m_kSoldier.iPsiXP - m_kChar.aStats[eStat_Will] - (4 * GetRank()) > 0)
            {
                m_kChar.aStats[eStat_Will] += m_kSoldier.iPsiXP - m_kChar.aStats[eStat_Will] - (4 * GetRank());
            }

            m_kSoldier.iPsiXP = 0;
            BARRACKS().UpdateFoundryPerksForSoldier(self);
            kNewLoadout = m_kChar.kInventory;
            kNewLoadout.iArmor = eItem_MecCivvies;

            iEquipmentGroup = 20;
            m_kCEChar.iClassId += 20; // Base class +20 maps to the corresponding MEC class
            m_kCESoldier.kClass.iSoldierClassId = m_kCEChar.iClassId;

            if (GetRank() < 7)
            {
                m_kSoldier.iXP = TACTICAL().GetXPRequired(GetRank() - 1) + int(float(TACTICAL().GetXPRequired(GetRank()) - TACTICAL().GetXPRequired(GetRank() - 1)) * (float(1) - (float(TACTICAL().GetXPRequired(GetRank() + 1) - m_kSoldier.iXP) / float(TACTICAL().GetXPRequired(GetRank() + 1) - TACTICAL().GetXPRequired(GetRank())))));
            }
            else
            {
                m_kSoldier.iXP = TACTICAL().GetXPRequired(GetRank() - 1);
            }

            m_kSoldier.iRank -= 1;

            if (m_kSoldier.iRank > BARRACKS().m_iHighestMecRank)
            {
                BARRACKS().m_iHighestMecRank = m_kSoldier.iRank;
            }

            if (!IsASpecialSoldier())
            {
                `CONTENTMGR.GetPossibleVoices(EGender(m_kSoldier.kAppearance.iGender), m_kSoldier.kAppearance.iLanguage, true, PossibleVoices);
                m_kSoldier.kAppearance.iVoice = PossibleVoices[Rand(PossibleVoices.Length)];
            }

            m_bAllIn = false;
            break;
        case 11: // Sniper
            iEquipmentGroup = 7;
            break;
        case 12: // Rocketeer
            iEquipmentGroup = 8;
            TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 1, `LW_ITEM_ID(RocketLauncher));
            TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 1, `LW_ITEM_ID(RocketLauncher));
            break;
        case 13: // Medic
            iEquipmentGroup = 5;
            break;
        case 14: // Assault
            iEquipmentGroup = 6;
            break;
        case 21: // Scout
            iEquipmentGroup = 11; // strike rifles
            break;
        case 22: // Gunner
            iEquipmentGroup = 4;
            break;
        case 23: // Engineer
            iEquipmentGroup = 10;
            break;
        case 24: // Infantry
            iEquipmentGroup = 5;
            break;
        case 0:
            // TODO: incorporate classes from mods
            iNewClassId = 1 + Rand(4);

            while (iPreviousClassId == iNewClassId)
            {
                iNewClassId = 1 + Rand(4);
            }

            m_kCEChar.iClassId = iNewClassId;
            m_kCESoldier.kClass.iSoldierClassId = iNewClassId;
            GivePerk(GetPerkInClassTree(1, 2 * Rand(2), false));
            LWCE_SetSoldierClass(iNewClassId);

            return;
        default:
            `LWCE_LOG_CLS("LWCE_SetSoldierClass received unknown class ID " $ iNewClassId $ ". Can't assign this soldier a class.");
            return;
    }

    m_kSoldier.kClass.eWeaponType = EWeaponProperty(iEquipmentGroup);
    m_kCESoldier.kClass.iWeaponType = iEquipmentGroup;
    m_kSoldier.kClass.strName = GetSoldierClassName(iNewClassId);
    m_kCESoldier.kClass.strName = m_kSoldier.kClass.strName;

    TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));
    TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));

    if (iNewClassId != eSC_Mec)
    {
        if (HasPerk(`LW_PERK_ID(FireRocket)))
        {
            TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
            TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
        }
        else
        {
            kNewLoadout.iPistol = kStorage.LWCE_GetInfiniteSecondary(self);
            m_kBackedUpLoadout.iPistol = kStorage.LWCE_GetInfiniteSecondary(self);
        }
    }

    LOCKERS().ApplySoldierLoadout(self, kNewLoadout);

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier())
    {
        AssignRandomPerks();
    }

    // Set the soldier's cosmetics based on their class
    if (iNewClassId != eSC_Mec)
    {
        // ePreviousClass: index into cosmetics config
        iPreviousClassId = 0;

        switch (m_iEnergy)
        {
            case 11: // Sniper
                iPreviousClassId = 4;
                break;
            case 21: // Scout
                iPreviousClassId = 6;
                break;
            case 12: // Rocketeer
                iPreviousClassId = 8;
                break;
            case 22: // Gunner
                iPreviousClassId = 10;
                break;
            case 13: // Medic
                iPreviousClassId = 12;
                break;
            case 23: // Engineer
                iPreviousClassId = 14;
                break;
            case 14: // Assault
                iPreviousClassId = 16;
                break;
            case 24: // Infantry
                iPreviousClassId = 18;
                break;
        }

        if (iPreviousClassId != 0)
        {
            if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[iPreviousClassId] >= 1)
            {
                m_kSoldier.kAppearance.iArmorTint = class'XGTacticalGameCore'.default.HQ_BASE_POWER[iPreviousClassId] - 1;

                if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[iPreviousClassId + 1] >= 1)
                {
                    m_kSoldier.kAppearance.iHaircut = class'XGTacticalGameCore'.default.HQ_BASE_POWER[iPreviousClassId + 1];
                }
            }
        }
    }

    OnLoadoutChange();
}

protected function DamageItem(int iItemId, LWCE_XGStorage kStorage)
{
    kStorage.LWCE_DamageItem(iItemId, 1);

    // Mark that an item was damaged, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsDamagedLastMission, iItemId, 1);
}

function EPerkType GetPerkInClassTree(int branch, int Option, optional bool bIsPsiTree)
{
    `LWCE_LOG_DEPRECATED_CLS(GetPerkInClassTree);
    return 0;
}

function int LWCE_GetPerkInClassTree(int iRow, int iColumn, optional bool bIsPsiTree)
{
    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier() && iRow != 1)
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

    bHadGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar);

    if (iPerkId < ePerk_MAX)
    {
        ++ m_kChar.aUpgrades[iPerkId];
    }

    kPerkData.Id = iPerkId;
    kPerkData.SourceId = 0; // Marks perk as innate to the character
    kPerkData.SourceType = 0;
    m_kCEChar.arrPerks.AddItem(kPerkData);

    bIsGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar);

    if (iPerkId == `LW_PERK_ID(FireRocket))
    {
        // Remove soldier's pistol and give them a rocket launcher
        GivePsiPerks();
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

                    if (!PerkLockedOut(iPerkId, I, true))
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

function bool IsAugmented()
{
    if (m_kCEChar.iClassId >= 31 && m_kCEChar.iClassId <= 34)
    {
        return true;
    }

    if (m_kCEChar.iClassId >= 41 && m_kCEChar.iClassId <= 44)
    {
        return true;
    }

    // TODO: need a way to determine if mod-added classes are MECs

    return false;
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
            iClassId = kBarracks.PickAClass(); // TODO add LWCE version
        }

        m_kCESoldier.kClass.iSoldierClassId = iClassId;
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
    local int statOffense, statWill, statHealth;
    local bool bRand;
    local int iRank, iColumn, iStatProgression;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_TPerkTreeChoice kPerkChoice;

    bRand = IsOptionEnabled(`LW_SECOND_WAVE_ID(HiddenPotential));
    iColumn = statsString & 255; // TODO confirm these
    iRank = ((statsString >> 8) & 255);

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
        if (statsString > 1)
        {
            kPerksMgr = `LWCE_PERKS_STRAT;

            // TODO: see if we can do without the bit fiddling somehow
            if (kPerksMgr.TryGetPerkChoiceInTree(kPerkChoice, self, iRank, iColumn, /* bIsPsiTree */ false))
            {
                ApplyStatChanges(kPerkChoice.kStatChanges);
            }
        }
    }

    m_kChar.aStats[eStat_HP] += statHealth;
    m_kChar.aStats[eStat_Offense] += statOffense;
    m_kChar.aStats[eStat_Will] += statWill;
}

function bool PerkLockedOut(int iPerkId, int iRow, optional bool isPsiPerk = false)
{
    local int iOptions, iPerk;
    local int iRequiredRank;

    iRequiredRank = iRow + 1;

    if (isPsiPerk)
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

    for (iOptions = 0; iOptions < 3; iOptions++)
    {
        iPerk = LWCE_GetPerkInClassTree(iRow, iOptions, isPsiPerk);

        if (HasPerk(iPerk))
        {
            return true;
        }
    }

    if (isPsiPerk)
    {
        if (iPerkId == ePerk_Rift)
        {
            return (m_kChar.aUpgrades[ePerk_MindControl] & 254) == 0;
        }

        // TODO better system for psi perk prerequisites
        return !LABS().IsResearched(`LWCE_PERKS_STRAT.GetPerkInTreePsi(iPerkId | (1 << 8), 0));
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

protected function CopyFromVanillaCharacter()
{
    local int Index;
    local LWCE_TIDWithSource kIdWithSource;

    m_kCEChar.strName = m_kChar.strName;
    m_kCEChar.iCharacterType = m_kChar.iType;
    m_kCEChar.iClassId = m_kChar.eClass;
    m_kCEChar.fBioElectricParticleScale = m_kChar.fBioElectricParticleScale;
    m_kCEChar.bHasPsiGift = m_kChar.bHasPsiGift;
    m_kCEChar.kInventory = m_kChar.kInventory;

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

    for (Index = 0; Index < eStat_MAX; Index++)
    {
        m_kCEChar.aStats[Index] = m_kChar.aStats[Index];
    }
}

protected function LoseItem(int iItemId, LWCE_XGStorage kStorage)
{
    kStorage.RemoveItem(iItemId, 1);

    // Mark that an item was lost, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsLostLastMission, iItemId, 1);
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