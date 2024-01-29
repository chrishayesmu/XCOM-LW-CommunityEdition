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

function OnEngagementOver()
{
    local bool bFriendlyShipLost;
    local LWCE_XGInterception kInterception;
    local LWCE_XGShip kShip;

    kInterception = LWCE_XGInterception(m_kInterceptionEngagement.m_kInterception);

    GoToView(eIntEngagementView_Result);

    switch (m_kInterceptionEngagement.m_kInterception.m_eUFOResult)
    {
        case eUR_Crash:
        case eUR_Destroyed:
            break;
        case eUR_Escape:
            kShip = LWCE_XGInterceptionEngagement(m_kInterceptionEngagement).LWCE_GetEnemyShip(0);

            if (kShip.m_kTemplate.nmSize == 'Small' || kShip.m_kTemplate.nmSize == 'Medium')
            {
                Sound().PlaySFX(SNDLIB().SFX_Int_SmallUFOEscape);
            }
            else
            {
                Sound().PlaySFX(SNDLIB().SFX_Int_BigUFOEscape);
            }

            Narrative(`XComNarrativeMoment("RoboHQ_ContactLost"));
            break;
    }

    bFriendlyShipLost = false;
    foreach kInterception.m_arrFriendlyShips(kShip)
    {
        if (kShip.GetHP() <= 0)
        {
            bFriendlyShipLost = true;
            break;
        }
    }

    if (bFriendlyShipLost)
    {
        Narrative(`XComNarrativeMoment("RoboHQ_AircraftLost"));
    }

    Sound().PlayMusic(eMusic_MC);
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

function SFXShipDestroyed(XGShip kShip)
{
    if (kShip.IsAlienShip())
    {
        switch (LWCE_XGShip(kShip).m_nmShipTemplate)
        {
            case 'UFOFighter':
            case 'UFOScout':
                Sound().PlaySFX(SNDLIB().SFX_Int_SmallUFOGoingDown);
                break;
            default:
                Sound().PlaySFX(SNDLIB().SFX_Int_BigUFOGoingDown);
                break;
        }
    }
    else
    {
        PRES().UINarrative(`XComNarrativeMoment("InterceptorDestroyed"));
        Sound().PlaySFX(SNDLIB().SFX_Int_JetExplode);
    }
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