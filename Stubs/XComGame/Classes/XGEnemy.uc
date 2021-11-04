class XGEnemy extends XGOvermindActor;

//complete stub

struct CheckpointRecord
{
    var array<XGEnemyPod> m_arrPods;
    var array<XGEnemyUnit> m_arrAllEnemies;
    var array<XGEnemyUnit> m_arrNewVisibleEnemies;
    var array<XGEnemyUnit> m_arrNewNotVisibleEnemies;
    var array<XGEnemyUnit> m_arrNewInvalidEnemies;
};

var array<XGEnemyPod> m_arrPods;
var array<XGEnemyUnit> m_arrAllEnemies;
var array<XGEnemyUnit> m_arrNewVisibleEnemies;
var array<XGEnemyUnit> m_arrNewNotVisibleEnemies;
var array<XGEnemyUnit> m_arrNewInvalidEnemies;

function Init(){}
function Update(optional bool bUpdatePods){}
function UpdateEnemyList(){}
function UpdatePods(){}
function UpdateVisibility(){}
function ClearLists(){}
function XGEnemyUnit GetEnemyByUnit(XGUnit kUnit){}
function XGEnemyUnit AddNewEnemy(XGUnit kUnit){}
function bool CanSee(){}
function XGEnemyUnit GetClosestEnemy(Vector vPoint, bool bMustBeVisible){}
function array<XGEnemyPod> GetVisiblePods(){}
function array<XGEnemyPod> GetPodsFromEnemies(array<XGEnemyUnit> arrUnits){}
function float GetParameter(){}
