class XGAction_Move_Direct extends XGAction
    native(Action)
    notplaceable
    hidecategories(Navigation);

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
var private transient bool bWaitingForPods;
var private transient bool bWasWaitingForPods;
var private transient bool bRemovedMovingUnit;
var private bool m_bInitialReplicationDataReceived_XGAction_Move_Direct;
var bool m_bNoChangeRMA;
var privatewrite bool HACK_bDoGhettoStuckMovingTimeout;
var float m_fDistance;
var float m_fStartDistance;
var Vector m_vOldDirection;
var Vector m_vNewDirection;
var Vector m_vCoverPoint;
var ECoverState m_PredictedCoverState;
var XGAction_Move_Direct.AnimationState eCurrentAnimState;
var Vector m_vPredictedCoverDirection;
var Vector m_vLocLastFrame;
var float m_fTimeout;
var float m_fTimeoutTimer;
var private repnotify InitialReplicationData_XGAction_Move_Direct m_kInitialReplicationData_XGAction_Move_Direct;
var privatewrite float HACK_fGhettoStuckMovingTimer;

defaultproperties
{
    m_fTimeout=3.0
    m_bAllowDuplicates=true
    m_bNeedsFinalReplication=false
    m_bBlocksInput=true
    m_bModal=false
}