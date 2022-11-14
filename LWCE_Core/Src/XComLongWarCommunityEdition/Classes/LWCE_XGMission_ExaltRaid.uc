class LWCE_XGMission_ExaltRaid extends XGMission_ExaltRaid;

struct CheckpointRecord_LWCE_XGMission_ExaltRaid extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION