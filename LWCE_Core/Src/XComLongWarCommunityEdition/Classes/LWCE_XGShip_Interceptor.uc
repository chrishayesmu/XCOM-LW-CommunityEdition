class LWCE_XGShip_Interceptor extends XGShip_Interceptor implements(LWCE_XGShip);

struct CheckpointRecord_LWCE_XGShip_Interceptor extends CheckpointRecord_XGShip_Interceptor
{
    var array<name> m_arrCEWeapons;
    var LWCE_TShip m_kCETShip;
};

var array<name> m_arrCEWeapons;
var LWCE_TShip m_kCETShip;

function Init(TShip kTShip)
{
    // TODO: deprecate this function and replace with a template-driven LWCE version

    m_v2Coords = GetHomeCoords();
    m_v2Destination = m_v2Coords;
    m_fFlightTime = 43200.0;

    class'LWCE_XGShip_Extensions'.static.Init(self, kTShip);

    // TODO: default weapon should be determined by template
    LWCE_EquipWeapon('Item_AvalancheMissiles', 0);
    InitSound();

    if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_WingtipSparrowhawks'))
    {
        // Sparrowhawks are just Stingrays; their damage is cut in half by logic in the interception code
        LWCE_EquipWeapon('Item_StingrayMissiles', 1);
    }
}

function EquipWeapon(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipWeapon);
}

function LWCE_EquipWeapon(name ItemName, int Index)
{
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

function LWCE_TShip GetShipData()
{
    return m_kCETShip;
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
