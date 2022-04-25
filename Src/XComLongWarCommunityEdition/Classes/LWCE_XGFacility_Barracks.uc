class LWCE_XGFacility_Barracks extends XGFacility_Barracks
    config(LWCEClasses);

var config array<LWCE_TClassDefinition> arrSoldierClassDefs;

var array<LWCE_TClassDefinition> arrSoldierClasses;


function Init(bool bLoadingFromSave)
{
    BaseInit();

    m_kCharGen = Spawn(class'LWCE_XGCharacterGenerator');

    m_kLockers = Spawn(class'LWCE_XGFacility_Lockers');
    m_kLockers.Init(false);

    m_kPerkManager = Spawn(class'LWCE_XComPerkManager');
    m_kPerkManager.Init();

    BuildClassDefinitions();
    BuildMedals();
}

function AddNewSoldiers(int iNumSoldiers, optional bool bCreatePawns = true)
{
    local LWCE_XGStrategySoldier kSoldier;
    local int I;

    for (I = 0; I < iNumSoldiers; I++)
    {
        kSoldier = Spawn(class'LWCE_XGStrategySoldier');
        kSoldier.m_kSoldier = m_kCharGen.CreateTSoldier();
        kSoldier.m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);
        kSoldier.Init();

        RandomizeStats(kSoldier);
        STORAGE().AutoEquip(kSoldier);
        AddNewSoldier(kSoldier, true);

        if (bCreatePawns)
        {
            kSoldier.SetHQLocation(0, true);
        }

    }

    ReorderRanks();
}

function AddTank(EItemType eArmor, EItemType eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(AddTank);
}

function LWCE_AddTank(int iArmorItemId, int iWeaponItemId)
{
    local LWCE_XGStrategySoldier kTank;
    local TInventory kTankLoadout;

    kTank = Spawn(class'LWCE_XGStrategySoldier');
    kTank.m_kChar = TACTICAL().GetTCharacter(eChar_Tank);

    // TODO try to draw these stats dynamically from the item itself
    if (iArmorItemId == eItem_SHIV_Alloy)
    {
        kTank.m_kSoldier.strLastName = m_strAlloySHIVPrefix $ string(++m_iAlloyTankCounter);
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.ALLOY_SHIV_HP_BONUS;
    }
    else if (iArmorItemId == eItem_SHIV_Hover)
    {
        kTank.m_kSoldier.strLastName = m_strHoverSHIVPrefix $ string(++m_iHoverTankCounter);
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.HOVER_SHIV_HP_BONUS;
    }
    else
    {
        kTank.m_kSoldier.strLastName = m_strSHIVPrefix $ string(++m_iTankCounter);
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CinematicMode)))
    {
        kTank.m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(GhostInTheMachine)) > 0)
    {
        kTank.m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(GhostInTheMachine));
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics)) > 0)
    {
        kTank.m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics));
    }

    kTank.m_kSoldier.iRank = -1;
    kTank.m_kSoldier.iCountry = 66;
    kTankLoadout.iArmor = iArmorItemId;
    kTank.Init();

    TACTICAL().TInventoryLargeItemsSetItem(kTankLoadout, 0, iWeaponItemId);
    m_kLockers.ApplyTankLoadout(kTank, kTankLoadout);
    AddNewSoldier(kTank);

}

function BuildClassDefinitions()
{
    local int iClassId, Index;

    arrSoldierClasses.Length = arrSoldierClassDefs.Length;

    for (Index = 0; Index < arrSoldierClassDefs.Length; Index++)
    {
        arrSoldierClasses[Index] = arrSoldierClassDefs[Index];

        iClassId = arrSoldierClasses[Index].iSoldierClassId;
        arrSoldierClasses[Index].strName = class'XGLocalizedData'.default.SoldierClassNames[iClassId];
    }
}

function int CalcTotalSoldierRanks()
{
    local XGStrategySoldier kSoldier;
    local int iSum;

    iSum = 0;

    foreach m_arrSoldiers(kSoldier)
    {
        if (!kSoldier.IsATank())
        {
            iSum += kSoldier.GetRank();
        }
    }

    return iSum;
}

function bool CanLoadSoldier(XGStrategySoldier kSoldier, optional bool bAllowInjured = false)
{
    if (kSoldier.IsInjured() && !bAllowInjured)
    {
        return false;
    }

    if (kSoldier.GetStatus() == eStatus_OnMission)
    {
        return false;
    }

    if (kSoldier.GetStatus() == eStatus_CovertOps)
    {
        return false;
    }

    if (kSoldier.IsInPsiTesting())
    {
        return false;
    }

    if (kSoldier.IsInGeneticsLab())
    {
        return false;
    }

    if (kSoldier.IsBeingAugmented())
    {
        return false;
    }

    if (kSoldier.m_kChar.kInventory.iArmor == 0)
    {
        return false;
    }

    // No SHIVs allowed on base assault
    if (HANGAR().m_kSkyranger.m_bExtendSquadForHQAssault && kSoldier.IsATank())
    {
        return false;
    }

    // TODO: add mod hook

    return true;
}

function XGStrategySoldier CreateSoldier(ESoldierClass eClass, int iSoldierLevel, int iCountry, optional bool bBlueshirt = false)
{
    local LWCE_XGStrategySoldier kSoldier;
    local int I;

    kSoldier = Spawn(class'LWCE_XGStrategySoldier');
    kSoldier.m_kSoldier = m_kCharGen.CreateTSoldier(, iCountry);
    kSoldier.m_kSoldier.bBlueshirt = bBlueshirt;
    kSoldier.m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);
    kSoldier.Init();

    RandomizeStats(kSoldier);
    STORAGE().AutoEquip(kSoldier);

    if (bBlueshirt)
    {
        if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(SecurityTrainingWeapons)))
        {
            LOCKERS().EquipLargeItem(kSoldier, `LW_ITEM_ID(LaserRifle), 0);
        }

        if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(SecurityTrainingArmor)))
        {
            LOCKERS().EquipArmor(kSoldier, `LW_ITEM_ID(PhalanxArmor));
        }
    }

    for (I = 0; I < iSoldierLevel; I++)
    {
        kSoldier.LWCE_LevelUp(eClass);
    }

    AddNewSoldier(kSoldier,, bBlueshirt);
    return kSoldier;
}

function bool HasSoldierOfRankOrHigher(int iRank)
{
    local XGStrategySoldier kSoldier;

    foreach m_arrSoldiers(kSoldier)
    {
        if (kSoldier.GetRank() >= iRank)
        {
            return true;
        }
    }

    return false;
}

function LWCE_TClassDefinition GetClassDefinition(int iClassId)
{
    local int Index;
    local LWCE_TClassDefinition kClassDef;

    Index = arrSoldierClasses.Find('iSoldierClassId', iClassId);

    if (Index == INDEX_NONE)
    {
        kClassDef.iSoldierClassId = -1;
        return kClassDef;
    }

    return arrSoldierClasses[Index];
}

function string GetClassIcon(int iClassId, bool bIsGeneModded, bool bIsPsionic)
{
    local int Index;

    Index = arrSoldierClasses.Find('iSoldierClassId', iClassId);

    if (Index == INDEX_NONE)
    {
        return "";
    }

    if (bIsGeneModded && bIsPsionic)
    {
        return "img:///" $ arrSoldierClasses[Index].IconGeneModdedAndPsionic;
    }
    else if (bIsGeneModded)
    {
        return "img:///" $ arrSoldierClasses[Index].IconGeneModded;
    }
    else if (bIsPsionic)
    {
        return "img:///" $ arrSoldierClasses[Index].IconPsionic;
    }
    else
    {
        return "img:///" $ arrSoldierClasses[Index].IconBase;
    }
}

function string GetClassName(int iClassId)
{
    local int Index;

    Index = arrSoldierClasses.Find('iSoldierClassId', iClassId);

    if (Index == INDEX_NONE)
    {
        return "";
    }

    return arrSoldierClasses[Index].strName;
}

// Rewritten for Long War: tries to find the index of the soldier who's going to be commanding this mission,
// based on who has the highest officer rank, with a tie-breaker for which soldier has the highest will.
function int GetCommandingSoldierIndex(XGShip_Dropship kSkyranger)
{
    local int iSoldier, iOfficer;

    // LWCE: fix a None access when soldier slot 0 is empty
    // Override kMission and ignore whatever's passed in, so we always use a valid soldier slot
    iOfficer = -1;

    for (iSoldier = 0; iSoldier < kSkyranger.m_arrSoldiers.Length; iSoldier++)
    {
        if (kSkyranger.m_arrSoldiers[iSoldier] == none)
        {
            continue;
        }

        if (iOfficer < 0)
        {
            iOfficer = iSoldier;
        }

        if (kSkyranger.m_arrSoldiers[iSoldier].MedalCount() >= kSkyranger.m_arrSoldiers[iOfficer].MedalCount())
        {
            if (kSkyranger.m_arrSoldiers[iSoldier].MedalCount() == kSkyranger.m_arrSoldiers[iOfficer].MedalCount())
            {
                if (kSkyranger.m_arrSoldiers[iSoldier].GetCurrentStat(eStat_Will) > kSkyranger.m_arrSoldiers[iOfficer].GetCurrentStat(eStat_Will))
                {
                    iOfficer = iSoldier;
                }
            }
            else
            {
                iOfficer = iSoldier;
            }
        }
    }

    return iOfficer;
}

function ESoldierClass GetLeastCommonClass()
{
    `LWCE_LOG_DEPRECATED_CLS(GetLeastCommonClass);
    return eSC_None;
}

function LWCE_TClassDefinition LWCE_GetLeastCommonClass()
{
    local int Index, iLeastCommonIndex;
    local array<LWCE_TClassDefinition> arrBaseClasses;
    local array<int> arrOccurrences;
    local LWCE_TClassDefinition kClassDef;

    foreach arrSoldierClasses(kClassDef)
    {
        if (kClassDef.bIsBaseClass)
        {
            arrBaseClasses.AddItem(kClassDef);
        }
    }

    for (Index = 0; Index < arrBaseClasses.Length; Index++)
    {
        arrOccurrences[Index] = LWCE_GetNumSoldiersOfClass(arrBaseClasses[Index].iSoldierClassId);
    }

    iLeastCommonIndex = 0;

    for (Index = 1; Index < arrBaseClasses.Length; Index++)
    {
        if (arrOccurrences[Index] < arrOccurrences[iLeastCommonIndex])
        {
            iLeastCommonIndex = Index;
        }
        else if (arrOccurrences[Index] == arrOccurrences[iLeastCommonIndex])
        {
            // If two classes are equally sparse, 50% chance to swap
            if (Rand(2) == 1)
            {
                iLeastCommonIndex = Index;
            }
        }
    }

    return arrBaseClasses[iLeastCommonIndex];
}

function int LWCE_GetNumSoldiersOfBaseClass(int iClassId)
{
    local int iNum;
    local XGStrategySoldier kSoldier;

    foreach m_arrSoldiers(kSoldier)
    {
        if (LWCE_XGStrategySoldier(kSoldier).LWCE_GetBaseClass() == iClassId)
        {
            iNum++;
        }
    }

    return iNum;
}

function int GetNumSoldiersOfClass(ESoldierClass eClass)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumSoldiersOfClass);
    return -1;
}

function int LWCE_GetNumSoldiersOfClass(int iClassId)
{
    local int iNum;
    local XGStrategySoldier kSoldier;

    foreach m_arrSoldiers(kSoldier)
    {
        if (LWCE_XGStrategySoldier(kSoldier).LWCE_GetClass() == iClassId)
        {
            iNum++;
        }
    }

    return iNum;
}

/// <summary>
/// Returns the ID of the corresponding MEC class for the input class.
/// If the input class cannot be augmented, returns -1.
/// </summary>
function int GetResultingMecClass(int iClassId)
{
    local LWCE_TClassDefinition kClassDef;

    kClassDef = GetClassDefinition(iClassId);

    if (kClassDef.iSoldierClassId < 0 || kClassDef.iAugmentsIntoClassId <= 0)
    {
        return -1;
    }

    return kClassDef.iAugmentsIntoClassId;
}

// Rewritten for Long War: tries to find the index of the soldier who's going to be commanding this mission,
// based on who has the highest officer rank, with a tie-breaker for which soldier has the highest will.
// In LWCE, this has been moved to GetCommandingSoldierIndex.
function int LoadOrUnloadSoldier(int kSoldier, XGShip_Dropship kSkyranger, optional int kMission = -2)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function LoadOrUnloadSoldier was called. This needs to be replaced with GetCommandingSoldierIndex. Stack trace follows.");
    ScriptTrace();
    return -1;
}

function ESoldierClass NeverGiven()
{
    `LWCE_LOG_DEPRECATED_CLS(NeverGiven);
    return eSC_None;
}

