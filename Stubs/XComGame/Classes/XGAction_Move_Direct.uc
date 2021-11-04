class XGAction_Move_Direct extends XGAction
    native(Action)
    notplaceable
    hidecategories(Navigation);
//complete stub

const HACK_MAX_GHETTO_STUCK_MOVING_TIMEOUT_SECONDS = 30.0f;
const RUSHCAM_START_DIST = 384;
const RUSHCAM_STOP_DIST = 110;

enum AnimationState
{
    eAnimNone,
    eAnimRun,
    eAnimStopping,
    eAnimStop,
    AnimationState_MAX
};

struct native InitialReplicationData_XGAction_Move_Direct
{
    var Vector m_vDestination;
    var Vector m_vStartLocation;
    var bool m_bIgnoreCloseCombat;
    var float m_fDistance;
    var Vector m_vNewDirection;
    var float m_fStartDistance;
    var float m_fPawnTotalDistanceAlongPath;
    var float m_fPawnDistanceToStopExactly;
    var bool m_bNextMoveIsEndMove;
    var bool m_bNextMoveIsDirectMove;
    var Vector m_vCoverPoint;
    var ECoverState m_ePredictedCoverState;
    var EFavorDirection m_eUnitFavorDirection;
    var Vector m_vPredictedCoverDirection;
    var bool m_bServerInitializedAllData;
};

var Vector m_vDestination;
var Vector m_vNextPoint;
var Vector m_vStartLocation;
var bool m_bIgnoreCloseCombat;
var bool m_bBlendRotationToNextPoint;
var bool m_bForceFinished;
var bool m_bClearPath;
var bool m_bGlamCamActive;
var bool m_bNextMoveIsEndMove;
var bool m_bNextMoveIsDirectMove;
var bool m_bWaitingPostPodReveal;
var bool m_bSpawnForcedWalkIn;
var transient bool bWaitingForPods;
var transient bool bWasWaitingForPods;
var transient bool bRemovedMovingUnit;
var bool m_bInitialReplicationDataReceived_XGAction_Move_Direct;
var bool m_bNoChangeRMA;
var bool HACK_bDoGhettoStuckMovingTimeout;
var float m_fDistance;
var float m_fStartDistance;
var Vector m_vOldDirection;
var Vector m_vNewDirection;
var Vector m_vCoverPoint;
var ECoverState m_PredictedCoverState;
var AnimationState eCurrentAnimState;
var Vector m_vPredictedCoverDirection;
var Vector m_vLocLastFrame;
var float m_fTimeout;
var float m_fTimeoutTimer;
var repnotify InitialReplicationData_XGAction_Move_Direct m_kInitialReplicationData_XGAction_Move_Direct;
var float HACK_fGhettoStuckMovingTimer;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Move_Direct;
}

final simulated function string InitialReplicationData_XGAction_Move_Direct_ToString(const out InitialReplicationData_XGAction_Move_Direct kInitialReplicationData_XGAction_Move_Direct){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bIgnoreCloseCombat=false){}
simulated event SimulatedInit(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
simulated function AddRevealedEnemy(XGUnit kEnemy, EEnemyReveal eRevealType){}
simulated function RemoveFromReveal(array<XGUnit> arrUnit){}
simulated function SwitchAnimation(AnimationState Anim){}
simulated function Abort();
simulated function bool StopMove(EStopMoveType kType);
simulated function SetupNextMoveIsDirectMove(){}
simulated function SetupNextMoveIsEndMove(optional XGAction_EndMove kEndMoveAction){}
simulated function bool StartRushCam(){}
simulated function StopRushCam(){}
simulated function InternalCompleteAction(){}

simulated state Executing
{
    simulated function SetDefaultView();
    simulated function SetInvisibleView();
    simulated function Abort(){}
    simulated function bool StopMove(EStopMoveType kType){}
    simulated function BeginState(name nmPrev){}
    simulated function bool ReachedDestination(){}
    simulated function SetMoveDirectionAndFocalPoint(){}
    simulated function DoStopMoveAnimCheck(){}
    simulated function ReactionProcessing(){}
    simulated function UpdateCamera(){}
    simulated event Tick(float fDeltaTime)
	{
		super.Tick(fDeltatime);
	}
}
