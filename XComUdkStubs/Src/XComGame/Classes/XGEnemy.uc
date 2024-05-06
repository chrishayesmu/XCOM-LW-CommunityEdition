class XGEnemy extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

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