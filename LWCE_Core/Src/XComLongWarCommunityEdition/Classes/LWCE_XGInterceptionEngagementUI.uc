class LWCE_XGInterceptionEngagementUI extends XGInterceptionEngagementUI;

function PostInit(XGInterception kXGInterception)
{
    local int iShipWeaponId;

    m_kInterceptionEngagement = Spawn(class'LWCE_XGInterceptionEngagement');
    m_kInterceptionEngagement.Init(kXGInterception);
    m_kInterceptionEngagement.GetCombat();

    iShipWeaponId = class'LWCE_XGFacility_Hangar'.static.LWCE_ItemTypeToShipWeapon(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0].GetWeapon());

    if (!IsShortDistanceWeapon(SHIPWEAPON(iShipWeaponId).eType))
    {
        Narrative(`XComNarrativeMoment("InterceptorEnemySighted"));
    }

    m_kInterceptionEngagement.m_kInterception.m_kUFOTarget.m_bWasEngaged = true;
    GEOSCAPE().UpdateSound();
}

function VOInRange()
{
    local int iShipWeaponId;

    iShipWeaponId = class'LWCE_XGFacility_Hangar'.static.LWCE_ItemTypeToShipWeapon(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0].GetWeapon());

    if (m_bFirstFire && IsShortDistanceWeapon(SHIPWEAPON(iShipWeaponId).eType))
    {
        PRES().UINarrative(`XComNarrativeMoment("InterceptorClosingOnTarget"));
        m_bFirstFire = false;
    }
}