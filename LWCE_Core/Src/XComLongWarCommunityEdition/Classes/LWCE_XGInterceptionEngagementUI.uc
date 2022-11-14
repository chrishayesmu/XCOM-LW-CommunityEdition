class LWCE_XGInterceptionEngagementUI extends XGInterceptionEngagementUI;

function PostInit(XGInterception kXGInterception)
{
    local LWCE_XGShip_Interceptor kInterceptor;

    m_kInterceptionEngagement = Spawn(class'LWCE_XGInterceptionEngagement');
    m_kInterceptionEngagement.Init(kXGInterception);
    m_kInterceptionEngagement.GetCombat();

    kInterceptor = LWCE_XGShip_Interceptor(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0]);

    if (!LWCE_IsShortDistanceWeapon(kInterceptor.LWCE_GetWeapon()))
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
    // TODO: base this on the weapon's actual attributes
    switch (WeaponName)
    {
        case 'Item_PhoenixCannon':
        case 'Item_LaserCannon':
        case 'Item_EMPCannon':
            return true;
        default:
            return false;
    }
}

function VOInRange()
{
    local LWCE_XGShip_Interceptor kInterceptor;

    kInterceptor = LWCE_XGShip_Interceptor(m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0]);

    if (m_bFirstFire && LWCE_IsShortDistanceWeapon(kInterceptor.LWCE_GetWeapon()))
    {
        PRES().UINarrative(`XComNarrativeMoment("InterceptorClosingOnTarget"));
        m_bFirstFire = false;
    }
}