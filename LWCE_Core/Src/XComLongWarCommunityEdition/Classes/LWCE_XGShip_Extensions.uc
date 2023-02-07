class LWCE_XGShip_Extensions extends Object
    abstract;

static function Init(XGShip kSelf, TShip kTShip)
{
    local array<name> arrShipWeapons;
    local int I;

    kSelf.m_kTShip = kTShip;
    kSelf.m_iHP = kSelf.GetHullStrength();
    arrShipWeapons = LWCE_XGShip(kSelf).LWCE_GetWeapons();

    for (I = 0; I < arrShipWeapons.Length; I++)
    {
        kSelf.m_afWeaponCooldown.AddItem(0.0f);
    }

    if (kSelf.IsA('XGShip_UFO'))
    {
        if (kSelf.m_kTShip.eType == 4 || kSelf.m_kTShip.eType == 5) // Scout/Destroyer
        {
            kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_UFO_Small);
        }
        else if (kSelf.m_kTShip.eType == 10 || kSelf.m_kTShip.eType == 11) // Fighter/Raider
        {
            kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_UFO_Small);
        }
        else if (kSelf.m_kTShip.eType == 9) // Overseer
        {
            kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_UFO_Overseer);
        }
        else
        {
            kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_UFO_Large);
        }
    }
    else if (kSelf.IsA('XGShip_Dropship'))
    {
        kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_Skyranger);
    }
    else if (kSelf.m_kTShip.eType == eShip_Interceptor)
    {
        kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_Interceptor);
    }
    else
    {
        kSelf.SetEntity(kSelf.Spawn(class'XGShipEntity'), eEntityGraphic_Firestorm);
    }

    kSelf.m_kGeoscape = kSelf.GEOSCAPE();
    kSelf.InitWatchVariables();
    kSelf.ResetWeapons();
}