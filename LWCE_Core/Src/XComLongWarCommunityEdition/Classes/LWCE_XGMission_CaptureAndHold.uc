class LWCE_XGMission_CaptureAndHold extends XGMission_CaptureAndHold;

struct CheckpointRecord_LWCE_XGMission_CaptureAndHold extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION