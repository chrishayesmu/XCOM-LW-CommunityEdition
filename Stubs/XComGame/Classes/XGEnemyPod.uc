class XGEnemyPod extends XGOvermindActor;
//complete stub

struct CheckpointRecord
{
    var array<XGEnemyUnit> m_arrMembers;
    var Vector m_vCoverDirection;
    var Vector m_vCenter;
    var float m_fRadius;
    var array<XGPod> m_arrFighting;
    var bool m_bCanSee;
    var int m_iTurnsSinceVisible;

};

var array<XGEnemyUnit> m_arrMembers;
var Vector m_vCoverDirection;
var Vector m_vCenter;
var float m_fRadius;
var array<XGPod> m_arrFighting;
var bool m_bCanSee;
var int m_iTurnsSinceVisible;

function Vector GetLocation()
{}
function bool CanSee()
{}
function UpdateVisibility()
{}
function array<XGEnemyUnit> GetVisibleMembers()
{}
function array<XGUnit> GetUnits()
{}
function AddMember(XGEnemyUnit kEnemy)
{}
function bool ShouldAbsorbPod(XGEnemyPod kPod)
{}
function AbsorbPod(XGEnemyPod kPod)
{}
DefaultProperties
{
}
