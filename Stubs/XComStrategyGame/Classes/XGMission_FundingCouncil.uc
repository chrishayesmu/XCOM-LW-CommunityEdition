class XGMission_FundingCouncil extends XGMission
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord_XGMission_FundingCouncil extends CheckpointRecord
{
    var TFCMission m_kTMission;
    var XGShip_Dropship m_kSkyranger;
};

var TFCMission m_kTMission;
var XGShip_Dropship m_kSkyranger;

simulated function string GetTitle(){}
function XGShip_Dropship GetAssignedSkyranger(){}
function TBriefingInfo GetBriefingInfo(){}
