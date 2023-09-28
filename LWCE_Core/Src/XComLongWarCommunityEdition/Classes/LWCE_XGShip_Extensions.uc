class LWCE_XGShip_Extensions extends Object
    abstract;

static function Init(XGShip kSelf, name nmTeam)
{
    local LWCE_XGShip kCESelf;
    local LWCEShipTemplate kTemplate;
    local array<name> arrShipWeapons;
    local int I;

    kCESelf = LWCE_XGShip(kSelf);
    kCESelf.ReinitCachedStatsFromTemplate(nmTeam);
    kSelf.m_iHP = kSelf.GetHullStrength();
    arrShipWeapons = kCESelf.LWCE_GetWeapons();

    for (I = 0; I < arrShipWeapons.Length; I++)
    {
        kSelf.m_afWeaponCooldown.AddItem(0.0f);
    }

    // TODO drop any reference to m_kTShip; it's unpopulated now
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

static function ReinitFromTemplate(XGShip kSelf, name nmTeam)
{
    local LWCE_XGShip kCESelf;
    local LWCEShipTemplate kTemplate;

    kCESelf = LWCE_XGShip(kSelf);
    kTemplate = kCESelf.GetTemplate();

    kCESelf.SetCurrentStats(kTemplate.GetStats(nmTeam));
}