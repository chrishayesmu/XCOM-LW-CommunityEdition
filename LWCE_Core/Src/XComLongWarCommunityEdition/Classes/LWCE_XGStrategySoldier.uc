class LWCE_XGStrategySoldier extends XGStrategySoldier;

struct CheckpointRecord_LWCE_XGStrategySoldier extends CheckpointRecord
{
    var int m_iPsionicClassId;
    var LWCE_TCharacter m_kCEChar;
    var LWCE_TSoldier m_kCESoldier;
    var LWCE_TInventory m_kCEBackedUpLoadout;
};

var int m_iPsionicClassId;

// An LWCE version of the underlying character, including perks, abilities, etc.
// NOTE: While you can freely read from this struct, it is CRITICAL that you do not modify the
// struct directly! Use functions within this class to do so. The struct's fields must be
// kept in sync with the game's original version which is used extensively in native code;
// failure to do so can cause broken behavior or even game crashes.
var LWCE_TCharacter m_kCEChar;
var LWCE_TSoldier m_kCESoldier;
var LWCE_TInventory m_kCEBackedUpLoadout;

function Init()
{
    // Called after the soldier is first spawned and set up; use this opportunity
    // to sync vanilla game data into our structs
    // TODO: all of this should be set up directly when the soldier is created, instead

    CopyFromVanillaCharacter();

    // Sync soldier data
    // TODO: stop doing this over time
    // m_kCESoldier.iID = m_kCESoldier.iID;
    // m_kCESoldier.iRank = m_kCESoldier.iRank;
    // m_kCESoldier.iPsiRank = m_kCESoldier.iPsiRank;
    // m_kCESoldier.iXP = m_kCESoldier.iXP;
    // m_kCESoldier.iPsiXP = m_kCESoldier.iPsiXP;
    // m_kCESoldier.iNumKills = m_kCESoldier.iNumKills;
    // m_kCESoldier.bBlueshirt = m_kCESoldier.bBlueshirt;
    // m_kCESoldier.iSoldierClassId = m_kSoldier.kClass.eType;
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

    kCETransfer.kChar = m_kCEChar;
    kCETransfer.kSoldier = m_kCESoldier;
    kCETransfer.kChar.kInventory = m_kCEChar.kInventory;

    `LWCE_LOG_CLS("Building transfer soldier: m_kCEChar.iCharacterType = " $ m_kCEChar.iCharacterType $ ", m_kCEChar.kInventory.arrLargeItems.Length = " $ m_kCEChar.kInventory.arrLargeItems.Length $ ", m_kCEChar.kInventory.nmArmor = " $ m_kCEChar.kInventory.nmArmor);
    `LWCE_LOG_CLS("m_kCESoldier.strFirstName = " $ m_kCESoldier.strFirstName $ ", m_kCESoldier.strLastName = " $ m_kCESoldier.strLastName);
    `LWCE_LOG_CLS("Aim: " $ m_kCEChar.aStats[eStat_Offense] $ "; m_aStatModifiers[eStat_Offense] = " $ m_aStatModifiers[eStat_Offense]);

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

function XComUnitPawn CreatePawn(optional name DestState = 'InHQ')
{
    local class<XComUnitPawn> PawnClass;
    local LWCE_TInventory kInv;

    `LWCE_LOG_CLS("CreatePawn: DestState = " $ DestState);

    // TODO override other pawn classes
    if (m_kPawn == none)
    {
        if (IsATank())
        {
            PawnClass = class'LWCE_XComTank';
        }
        else if (IsAugmented() && m_kCEChar.kInventory.nmArmor != 'Item_BaseAugments' && CanWearMecInRoom(ESoldierLocation(m_iHQLocation)))
        {
            PawnClass = class'XComMecPawn';
        }
        else
        {
            PawnClass = class'LWCE_XComHumanPawn';
        }

        m_kPawn = Spawn(PawnClass, self,,,,, /* bNoCollisionFail */ true);
    }

    m_kPawn.GotoState(DestState);

    if (m_kPawn.IsA('XComHumanPawn') && DestState == 'MedalCeremony')
    {
        XComHumanPawn(m_kPawn).SetMedals(m_arrMedals);
    }

    if (IsATank())
    {
        LWCE_XComTank(m_kPawn).LWCE_Init(m_kCEChar.kInventory);
    }
    else if (IsAugmented() && m_kChar.kInventory.iArmor != eItem_MecCivvies)
    {
        if (CanWearMecInRoom(ESoldierLocation(m_iHQLocation)))
        {
            XComMecPawn(m_kPawn).Init(m_kChar, m_kChar.kInventory, m_kSoldier.kAppearance);
        }
        else
        {
            kInv = m_kCEChar.kInventory;
            kInv.nmArmor = 'Item_BaseAugments';
            LWCE_XComHumanPawn(m_kPawn).LWCE_Init(m_kCEChar, kInv, m_kCESoldier.kAppearance);
        }
    }
    else
    {
        LWCE_XComHumanPawn(m_kPawn).LWCE_Init(m_kCEChar, m_kCEChar.kInventory, m_kCESoldier.kAppearance);
    }

    return m_kPawn;
}

