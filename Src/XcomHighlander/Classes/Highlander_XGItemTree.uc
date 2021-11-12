class Highlander_XGItemTree extends XGItemTree;

function Init()
{
    m_kStrategyActorTag = new class'XGStrategyActorTag';

    m_arrItems.Add(255);
    m_arrFacilities.Add(24);
    m_arrStaff.Add(4);
    m_arrShips.Add(16);
    m_arrShipWeapons.Add(11);

    BuildItems();
    BuildShips();
    BuildShipWeapons();
    BuildFacilities();
    BuildStaffTypes();
}

function BuildShips()
{
    BuildShip(1,  m_strSizeSmall,     68, 3);     // Interceptor
    BuildShip(2,  m_strSizeSmall,     67);        // Skyranger
    BuildShip(3,  m_strSizeSmall,     69, 3);     // Firestorm
    BuildShip(4,  m_strSizeSmall,     80, 8);     // Scout
    BuildShip(5,  m_strSizeMedium,    81, 8);     // Destroyer
    BuildShip(6,  m_strSizeLarge,     82, 9);     // Abductor
    BuildShip(7,  m_strSizeLarge,     83, 9);     // Transport
    BuildShip(8,  m_strSizeVeryLarge, 84, 10);    // Battleship
    BuildShip(9,  m_strSizeMedium,    85, 9, 8);  // Overseer
    BuildShip(10, m_strSizeSmall,     80, 8);     // Fighter
    BuildShip(11, m_strSizeMedium,    81, 8);     // Raider
    BuildShip(12, m_strSizeLarge,     82, 9);     // Harvester
    BuildShip(13, m_strSizeLarge,     83, 9);     // Terror Ship
    BuildShip(14, m_strSizeVeryLarge, 84, 9, 8);  // Assault Carrier

    UpdateShips();
}

function BuildShipWeapons()
{
    BuildShipWeapon(1, -1, 100, 0.750, 140, 5, 40 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(2, 3, 100, 1.50, 200, 10, 40 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(3, 3, 100, 2.0, 340, 0, 40 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(4, -1, 100, 1.0, 290, 5, 55 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(5, 10, 100, 1.0, 650, 22, 40 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(6, -1, 100, 0.550, 310, 30, 30 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(7, 10, 100, 1.250, 1200, 26, 30 + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(8, -1, 101, 1.150, 450, 0, 33);
    BuildShipWeapon(9, -1, 101, 1.250, 800, 20, 40);
    BuildShipWeapon(10, -1, 101, 1.250, 1300, 50, 45);

    UpdateShips();
}