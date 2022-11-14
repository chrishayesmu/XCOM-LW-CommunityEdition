class LWCE_XGMission_HQAssault extends XGMission_HQAssault;

struct CheckpointRecord_LWCE_XGMission_HQAssault extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION