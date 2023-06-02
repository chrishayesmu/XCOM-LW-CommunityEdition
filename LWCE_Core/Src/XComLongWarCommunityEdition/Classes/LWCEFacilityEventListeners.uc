/// <summary>
/// Implements event listeners for core Long War 1.0 logic, keeping them separate from the implementation
/// of facility templates themselves.
/// </summary>
class LWCEFacilityEventListeners extends LWCEDataSet;

static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> Templates;

    Templates.AddItem(AlienContainment());
    Templates.AddItem(CyberneticsLab());
    Templates.AddItem(Foundry());
    Templates.AddItem(GeneticsLab());
    Templates.AddItem(PsionicLabs());

    return Templates;
}

static function LWCEEventListenerTemplate AlienContainment()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'AlienContainment');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', AlienContainment_CanBeRemoved);

    return Template;
}

static function AlienContainment_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_AlienContainment')
    {
        return;
    }

    if (`LWCE_LABS.LWCE_IsInterrogationTech(`LWCE_LABS.LWCE_GetCurrentTech().GetTechName()))
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strCaptiveCantRemoveBody;
    }
    else
    {
        kDataContainer.Data[3].B = true; // can be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strCaptiveRemoveBody; // warn that captives will be killed
    }
}

static function LWCEEventListenerTemplate CyberneticsLab()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'CyberneticsLab');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', CyberneticsLab_CanBeRemoved);

    return Template;
}

static function CyberneticsLab_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_CyberneticsLab')
    {
        return;
    }

    if (`LWCE_CYBERNETICSLAB.m_arrPatients.Length > 0)
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strCyberneticsLabsCantRemoveBody;
    }
    else if (`LWCE_CYBERNETICSLAB.m_arrRepairingItems.Length > 0)
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strCyberneticsLabsCantRemoveMecs;
    }
}

static function LWCEEventListenerTemplate Foundry()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'Foundry');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', Foundry_CanBeRemoved);

    return Template;
}

static function Foundry_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_Foundry')
    {
        return;
    }

    if (`LWCE_ENGINEERING.m_arrCEFoundryProjects.Length > 0)
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strFoundryCantRemoveBody;
    }
}

static function LWCEEventListenerTemplate GeneticsLab()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'GeneticsLab');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', GeneticsLab_CanBeRemoved);

    return Template;
}

static function GeneticsLab_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_GeneticsLab')
    {
        return;
    }

    if (`LWCE_GENELABS.m_arrPatients.Length > 0)
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strGeneLabsCantRemoveBody;
    }
}

static function LWCEEventListenerTemplate PsionicLabs()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'PsionicLabs');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', PsionicLabs_CanBeRemoved);

    return Template;
}

static function PsionicLabs_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_PsionicLabs')
    {
        return;
    }

    if (`LWCE_PSILABS.m_arrCETraining.Length > 0)
    {
        kDataContainer.Data[3].B = false; // can't be removed
        kDataContainer.Data[4].S = class'LWCE_XGBuildUI'.default.m_strPsiLabsCantRemoveBody;
    }
}