class XGOvermind extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<XGPod> m_arrPods;
    var array<XGPod> m_arrActivePods;
    var array<XGPod> m_arrControlledPods;
    var XGLayout m_kLayout;
    var XGDeployAI m_kDeploy;
    var XGEnemy m_kEnemy;
    var array<XGHuntTarget> m_arrHuntTargets;
    var array<TAlienSpawn> m_arrSpawns;
    var int m_iTurnsSinceContact;
    var int m_iTurnsSinceCall;
    var bool m_bConverged;
    var array<XGUnit> m_arrVisibleEnemies;
    var Vector m_vEnemySpawn;
    var Vector m_vPlay;
    var int m_iDeflection;
    var name m_strState;
    var float m_fPlayDist;
    var XComWaveSystem m_kWaveSystem;
};

var array<XGPod> m_arrPods;
var array<XGPod> m_arrActivePods;
var array<XGPod> m_arrControlledPods;
var XGLayout m_kLayout;
var XGDeployAI m_kDeploy;
var XGEnemy m_kEnemy;
var array<XGHuntTarget> m_arrHuntTargets;
var array<TAlienSpawn> m_arrSpawns;
var int m_iTurnsSinceContact;
var int m_iTurnsSinceCall;
var bool m_bConverged;
var array<XGUnit> m_arrVisibleEnemies;
var Vector m_vEnemySpawn;
var Vector m_vPlay;
var int m_iDeflection;
var name m_strState;
var float m_fPlayDist;
var XComCapturePointVolume m_kActiveCapPoint;
var XComWaveSystem m_kWaveSystem;

defaultproperties
{
    m_iDeflection=1
}