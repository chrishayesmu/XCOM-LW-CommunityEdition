class Highlander_XGShip_Dropship extends XGShip_Dropship;

function Init(TShip kTShip)
{
    super(XGShip).Init(kTShip);

    CargoInfo = Spawn(class'Highlander_XGDropshipCargoInfo');
    Highlander_XGDropshipCargoInfo(CargoInfo).Init();

    m_arrUpgrades.Add(3);
    m_iCapacity = class'XGTacticalGameCore'.default.SKYRANGER_CAPACITY;

    InitSound();
}