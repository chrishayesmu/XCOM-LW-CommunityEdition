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
    local XGStrategySoldier kTank;
    local TInventory kTankLoadout;

    kTank = Spawn(class'Highlander_XGStrategySoldier');
    kTank.m_kChar = TACTICAL().GetTCharacter(eChar_Tank);

    if (eArmor == eItem_SHIV_Alloy)
    {
        kTank.m_kSoldier.strLastName = m_strAlloySHIVPrefix $ string(++m_iAlloyTankCounter);
        kTank.m_kChar.aStats[0] += class'XGTacticalGameCore'.default.ALLOY_SHIV_HP_BONUS;
    }
    else if (eArmor == eItem_SHIV_Hover)
    {
        kTank.m_kSoldier.strLastName = m_strHoverSHIVPrefix $ string(++m_iHoverTankCounter);
        kTank.m_kChar.aStats[0] += class'XGTacticalGameCore'.default.HOVER_SHIV_HP_BONUS;
    }
    else
    {
        kTank.m_kSoldier.strLastName = m_strSHIVPrefix $ string(++m_iTankCounter);
    }

    if (IsOptionEnabled(11)) // Cinematic Mode
    {
        kTank.m_kChar.aStats[1] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
    }

    if (HQ().HasBonus(25) > 0) // Ghost In the Machine
    {
        kTank.m_kChar.aStats[1] += HQ().HasBonus(25);
    }

    if (HQ().HasBonus(48) > 0) // Robotics
    {
        kTank.m_kChar.aStats[1] += HQ().HasBonus(48);
    }

    kTank.m_kSoldier.iRank = -1;
    kTank.m_kSoldier.iCountry = 66;
    kTankLoadout.iArmor = eArmor;

    TACTICAL().TInventoryLargeItemsSetItem(kTankLoadout, 0, eWeapon);
    m_kLockers.ApplyTankLoadout(kTank, kTankLoadout);
    AddNewSoldier(kTank);
}

function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier)
{
    local Highlander_XGFacility_Engineering kEngineering;

    kEngineering = `HL_ENGINEERING;

    if (HQ().HasFacility(eFacility_Foundry))
    {
        // Highlander issue #4: LW 1.0 uses the ID for Phoenix Coilguns (44) in this block, where it means to use Quenchguns (46)
        kSoldier.m_kChar.aUpgrades[109] = kEngineering.IsFoundryTechResearched(18) ? 1 : 0; // SCOPE Upgrade
        kSoldier.m_kChar.aUpgrades[110] = kEngineering.IsFoundryTechResearched(13) ? 1 : 0; // Mag Pistols
        kSoldier.m_kChar.aUpgrades[111] = kEngineering.IsFoundryTechResearched(14) ? 1 : 0; // Rail Pistols
        kSoldier.m_kChar.aUpgrades[123] = kEngineering.IsFoundryTechResearched(10) ? 1 << 1 : 0; // Ammo Conservation
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(7)  ? 1 << 2 : 0); // Enhanced Plasma
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(11) ? 1 << 3 : 0); // Advanced Flight
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(15) ? 1 << 4 : 0); // Reflex Pistols
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(44) ? 1 << 5 : 0); // Quenchguns
        kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(3)  ? 1 << 6 : 0); // Improved Medikit
        kSoldier.m_kChar.aUpgrades[115] = kEngineering.IsFoundryTechResearched(4) ? 1 : 0; // Improved Arc Thrower
        kSoldier.m_kChar.aUpgrades[117] = kEngineering.IsFoundryTechResearched(9) ? 1 : 0; // Drone Capture
        kSoldier.m_kChar.aUpgrades[118] = kEngineering.IsFoundryTechResearched(8) ? 1 : 0; // Field Repairs
        kSoldier.m_kChar.aUpgrades[120] = kEngineering.IsFoundryTechResearched(19) ? 1 : 0; // Jellied Elerium
        kSoldier.m_kChar.aUpgrades[125] = kEngineering.IsFoundryTechResearched(2) ? 1 : 0; // Alien Grenades
        kSoldier.UpdateTacticalRigging(kEngineering.IsFoundryTechResearched(24)); // Tac Rigging

        if (kSoldier.IsATank())
        {
            kSoldier.m_kChar.aUpgrades[124] = kEngineering.IsFoundryTechResearched(23) ? 1 : 0; // Sentinel Drone
            kSoldier.m_kChar.aUpgrades[139] = kEngineering.IsFoundryTechResearched(23) ? 1 : 0; // Sentinel Drone
            kSoldier.m_kChar.aUpgrades[21] = kEngineering.IsFoundryTechResearched(16) ? 1 : 0; // SHIV Suppression
        }

        if (kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[121] = kEngineering.IsFoundryTechResearched(20) ? 1 : 0; // MEC Close Combat
        }

        if (kSoldier.IsATank() || kSoldier.IsAugmented())
        {
            kSoldier.m_kChar.aUpgrades[31] = kEngineering.IsFoundryTechResearched(21) ? 1 : 0; // Advanced Servomotors
            kSoldier.m_kChar.aUpgrades[123] = kSoldier.m_kChar.aUpgrades[123] | (kEngineering.IsFoundryTechResearched(22) ? 1 : 0); // Shaped Armor
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