class Highlander_XGFacility_Barracks extends XGFacility_Barracks;

function Init(bool bLoadingFromSave)
{
    BaseInit();

    m_kCharGen = Spawn(class'Highlander_XGCharacterGenerator');

    m_kLockers = Spawn(class'Highlander_XGFacility_Lockers');
    m_kLockers.Init(false);

    m_kPerkManager = Spawn(class'Highlander_XComPerkManager');
    m_kPerkManager.Init();

    BuildMedals();
}

function AddNewSoldiers(int iNumSoldiers, optional bool bCreatePawns = true)
{
    local XGStrategySoldier kSoldier;
    local int I;

    for (I = 0; I < iNumSoldiers; I++)
    {
        kSoldier = Spawn(class'Highlander_XGStrategySoldier');
        kSoldier.m_kSoldier = m_kCharGen.CreateTSoldier();
        kSoldier.m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);

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
    `HL_LOG_DEPRECATED_CLS(AddTank);
}

function HL_AddTank(int iArmorItemId, int iWeaponItemId)
{
    local XGStrategySoldier kTank;
    local TInventory kTankLoadout;

    kTank = Spawn(class'Highlander_XGStrategySoldier');
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

    TACTICAL().TInventoryLargeItemsSetItem(kTankLoadout, 0, iWeaponItemId);
    m_kLockers.ApplyTankLoadout(kTank, kTankLoadout);
    AddNewSoldier(kTank);
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
    local XGStrategySoldier kSoldier;
    local int I;

    kSoldier = Spawn(class'Highlander_XGStrategySoldier');
    kSoldier.m_kSoldier = m_kCharGen.CreateTSoldier(, iCountry);
    kSoldier.m_kSoldier.bBlueshirt = bBlueshirt;
    kSoldier.m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);
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
        kSoldier.LevelUp(eClass);
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

function PostMission(XGShip_Dropship kSkyranger, bool bSkipSetHQLocation)
{
    local Highlander_XGStorage kStorage;
    local Highlander_XGStrategySoldier kHLSoldier;
    local XGStrategySoldier kSoldier;

    kStorage = `HL_STORAGE;

    kStorage.m_arrHLItemsDamagedLastMission.Remove(0, kStorage.m_arrHLItemsDamagedLastMission.Length);
    kStorage.m_arrHLItemsLostLastMission.Remove(0, kStorage.m_arrHLItemsLostLastMission.Length);

    foreach kSkyranger.m_arrSoldiers(kSoldier)
    {
        kHLSoldier = Highlander_XGStrategySoldier(kSoldier);
        kHLSoldier.CheckForDamagedOrLostItems();

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
        kHLSoldier = Highlander_XGStrategySoldier(kSkyranger.m_kCovertOperative);
        kHLSoldier.CheckForDamagedOrLostItems();

        DetermineTimeOut(kHLSoldier);
        kHLSoldier.m_iNumMissions += 65537;
    }

    if (!bSkipSetHQLocation)
    {
        SetAllSoldierHQLocations();
    }
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier)
{
    local Highlander_XGFacility_Engineering kEngineering;

    kEngineering = `HL_ENGINEERING;

    if (HQ().HasFacility(eFacility_Foundry))
    {
        // Highlander issue #4: LW 1.0 uses the ID for Phoenix Coilguns (44) in this block, where it means to use Quenchguns (46)
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
            kSoldier.m_kChar.aUpgrades[21] = kEngineering.IsFoundryTechResearched(`LW_FOUNDRY_ID(SHIVSuppression)) ? 1 : 0;
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

    `HL_MOD_LOADER.UpdateFoundryPerksForSoldier(kSoldier, kEngineering);
}