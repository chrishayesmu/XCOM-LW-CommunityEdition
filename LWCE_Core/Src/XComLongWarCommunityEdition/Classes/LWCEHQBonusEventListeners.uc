class LWCEHQBonusEventListeners extends LWCEDataSet;

// TODO: all of the bonuses that just give bonus items/techs/facilities at campaign start could be
// their own form of template, that can be easily configured by the player, and only require custom
// event listeners for more complicated bonuses
static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> Templates;

    Templates.AddItem(AncientArtifact());
    Templates.AddItem(Cadre());
    Templates.AddItem(ForeignLegion());
    Templates.AddItem(ForTheSakeOfGlory());
    Templates.AddItem(GhostInTheMachine());
    Templates.AddItem(JaiJawan());
    Templates.AddItem(KiryuKaiCommander());
    Templates.AddItem(JungleScouts_Alternate());
    Templates.AddItem(Resourceful());
    Templates.AddItem(SukhoiCompany());
    Templates.AddItem(TheirFinestHour());

    return Templates;
}

static function LWCEEventListenerTemplate AncientArtifact()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'AncientArtifact');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', AncientArtifact_OnCampaignStart);

    return Template;
}

static function AncientArtifact_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(AncientArtifact)) > 0)
    {
        kStorage = LWCE_XGStorage(kStrategy.STORAGE());
        kStorage.LWCE_AddItem('Item_IlluminatorGunsight');
    }
}

static function LWCEEventListenerTemplate Cadre()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'Cadre');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', Cadre_OnCampaignStart);

    return Template;
}

static function Cadre_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local int CadreBonus;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);
    CadreBonus = kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(Cadre));

    if (CadreBonus > 0)
    {
        // TODO: need to configure this in a way that will work with class mods
        kBarracks = LWCE_XGFacility_Barracks(kStrategy.m_kHQ.m_kBarracks);
        kBarracks.LWCE_CreateSoldier(1, CadreBonus, Rand(36));
        kBarracks.LWCE_CreateSoldier(2, CadreBonus, Rand(36));
        kBarracks.LWCE_CreateSoldier(3, CadreBonus, Rand(36));
        kBarracks.LWCE_CreateSoldier(4, CadreBonus, Rand(36));
    }
}

static function LWCEEventListenerTemplate ForeignLegion()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'ForeignLegion');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', ForeignLegion_OnCampaignStart);

    return Template;
}

static function ForeignLegion_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(ForeignLegion)) > 0)
    {
        kStrategy.m_kHQ.m_kBarracks.AddNewSoldiers(20); // TODO configure
    }
}

static function LWCEEventListenerTemplate ForTheSakeOfGlory()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'ForTheSakeOfGlory');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', ForTheSakeOfGlory_OnCampaignStart);

    return Template;
}

static function ForTheSakeOfGlory_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_AdvancedRepair');
    }
}

static function LWCEEventListenerTemplate GhostInTheMachine()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'GhostInTheMachine');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', GhostInTheMachine_OnCampaignStart);

    return Template;
}

static function GhostInTheMachine_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(GhostInTheMachine)) > 0)
    {
        kStorage = LWCE_XGStorage(kStrategy.STORAGE());
        kStorage.LWCE_AddItem('Item_SHIV', 2);
    }
}

static function LWCEEventListenerTemplate JaiJawan()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'JaiJawan');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', JaiJawan_OnCampaignStart);

    return Template;
}

static function JaiJawan_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(JaiJawan)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kStorage = LWCE_XGStorage(kEngineering.m_kStorage);

        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_EleriumAfterburners');
        kStorage.LWCE_AddItem('Item_Interceptor', 2);
    }
}

// This is a version of Jungle Scouts which can be enabled in LW 1.0's ini, which is more powerful
// and just gives Tactical Rigging from the start of the game
static function LWCEEventListenerTemplate JungleScouts_Alternate()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'JungleScouts_Alternate');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', JungleScouts_Alternate_OnCampaignStart);

    return Template;
}

static function JungleScouts_Alternate_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_TacticalRigging');
    }
}

static function LWCEEventListenerTemplate KiryuKaiCommander()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'KiryuKaiCommander');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', KiryuKaiCommander_OnCampaignStart);

    return Template;
}

static function KiryuKaiCommander_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local int KiryuKaiBonus;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);
    KiryuKaiBonus = kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(KiryuKaiCommander));

    if (KiryuKaiBonus > 0)
    {
        kBarracks = LWCE_XGFacility_Barracks(kStrategy.m_kHQ.m_kBarracks);
        kBarracks.LWCE_CreateSoldier(kBarracks.SelectRandomBaseClassId(), KiryuKaiBonus, eCountry_Japan);
    }
}

static function LWCEEventListenerTemplate Resourceful()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'Resourceful');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', Resourceful_OnCampaignStart);

    return Template;
}

static function Resourceful_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(Resourceful)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_AlienMetallurgy');
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_ImprovedSalvage');
    }
}

static function LWCEEventListenerTemplate SukhoiCompany()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'SukhoiCompany');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', SukhoiCompany_OnCampaignStart);

    return Template;
}

static function SukhoiCompany_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_ImprovedAvionics');
    }
}

static function LWCEEventListenerTemplate TheirFinestHour()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'TheirFinestHour');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('OnNewCampaignStarted', TheirFinestHour_OnCampaignStart);

    return Template;
}

static function TheirFinestHour_OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGStrategy kStrategy;

    kStrategy = LWCE_XGStrategy(EventSource);

    if (kStrategy.m_kHQ.HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour)) > 0)
    {
        kEngineering = LWCE_XGFacility_Engineering(kStrategy.m_kHQ.m_kEngineering);
        kEngineering.m_arrCEFoundryHistory.AddItem('Foundry_PenetratorWeapons');
    }
}