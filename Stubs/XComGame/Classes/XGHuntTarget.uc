class XGHuntTarget extends XGOvermindActor;
//complete stub

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

function Vector GetLocation(){}
function SetTarget(Vector vLocation, int iTurnsLeft, bool bSearch, optional array<XGEnemyUnit> arrEnemies, optional bool bMimicBeacon){}
function bool IsSearch(){}
function ClearHunters(){}
function bool Validate(array<XGEnemyUnit> arrEnemies){}
