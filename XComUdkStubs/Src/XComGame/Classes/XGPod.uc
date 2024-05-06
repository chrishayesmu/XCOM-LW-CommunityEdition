class XGPod extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<XGUnit> m_arrMembers;
    var array<XGTactic> m_arrOldTactics;
    var XGTactic m_kCurrentTactic;
    var TAlienSpawn m_kSpawnInfo;
    var EPodAnimation m_eAnim;
    var bool m_bGathered;
    var bool m_bRetreated;
    var int m_iNumLost;
    var int m_iTurnsSinceVisible;
    var int m_iPodID;
    var bool m_bCalledReinforcements;
};

var array<XGUnit> m_arrMembers;
var array<XGTactic> m_arrOldTactics;
var XGTactic m_kCurrentTactic;
var TAlienSpawn m_kSpawnInfo;
var EPodAnimation m_eAnim;
var bool m_bGathered;
var bool m_bRetreated;
var bool m_bCalledReinforcements;
var int m_iNumLost;
var int m_iTurnsSinceVisible;
var int m_iPodID;

defaultproperties
{
    m_iTurnsSinceVisible=10
}