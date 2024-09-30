class LWCE_XGMission_HQAssault extends LWCE_XGMission;

function OnLoadGame()
{
    if (Game().m_kStrategyTransport == none)
    {
        PRES().m_bIsShuttling = true;
        GEOSCAPE().StartHQAssault();
        PRES().m_bIsShuttling = false;
    }
}