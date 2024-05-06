class XComAlienPodManager extends Actor
    native(AI)
    dependson(XComAlienPod, XGOvermindActor)
    notplaceable
    hidecategories(Navigation);

const MAX_ROAMING_PER_POD = 2;
const MAX_FAILURES_BEFORE_ABORT = 32;

struct CheckpointRecord
{
    var array<XComAlienPod> m_arrPod;
    var bool m_bHasTerrorPods;
};

struct podscore
{
    var float fScore;
    var XComAlienPod kPod;
};

var array<XComAlienPod> m_arrPod;
var bool m_bHasTerrorPods;
var bool m_bIsBusy;
var bool m_bFirstResponse;
var bool m_bSpoken;
var bool m_bPodRevealAttack;
var bool m_bWaitForSaveLoad;
var array<XComAlienPod> m_arrRevealed;
var array<XComAlienPod> m_arrRevealPostponed;
var array<XComAlienPod> m_arrActivation;
var array<XComAlienPod> m_arrTriggered;
var array<XComAlienPod> m_arrDynamic;
var array<XComAlienPod> m_arrTripped;
var int m_iActivePodIdx;
var XGAIPlayer m_kPlayer;
var XGUnit m_kUnit;
var XGCameraView m_kSavedView;
var array<int> m_kLootList;
var XComAlienPod m_kLastPodCleared;
var Volume m_kExitVolume;
var int m_nActivatedAliens;
var array<XComAlienPod> m_arrContingent;
var int m_iRevealedCount;
var XComAlienPod m_kCommanderPod;
var array<XComAlienPod> m_arrSecondaryPod;
var array<TAlienSpawn> m_arrSpawnList;
var int m_iAttackChance;
var int m_nPods;
var int m_nReplacedPods;
var Vector m_vLastEnemyLoc;
var array<XComAlienPod> m_arrLastScored;

defaultproperties
{
    m_bPodRevealAttack=true
}