class XGEnemyUnit extends XGOvermindActor;
//complete stub

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

function bool CanSee(){}
function int GetTurnsSinceVisible()
{}
function UpdateVisibility(bool bVisible)
{}
function XGEnemyPod GetPod()
{}
DefaultProperties
{
}
