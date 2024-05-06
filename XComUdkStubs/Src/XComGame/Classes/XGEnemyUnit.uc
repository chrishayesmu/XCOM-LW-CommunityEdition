class XGEnemyUnit extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var XGUnit m_kUnit;
    var int m_iLastTurnVisible;
    var bool m_bCanSee;
    var Vector m_vLastSeen;
    var XGEnemyPod m_kPod;
};

var XGUnit m_kUnit;
var int m_iLastTurnVisible;
var bool m_bCanSee;
var Vector m_vLastSeen;
var XGEnemyPod m_kPod;