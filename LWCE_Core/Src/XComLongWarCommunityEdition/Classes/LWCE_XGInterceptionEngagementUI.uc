class LWCE_XGInterceptionEngagementUI extends XGInterceptionEngagementUI;

function PostInit(XGInterception kXGInterception)
{
    local LWCE_XGShip_Interceptor kInterceptor;

    m_kInterceptionEngagement = Spawn(class'LWCE_XGInterceptionEngagement');
    m_kInterceptionEngagement.Init(kXGInterception);
    m_kInterceptionEngagement.GetCombat();

    kInterceptor = LWCE_XGShip_Interceptor(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0]);

    if (!LWCE_IsShortDistanceWeapon(kInterceptor.GetWeaponAtIndex(0)))
    {
        Narrative(`XComNarrativeMoment("InterceptorEnemySighted"));
    }

    m_kInterceptionEngagement.m_kInterception.m_kUFOTarget.m_bWasEngaged = true;
    GEOSCAPE().UpdateSound();
}

function bool IsShortDistanceWeapon(int iWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(IsShortDistanceWeapon);

    return false;
}

function bool LWCE_IsShortDistanceWeapon(name WeaponName)
{
    return `LWCE_SHIP_WEAPON(WeaponName).eEngagementDistance == eER_Short;
}

function VOInRange()
{
    local LWCE_XGShip_Interceptor kInterceptor;

    kInterceptor = LWCE_XGShip_Interceptor(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0]);

    if (m_bFirstFire && LWCE_IsShortDistanceWeapon(kInterceptor.GetWeaponAtIndex(0)))
    {
        PRES().UINarrative(`XComNarrativeMoment("InterceptorClosingOnTarget"));
        m_bFirstFire = false;
    }
}