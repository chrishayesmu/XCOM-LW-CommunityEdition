class LWCE_XGMission_Terror extends XGMission_Terror;

struct CheckpointRecord_LWCE_XGMission_Terror extends CheckpointRecord_XGMission_Terror
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION