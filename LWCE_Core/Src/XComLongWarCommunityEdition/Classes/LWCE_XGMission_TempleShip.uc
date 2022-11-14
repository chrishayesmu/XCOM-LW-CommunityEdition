class LWCE_XGMission_TempleShip extends XGMission_TempleShip;

struct CheckpointRecord_LWCE_XGMission_TempleShip extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION