class LWCE_XGMission extends XGMission;

struct CheckpointRecord_LWCE_XGMission extends XGMission.CheckpointRecord
{
    var name m_nmCity;
    var name m_nmCountry;
    var name m_nmContinent;
    var name m_nmMissionTemplate;
    var LWCE_TMissionReward m_kCEReward;
};

var name m_nmCity;
var name m_nmCountry;
var name m_nmContinent;
var name m_nmMissionTemplate;
var LWCE_TMissionReward m_kCEReward;

var LWCEMissionTemplate m_kTemplate;

function Init(name nmTemplate)
{
    m_nmMissionTemplate = nmTemplate;
    m_kTemplate = `LWCE_MISSION(nmTemplate);
}

function GenerateBattleDescription()
{
    local LWCE_TMissionReward kReward;

    if (m_kDesc.m_strOpName == "")
    {
        if (m_arrArtifacts.Length < 255)
        {
            m_arrArtifacts.Add(255 - m_arrArtifacts.Length);
        }

        m_kDesc.m_iMissionID = m_iID;
        m_kDesc.m_strOpName = GenerateOpName(m_kDesc.m_bIsTutorial && m_kDesc.m_bDisableSoldierChatter);
        m_kDesc.m_strLocation = GetLocationString();
        m_kDesc.m_iMissionType = m_iMissionType;

        `LWCE_LOG_WARN("GenerateBattleDescription is not fully implemented yet");
        // TODO
        // if (m_iMissionType == eMission_Crash)
        // {
        //     m_kDesc.m_eUFOType = EShipType(XGMission_UFOCrash(kSelf).m_iUFOType);
        // }
        // else if (m_iMissionType == eMission_LandedUFO)
        // {
        //     m_kDesc.m_eUFOType = XGMission_UFOLanded(kSelf).kUFO.m_kTShip.eType;
        // }

        m_kDesc.m_arrArtifacts = m_arrArtifacts;
        m_kDesc.m_iPodGroup = 0;
        m_kDesc.m_strObjective = m_strObjective;
        m_kDesc.m_strDesc = GetTitle();
        m_kDesc.m_iDifficulty = Game().GetDifficulty();
        m_kDesc.m_iLowestDifficulty = Game().m_iLowestDifficulty;

        LWCE_XGBattleDesc(m_kDesc).m_kArtifactsContainer.m_arrEntries = kReward.arrItems;
    }

    m_kDesc.m_strTime = CalcTime();
}

function TBriefingInfo GetBriefingInfo()
{
    local TBriefingInfo kInfo;
    local XGParamTag kTag;

    kInfo.strOpName = Caps(m_kDesc.m_strOpName);
    kInfo.strLocation = class'UIUtilities'.static.CapsCheckForGermanScharfesS(m_kDesc.m_strLocation);

    if (!m_kDesc.m_bIsTutorial)
    {
        if (m_kDesc.m_iMissionType == eMission_TerrorSite)
        {
            kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
            kTag.StrValue0 = kInfo.strLocation;
            kInfo.strMissionType = class'XComLocalizer'.static.ExpandString(Caps(m_kTemplate.strTitle));
        }
        else
        {
            kInfo.strMissionType = Caps(m_kTemplate.strTitle) $ "<br/>" $ kInfo.strLocation;
        }
    }
    else
    {
        kInfo.strMissionType = kInfo.strLocation;
    }

    kInfo.strSituation = m_kTemplate.strSituation;
    kInfo.strObjective = class'XComLocalizer'.static.ExpandString(m_kTemplate.strObjectives);
    kInfo.strTip = m_strTip;
    kInfo.strMapName = m_kDesc.m_strMapName;

    return kInfo;
}

function XGContinent GetContinent()
{
    if (m_nmContinent == '')
    {
        return none;
    }
    else
    {
        return `LWCE_XGCONTINENT(m_nmContinent);
    }
}

function int GetCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCountry);

    return -1;
}

function XGCountry LWCE_GetCountry()
{
    // This function is changed to return XGCountry to be consistent with GetCity and GetContinent

    if (m_nmCountry != '')
    {
        return `LWCE_XGCOUNTRY(m_nmCountry);
    }
    else if (m_nmCity != '')
    {
        return `LWCE_XGCOUNTRY(`LWCE_XGCITY(m_nmCity).m_nmCountry);
    }
    else
    {
        return none;
    }
}

function XGCity GetCity()
{
    if (m_nmCity == '')
    {
        return none;
    }
    else
    {
        return `LWCE_XGCITY(m_nmCity);
    }
}

function string GetLocationString()
{
    if (m_nmCity != '')
    {
        return GetCity().GetFullName();
    }
    else if (m_nmCountry != '')
    {
        return LWCE_GetCountry().GetName();
    }
    else if (m_nmContinent != '')
    {
        return GetContinent().GetName();
    }
}

function EMissionRegion GetRegion()
{
    `LWCE_LOG_DEPRECATED_CLS(GetRegion);

    return eMissionRegion_Any;
}

function name LWCE_GetRegion()
{
    `LWCE_LOG_NOT_IMPLEMENTED(LWCE_GetRegion);

    return '';
}

/// <summary>
/// Some missions can have subtypes; for example, council missions could be bomb disposal,
/// script missions like Portent or Site Recon, etc. Those mission types can override this
/// method in their subclass in order to provide their subtype.
///
/// The subtype is used in some LWCE configuration, e.g. when determining what lead-in audio
/// to play on the mission load screen. It is also meaningful within the subclasses that implement it.
/// </summary>
function name GetSubtype()
{
    return '';
}

simulated function string GetTitle()
{
    return m_kTemplate.strTitle;
}

simulated function string GetHelp()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetHelp);

    return "";
}