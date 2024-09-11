/// <summary>
/// TODO
/// </summary>
class LWCEMissionTemplate extends LWCEDataTemplate
    config(LWCEMissions);

var config string MissionClass; // e.g. LWCE_XGMission_UFOLanded

// If populated, these name lists will be available to the localizer when generating an
// operation name for missions following this template.
var config array<name> arrNameLists;

// Title for this mission type, as shown in the mission list on the Geoscape.
var const localized string strTitle;

// Description of the mission situation, shown in the pre-mission Skyranger loading screen.
var const localized string strSituation;

// Mission objectives, which will be displayed to the player during the mission.
var const localized string strObjectives;

// Missions created from this template will have this operation name. The string will
// be expanded through the current localization context at mission creation time.
var const localized string strOperationName;

var array<delegate<OnMissionCreated> > OnMissionCreatedDelegates;
var array<delegate<OnMissionLost> > OnMissionLostDelegates;
var array<delegate<OnMissionWon> > OnMissionWonDelegates;

/// <summary>
/// Callback type for when a mission is first created.
/// </summary>
delegate OnMissionCreated(LWCE_XGMission kMission);

/// <summary>
/// Callback type for when a mission has been lost. This could be due to the entire
/// squad dying, the player choosing to evac, TODO
/// </summary>
delegate OnMissionLost(LWCE_XGMission kMission);

/// <summary>
/// TODO
/// </summary>
delegate OnMissionWon(LWCE_XGMission kMission);

function LWCE_XGMission CreateMission(Object kOwner)
{
    local Class MissionClassDef;
    local delegate<OnMissionCreated> del;
    local LWCE_XGMission kMission;

    MissionClassDef = class<LWCE_XGMission>(DynamicLoadObject(MissionClass, class'Class'));

    if (MissionClassDef == none)
    {
        `LWCE_LOG_ERROR(DataName $ ": could not load the configured MissionClass " $ MissionClass $ "! Cannot create a mission using this template.");
        return none;
    }

    kMission = LWCE_XGMission(new (kOwner) MissionClassDef);

    // TODO: should there be some sort of initialization before we hand off to these delegates?
    foreach OnMissionCreatedDelegates(del)
    {
        del(kMission);
    }

    return kMission;
}

function string GenerateOperationName(LWCE_XGMission kMission)
{
    `LWCE_ENGINE.m_kCEMissionTag.Mission = kMission;

    return `LWCE_XEXPAND(strOperationName);
}


function bool ValidateTemplate(out string strError)
{
    if (MissionClass == "")
    {
        strError = "No value has been set for MissionClass";
        return false;
    }

    return super.ValidateTemplate(strError);
}
