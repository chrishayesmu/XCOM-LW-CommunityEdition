class XGTactic_Fight extends XGTactic
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGTactic_Fight extends CheckpointRecord
{
    var array<XGEnemyUnit> m_arrTargets;
    var array<XGEnemyPod> m_arrEnemyPods;
};

var array<XGEnemyUnit> m_arrTargets;
var array<XGEnemyPod> m_arrEnemyPods;

function InitFight(XGPod kPod, array<XGEnemyPod> arrEnemyPods){}
function InitSeek(XGPod kPod, XGEnemyUnit kEnemy){}
function EPodAnimation GetPodAnim(){}
function CallForHelp(){}
function bool Validate(array<XGEnemyUnit> arrInvalid){}

defaultproperties
{
    m_strName="FIGHT"
}