/// <summary>
/// Returns a base class ID which has never been assigned to a soldier in this campaign, if any exist.
/// </summary>
function int LWCE_NeverGiven()
{
    local array<LWCE_TClassDefinition> arrBaseClasses;
    local XGStrategySoldier kSoldier;
    local LWCE_XGStrategySoldier kCESoldier;
    local int iClassIndex;
    local LWCE_TClassDefinition kClassDef;

    foreach arrSoldierClasses(kClassDef)
    {
        if (kClassDef.bIsBaseClass)
        {
            arrBaseClasses.AddItem(kClassDef);
        }
    }

    foreach m_arrSoldiers(kSoldier)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSoldier);
        iClassIndex = arrBaseClasses.Find('iSoldierClassId', kCESoldier.LWCE_GetBaseClass());

        if (iClassIndex != INDEX_NONE)
        {
            arrBaseClasses.Remove(iClassIndex, 1);
        }
    }

    foreach m_arrFallen(kSoldier)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSoldier);
        iClassIndex = arrBaseClasses.Find('iSoldierClassId', kCESoldier.LWCE_GetBaseClass());

        if (iClassIndex != INDEX_NONE)
        {
            arrBaseClasses.Remove(iClassIndex, 1);
        }
    }

    if (arrBaseClasses.Length > 0)
    {
        return arrBaseClasses[Rand(arrBaseClasses.Length)].iSoldierClassId;
    }
    else
    {
        return 0;
    }
}

function ESoldierClass PickAClass()
{
    `LWCE_LOG_DEPRECATED_CLS(PickAClass);
    return eSC_None;
}

function int LWCE_PickAClass()
{
    local int iClassId;

    iClassId = LWCE_NeverGiven();

    if (iClassId != 0)
    {
        return iClassId;
    }

    if (Rand(100) > class'XGTacticalGameCore'.default.LATE_UFO_CHANCE)
    {
        return SelectRandomBaseClassId();
    }
    else
    {
        return LWCE_GetLeastCommonClass().iSoldierClassId;
    }
}

function PostMission(XGShip_Dropship kSkyranger, bool bSkipSetHQLocation)
{
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategySoldier kCESoldier;
    local XGStrategySoldier kSoldier;

    kStorage = `LWCE_STORAGE;

    kStorage.m_arrCEItemsDamagedLastMission.Remove(0, kStorage.m_arrCEItemsDamagedLastMission.Length);
    kStorage.m_arrCEItemsLostLastMission.Remove(0, kStorage.m_arrCEItemsLostLastMission.Length);

    foreach kSkyranger.m_arrSoldiers(kSoldier)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSoldier);
        kCESoldier.CheckForDamagedOrLostItems();

        DetermineTimeOut(kSoldier);
        kSoldier.m_iNumMissions += 65537; // The upper two bytes of m_iNumMissions track how many missions the soldier has been on at their current officer rank
        UpdateOTSPerksForSoldier(kSoldier);

        if (kSoldier.GetRank() == 7)
        {
            // Give bonus stats every N missions for MSGT soldiers
            if ((kSoldier.GetNumMissions() % int(float(class'XGTacticalGameCore'.default.HQ_STARTING_MONEY) * (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)) ? class'XGTacticalGameCore'.default.SW_MARATHON : float(1)))) == 0)
            {
                switch (Rand(10))
                {
                    case 0:
                        if (kSoldier.m_kChar.aStats[eStat_HP] < 20)
                        {
                            kSoldier.m_kChar.aStats[eStat_HP] += 1;
                        }

                        break;
                    case 1:
                    case 2:
                    case 3:
                        if (kSoldier.m_kChar.aStats[eStat_Offense] < 120)
                        {
                            kSoldier.m_kChar.aStats[eStat_Offense] += 1;
                        }

                        break;
                    case 4:
                    case 5:
                    case 6:
                        if (kSoldier.m_kChar.aStats[eStat_Will] < 120)
                        {
                            kSoldier.m_kChar.aStats[eStat_Will] += 1;
                        }

                        break;
                    case 7:
                    case 8:
                    case 9:
                        if (kSoldier.m_kChar.aStats[eStat_Defense] < 20)
                        {
                            kSoldier.m_kChar.aStats[eStat_Defense] += 1;
                        }

                        break;
                }
            }
        }
    }

    if (kSkyranger.m_kCovertOperative != none)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSkyranger.m_kCovertOperative);
        kCESoldier.CheckForDamagedOrLostItems();

        DetermineTimeOut(kCESoldier);
        kCESoldier.m_iNumMissions += 65537;
    }

    if (!bSkipSetHQLocation)
    {
        SetAllSoldierHQLocations();
    }
}

