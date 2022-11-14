class LWCE_XGShip_Interceptor extends XGShip_Interceptor;

struct CheckpointRecord_LWCE_XGShip_Interceptor extends CheckpointRecord_XGShip_Interceptor
{
    var array<name> m_arrCEWeapons;
};

// NOTE: this is an array of weapons for possible future expansion, but for now, only
// index 0 should be used. Other indices will be ignored.
var array<name> m_arrCEWeapons;
var LWCE_TShip m_kCETShip;

function Init(TShip kTShip)
{
    // TODO: deprecate this function and replace with a template-driven LWCE version

    m_v2Coords = GetHomeCoords();
    m_v2Destination = m_v2Coords;
    m_fFlightTime = 43200.0;

    super(XGShip).Init(kTShip);

    // TODO: default weapon should be determined by template
    m_arrCEWeapons.AddItem('Item_AvalancheMissiles');
    InitSound();
}

function EquipWeapon(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipWeapon);
}

function LWCE_EquipWeapon(name ItemName)
{
    if (m_arrCEWeapons[0] != '' && ItemName != 'Item_WingtipSparrowhawks')
    {
        LWCE_XGStorage(STORAGE()).LWCE_AddItem(m_arrCEWeapons[0]);
    }

    m_kCETShip.arrWeapons.Remove(0, m_kCETShip.arrWeapons.Length);

    if (ItemName != 'Item_WingtipSparrowhawks')
    {
        m_arrCEWeapons[0] = ItemName;
        m_kCETShip.arrWeapons.AddItem(ItemName);
    }

    if (ItemName == 'Item_WingtipSparrowhawks' || `LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_WingtipSparrowhawks'))
    {
        m_kCETShip.arrWeapons.AddItem('Item_StingrayMissiles'); // TODO confirm that this is the right item and Sparrowhawks aren't separate
    }

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

function EItemType GetWeapon()
{
    `LWCE_LOG_DEPRECATED_CLS(GetWeapon);

    return eItem_None;
}

function name LWCE_GetWeapon()
{
    return m_arrCEWeapons.Length > 0 ? m_arrCEWeapons[0] : '';
}

function string GetWeaponString()
{
    return `LWCE_ITEM(LWCE_GetWeapon()).strName;
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
