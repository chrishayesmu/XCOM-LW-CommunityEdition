class LWCE_XGMission_FundingCouncil extends XGMission_FundingCouncil;

struct CheckpointRecord_LWCE_XGMission_FundingCouncil extends CheckpointRecord_XGMission_FundingCouncil
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION