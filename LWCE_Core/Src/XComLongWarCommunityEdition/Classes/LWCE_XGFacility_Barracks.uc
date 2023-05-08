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

function InitNewGame()
{
    bInitingNewGame = true;
    m_iCapacity = class'XGTacticalGameCore'.default.BARRACKS_CAPACITY;
    m_arrOTSUpgrades.Add(8);
    LWCE_CreateSoldier(0, 0, HQ().GetHomeCountry());

    AddNewSoldiers(class'XGTacticalGameCore'.default.NUM_STARTING_SOLDIERS - 1, false);
    bInitingNewGame = false;
}

function AddNewSoldier(XGStrategySoldier kSoldier, optional bool bSkipReorder = false, optional bool bBlueshirt = false)
{
    local LWCEDataContainer kData;

    LWCE_XGStrategySoldier(kSoldier).m_kCESoldier.iID = m_iSoldierCounter++;

    UpdateOTSPerksForSoldier(kSoldier);
    UpdateFoundryPerksForSoldier(kSoldier);
    NameCheck(kSoldier);

    // EVENT: BeforeAddMissionToGeoscape
    //
    // SUMMARY: Emitted right before a soldier is added to the barracks. This includes SHIVs. At this point, all base game
    //          soldier generation (stats, class, country, name, etc) is complete and can be overridden by listeners.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCE_XGStrategySoldier - The soldier who is about to be added. Can be modified freely.
    //
    // SOURCE: LWCE_XGFacility_Barracks
    kData = class'LWCEDataContainer'.static.NewObject('AddNewSoldier', kSoldier);
    `LWCE_EVENT_MGR.TriggerEvent('AddNewSoldier', kData, self);

    m_arrSoldiers.AddItem(kSoldier);

    if (!bSkipReorder)
    {
        ReorderRanks();
    }

    if (STAT_GetStat(eRecap_MaxSoldiers) < m_arrSoldiers.Length)
    {
        STAT_SetStat(eRecap_MaxSoldiers, m_arrSoldiers.Length);
    }
}

function AddNewSoldiers(int iNumSoldiers, optional bool bCreatePawns = true)
{
    local LWCE_XGStrategySoldier kSoldier;
    local int I;

    for (I = 0; I < iNumSoldiers; I++)
    {
        kSoldier = Spawn(class'LWCE_XGStrategySoldier');
        kSoldier.m_kCESoldier = LWCE_XGCharacterGenerator(m_kCharGen).LWCE_CreateTSoldier();
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

function LWCE_AddTank(name ArmorName, name WeaponName)
{
    local LWCE_XGStrategySoldier kTank;
    local LWCE_TInventory kTankLoadout;

    // TODO: set and use m_kCEChar as well
    kTank = Spawn(class'LWCE_XGStrategySoldier');
    kTank.m_kChar = TACTICAL().GetTCharacter(eChar_Tank);

    if (ArmorName == 'Item_SHIVAlloyChassis')
    {
        kTank.m_kCESoldier.strLastName = m_strAlloySHIVPrefix $ ++m_iAlloyTankCounter;
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.ALLOY_SHIV_HP_BONUS;
    }
    else if (ArmorName == 'Item_SHIVHoverChassis')
    {
        kTank.m_kCESoldier.strLastName = m_strHoverSHIVPrefix $ ++m_iHoverTankCounter;
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.HOVER_SHIV_HP_BONUS;
    }
    else
    {
        kTank.m_kCESoldier.strLastName = m_strSHIVPrefix $ ++m_iTankCounter;
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

    kTank.m_kCESoldier.iRank = -1;
    kTank.m_kCESoldier.iCountry = 66;
    kTankLoadout.nmArmor = ArmorName;
    kTank.Init();

    class'LWCEInventoryUtils'.static.SetLargeItem(kTankLoadout, 0, WeaponName);
    LWCE_XGFacility_Lockers(m_kLockers).LWCE_ApplyTankLoadout(kTank, kTankLoadout);
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

        if (iClassId < 48)
        {
            arrSoldierClasses[Index].strName = class'XGLocalizedData'.default.SoldierClassNames[iClassId];
        }

        // Populate possible nicknames for the class. This isn't the most flexible way - someone could make a mod that uses the
        // same supraclasses and new subclasses or something, and maybe invalidate some assumptions here. If someone does that, they
        // can handle it in their mod.
        switch (iClassId)
        {
            case 1:  // Scout-Sniper
            case 11: // Sniper
            case 21: // Scout
                arrSoldierClasses[Index].NicknamesFemale = class'XGCharacterGenerator'.default.m_arrFSniperNicknames;
                arrSoldierClasses[Index].NicknamesMale = class'XGCharacterGenerator'.default.m_arrMSniperNicknames;
                break;
            case 2:  // Weapons
            case 12: // Rocketeer
            case 22: // Gunner
                arrSoldierClasses[Index].NicknamesFemale = class'XGCharacterGenerator'.default.m_arrFHeavyNicknames;
                arrSoldierClasses[Index].NicknamesMale = class'XGCharacterGenerator'.default.m_arrMHeavyNicknames;
                break;
            case 3:  // Support
            case 13: // Medic
            case 23: // Engineer
                arrSoldierClasses[Index].NicknamesFemale = class'XGCharacterGenerator'.default.m_arrFSupportNicknames;
                arrSoldierClasses[Index].NicknamesMale = class'XGCharacterGenerator'.default.m_arrMSupportNicknames;
                break;
            case 4:  // Tactical
            case 14: // Assault
            case 24: // Infantry
                arrSoldierClasses[Index].NicknamesFemale = class'XGCharacterGenerator'.default.m_arrFAssaultNicknames;
                arrSoldierClasses[Index].NicknamesMale = class'XGCharacterGenerator'.default.m_arrMAssaultNicknames;
                break;
            case 6:  // MEC supraclass
            case 31: // Jaeger
            case 32: // Archer
            case 33: // Guardian
            case 34: // Marauder
            case 41: // Pathfinder
            case 42: // Goliath
            case 43: // Shogun
            case 44: // Valkyrie
                arrSoldierClasses[Index].NicknamesFemale = class'XGCharacterGenerator'.default.m_arrFMECNicknames;
                arrSoldierClasses[Index].NicknamesMale = class'XGCharacterGenerator'.default.m_arrMMECNicknames;
                break;
        }
    }

    `LWCE_MOD_LOADER.OnClassDefinitionsBuilt(arrSoldierClasses);
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

    if (LWCE_XGStrategySoldier(kSoldier).m_kCEChar.kInventory.nmArmor == '')
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

function ChooseHQAssaultSquad(XGShip_Dropship kSkyranger, bool bReinforcements)
{
    local XGStrategySoldier kSoldier;

    if (bReinforcements)
    {
        while (kSkyranger.m_arrSoldiers.Length > 8)
        {
            kSoldier = kSkyranger.m_arrSoldiers[Rand(kSkyranger.m_arrSoldiers.Length)];
            UnloadSoldier(kSoldier);
        }

        kSkyranger.m_bReinforcementsForHQAssault = true;

        while (!kSkyranger.IsFull())
        {
            kSoldier = LWCE_CreateSoldier(0, 0, Continent(HQ().GetContinent()).GetRandomCouncilCountry(), true);
            kSoldier.m_bBlueShirt = true;
            kSoldier.m_kSoldier.kAppearance.iArmorTint = 7;
            kSoldier.m_kSoldier.kAppearance.iHaircut = 425;
            kSoldier.m_kSoldier.kAppearance.iVoice = kSoldier.m_kSoldier.kAppearance.iGender == eGender_Male ? 61 : 64;
            kSoldier.m_kSoldier.kAppearance.iLanguage = 0;
            LoadSoldier(kSoldier, kSkyranger);
        }
    }
}

function XGStrategySoldier CreateSoldier(ESoldierClass iClassId, int iSoldierLevel, int iCountry, optional bool bBlueshirt = false)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateSoldier);
    return none;
}

function LWCE_XGStrategySoldier LWCE_CreateSoldier(int iClassId, int iSoldierLevel, int iCountry, optional bool bBlueshirt = false)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Lockers kLockers;
    local LWCE_XGStrategySoldier kSoldier;
    local int I;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kLockers = LWCE_XGFacility_Lockers(LOCKERS());

    kSoldier = Spawn(class'LWCE_XGStrategySoldier');
    kSoldier.m_kCESoldier = LWCE_XGCharacterGenerator(m_kCharGen).LWCE_CreateTSoldier(, iCountry);
    kSoldier.m_kCESoldier.bBlueshirt = bBlueshirt;
    kSoldier.m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);
    kSoldier.Init();

    RandomizeStats(kSoldier);
    STORAGE().AutoEquip(kSoldier);

    if (bBlueshirt)
    {
        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_SecurityTrainingWeapons'))
        {
            kLockers.LWCE_EquipLargeItem(kSoldier, 'Item_LaserRifle', 0);
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_SecurityTrainingArmor'))
        {
            kLockers.LWCE_EquipArmor(kSoldier, 'Item_PhalanxArmor');
        }
    }

    for (I = 0; I < iSoldierLevel; I++)
    {
        kSoldier.LWCE_LevelUp(iClassId);
    }

    AddNewSoldier(kSoldier,, bBlueshirt);
    return kSoldier;
}

function DetermineTimeOut(XGStrategySoldier kSoldier)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGFacility_Engineering kEngineering;
    local int iBaseTimeOut, iRandTimeOut;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    kCESoldier.m_iTurnsOut = 0;

    if (kCESoldier.IsATank())
    {
        kCESoldier.m_iTurnsOut += 24 + Rand(24);
    }
    else
    {
        if (kCESoldier.IsAugmented())
        {
            if ((kCESoldier.m_bAllIn || kCESoldier.IsInjured()) && kCESoldier.GetCurrentStat(eStat_HP) > 0)
            {
                kCESoldier.m_iTurnsOut += 144;
            }
            else
            {
                kCESoldier.m_iTurnsOut += 120 + Rand(24);
            }
        }
        else
        {
            if ((kCESoldier.m_bAllIn || kCESoldier.IsInjured()) && kCESoldier.GetCurrentStat(eStat_HP) > 0)
            {
                kCESoldier.m_iTurnsOut += 144;
            }
            else
            {
                kCESoldier.m_iTurnsOut += 96 + Rand(48);
            }

            if (HQ().HasBonus(`LW_HQ_BONUS_ID(GiftOfOsiris)) > 0)
            {
                kCESoldier.m_iTurnsOut += int((1.0f - (HQ().HasBonus(`LW_HQ_BONUS_ID(GiftOfOsiris)) / 100.0f)) * (class'XGTacticalGameCore'.default.SPECIES_POINT_LIMIT * kCESoldier.MedalCount()));
            }
            else
            {
                kCESoldier.m_iTurnsOut += class'XGTacticalGameCore'.default.SPECIES_POINT_LIMIT * kCESoldier.MedalCount();
            }

            for (iBaseTimeOut = 0; iBaseTimeOut < class'XGTacticalGameCore'.default.ItemBalance_Easy.Length; iBaseTimeOut++)
            {
                if (kCESoldier.HasPerk(class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].eItem))
                {
                    if (HQ().HasBonus(`LW_HQ_BONUS_ID(GiftOfOsiris)) > 0)
                    {
                        kCESoldier.m_iTurnsOut += int((1.0f - (HQ().HasBonus(`LW_HQ_BONUS_ID(GiftOfOsiris)) / 100.0f)) * class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].iEng);
                    }
                    else
                    {
                        if (HQ().HasBonus(`LW_HQ_BONUS_ID(CallToArms)) > 0)
                        {
                            if (class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].iAlloys > 0)
                            {
                                kCESoldier.m_iTurnsOut += int((1.0f - (HQ().HasBonus(`LW_HQ_BONUS_ID(CallToArms)) / 100.0f)) * class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].iEng);
                                continue;
                            }
                        }

                        kCESoldier.m_iTurnsOut += class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].iEng;
                    }
                }
            }
        }

        if (kCESoldier.m_bAllIn)
        {
            if (kCESoldier.GetCurrentStat(eStat_HP) > 0)
            {
                kCESoldier.m_aStatModifiers[eStat_HP] = Max(kCESoldier.m_aStatModifiers[eStat_HP] - 1, 1 - kCESoldier.GetMaxStat(eStat_HP));
            }
        }
        else
        {
            kCESoldier.m_bAllIn = true;
        }
    }

    kCESoldier.m_iTurnsOut += kCESoldier.GetMaxStat(eStat_CriticalWoundsReceived) * class'XGTacticalGameCore'.default.CB_AIRANDSPACE_BONUS;
    kCESoldier.m_iTurnsOut *= float(class'XGTacticalGameCore'.default.RAND_DAYS_INJURED_TANK) / 100.0f;

    if (kCESoldier.HasPerk(`LW_PERK_ID(StayFrosty)))
    {
        kCESoldier.m_iTurnsOut -= Min(24, kCESoldier.m_iTurnsOut);
    }

    if (kCESoldier.m_kCEChar.kInventory.nmArmor == 'Item_VortexArmor')
    {
        kCESoldier.m_iTurnsOut = 0;
        kCESoldier.m_bAllIn = false;
    }

    if (kCESoldier.IsInjured() && kCESoldier.GetCurrentStat(eStat_HP) > 0)
    {
        if (kCESoldier.IsATank())
        {
            iBaseTimeOut = class'XGTacticalGameCore'.default.BASE_DAYS_INJURED_TANK;
            iRandTimeOut = iBaseTimeOut * (kCESoldier.GetMaxStat(eStat_HP) - kCESoldier.GetCurrentStat(eStat_HP));
            iRandTimeOut += Max(2 * iBaseTimeOut * ((kCESoldier.GetMaxStat(eStat_HP) / 4) - kCESoldier.GetCurrentStat(eStat_HP)), 0);
            iRandTimeOut += Rand(Max(iRandTimeOut / 2, 96));

            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedRepair'))
            {
                iRandTimeOut *= 0.670;
            }
        }
        else
        {
            iBaseTimeOut = class'XGTacticalGameCore'.default.BASE_DAYS_INJURED;
            iRandTimeOut = class'XGTacticalGameCore'.default.RAND_DAYS_INJURED;
            iBaseTimeOut -= ((iBaseTimeOut * (iRandTimeOut / 100)) / (STAT_GetStat(1) + (iRandTimeOut % 100)));
            iRandTimeOut = iBaseTimeOut;
            iRandTimeOut -= ((iBaseTimeOut * kCESoldier.GetCurrentStat(eStat_HP)) / kCESoldier.GetMaxStat(eStat_HP));
            iRandTimeOut -= Rand(iBaseTimeOut / kCESoldier.GetMaxStat(eStat_HP));

            if (kCESoldier.IsAugmented())
            {
                if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedRepair'))
                {
                    iRandTimeOut *= 0.80;
                }
            }

            if (kCESoldier.HasPerk(`LW_PERK_ID(AdaptiveBoneMarrow)))
            {
                iRandTimeOut *= (1.0 - class'XGTacticalGameCore'.default.GENEMOD_BONEMARROW_RECOVERY_BONUS);
            }

            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedSurgery'))
            {
                iRandTimeOut *= 0.70;
            }
        }
    }

    kCESoldier.m_iTurnsOut += iRandTimeOut;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        if (class'XGTacticalGameCore'.default.SW_MARATHON < 1.0f)
        {
            kCESoldier.m_iTurnsOut /= (class'XGTacticalGameCore'.default.SW_MARATHON + 1.0f) / 2.0f;
        }
        else
        {
            kCESoldier.m_iTurnsOut /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    kCESoldier.m_iTurnsOut = Max(0, kCESoldier.m_iTurnsOut);
    STAT_AddStat(eRecap_DaysInInfirmary, kCESoldier.m_iTurnsOut / 24);
}

function DismissSoldier(XGStrategySoldier kSoldier)
{
    if (kSoldier == none)
    {
        return;
    }

    if (LWCE_XGStrategySoldier(kSoldier).m_kCESoldier.iPsiRank == 7)
    {
        return;
    }

    RemoveSoldier(kSoldier);
    STORAGE().ReleaseLoadout(kSoldier);
    RollStat(kSoldier, 0, 0); // Releases any officer medals used by this soldier
    kSoldier.Destroy();
}

function GenerateNewNickname(XGStrategySoldier kNickSoldier)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_TClassDefinition kClassDef;
    local array<string> NickNames;

    kCESoldier = LWCE_XGStrategySoldier(kNickSoldier);

    if (kCESoldier.m_kCESoldier.strNickName == "")
    {
        kClassDef = GetClassDefinition(kCESoldier.LWCE_GetClass());
        NickNames = kCESoldier.m_kCESoldier.kAppearance.iGender == eGender_Female ? kClassDef.NicknamesFemale : kClassDef.NicknamesMale;

        if (NickNames.Length == 0)
        {
            `LWCE_LOG_CLS("WARNING! Class ID " $ kClassDef.iSoldierClassId $ " does not have any nicknames configured for gender " $ (kCESoldier.m_kCESoldier.kAppearance.iGender == eGender_Female ? "female" : "male"));
            return;
        }

        kCESoldier.m_kCESoldier.strNickName = NickNames[Rand(NickNames.Length)];
        NickNameCheck(kCESoldier);
    }
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

    if (iClassId == 0)
    {
        return "";
    }

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

        if (iOfficer < 0 && kSkyranger.m_arrSoldiers[iSoldier].MedalCount() > 0)
        {
            iOfficer = iSoldier;
        }

        if (iOfficer >= 0 && kSkyranger.m_arrSoldiers[iSoldier].MedalCount() >= kSkyranger.m_arrSoldiers[iOfficer].MedalCount())
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

function XGStrategySoldier GetSoldierByID(int iID)
{
    local XGStrategySoldier kSoldier;

    foreach m_arrSoldiers(kSoldier)
    {
        if (LWCE_XGStrategySoldier(kSoldier).m_kCESoldier.iID == iID)
        {
            return kSoldier;
        }
    }

    return none;
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

function HealAndRest()
{
    local XGMission kMission;
    local XGStrategySoldier kSoldier;
    local int iHP;

    foreach m_arrSoldiers(kSoldier)
    {
        if (kSoldier.GetStatus() == eStatus_OnMission)
        {
            continue;
        }

        if (kSoldier.m_iTurnsOut <= 0)
        {
            if (kSoldier.GetStatus() == eStatus_Healing || kSoldier.GetStatus() == /* fatigued */ 8)
            {
                iHP = kSoldier.GetMaxStat(eStat_HP) - kSoldier.GetCurrentStat(eStat_HP);
                kSoldier.Heal(iHP);
                PRES().Notify(eGA_SoldierHealed, LWCE_XGStrategySoldier(kSoldier).m_kCESoldier.iID);

                foreach GEOSCAPE().m_arrMissions(kMission)
                {
                    if (kMission.m_iDetectedBy >= 0)
                    {
                        GEOSCAPE().RestoreNormalTimeFrame();
                        break;
                    }
                }

                kSoldier.SetStatus(eStatus_Active);
                kSoldier.m_bAllIn = false;
                STORAGE().RestoreBackedUpInventory(kSoldier);
            }
        }

        if (kSoldier.m_iTurnsOut > 0)
        {
            if (kSoldier.GetStatus() == eStatus_Healing)
            {
                iHP = kSoldier.GetMaxStat(eStat_HP) - kSoldier.GetCurrentStat(eStat_HP);
                if (((iHP - 1) / kSoldier.m_iTurnsOut) >= 1)
                {
                    kSoldier.Heal((iHP - 1) / kSoldier.m_iTurnsOut);
                }
            }

            kSoldier.m_iTurnsOut--;
        }
    }

    ReorderRanks();
    STAT_SetStat(1, Max(Game().GetDays(), Game().GetDays() + STAT_GetStat(2)));
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

function NickNameCheck(XGStrategySoldier kSoldier)
{
    local int iCounter;
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_TClassDefinition kClassDef;
    local array<string> NickNames;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (kCESoldier.IsATank())
    {
        return;
    }

    kClassDef = GetClassDefinition(kCESoldier.LWCE_GetClass());
    NickNames = kCESoldier.m_kCESoldier.kAppearance.iGender == eGender_Female ? kClassDef.NicknamesFemale : kClassDef.NicknamesMale;

    iCounter = 20;
    while (NickNameMatch(kCESoldier) && iCounter > 0)
    {
        kCESoldier.m_kCESoldier.strNickName = NickNames[Rand(NickNames.Length)];
        iCounter--;
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

function RandomizeStats(XGStrategySoldier kRecruit)
{
    local LWCE_XGStrategySoldier kCERecruit;

    // iMultiple is originally a simple int, expanded by Long War to an array with the following mapping
    // (taken from the LW souce files, S_XGFacility_Barracks_RandomizeStats.upk_mod):
    //
    //    pointArray[5]      (0-4)
    //    totalPoints        (5)
    //    currentPoints	     (6)
    //    iterations         (7)
    //    finder             (8)
    //    selection	         (9)
    //    stat               (10)
    //    statsArray[5]       (11-15)
    //    deltaArray[5]      (16-20)
    //    totalDeltaStat     (21)
    //    temp               (22)
    //
    // Within this function, the stats are mapped in this way:
    //
    //    HP                  0
    //    Aim                 1
    //    Defense             2
    //    Mobility            3
    //    Will                4

    local int deltaArray[5], pointArray[5], statsArray[5];
    local int currentPoints, totalDeltaStat, totalPoints, finder, iterations, selection, iStat, iTemp;

    kCERecruit = LWCE_XGStrategySoldier(kRecruit);

    if (!IsOptionEnabled(/* Strict Screening */ 2))
    {
        // TODO: don't use the baseline character for anything; replace the generation entirely
        // TODO: introduce new config variables
        deltaArray[0] = kCERecruit.m_kChar.aStats[eStat_HP] - class'XGTacticalGameCore'.default.HIGH_WILL;
        deltaArray[1] = kCERecruit.m_kChar.aStats[eStat_Offense] - class'XGTacticalGameCore'.default.LOW_AIM;
        deltaArray[2] = -class'XGTacticalGameCore'.default.HIGH_MOBILITY;
        deltaArray[3] = kCERecruit.m_kChar.aStats[eStat_Mobility] - class'XGTacticalGameCore'.default.LOW_MOBILITY;
        deltaArray[4] = kCERecruit.m_kChar.aStats[eStat_Will] - class'XGTacticalGameCore'.default.LOW_WILL;

        pointArray[0] = deltaArray[0] * (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL / 100);
        pointArray[1] = deltaArray[1] * class'XGTacticalGameCore'.default.ROOKIE_AIM;
        pointArray[2] = deltaArray[2] * (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY / 100);
        pointArray[3] = deltaArray[3] * (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY % 100);
        pointArray[4] = deltaArray[4] * (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL % 100);

        // All stats are initialized to their lowest possible value
        kCERecruit.m_kChar.aStats[eStat_HP] = class'XGTacticalGameCore'.default.HIGH_WILL;
        kCERecruit.m_kChar.aStats[eStat_Offense] = class'XGTacticalGameCore'.default.LOW_AIM;
        kCERecruit.m_kChar.aStats[eStat_Defense] += class'XGTacticalGameCore'.default.HIGH_MOBILITY;
        kCERecruit.m_kChar.aStats[eStat_Mobility] = class'XGTacticalGameCore'.default.LOW_MOBILITY;
        kCERecruit.m_kChar.aStats[eStat_Will] = class'XGTacticalGameCore'.default.LOW_WILL;

        totalPoints = 0;
        totalDeltaStat = 0;

        for (iStat = 0; iStat < 5; iStat++)
        {
            totalPoints += pointArray[iStat];
            totalDeltaStat += ((1260 * deltaArray[iStat]) / (1 + Max(1, (deltaArray[iStat] - 1) / 3)));
        }

        if (HQ().HasBonus(/* Per Ardua Ad Astra */ 10) > 0)
        {
            totalPoints += HQ().HasBonus(10);
        }

        currentPoints = totalPoints;

        for (iterations = 0; currentPoints > 0 && iterations < 512; iterations++)
        {
            selection = Rand(totalDeltaStat);
            finder = 0;

            for (iStat = 0; iStat < 5; iStat++)
            {
                finder += ((1260 * deltaArray[iStat]) / (1 + Max(1, (deltaArray[iStat] - 1) / 3)));

                if (finder > selection)
                {
                    break;
                }
            }

            if (iStat == 0)
            {
                if (statsArray[0] < 2 * deltaArray[0]) // if (statsArray[0] < 2 * deltaArray[0])
                {
                    if ((currentPoints - (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL / 100)) >= 0) // if (currentPoints - hpPointCost >= 0)
                    {
                        currentPoints -= (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL / 100); // currentPoints -= hpPointCost;
                        statsArray[0] += 1; // statsArray[0] += 1;
                    }
                }
            }

            if (iStat == 1) // if (stat == 1)
            {
                iTemp = 1 + Rand((deltaArray[1] - 1) / 3);
                iTemp = Min(iTemp, (2 * deltaArray[1]) - statsArray[1]);
                iTemp = Min(iTemp, currentPoints / class'XGTacticalGameCore'.default.ROOKIE_AIM);

                if (statsArray[1] < (2 * deltaArray[1]))
                {
                    if (currentPoints - class'XGTacticalGameCore'.default.ROOKIE_AIM >= 0)
                    {
                        currentPoints -= (iTemp * class'XGTacticalGameCore'.default.ROOKIE_AIM);
                        statsArray[1] += iTemp;
                    }
                }
            }

            if (iStat == 2) // if (stat == 2)
            {
                iTemp = 1 + Rand((deltaArray[2] - 1) / 3);
                iTemp = Min(iTemp, (2 * deltaArray[2]) - statsArray[2]);
                iTemp = Min(iTemp, currentPoints / (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY / 100));

                if (statsArray[2] < 2 * deltaArray[2])
                {
                    if (currentPoints - (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY / 100) >= 0)
                    {
                        currentPoints -= (iTemp * (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY / 100));
                        statsArray[2] += iTemp;
                    }
                }
            }

            if (iStat == 3) // if (stat == 3)
            {
                if (statsArray[3] < (2 * deltaArray[3]))
                {
                    if ((currentPoints - (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY % 100)) >= 0)
                    {
                        currentPoints -= (class'XGTacticalGameCore'.default.ROOKIE_MOBILITY % 100);
                        statsArray[3] += 1;
                    }
                }
            }

            if (iStat == 4) // if (stat == 4)
            {
                iTemp = 1 + Rand((deltaArray[4] - 1) / 3);
                iTemp = Min(iTemp, (2 * deltaArray[4]) - statsArray[4]);
                iTemp = Min(iTemp, currentPoints / (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL % 100));

                if (statsArray[4] < (2 * deltaArray[4]))
                {
                    // End:0xC83
                    if ((currentPoints - (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL % 100)) >= 0)
                    {
                        currentPoints -= (iTemp * (class'XGTacticalGameCore'.default.ROOKIE_STARTING_WILL % 100));
                        statsArray[4] += iTemp;
                    }
                }
            }
        }

        kCERecruit.m_kChar.aStats[eStat_HP] += statsArray[0];
        kCERecruit.m_kChar.aStats[eStat_Offense] += statsArray[1];
        kCERecruit.m_kChar.aStats[eStat_Defense] += statsArray[2];
        kCERecruit.m_kChar.aStats[eStat_Mobility] += statsArray[3];
        kCERecruit.m_kChar.aStats[eStat_Will] += statsArray[4];
    }
    else if (HQ().HasBonus(/* Per Ardua Ad Astra */ 10) > 0)
    {
        kCERecruit.m_kChar.aStats[eStat_Offense] += 2;
        kCERecruit.m_kChar.aStats[eStat_Defense] += 1;
        kCERecruit.m_kChar.aStats[eStat_Will] += 2;
    }

    if (IsOptionEnabled(/* Cinematic Mode */ 11))
    {
        kCERecruit.m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
    }

    if (HQ().HasBonus(/* Pax Nigeriana */ 8) > 0)
    {
        kCERecruit.m_kChar.aStats[eStat_Mobility] += HQ().HasBonus(8);
    }

    if (HQ().HasBonus(/* Special Air Service */ 15) > 0)
    {
        kCERecruit.m_kChar.aStats[eStat_Offense] += HQ().HasBonus(15);
    }

    if (HQ().HasBonus(/* Patriae Semper Vigilis */ 21) > 0)
    {
        kCERecruit.m_kChar.aStats[eStat_Will] += HQ().HasBonus(21);
    }

    if (HQ().HasBonus(/* Survival Training */ 27) > 0)
    {
        kCERecruit.m_kChar.aStats[eStat_HP] += HQ().HasBonus(27);
    }

    `LWCE_LOG_CLS("New recruit final stats for " $ kCERecruit.GetName(eNameType_Full) $ ": HP = " $ kCERecruit.m_kChar.aStats[eStat_HP] $ "; aim = " $ kCERecruit.m_kChar.aStats[eStat_Offense] $ "; mobility = " $ kCERecruit.m_kChar.aStats[eStat_Mobility] $ "; Will = " $ kCERecruit.m_kChar.aStats[eStat_Will]);

    kCERecruit.m_kCEChar.aStats[eStat_HP] = kCERecruit.m_kChar.aStats[eStat_HP];
    kCERecruit.m_kCEChar.aStats[eStat_Offense] = kCERecruit.m_kChar.aStats[eStat_Offense];
    kCERecruit.m_kCEChar.aStats[eStat_Defense] = kCERecruit.m_kChar.aStats[eStat_Defense];
    kCERecruit.m_kCEChar.aStats[eStat_Mobility] = kCERecruit.m_kChar.aStats[eStat_Mobility];
    kCERecruit.m_kCEChar.aStats[eStat_Will] = kCERecruit.m_kChar.aStats[eStat_Will];
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
            if (LWCE_XGStrategySoldier(kSoldier).m_kCESoldier.iPsiRank == 7)
            {
                kVolunteer = kSoldier;
                arrSoldiers.AddItem(kSoldier);

                break;
            }
        }

        if (kVolunteer != none && kVolunteer.MedalCount() > 4)
        {
            `ONLINEEVENTMGR.UnlockAchievement(AT_GuardianOfEarth);
        }
    }

    foreach m_aLastMissionSoldiers(kSoldier)
    {
        if (arrSoldiers.Length < iNumToPreload && kSoldier != kVolunteer && CanLoadSoldier(kSoldier))
        {
            arrSoldiers.AddItem(kSoldier);
        }
    }

    foreach m_arrSoldiers(kSoldier)
    {
        if (arrSoldiers.Length < iNumToPreload)
        {
            if (arrSoldiers.Find(kSoldier) < 0 && CanLoadSoldier(kSoldier))
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
    local LWCE_XGStrategySoldier kCESoldier;

    kEngineering = `LWCE_ENGINEERING;
    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    // TODO: Foundry templates could just specify what perks they give instead
    if (HQ().HasFacility(eFacility_Foundry))
    {
        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_SCOPEUpgrade'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(SCOPEUpgrade), 'Foundry', 'Foundry_SCOPEUpgrade');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_MagPistols'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(MagPistols), 'Foundry', 'Foundry_MagPistols');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_RailPistols'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(RailPistols), 'Foundry', 'Foundry_RailPistols');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AmmoConservation'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(AmmoConservation), 'Foundry', 'Foundry_AmmoConservation');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_EnhancedPlasma'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(EnhancedPlasma), 'Foundry', 'Foundry_EnhancedPlasma');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedFlight'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(AdvancedFlight), 'Foundry', 'Foundry_AdvancedFlight');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ReflexPistols'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(ReflexPistols), 'Foundry', 'Foundry_ReflexPistols');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_Quenchguns'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(Quenchguns), 'Foundry', 'Foundry_Quenchguns');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedMedikit'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(ImprovedMedikit), 'Foundry', 'Foundry_ImprovedMedikit');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedArcThrower'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(ImprovedArcThrower), 'Foundry', 'Foundry_ImprovedArcThrower');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_DroneCapture'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(DroneCapture), 'Foundry', 'Foundry_DroneCapture');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_FieldRepairs'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(FieldRepairs), 'Foundry', 'Foundry_FieldRepairs');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_JelliedElerium'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(JelliedElerium), 'Foundry', 'Foundry_JelliedElerium');
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades'))
        {
            kCESoldier.LWCE_GivePerk(`LW_PERK_ID(AlienGrenades), 'Foundry', 'Foundry_AlienGrenades');
        }

        kSoldier.UpdateTacticalRigging(kEngineering.LWCE_IsFoundryTechResearched('Foundry_TacticalRigging'));

        if (kSoldier.IsATank())
        {
            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_SentinelDrone'))
            {
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(SentinelDrone), 'Foundry', 'Foundry_SentinelDrone');
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(RepairServos), 'Foundry', 'Foundry_SentinelDrone');
            }

            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_SHIVSuppression'))
            {
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(Suppression), 'Foundry', 'Foundry_SHIVSuppression');
            }
        }

        if (kSoldier.IsAugmented())
        {
            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_MECCloseCombat'))
            {
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(MECCloseCombat), 'Foundry', 'Foundry_MECCloseCombat');
            }
        }

        if (kSoldier.IsATank() || kSoldier.IsAugmented())
        {
            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedServomotors'))
            {
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(Sprinter), 'Foundry', 'Foundry_AdvancedServomotors');
            }

            if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ShapedArmor'))
            {
                kCESoldier.LWCE_GivePerk(`LW_PERK_ID(ShapedArmor), 'Foundry', 'Foundry_ShapedArmor');
            }
        }
    }

    `LWCE_MOD_LOADER.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
}

function UpdateGrenades(EItemType eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateGrenades);
}

function LWCE_UpdateGrenades(name OldWeaponName, name NewWeaponName)
{
    local XGStrategySoldier kSoldier;
    local LWCE_XGStrategySoldier kCESoldier;
    local int iSmallItem;

    foreach m_arrSoldiers(kSoldier)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSoldier);

        if (!kCESoldier.IsATank())
        {
            for (iSmallItem = 0; iSmallItem < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; iSmallItem++)
            {
                if (kCESoldier.m_kCEChar.kInventory.arrSmallItems[iSmallItem] == OldWeaponName)
                {
                    LWCE_XGFacility_Lockers(m_kLockers).LWCE_EquipSmallItem(kCESoldier, NewWeaponName, iSmallItem);
                }
            }
        }
    }
}