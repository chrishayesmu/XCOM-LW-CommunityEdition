class LWCE_XGMission_AlienBase extends XGMission_AlienBase;

struct CheckpointRecord_LWCE_XGMission_AlienBase extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION