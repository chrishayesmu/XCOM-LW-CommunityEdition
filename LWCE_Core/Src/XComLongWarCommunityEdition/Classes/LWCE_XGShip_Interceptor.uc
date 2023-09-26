class LWCE_XGShip_Interceptor extends XGShip_Interceptor implements(LWCE_XGShip);

struct CheckpointRecord_LWCE_XGShip_Interceptor extends CheckpointRecord_XGShip_Interceptor
{
    var name m_nmContinent;
    var name m_nmShipTemplate;
    var array<name> m_arrCEWeapons;
    var LWCE_TShip m_kCETShip;
};

var name m_nmContinent;
var name m_nmShipTemplate; // TODO: Ship templates aren't implemented yet; this is for future use
var array<name> m_arrCEWeapons;
var LWCE_TShip m_kCETShip;

function Init(TShip kTShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmShipTemplate, TShip kTShip)
{
    // TODO: get rid of TShip and replace with a template-driven LWCE version
    m_nmShipTemplate = nmShipTemplate;
    m_v2Coords = GetHomeCoords();
    m_v2Destination = m_v2Coords;
    m_fFlightTime = 43200.0;

    class'LWCE_XGShip_Extensions'.static.Init(self, kTShip);

    // Copy from the base game struct for now; eventually we'll move this to templates too
    m_kCETShip.eType = m_kTShip.eType;
    m_kCETShip.strName = m_kTShip.strName;
    m_kCETShip.strSize = m_kTShip.strSize;
    m_kCETShip.iSpeed = m_kTShip.iSpeed;
    m_kCETShip.iEngagementSpeed = m_kTShip.iEngagementSpeed;
    m_kCETShip.iHP = m_kTShip.iHP;
    m_kCETShip.iArmor = m_kTShip.iArmor;
    m_kCETShip.iArmorPen = m_kTShip.iAP;
    m_kCETShip.iRange = m_kTShip.iRange;
    m_kCETShip.iImage = m_kTShip.iImage;

    // TODO: default weapon should be determined by template
    LWCE_EquipWeapon('Item_AvalancheMissiles', 0);
    InitSound();

    // TODO: emit an event which the Foundry template can use instead
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
