class LWCE_XGCountry extends XGCountry;

var name nmCountry;
var name nmContinent;

function AddPanic(int iPanic, optional bool bSuppressHeadline)
{
    local int iPrevPanic;

    iPrevPanic = m_iPanic;

    if (m_iPanic == -1)
    {
        return;
    }

    if (!m_kTCountry.bCouncilMember)
    {
        return;
    }

    if (m_iPanic >= 99 && iPanic > 0)
    {
        return;
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        // Don't apply dynamic war scaling to the panic which is applied at the start of the game
        if (STAT_GetStat(1) > 0)
        {
            iPanic /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    if (iPanic > 0)
    {
        if (Roll(m_kTCountry.iScience))
        {
            iPanic = Max(1, iPanic / 2);
        }
    }

    iPanic += EXALT().GetPanicMod(ECountry(m_kTCountry.iEnum), iPanic);
    m_iPanic = Clamp(m_iPanic + iPanic, 0, 99);
    GEOSCAPE().ColorCountry(ECountry(GetID()), GetPanicColor());

    if (m_iPanic >= GetPanicWarningThreshhold() && m_iPanic - iPanic < GetPanicWarningThreshhold() && iPanic > 0)
    {
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('CountryPanic').AddInt(m_kTCountry.iEnum).Build());
    }

    if (iPrevPanic != m_iPanic)
    {
        if (!bSuppressHeadline)
        {
            SITROOM().PushPanicHeadline(ECountry(GetID()), m_iPanic / 20);
        }
    }

    CalcFunding();
}

function LeaveXComProject()
{
    AI().ClearFromAbductionList(ECountry(GetID()));

    m_iFunding = 0;
    m_iPanic = -1;

    if (LeftXCom())
    {
        return;
    }

    if (HasSatelliteCoverage())
    {
        HQ().RemoveSatellite(m_kTCountry.iEnum);
    }

    m_bSecretPact = true;
    GEOSCAPE().ColorCountry(ECountry(GetID()), GetPanicColor());
    Game().CheckForLoseGame();
    World().m_kFundingCouncil.OnCountryLeft(ECountry(GetID()));
    World().m_iNumCountriesLost += 1;

    STAT_AddStat(eRecap_CountriesLost, 1);
    SetEntity(Spawn(class'LWCE_XGEntity'), GetStormEntity());

    // Taking a country and building a base costs the aliens 50 resources (except in the first month,
    // when it's the result of a guaranteed infiltration mission)
    if (AI().GetMonth() != 0)
    {
        STAT_AddStat(19, -50);
    }
}