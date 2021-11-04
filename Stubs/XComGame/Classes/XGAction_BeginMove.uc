class XGAction_BeginMove extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

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
var bool m_bInitialReplicationDataReceived_XGAction_BeginMove;
var bool m_bPathDataReplicated;
var XGCameraView_Moving m_kMoveView;
var Vector m_vComputePathDest;
var transient AnimNodeSequence m_TmpNode;
var transient ESingleAnim CustomStartMoveAnimAction;
var repnotify InitialReplicationData_XGAction_BeginMove m_kInitialReplicationData_XGAction_BeginMove;
var ReplicatedPathPoint m_arrReplicatedPathPoints[128];
var array<PathPoint> m_arrPathPoints;
var transient int iTemp;
var transient float fTemp;
var float HACK_fGhettoStuckLoopingTimeoutSeconds;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_arrReplicatedPathPoints, m_kInitialReplicationData_XGAction_BeginMove;
}

final simulated function string InitialReplicationData_XGAction_BeginMove_ToString(const out InitialReplicationData_XGAction_BeginMove kInitialReplicationData_XGAction_BeginMove){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bNoCost, optional bool bFlying){}
simulated event SimulatedInit(){}
simulated function bool IsPathDataReplicated(){}
simulated function bool CanBePerformed(){}
simulated function AddRevealedEnemy(XGUnit kEnemy, EEnemyReveal eRevealType){}
simulated function RemoveFromReveal(array<XGUnit> arrUnit){}
function ProcessSuppression(XGUnit kUnit){}
simulated function ESingleAnim GetCustomStartMoveAnimAction(Vector Destination){}

simulated state Executing
{
    simulated event BeginState(name P){}
    simulated event Tick(float fDeltaTime){super.Tick(fDeltaTime);}
}