/// <summary>
/// Selects the class ID of a base class at random, without regard for the current or historical XCOM roster.
/// </summary>
function int SelectRandomBaseClassId()
{
    local array<LWCE_TClassDefinition> arrBaseClasses;
    local LWCE_TClassDefinition kClassDef;

    foreach arrSoldierClasses(kClassDef)
    {
        if (kClassDef.bIsBaseClass)
        {
            arrBaseClasses.AddItem(kClassDef);
        }
    }

    // This shouldn't ever happen, but may as well check
    if (arrBaseClasses.Length == 0)
    {
        return -1;
    }

    return arrBaseClasses[Rand(arrBaseClasses.Length)].iSoldierClassId;
}

function SelectSoldiersForSkyrangerSquad(XGShip_Dropship kSkyranger, out array<XGStrategySoldier> arrSoldiers, optional XGMission kMission = none)
{
    local XGStrategySoldier kSoldier, kVolunteer;
    local int iNumToPreload;

    arrSoldiers.Length = 0;

    // Soldiers only get preloaded on the first mission (since there's no chance for the player to load them)
    if (kMission != none && kMission.m_kDesc.m_bIsFirstMission == true)
    {
        iNumToPreload = kSkyranger.GetCapacity();
    }
    else
    {
        iNumToPreload = 0;
    }

    if (kMission != none && kMission.m_iMissionType == eMission_Final)
    {
        foreach m_arrSoldiers(kSoldier)
        {
            if (kSoldier.m_kSoldier.iPsiRank == 7)
            {
                kVolunteer = kSoldier;
                arrSoldiers.AddItem(kSoldier);

                break;
            }
        }

        if (kVolunteer != none && kVolunteer.MedalCount() > 4)
        {
            XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_GuardianOfEarth);
        }
    }

    foreach BARRACKS().m_aLastMissionSoldiers(kSoldier)
    {
        if (arrSoldiers.Length < iNumToPreload && kSoldier != kVolunteer && BARRACKS().CanLoadSoldier(kSoldier))
        {
            arrSoldiers.AddItem(kSoldier);
        }
    }

    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        if (arrSoldiers.Length < iNumToPreload)
        {
            if (arrSoldiers.Find(kSoldier) < 0 && BARRACKS().CanLoadSoldier(kSoldier))
            {
                if (kSoldier.GetStatus() != 8)
                {
                    arrSoldiers.AddItem(kSoldier);
                }
            }
        }
    }
}

function bool UnloadSoldier(XGStrategySoldier kSoldier)
{
    local XGShip_Dropship kSkyranger;
    local LWCE_XGStrategySoldier kCESoldier;
    local bool bFound;
    local int I;

    bFound = false;
    kSkyranger = HANGAR().m_kSkyranger;
    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    for (I = 0; I < kSkyranger.m_arrSoldiers.Length; I++)
    {
        if (kSkyranger.m_arrSoldiers[I] == kCESoldier)
        {
            bFound = true;
            break;
        }
    }

    if (bFound)
    {
        kSkyranger.m_arrSoldiers.RemoveItem(kCESoldier);
    }
    else if (kSkyranger.m_kCovertOperative == kCESoldier)
    {
        kSkyranger.m_kCovertOperative = none;
        bFound = true;
    }

    if (!bFound)
    {
        return true;
    }

    if (kCESoldier.m_bBlueShirt)
    {
        kCESoldier.m_bBlueShirt = false;
        DetermineTimeOut(kCESoldier);
        UpdateOTSPerksForSoldier(kCESoldier);

        if (kCESoldier.IsReadyToLevelUp())
        {
            kCESoldier.LWCE_LevelUp();
        }
    }

    if (kCESoldier.GetCurrentStat(eStat_HP) <= 0)
    {
        MoveToMorgue(kCESoldier, kSkyranger.m_strLastOpName, GEOSCAPE().m_kDateTime);
    }
    else if (kCESoldier.IsInjured())
    {
        MoveToInfirmary(kCESoldier);
    }
    else if (kCESoldier.m_bAllIn)
    {
        STORAGE().BackupAndReleaseInventory(kCESoldier);
        kSoldier.SetStatus(ESoldierStatus(8));
    }
    else
    {
        kCESoldier.SetStatus(eStatus_Active);
    }

    return true;
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier)
{
    local LWCE_XGFacility_Engineering kEngineering;

    kEngineering = `LWCE_ENGINEERING;

    if (HQ().HasFacility(eFacility_Foundry))
    {
        // LWCE issue #4: LW 1.0 uses the ID for Phoenix Coilguns (44) in this block, where it means to use Quenchguns (46)
        kSoldier.m_kChar.aUpgrades[109] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(SCOPEUpgrade)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[110] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(MagPistols)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[111] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(RailPistols)) ? 1 : 0;

        // aUpgrades[123] is a bitfield of different Foundry upgrades
        kSoldier.m_kChar.aUpgrades[123] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(AmmoConservation)) ? 1 << 1 : 0;
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(EnhancedPlasma))  ? 1 << 2 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(AdvancedFlight)) ? 1 << 3 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(ReflexPistols)) ? 1 << 4 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(Quenchguns)) ? 1 << 5 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(ImprovedMedikit))  ? 1 << 6 : 0);

        kSoldier.m_kChar.aUpgrades[115] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(ImprovedArcThrower)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[117] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(DroneCapture)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[118] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(FieldRepairs)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[120] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(JelliedElerium)) ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[125] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades)) ? 1 : 0;

        kSoldier.UpdateTacticalRigging(kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(TacticalRigging)));

        if (kSoldier.IsATank())
        {
            kSoldier.m_kChar.aUpgrades[124] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(SentinelDrone)) ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[139] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(SentinelDrone)) ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[`LW_PERK_ID(Suppression)] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(SHIVSuppression)) ? 1 : 0;
        }

        if (kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[121] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(MECCloseCombat)) ? 1 : 0;
        }

        if (kSoldier.IsATank() || kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[31] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(AdvancedServomotors)) ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(ShapedArmor)) ? 1 : 0);
        }
    }
    else
    {
        kSoldier.m_kChar.aUpgrades[109] = 0; // SCOPE Upgrade
        kSoldier.m_kChar.aUpgrades[110] = 0; // Mag Pistols
        kSoldier.m_kChar.aUpgrades[111] = 0; // Rail Pistols
        kSoldier.m_kChar.aUpgrades[115] = 0; // Improved Arc Thrower
        kSoldier.m_kChar.aUpgrades[117] = 0; // Drone Capture
        kSoldier.m_kChar.aUpgrades[118] = 0; // Field Repairs
        kSoldier.m_kChar.aUpgrades[120] = 0; // Jellied Elerium
        kSoldier.m_kChar.aUpgrades[121] = 0; // MEC Close Combat
        kSoldier.m_kChar.aUpgrades[123] = 0; // Bitfield of multiple upgrades
        kSoldier.m_kChar.aUpgrades[124] = 0; // Sentinel Drone
        kSoldier.m_kChar.aUpgrades[125] = 0; // Alien Grenades
        kSoldier.UpdateTacticalRigging(false);
    }

    kSoldier.m_kChar.aUpgrades[113] = 0;

    `LWCE_MOD_LOADER.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
}