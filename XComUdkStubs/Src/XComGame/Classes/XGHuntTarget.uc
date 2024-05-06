class XGHuntTarget extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector m_vLocation;
    var array<XGEnemyUnit> m_arrEnemies;
    var array<XGPod> m_arrHunters;
    var int m_iTurnsRemaining;
    var bool m_bSearch;
    var bool m_bMimicBeacon;
};

var Vector m_vLocation;
var array<XGEnemyUnit> m_arrEnemies;
var array<XGPod> m_arrHunters;
var int m_iTurnsRemaining;
var bool m_bSearch;
var bool m_bMimicBeacon;