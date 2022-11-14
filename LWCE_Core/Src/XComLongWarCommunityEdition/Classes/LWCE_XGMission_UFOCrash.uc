class LWCE_XGMission_UFOCrash extends XGMission_UFOCrash;

struct CheckpointRecord_LWCE_XGMission_UFOCrash extends CheckpointRecord_XGMission_UFOCrash
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION