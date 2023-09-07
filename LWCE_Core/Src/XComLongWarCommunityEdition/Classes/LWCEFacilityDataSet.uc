/// <summary>
/// Implements event listeners for core Long War 1.0 logic, keeping them separate from the implementation
/// of facility templates themselves.
/// </summary>
class LWCEFacilityDataSet extends LWCEDataSet;

static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> Templates;

    // Facilities themselves are instantiated based on config; we're just setting up some
    // extra event listeners for base game facilities
    Templates.AddItem(AlienContainment());
    Templates.AddItem(RepairBay());
    Templates.AddItem(Foundry());
    Templates.AddItem(GeneticsLab());
    Templates.AddItem(OfficerTrainingSchool());
    Templates.AddItem(PsionicLabs());

    return Templates;
}

static function OnPostTemplatesCreated()
{
    local LWCEFacilityTemplateManager kTemplateMgr;

    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    kTemplateMgr.FindFacilityTemplate('Facility_Laboratory').StaffRequirementsFn = LaboratoryStaffRequirementsFn;
    kTemplateMgr.FindFacilityTemplate('Facility_SatelliteNexus').StaffRequirementsFn = SatelliteStaffRequirementsFn;
    kTemplateMgr.FindFacilityTemplate('Facility_SatelliteUplink').StaffRequirementsFn = SatelliteStaffRequirementsFn;
    kTemplateMgr.FindFacilityTemplate('Facility_Workshop').StaffRequirementsFn = WorkshopStaffRequirementsFn;
}

static function array<LWCE_TStaffRequirement> LaboratoryStaffRequirementsFn(LWCEFacilityTemplate kFacility)
{
    local array<LWCE_TStaffRequirement> arrRequirements;
    local LWCE_TStaffRequirement kReq;
    local int iLabs;

    kReq.StaffType = 'Scientist';

    iLabs = `LWCE_HQ.LWCE_GetNumFacilities('Facility_Laboratory') + `LWCE_ENGINEERING.LWCE_GetNumFacilitiesBuilding('Facility_Laboratory');

    if (iLabs == 0)
    {
        kReq.NumRequired = class'XGTacticalGameCore'.default.LAB_MINIMUM;
    }
    else
    {
        kReq.NumRequired  = class'XGTacticalGameCore'.default.LAB_MINIMUM - 1;
        kReq.NumRequired += iLabs * class'XGTacticalGameCore'.default.LAB_MULTIPLE;
    }

    arrRequirements.AddItem(kReq);
    return arrRequirements;
}

static function array<LWCE_TStaffRequirement> SatelliteStaffRequirementsFn(LWCEFacilityTemplate kFacility)
{
    local array<LWCE_TStaffRequirement> arrRequirements;
    local LWCE_TStaffRequirement kReq;
    local int iNexuses, iUplinks;

    kReq.StaffType = 'Engineer';

    iNexuses = `LWCE_HQ.LWCE_GetNumFacilities('Facility_SatelliteNexus') + `LWCE_ENGINEERING.LWCE_GetNumFacilitiesBuilding('Facility_SatelliteNexus');
    iUplinks = `LWCE_HQ.LWCE_GetNumFacilities('Facility_SatelliteUplink') + `LWCE_ENGINEERING.LWCE_GetNumFacilitiesBuilding('Facility_SatelliteUplink');

    iUplinks -= 1; // The free uplink that the player starts with doesn't count towards engineer requirements

    if (kFacility.GetFacilityName() == 'Facility_SatelliteNexus')
    {
        iNexuses += 1;
    }
    else
    {
        iUplinks += 1;
    }

    kReq.NumRequired = iNexuses * class'XGTacticalGameCore'.default.NEXUS_MULTIPLE + iUplinks * class'XGTacticalGameCore'.default.UPLINK_MULTIPLE;

    arrRequirements.AddItem(kReq);
    return arrRequirements;
}

static function array<LWCE_TStaffRequirement> WorkshopStaffRequirementsFn(LWCEFacilityTemplate kFacility)
{
    local array<LWCE_TStaffRequirement> arrRequirements;
    local LWCE_TStaffRequirement kReq;
    local int iWorkshops;

    kReq.StaffType = 'Engineer';

    iWorkshops = `LWCE_HQ.LWCE_GetNumFacilities('Facility_Workshop') + `LWCE_ENGINEERING.LWCE_GetNumFacilitiesBuilding('Facility_Workshop');

    if (iWorkshops == 0)
    {
        kReq.NumRequired = class'XGTacticalGameCore'.default.WORKSHOP_MINIMUM;
    }
    else
    {
        kReq.NumRequired  = class'XGTacticalGameCore'.default.WORKSHOP_MINIMUM - 1;
        kReq.NumRequired += iWorkshops * class'XGTacticalGameCore'.default.WORKSHOP_MULTIPLE;
    }

    arrRequirements.AddItem(kReq);
    return arrRequirements;
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

static function LWCEEventListenerTemplate Foundry()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'Foundry');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('FacilityAddedToBase', Foundry_FacilityAddedOrRemoved);
    Template.AddEvent('FacilityRemovedFromBase', Foundry_FacilityAddedOrRemoved);
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

static function Foundry_FacilityAddedOrRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;

    kDataContainer = LWCEDataContainer(EventData);

    if (kDataContainer.Data[0].Nm != 'Facility_Foundry')
    {
        return;
    }

    `LWCE_BARRACKS.UpdateFoundryPerks();
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

static function LWCEEventListenerTemplate OfficerTrainingSchool()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'OfficerTrainingSchool');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('FacilityAddedToBase', OfficerTrainingSchool_FacilityAddedOrRemoved);
    Template.AddEvent('FacilityRemovedFromBase', OfficerTrainingSchool_FacilityAddedOrRemoved);

    return Template;
}

static function OfficerTrainingSchool_FacilityAddedOrRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;

    kDataContainer = LWCEDataContainer(EventData);

    if (kDataContainer.Data[0].Nm != 'Facility_OfficerTrainingSchool')
    {
        return;
    }

    `LWCE_BARRACKS.UpdateOTSPerks();
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

static function LWCEEventListenerTemplate RepairBay()
{
    local LWCEEventListenerTemplate Template;

    `CREATE_EVENT_LISTENER_TEMPLATE(Template, 'RepairBay');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('FacilityAddedToBase', RepairBay_FacilityAddedToBase);
    Template.AddEvent('LWCEFacilityTemplate_CanBeRemoved', RepairBay_CanBeRemoved);

    return Template;
}

static function RepairBay_CanBeRemoved(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCEFacilityTemplate kFacility;

    kDataContainer = LWCEDataContainer(EventData);
    kFacility = LWCEFacilityTemplate(EventSource);

    if (kFacility.GetFacilityName() != 'Facility_RepairBay')
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

static function RepairBay_FacilityAddedToBase(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;

    kDataContainer = LWCEDataContainer(EventData);

    if (kDataContainer.Data[0].Nm != 'Facility_RepairBay')
    {
        return;
    }

    // The MEC minigun and base augments are marked infinite, but still aren't in XCOM's inventory until this happens
    `LWCE_STORAGE.LWCE_AddItem('Item_BaseAugments', 1000);
    `LWCE_STORAGE.LWCE_AddItem('Item_Minigun', 1000);
}