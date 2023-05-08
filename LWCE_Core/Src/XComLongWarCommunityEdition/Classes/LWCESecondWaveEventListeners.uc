class LWCESecondWaveEventListeners extends LWCEDataSet;

static function LWCEEventListenerTemplate WeAreLegion()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'WeAreLegion');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', WeAreLegion_OnCampaignStart);
    // TODO: need an event to adjust squad size upwards for some missions

    return Template;
}

static function WeAreLegion_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.IsOptionEnabled(`LW_SECOND_WAVE_ID(WeAreLegion)))
    {
        kBarracks = LWCE_XGFacility_Barracks(kStrategy.m_kHQ.m_kBarracks);
        kBarracks.m_arrOTSUpgrades[1] = 1; // Squad Size 1
        kBarracks.m_arrOTSUpgrades[2] = 1; // Squad Size 2
    }
}