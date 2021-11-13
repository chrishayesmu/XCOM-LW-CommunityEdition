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
    BuildShip(1,  m_strSizeSmall,     eImage_Interceptor, eShipWeapon_Avalanche);                            // Interceptor
    BuildShip(2,  m_strSizeSmall,     eImage_Skyranger);                                                     // Skyranger
    BuildShip(3,  m_strSizeSmall,     eImage_Firestorm,   eShipWeapon_Avalanche);                            // Firestorm
    BuildShip(4,  m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Scout
    BuildShip(5,  m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Destroyer
    BuildShip(6,  m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Abductor
    BuildShip(7,  m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Transport
    BuildShip(8,  m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOFusionI);                           // Battleship
    BuildShip(9,  m_strSizeMedium,    eImage_EtherealUFO, eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Overseer
    BuildShip(10, m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Fighter
    BuildShip(11, m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Raider
    BuildShip(12, m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Harvester
    BuildShip(13, m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Terror Ship
    BuildShip(14, m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Assault Carrier

    UpdateShips();
}

function BuildShipWeapons()
{
    local int ToHitBonus;

    // Second Wave 24: The Friendly Skies (bonus to interceptor/Firestorm aim)
    ToHitBonus = IsOptionEnabled(24) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0;

    // XCOM weapons
    BuildShipWeapon(1, -1,  100, 0.750, 140,  5,  40 + ToHitBonus); // Phoenix Cannon
    BuildShipWeapon(2, -1,  100, 1.50,  200,  10, 40 + ToHitBonus); // Stingray Missiles
    BuildShipWeapon(3, -1,  100, 2.0,   340,  0,  40 + ToHitBonus); // Avalanche Missiles
    BuildShipWeapon(4, -1,  100, 1.0,   290,  5,  55 + ToHitBonus); // Laser Cannon
    BuildShipWeapon(5, -1,  100, 1.0,   650,  22, 40 + ToHitBonus); // Plasma Cannon
    BuildShipWeapon(6, -1,  100, 0.550, 310,  30, 30 + ToHitBonus); // EMP Cannon
    BuildShipWeapon(7, -1,  100, 1.250, 1200, 26, 30 + ToHitBonus); // Fusion Lance

    // UFO weapons
    BuildShipWeapon(8,  -1, 101, 1.150, 450,  0,  33); // UFO: Single Plasma
    BuildShipWeapon(9,  -1, 101, 1.250, 800,  20, 40); // UFO: Double Plasma
    BuildShipWeapon(10, -1, 101, 1.250, 1300, 50, 45); // UFO: Fusion Lance

    UpdateShips();
}