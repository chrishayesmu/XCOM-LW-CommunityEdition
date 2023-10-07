class LWCE_XGInterceptionEngagementUI extends XGInterceptionEngagementUI;

function PostInit(XGInterception kXGInterception)
{
    local LWCE_XGInterception kCEInterception;
    local LWCE_XGShip kLeadingEnemyShip, kLeadingFriendlyShip;

    m_kInterceptionEngagement = Spawn(class'LWCE_XGInterceptionEngagement');
    m_kInterceptionEngagement.Init(kXGInterception);
    m_kInterceptionEngagement.GetCombat();

    kCEInterception = LWCE_XGInterception(m_kInterceptionEngagement.m_kInterception);

    kLeadingEnemyShip = kCEInterception.m_arrEnemyShips[0];
    kLeadingFriendlyShip = kCEInterception.m_arrFriendlyShips[0];

    if (!LWCE_IsShortDistanceWeapon(kLeadingFriendlyShip.GetWeaponAtIndex(0)))
    {
        Narrative(`XComNarrativeMoment("InterceptorEnemySighted"));
    }

    kLeadingEnemyShip.m_bWasEngaged = true;
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
    local LWCE_XGShip kLeadingFriendlyShip;

    kLeadingFriendlyShip = LWCE_XGInterception(m_kInterceptionEngagement.m_kInterception).m_arrFriendlyShips[0];

    if (m_bFirstFire && LWCE_IsShortDistanceWeapon(kLeadingFriendlyShip.GetWeaponAtIndex(0)))
    {
        PRES().UINarrative(`XComNarrativeMoment("InterceptorClosingOnTarget"));
        m_bFirstFire = false;
    }
}