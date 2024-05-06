class XGTactic_Fight extends XGTactic
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGTactic_Fight extends CheckpointRecord
{
    var array<XGEnemyUnit> m_arrTargets;
    var array<XGEnemyPod> m_arrEnemyPods;
};

var array<XGEnemyUnit> m_arrTargets;
var array<XGEnemyPod> m_arrEnemyPods;

defaultproperties
{
    m_strName="FIGHT"
}