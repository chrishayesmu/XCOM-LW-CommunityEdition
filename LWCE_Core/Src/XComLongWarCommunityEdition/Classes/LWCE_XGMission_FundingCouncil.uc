class LWCE_XGMission_FundingCouncil extends LWCE_XGMission;

struct CheckpointRecord_LWCE_XGMission_FundingCouncil extends CheckpointRecord_LWCE_XGMission
{
    // var LWCE_TFCMission m_kTMission;
};

// var LWCE_TFCMission m_kTMission;

simulated function string GetTitle()
{
    // return m_kTMission.strName;
    return "<< NOT IMPLEMENTED >>";
}

function TBriefingInfo GetBriefingInfo()
{
    local TBriefingInfo kInfo;

    kInfo = super.GetBriefingInfo();
    // kInfo.strSituation = m_kTMission.strSituationBrief;
    // kInfo.strObjective = m_kTMission.strObjectivesBrief;
    kInfo.strSituation = "Situation: << not implemented >>";
    kInfo.strObjective = "Objective: << not implemented >>";
    return kInfo;
}

function name GetSubtype()
{
    `LWCE_LOG_NOT_IMPLEMENTED(GetSubtype);
    return '';
}