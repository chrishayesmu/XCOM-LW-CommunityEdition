class LWCE_XGMission_UFOLanded extends XGMission_UFOLanded;

struct CheckpointRecord_LWCE_XGMission_UFOLanded extends CheckpointRecord_XGMission_UFOLanded
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION