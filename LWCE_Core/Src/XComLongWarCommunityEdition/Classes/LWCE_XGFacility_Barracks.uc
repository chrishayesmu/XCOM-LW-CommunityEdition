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

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(ForeignLegion)) > 0)
    {
        AddNewSoldiers(HQ().HasBonus(`LW_HQ_BONUS_ID(ForeignLegion)));
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(KiryuKaiCommander)) > 0) // Kiryu-Kai Commander
    {
        LWCE_CreateSoldier(SelectRandomBaseClassId(), HQ().HasBonus(`LW_HQ_BONUS_ID(KiryuKaiCommander)), eCountry_Japan);
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(Cadre)) > 0) // Cadre
    {
        // TODO: how to handle Cadre with class mods?
        LWCE_CreateSoldier(1, HQ().HasBonus(`LW_HQ_BONUS_ID(Cadre)), Rand(36));
        LWCE_CreateSoldier(2, HQ().HasBonus(`LW_HQ_BONUS_ID(Cadre)), Rand(36));
        LWCE_CreateSoldier(3, HQ().HasBonus(`LW_HQ_BONUS_ID(Cadre)), Rand(36));
        LWCE_CreateSoldier(4, HQ().HasBonus(`LW_HQ_BONUS_ID(Cadre)), Rand(36));
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(WeAreLegion)))
    {
        m_arrOTSUpgrades[1] = 1;
        m_arrOTSUpgrades[2] = 1;
    }

    bInitingNewGame = false;
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
        kTank.m_kSoldier.strLastName = m_strAlloySHIVPrefix $ ++m_iAlloyTankCounter;
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.ALLOY_SHIV_HP_BONUS;
    }
    else if (ArmorName == 'Item_SHIVHoverChassis')
    {
        kTank.m_kSoldier.strLastName = m_strHoverSHIVPrefix $ ++m_iHoverTankCounter;
        kTank.m_kChar.aStats[eStat_HP] += class'XGTacticalGameCore'.default.HOVER_SHIV_HP_BONUS;
    }
    else
    {
        kTank.m_kSoldier.strLastName = m_strSHIVPrefix $ ++m_iTankCounter;
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

function XGStrategySoldier LWCE_CreateSoldier(int iClassId, int iSoldierLevel, int iCountry, optional bool bBlueshirt = false)
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
                if (kCESoldier.m_kChar.aUpgrades[class'XGTacticalGameCore'.default.ItemBalance_Easy[iBaseTimeOut].eItem] > 0)
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

    if (kCESoldier.m_kChar.aUpgrades[`LW_PERK_ID(StayFrosty)] > 0)
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

            if (kCESoldier.m_kChar.aUpgrades[`LW_PERK_ID(AdaptiveBoneMarrow)] > 0)
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

function GenerateNewNickname(XGStrategySoldier kNickSoldier)
{
    local LWCE_TClassDefinition kClassDef;
    local array<string> NickNames;

    if (kNickSoldier.m_kSoldier.strNickName == "")
    {
        kClassDef = GetClassDefinition(LWCE_XGStrategySoldier(kNickSoldier).LWCE_GetClass());
        NickNames = kNickSoldier.m_kSoldier.kAppearance.iGender == eGender_Female ? kClassDef.NicknamesFemale : kClassDef.NicknamesMale;

        if (NickNames.Length == 0)
        {
            `LWCE_LOG_CLS("WARNING! Class ID " $ kClassDef.iSoldierClassId $ " does not have any nicknames configured for gender " $ (kNickSoldier.m_kSoldier.kAppearance.iGender == eGender_Female ? "female" : "male"));
            return;
        }

        kNickSoldier.m_kSoldier.strNickName = NickNames[Rand(NickNames.Length)];
        NickNameCheck(kNickSoldier);
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
    local LWCE_TClassDefinition kClassDef;
    local array<string> NickNames;

    if (kSoldier.IsATank())
    {
        return;
    }

    kClassDef = GetClassDefinition(LWCE_XGStrategySoldier(kSoldier).LWCE_GetClass());
    NickNames = kSoldier.m_kSoldier.kAppearance.iGender == eGender_Female ? kClassDef.NicknamesFemale : kClassDef.NicknamesMale;

    iCounter = 20;
    while (NickNameMatch(kSoldier) && iCounter > 0)
    {
        kSoldier.m_kSoldier.strNickName = NickNames[Rand(NickNames.Length)];
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

    kEngineering = `LWCE_ENGINEERING;

    if (HQ().HasFacility(eFacility_Foundry))
    {
        // LWCE issue #4: LW 1.0 uses the ID for Phoenix Coilguns (44) in this block, where it means to use Quenchguns (46)
        kSoldier.m_kChar.aUpgrades[109] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_SCOPEUpgrade') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[110] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_MagPistols') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[111] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_RailPistols') ? 1 : 0;

        // aUpgrades[123] is a bitfield of different Foundry upgrades
        kSoldier.m_kChar.aUpgrades[123] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_AmmoConservation') ? 1 << 1 : 0;
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_EnhancedPlasma')  ? 1 << 2 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedFlight') ? 1 << 3 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ReflexPistols') ? 1 << 4 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_Quenchguns') ? 1 << 5 : 0);
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedMedikit')  ? 1 << 6 : 0);

        kSoldier.m_kChar.aUpgrades[115] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedArcThrower') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[117] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_DroneCapture') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[118] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_FieldRepairs') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[120] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_JelliedElerium') ? 1 : 0;
        kSoldier.m_kChar.aUpgrades[125] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades') ? 1 : 0;

        kSoldier.UpdateTacticalRigging(kEngineering.LWCE_IsFoundryTechResearched('Foundry_TacticalRigging'));

        if (kSoldier.IsATank())
        {
            kSoldier.m_kChar.aUpgrades[124] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_SentinelDrone') ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[139] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_SentinelDrone') ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[`LW_PERK_ID(Suppression)] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_SHIVSuppression') ? 1 : 0;
        }

        if (kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[121] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_MECCloseCombat') ? 1 : 0;
        }

        if (kSoldier.IsATank() || kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[31] = kEngineering.LWCE_IsFoundryTechResearched('Foundry_AdvancedServomotors') ? 1 : 0;
            kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ShapedArmor') ? 1 : 0);
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