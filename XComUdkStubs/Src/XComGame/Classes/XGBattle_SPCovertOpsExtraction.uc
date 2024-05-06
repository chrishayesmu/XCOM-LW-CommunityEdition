class XGBattle_SPCovertOpsExtraction extends XGBattle_SP
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGBattle_SPCovertOpsExtraction extends CheckpointRecord_XGBattle_SP
{
    var XGUnit m_kCovertOperative;
};

var private const config int m_iCovertOpsCashRewardAmount;
var private XGUnit m_kCovertOperative;