/// <summary>
/// Rolls each of the soldier's eligible equipped items to see if any were damaged or lost in the previous mission.
/// Should only be called immediately after a mission ends, while the soldier still has their gear equipped. Calling at
/// other times, or multiple times, may result in extra gear being lost unnecessarily.
/// </summary>
function CheckForDamagedOrLostItems()
{
    local LWCEItemTemplate kItem;
    local LWCE_XGFacility_Lockers kLockers;
    local LWCE_XGStorage kStorage;
    local int Index;
    local name ItemName;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());
    kStorage = LWCE_XGStorage(STORAGE());

    ItemName = m_kCEChar.kInventory.nmPistol;
    kItem = `LWCE_ITEM(ItemName);

    // TODO: this should equip the infinite secondary if there's one other than pistol
    if (ItemName != '' && !kItem.IsInfinite())
    {
        if (ShouldItemBeLost())
        {
            kLockers.LWCE_EquipPistol(self, 'Item_Pistol');
            LoseItem(ItemName, kStorage);
        }
        else if (ShouldItemBeDamaged(ItemName))
        {
            kLockers.LWCE_EquipPistol(self, 'Item_Pistol');
            DamageItem(ItemName, kStorage);
        }
    }

    for (Index = 0; Index < m_kCEChar.kInventory.arrLargeItems.Length; Index++)
    {
        ItemName = m_kCEChar.kInventory.arrLargeItems[Index];
        kItem = `LWCE_ITEM(ItemName);

        if (ItemName != '' && !kItem.IsInfinite())
        {
            if (ShouldItemBeLost())
            {
                kLockers.UnequipLargeItem(self, Index);
                LoseItem(ItemName, kStorage);
            }
            else if (ShouldItemBeDamaged(ItemName))
            {
                kLockers.UnequipLargeItem(self, Index);
                DamageItem(ItemName, kStorage);
            }
        }
    }

    for (Index = 0; Index < m_kCEChar.kInventory.arrSmallItems.Length; Index++)
    {
        ItemName = m_kCEChar.kInventory.arrSmallItems[Index];
        kItem = `LWCE_ITEM(ItemName);

        if (ItemName != '' && !kItem.IsInfinite())
        {
            if (ShouldItemBeLost())
            {
                kLockers.UnequipSmallItem(self, Index);
                LoseItem(ItemName, kStorage);
            }
            else if (ShouldItemBeDamaged(ItemName))
            {
                kLockers.UnequipSmallItem(self, Index);
                DamageItem(ItemName, kStorage);
            }
        }
    }

    if (GetPsiRank() != 7 && !IsATank())
    {
        ItemName = m_kCEChar.kInventory.nmArmor;
        kItem = `LWCE_ITEM(ItemName);

        if (!kItem.IsInfinite())
        {
            if (ShouldItemBeLost())
            {
                kLockers.LWCE_EquipArmor(self, IsAugmented() ? 'Item_BaseAugments' : 'Item_TacArmor');
                LoseItem(ItemName, kStorage);
            }
            else if (ShouldItemBeDamaged(ItemName))
            {
                kLockers.LWCE_EquipArmor(self, IsAugmented() ? 'Item_BaseAugments' : 'Item_TacArmor');
                DamageItem(ItemName, kStorage);
            }
        }
    }

    if (m_kCEChar.kInventory.arrLargeItems.Length == 0)
    {
        kLockers.LWCE_EquipLargeItem(self, kStorage.LWCE_GetInfinitePrimary(self), 0);
    }

    if (m_kCEChar.kInventory.arrLargeItems.Length == 1)
    {
        kLockers.LWCE_EquipLargeItem(self, kStorage.LWCE_GetInfiniteSecondary(self), 1);
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
    local LWCE_XGFacility_Lockers kLockers;
    local name ArmorName;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());

    kLockers.UnequipPistol(self);

    ArmorName = m_kCEChar.kInventory.nmArmor;

    if (ArmorName == 'Item_TacArmor')
    {
        kLockers.LWCE_EquipArmor(self, 'Item_TacVest');
    }
    else
    {
        kLockers.LWCE_EquipArmor(self, 'Item_TacArmor');
    }

    // Forcibly re-equips the current armor for some reason (maybe to force the pawn to update?)
    kLockers.LWCE_EquipArmor(self, ArmorName);
    kLockers.LWCE_EquipLargeItem(self, 'Item_RocketLauncher', 1);
    OnLoadoutChange();
}

/// <summary>
/// Gets all of the perk IDs which this soldier has, regardless of source. The resulting array will
/// not contain duplicate items.
/// </summary>
function array<int> GetAllPerks()
{
    local array<int> arrPerks;
    local int Index;

    for (Index = 0; Index < m_kCEChar.arrPerks.Length; Index++)
    {
        if (arrPerks.Find(m_kCEChar.arrPerks[Index].Id) == INDEX_NONE)
        {
            arrPerks.AddItem(m_kCEChar.arrPerks[Index].Id);
        }
    }

    return arrPerks;
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

function LWCE_TClassDefinition GetClassDefinition()
{
    return `LWCE_BARRACKS.GetClassDefinition(m_kCEChar.iClassId);
}

/// <summary>
/// Long War adapted this function to return the soldier's class, and it has been modified for
/// LWCE to do the same. Mod authors should prefer using LWCE_GetClass directly.
/// </summary>
function int GetEnergy()
{
    return LWCE_GetClass();
}

function TInventory GetInventory()
{
    local TInventory kInventory;

    `LWCE_LOG_DEPRECATED_CLS(GetInventory);

    return kInventory;
}

function LWCE_TInventory LWCE_GetInventory()
{
    return m_kCEChar.kInventory;
}

function string GetName(ENameType eType)
{
    local string strOut;

    switch (eType)
    {
        case eNameType_First:
            return m_kCESoldier.strFirstName;
        case eNameType_Last:
            return m_kCESoldier.strLastName;
        case eNameType_Nick:
            if (m_kCESoldier.strNickName != "")
            {
                if (Left(m_kCESoldier.strNickName, 1) != "'" && Right(m_kCESoldier.strNickName, 1) != "'")
                {
                    return "'" $ m_kCESoldier.strNickName $ "'";
                }

                return m_kCESoldier.strNickName;
            }

            return "";
        case eNameType_Full:
            if (HasAnyMedal())
            {
                return GetName(eNameType_RankFull) @ m_kCESoldier.strLastName;
            }

            return m_kCESoldier.strFirstName @ m_kCESoldier.strLastName;
        case eNameType_Rank:
            if (HasAnyMedal())
            {
                return BARRACKS().m_arrMedalNames[MedalCount()];
            }

            return TACTICAL().GetRankString(m_kCESoldier.iRank);
        case eNameType_RankFull:
            return GetName(9) @ m_kCESoldier.strFirstName @ m_kCESoldier.strLastName;
        case eNameType_FullNick:
            if (m_kCESoldier.strNickName != "")
            {
                return GetName(9) @ m_kCESoldier.strFirstName @ GetName(eNameType_Nick) @ m_kCESoldier.strLastName;
            }

            return GetName(eNameType_RankFull);
        case 7: // Rank abbreviation + last name
            return GetName(9) @ m_kCESoldier.strLastName;
        case 8:
            strOut = GetName(eNameType_FullNick) $ "|" $ m_kCEChar.aStats[eStat_HP] $ "|" $ m_kCEChar.aStats[eStat_Mobility] $ "|" $ m_kCEChar.aStats[eStat_Will] $ "|" $ m_kCEChar.aStats[eStat_Offense] $ "|" $ m_kCEChar.aStats[eStat_Defense] $ "|";

            if (!IsATank())
            {
                strOut $= "<font size='1'><br></font><font color='#FFD038' size='16'>" $ m_kCESoldier.iXP;

                if (m_kCESoldier.iRank < 7)
                {
                    strOut $= "/" $ TACTICAL().GetXPRequired(m_kCESoldier.iRank + 1);
                }

                strOut $= "</font>";
            }

            strOut $= "|";

            // Check if this soldier is psionically capable
            if (!HasAnyMedal() && m_kCESoldier.iPsiRank >= 1 && !HasPerk(`LW_PERK_ID(NeuralDamping)) && !IsAugmented() && !IsATank() && `LWCE_LABS.LWCE_IsResearched('Tech_Xenopsionics'))
            {
                strOut $= "<font size='1'><br></font><font color='#A59ED1' size='16'>" $ m_kCESoldier.iPsiXP;

                if (m_kCESoldier.iPsiRank < 6)
                {
                    strOut $= "/" $ TACTICAL().GetPsiXPRequired(m_kCESoldier.iPsiRank + 1);
                }

                strOut $= "</font>";
            }

            return strOut;
        case 9: // Returns the soldier's rank abbreviation (either officer or normal rank)
            if (HasAnyMedal())
            {
                return BARRACKS().m_arrMedalNames[MedalCount() + 5];
            }

            return TACTICAL().GetRankString(m_kCESoldier.iRank, /* bAbbreviated */ true);
    }

    return "???";
}

function int GetNumKills()
{
    return m_kCESoldier.iNumKills;
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

function int GetPsiRank()
{
    return m_kCESoldier.iPsiRank;
}

function int GetRank()
{
    return m_kCESoldier.iRank;
}

function GivePerk(int iPerkId)
{
    `LWCE_LOG_DEPRECATED_CLS(GivePerk);
}

/// <summary>
/// Gives the soldier the specified perk. Note that calling this function alone will not give them
/// any stat bonuses associated with the perk (unless those stat bonuses are built into the perk itself,
/// e.g. Sprinter).
/// </summary>
function LWCE_GivePerk(int iPerkId, name SourceType, optional name SourceId = '')
{
    local LWCE_TIDWithSource kPerkData;

    if (HasPerk(iPerkId))
    {
        return;
    }

    if (iPerkId < ePerk_MAX)
    {
        ++m_kChar.aUpgrades[iPerkId];
    }

    kPerkData.Id = iPerkId;
    kPerkData.SourceId = SourceId;
    kPerkData.SourceType = SourceType;
    m_kCEChar.arrPerks.AddItem(kPerkData);

    if (iPerkId == `LW_PERK_ID(FireRocket))
    {
        // Remove soldier's pistol and give them a rocket launcher
        EquipRocketLauncher();
    }

    if (m_kPawn != none)
    {
        if (`CONTENTMGR.GetPerkContent(EPerkType(iPerkId)) != none)
        {
            m_kPawn.InitPawnPerkContent(m_kChar);
        }
    }

    // Make sure our class icon is up-to-date with the current state of the soldier
    // TODO: there must be a better spot (spots?) to do this
    m_kCESoldier.strClassIcon = LWCE_XGFacility_Barracks(BARRACKS()).GetClassIcon(m_kCESoldier.iSoldierClassId, class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(m_kCEChar), m_kCEChar.bHasPsiGift);
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
        if (m_kCEChar.arrPerks[Index].Id == iPerk && m_kCEChar.arrPerks[Index].SourceType == 'Innate')
        {
            return true;
        }
    }

    return false;
}

function bool IsATank()
{
    return m_kCEChar.iCharacterType == eChar_Tank;
}

function bool IsAugmented()
{
    return GetClassDefinition().bIsAugmented;
}

function bool IsAvailableForCovertOps()
{
    if (HasPerk(`LW_PERK_ID(FireRocket)))
    {
        return false;
    }

    if (IsATank())
    {
        return false;
    }

    if (IsAugmented())
    {
        return false;
    }

    if (GetStatus() != eStatus_Active)
    {
        return false;
    }

    if (IsInjured())
    {
        return false;
    }

    if (GetRank() == 0) // PFCs are ineligible
    {
        return false;
    }

    if (!GetClassDefinition().bCanDoCovertOps)
    {
        return false;
    }

    return true;
}

function bool IsReadyToLevelUp()
{
    if (IsATank())
    {
        return false;
    }
    else
    {
        return m_kCESoldier.iXP >= TACTICAL().GetXPRequired(GetRank() + 1);
    }
}

function bool IsReadyToPsiLevelUp()
{
    if (!HQ().HasFacility(eFacility_PsiLabs))
    {
        return false;
    }

    if (m_bPsiTested)
    {
        return false;
    }

    if (HasPerk(`LW_PERK_ID(NeuralDamping)))
    {
        return false;
    }

    if (GetStatus() != eStatus_Active)
    {
        return false;
    }

    if (IsAugmented())
    {
        return false;
    }

    if (IsATank())
    {
        return false;
    }

    if (HasPerk(`LW_PERK_ID(LeadByExample))) // no officers allowed to be psi
    {
        return false;
    }

    return m_kCESoldier.iPsiXP >= TACTICAL().GetPsiXPRequired(GetPsiRank() + 1);
}

function LevelUp(optional ESoldierClass eClass, optional out string statsString)
{
    `LWCE_LOG_DEPRECATED_CLS(LevelUp);
}

function LWCE_LevelUp(optional int iClassId)
{
    local LWCE_XGFacility_Barracks kBarracks;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());

    if (m_kCESoldier.iRank == 0)
    {
        if (iClassId == 0)
        {
            iClassId = kBarracks.LWCE_PickAClass();
        }

        m_kCESoldier.iSoldierClassId = iClassId;
        m_kCEChar.iBaseClassId = iClassId;
        m_kCEChar.iClassId = iClassId;
    }

    m_kCESoldier.iRank += 1;

    if (GetRank() == 3)
    {
        kBarracks.GenerateNewNickname(self);
    }

    if (m_kCESoldier.iXP < TACTICAL().GetXPRequired(GetRank()))
    {
        m_kCESoldier.iXP = TACTICAL().GetXPRequired(GetRank());
    }

    kBarracks.ReorderRanks();

    if (m_kCESoldier.iRank > kBarracks.m_iHighestRank)
    {
        kBarracks.m_iHighestRank = m_kCESoldier.iRank;

        if (m_kCESoldier.iRank == 7)
        {
            STAT_SetStat(eRecap_FirstColonel, Game().GetDays());
        }
    }

    if (IsAugmented())
    {
        if (m_kCESoldier.iRank > kBarracks.m_iHighestMecRank)
        {
            kBarracks.m_iHighestMecRank = m_kCESoldier.iRank;
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
    `LWCE_LOG_CLS("LWCE_RebuildAfterCombat: kCETransfer.kSoldier name is " $ kCETransfer.kSoldier.strFirstName @ kCETransfer.kSoldier.strLastName $ ", with " $ kCETransfer.kSoldier.iXP $ " XP");

    m_kChar = kTransfer.kChar;
    m_kSoldier = kTransfer.kSoldier;

    m_kCEChar = kCETransfer.kChar;
    m_kCESoldier = kCETransfer.kSoldier;
    m_aStatModifiers[eStat_HP] = kCETransfer.iHPAfterCombat - GetMaxStat(eStat_HP);
    m_bMIA = kCETransfer.bLeftBehind;
    m_strCauseOfDeath = kCETransfer.CauseOfDeathString;
}

function bool RemovePerk(int iPerkId, name nmSourceType, optional name nmSourceId = '')
{
    local int Index;

    for (Index = 0; Index < m_kCEChar.arrPerks.Length; Index++)
    {
        if (m_kCEChar.arrPerks[Index].Id == iPerkId && m_kCEChar.arrPerks[Index].SourceType == nmSourceType && (nmSourceId == '' || m_kCEChar.arrPerks[Index].SourceId == nmSourceId))
        {
            m_kCEChar.arrPerks.Remove(Index, 1);
            return true;
        }
    }

    return false;
}

function SetHQLocation(int iNewHQLocation, optional bool bForce = false, optional int SlotIdx = -1, optional bool bForceNewPawn = false)
{
    `LWCE_LOG_CLS("SetHQLocation: " $ self $ " - iNewHQLocation = " $ ELocation(iNewHQLocation) $ ", bForce = " $ bForce $ ", SlotIdx = " $ SlotIdx $ ", bForceNewPawn = " $ bForceNewPawn);

    super.SetHQLocation(iNewHQLocation, bForce, SlotIdx, bForceNewPawn);
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
    local LWCE_TInventory kNewLoadout;
    local array<ECharacterVoice> PossibleVoices;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());
    kGameCore = LWCE_XGTacticalGameCore(TACTICAL());
    kHQ = LWCE_XGHeadquarters(HQ());
    kStorage = `LWCE_STORAGE;
    iPreviousClassId = m_kCEChar.iClassId;
    kNewLoadout = m_kCEChar.kInventory;

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
            m_kCESoldier.iPsiRank = 0;

            ClearPerks();
            LWCE_GivePerk(`LW_PERK_ID(OneForAll), 'Innate');
            LWCE_GivePerk(`LW_PERK_ID(CombinedArms), 'Innate');

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

            m_kCESoldier.iPsiXP = 0;
            kBarracks.UpdateFoundryPerksForSoldier(self);
            kNewLoadout = m_kCEChar.kInventory;
            kNewLoadout.nmArmor = 'Item_BaseAugments';

            m_kCEChar.iClassId = iMecClassId;
            m_kCESoldier.iSoldierClassId = m_kCEChar.iClassId;

            if (GetRank() < 7)
            {
                m_kCESoldier.iXP = kGameCore.GetXPRequired(GetRank() - 1) + int(float(kGameCore.GetXPRequired(GetRank()) - kGameCore.GetXPRequired(GetRank() - 1)) * (float(1) - (float(kGameCore.GetXPRequired(GetRank() + 1) - m_kCESoldier.iXP) / float(kGameCore.GetXPRequired(GetRank() + 1) - kGameCore.GetXPRequired(GetRank())))));
            }
            else
            {
                m_kCESoldier.iXP = kGameCore.GetXPRequired(GetRank() - 1);
            }

            m_kCESoldier.iRank -= 1;

            if (m_kCESoldier.iRank > kBarracks.m_iHighestMecRank)
            {
                kBarracks.m_iHighestMecRank = m_kCESoldier.iRank;
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
            LWCE_GivePerk(kPerkChoice.iPerkId, 'Innate');
            LWCE_SetSoldierClass(kPerkChoice.iNewClassId);

            return;
    }

    m_kSoldier.kClass.eWeaponType = EWeaponProperty(iEquipmentGroup);
    m_kSoldier.kClass.strName = GetClassName();

    class'LWCEInventoryUtils'.static.SetLargeItem(kNewLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));
    class'LWCEInventoryUtils'.static.SetLargeItem(m_kCEBackedUpLoadout, 0, kStorage.LWCE_GetInfinitePrimary(self));

    if (iNewClassId != eSC_Mec)
    {
        if (HasPerk(`LW_PERK_ID(FireRocket)))
        {
            class'LWCEInventoryUtils'.static.SetLargeItem(kNewLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
            class'LWCEInventoryUtils'.static.SetLargeItem(m_kCEBackedUpLoadout, 1, kStorage.LWCE_GetInfiniteSecondary(self));
        }
        else
        {
            kNewLoadout.nmPistol = kStorage.LWCE_GetInfinitePistol(self);
            m_kCEBackedUpLoadout.nmPistol = kStorage.LWCE_GetInfinitePistol(self);
        }
    }

    LWCE_XGFacility_Lockers(LOCKERS()).LWCE_ApplySoldierLoadout(self, kNewLoadout);

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier())
    {
        AssignRandomPerks();
    }

    SetCosmeticsByClass();
    OnLoadoutChange();
    CopyFromVanillaCharacter();
}

// TODO: eventually we'll just deprecate the vanilla character entirely
protected function CopyFromVanillaCharacter()
{
    local int Index;
    local LWCE_TIDWithSource kIdWithSource;

    m_kCEChar.strName = m_kChar.strName;
    m_kCEChar.iCharacterType = m_kChar.iType;
    m_kCEChar.fBioElectricParticleScale = m_kChar.fBioElectricParticleScale;
    m_kCEChar.bHasPsiGift = m_kChar.bHasPsiGift;

    // Inventory is not copied; we should have fully replaced all use of the vanilla inventory system

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
            kIdWithSource.SourceId = '';
            kIdWithSource.SourceType = 'Innate';

            m_kCEChar.arrAbilities.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < ePerk_MAX; Index++)
    {
        if (m_kChar.aUpgrades[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = '';
            kIdWithSource.SourceType = 'Innate';

            m_kCEChar.arrPerks.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < eCP_MAX; Index++)
    {
        if (m_kChar.aProperties[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = '';
            kIdWithSource.SourceType = 'Innate';

            m_kCEChar.arrProperties.AddItem(kIdWithSource);
        }
    }

    for (Index = 0; Index < eTraversal_MAX; Index++)
    {
        if (m_kChar.aTraversals[Index] > 0)
        {
            kIdWithSource.Id = Index;
            kIdWithSource.SourceId = '';
            kIdWithSource.SourceType = 'Innate';

            m_kCEChar.arrTraversals.AddItem(kIdWithSource);
        }
    }

    SyncCharacterStatsFromVanilla();
}

protected function DamageItem(name ItemName, LWCE_XGStorage kStorage)
{
    kStorage.LWCE_DamageItem(ItemName, 1);

    // Mark that an item was damaged, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsDamagedLastMission, ItemName, 1);
}

protected function LoseItem(name ItemName, LWCE_XGStorage kStorage)
{
    kStorage.LWCE_RemoveItem(ItemName, 1);

    // Mark that an item was lost, for the debrief UI
    `LWCE_UTILS.AdjustItemQuantity(kStorage.m_arrCEItemsLostLastMission, ItemName, 1);
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

    // TODO rewrite to m_kCESoldier
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

protected function bool ShouldItemBeDamaged(name ItemName)
{
    local LWCEEquipmentTemplate kItem;
    local float fPercentHPMissing;
    local int iBaseDamageChance, iScaledDamageChance;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(Durability)))
    {
        return false;
    }

    kItem = LWCEEquipmentTemplate(`LWCE_ITEM(ItemName));
    iBaseDamageChance = kItem.iMaxChanceToBeDamaged;

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

protected function bool ShouldItemBeLost()
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

    `LWCE_LOG_CLS("SyncCharacterStatsFromVanilla for " $ GetName(eNameType_Full) $ ": copying vanilla aim " $ m_kChar.aStats[eStat_Offense] $ "; current is " $ m_kCEChar.aStats[eStat_Offense]);

    for (Index = 0; Index < eStat_MAX; Index++)
    {
        m_kCEChar.aStats[Index] = m_kChar.aStats[Index];
    }
}

defaultproperties
{
    m_iPsionicClassId=1
}