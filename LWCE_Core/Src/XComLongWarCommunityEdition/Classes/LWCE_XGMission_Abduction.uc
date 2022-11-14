class LWCE_XGMission_Abduction extends XGMission_Abduction;

struct CheckpointRecord_LWCE_XGMission_Abduction extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION