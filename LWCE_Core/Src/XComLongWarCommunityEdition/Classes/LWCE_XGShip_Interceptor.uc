class LWCE_XGShip_Interceptor extends XGShip_Interceptor implements(LWCE_XGShip);

struct CheckpointRecord_LWCE_XGShip_Interceptor extends CheckpointRecord_XGShip_Interceptor
{
    var name m_nmContinent;
    var name m_nmShipTemplate;
    var array<name> m_arrCEWeapons;
    var LWCE_TShip m_kCETShip;
};

var name m_nmContinent;
var name m_nmShipTemplate;
var array<name> m_arrCEWeapons;
var LWCE_TShipStats m_kTCachedStats; // Cached stats from the template

function Init(TShip kTShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmShipTemplate, name nmContinent)
{
    m_nmContinent = nmContinent;
    m_nmShipTemplate = nmShipTemplate;
    m_v2Coords = GetHomeCoords();
    m_v2Destination = m_v2Coords;
    m_fFlightTime = 43200.0;

    class'LWCE_XGShip_Extensions'.static.Init(self, class'LWCEShipDataSet'.const.SHIP_TEAM_XCOM);

    InitSound();
}

function ReinitFromTemplate(name nmTeam)
{
    class'LWCE_XGShip_Extensions'.static.ReinitFromTemplate(self, nmTeam);
}

function EquipWeapon(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipWeapon);
}

function LWCE_EquipWeapon(name ItemName, int Index)
{
    if (m_arrCEWeapons.Length <= Index)
    {
        m_arrCEWeapons.Length = Index + 1;
    }

    if (m_arrCEWeapons[Index] != '')
    {
        LWCE_XGStorage(STORAGE()).LWCE_AddItem(m_arrCEWeapons[0]);
    }

    m_arrCEWeapons[Index] = ItemName;

    if (m_kHangarShip != none)
    {
        // TODO: move somewhere centralized and potentially make extensible
        if (LWCE_XGHangarShip_Firestorm(m_kHangarShip) != none)
        {
            LWCE_XGHangarShip_Firestorm(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
        else
        {
            LWCE_XGHangarShip(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
    }
}

function name GetHomeContinent()
{
    return m_nmContinent;
}

function Vector2D GetHomeCoords()
{
    local Vector2D homeCoords;

    if (m_nmContinent != '')
    {
        homeCoords = `LWCE_XGCONTINENT(m_nmContinent).GetHQLocation();
    }
    
    return homeCoords;
}

function int GetHullStrength()
{
    return m_kTCachedStats.iHealth;
}

function int GetRange()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRange);

    return -100;
}

function int GetSpeed()
{
    return m_kTCachedStats.iSpeed;
}

function EItemType GetWeapon()
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetWeapon was called. This needs to be replaced with GetWeaponAtIndex. Stack trace follows.");
    ScriptTrace();

    return eItem_None;
}

function name GetWeaponAtIndex(int Index)
{
    if (Index >= m_arrCEWeapons.Length)
    {
        return '';
    }

    return m_arrCEWeapons[Index];
}

function array<TShipWeapon> GetWeapons()
{
    local array<TShipWeapon> arrWeapons;

    `LWCE_LOG_DEPRECATED_CLS(GetWeapons);

    arrWeapons.Length = 0;
    return arrWeapons;
}

function array<name> LWCE_GetWeapons()
{
    return m_arrCEWeapons;
}

function string GetWeaponString()
{
    return `LWCE_ITEM(GetWeaponAtIndex(0)).strName;
}

function XGHangarShip GetWeaponViewShip()
{
    if (m_kHangarShip == none)
    {
        if (IsFirestorm())
        {
            m_kHangarShip = Spawn(class'LWCE_XGHangarShip_Firestorm', self);
            m_kHangarShip.Init();
            LWCE_XGHangarShip_Firestorm(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
        else
        {
            m_kHangarShip = Spawn(class'LWCE_XGHangarShip', self);
            m_kHangarShip.Init();
            LWCE_XGHangarShip(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
    }

    return m_kHangarShip;
}

function bool IsFirestorm()
{
    return m_kCETShip.eType == eShip_Firestorm;
}

function bool IsInterceptor()
{
    return m_kCETShip.eType == eShip_Interceptor;
}

function int NumWeapons()
{
    return m_arrCEWeapons.Length;
}

// Custom functions for dealing with manually entering callsigns

function string GetCallsign()
{
    if (InStr(m_strCallsign, " ") >= 0)
    {
        return Split(m_strCallsign, " ", true);
    }

    return m_strCallsign;
}

function SetCallsign(string strNewCallsign)
{
    // Only change the callsign if it's different. This covers a small case where the callsign is set after every
    // kill to update the rank, but the rank may not be included in the callsign yet if the player has never named
    // this interceptor. In any other case, the two strings will be different because m_strCallsign will include
    // the rank label, and the incoming callsign should not.
    if (strNewCallsign != m_strCallsign)
    {
        m_strCallsign = `LWCE_HANGAR.GetRankForKills(m_iConfirmedKills) @ strNewCallsign;
    }
}
