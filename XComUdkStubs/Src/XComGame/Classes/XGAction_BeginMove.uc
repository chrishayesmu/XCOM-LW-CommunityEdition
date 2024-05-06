class XGAction_BeginMove extends XGAction
    notplaceable
    hidecategories(Navigation);

const MAX_REPLICATED_PATH_POINTS = 128;
const HACK_MAX_GHETTO_STUCK_LOOPING_TIMEOUT_SECONDS = 10.0f;
const HACK_MAX_GHETTO_STUCK_FINISH_ANIMS_TIMEOUT_SECONDS = 10.0f;

struct InitialReplicationData_XGAction_BeginMove
{
    var bool m_bSpeak;
    var bool m_bSkipCameraView;
    var bool m_bNoCost;
    var bool m_bFlying;
    var Vector m_vComputePathDest;
    var bool m_bUnitDashing;
    var int m_iPathNumPoints;
    var Vector m_vPathRawDestination;
    var Vector m_vPathAdjustedDestination;
    var bool m_bBullRush;
};

var bool m_bSpeak;
var bool m_bNoCost;
var bool m_bFlying;
var bool m_bSkipCameraView;
var bool m_bBullRush;
var private bool m_bInitialReplicationDataReceived_XGAction_BeginMove;
var private bool m_bPathDataReplicated;
var XGCameraView_Moving m_kMoveView;
var Vector m_vComputePathDest;
var transient AnimNodeSequence m_TmpNode;
var private transient ESingleAnim CustomStartMoveAnimAction;
var private repnotify InitialReplicationData_XGAction_BeginMove m_kInitialReplicationData_XGAction_BeginMove;
var private repretry ReplicatedPathPoint m_arrReplicatedPathPoints[128];
var private array<PathPoint> m_arrPathPoints;
var transient int iTemp;
var transient float fTemp;
var float HACK_fGhettoStuckLoopingTimeoutSeconds;

defaultproperties
{
    m_bNeedsFinalReplication=false
    m_bBlocksInput=true
    m_bModal=false
}