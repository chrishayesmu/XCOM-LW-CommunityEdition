class LWCE_XGCountry extends XGCountry;

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

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordCountryLeavesXCom());
    }

    STAT_AddStat(eRecap_CountriesLost, 1);
    SetEntity(Spawn(class'LWCE_XGEntity'), GetStormEntity());

    // Taking a country and building a base costs the aliens 50 resources (except in the first month,
    // when it's the result of a guaranteed infiltration mission)
    if (AI().GetMonth() != 0)
    {
        STAT_AddStat(19, -50);
    }
}