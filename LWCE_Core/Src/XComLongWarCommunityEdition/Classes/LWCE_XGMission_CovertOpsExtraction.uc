class LWCE_XGMission_CovertOpsExtraction extends XGMission_CovertOpsExtraction;

struct CheckpointRecord_LWCE_XGMission_CovertOpsExtraction extends XGMission.CheckpointRecord
{
    var LWCE_TMissionReward m_KCEReward;
};

var LWCE_TMissionReward m_KCEReward;

`include(generators.uci)

`LWCE_GENERATOR_XGMISSION