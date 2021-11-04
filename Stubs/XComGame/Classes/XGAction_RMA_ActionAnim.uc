class XGAction_RMA_ActionAnim extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

enum eRMAWaitStatus
{
    eRWS_Begin_CameraWait,
    eRWS_Anim,
    eRWS_Overmind,
    eRWS_IdleStateMachine,
    eRWS_HearSound,
    eRWS_Done,
    eRWS_MAX
};

struct InitialReplicationData_XGAction_RMA_ActionAnim
{
    var ESingleAnim animation;
    var Vector Destination;
    var float Distance;
    var Actor AssociatedActor;
    var bool m_bAssociatedActorNone;
    var bool m_ForceReplication;
};

var ESingleAnim eAnimation;
var EManeuverType eCallOthersReason;
var eRMAWaitStatus m_eWaitStatus;
var XGCameraView_Cinematic m_kActionView;
var Vector Destination;
var float Distance;
var Actor AssociatedActor;
var Vector vLookAt;
var XGUnit m_kResponder;
var bool m_bOnLookAt;
var bool bWasInCover;
var bool m_bInitialReplicationDataReceived_XGAction_RMA_ActionAnim;
var float WaitForCameraTimer;
var repnotify repretry InitialReplicationData_XGAction_RMA_ActionAnim m_kInitialReplicationData_XGAction_RMA_ActionAnim;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_RMA_ActionAnim;
}

simulated event ReplicatedEvent(name VarName){}
function bool Init(XGUnit kUnit, ESingleAnim eAnim, optional Vector InDest=vect(0.0,0.0,0.0), optional float InDist=0.0, optional Actor inActor=none){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool CanBePerformed(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
simulated function bool DoLookAt(){}
function bool DoResponseAction(){}
simulated function XGUnit ResponseActor(optional bool bSkipStrangle=false){}
simulated function string GetDebugHangLog(){}

simulated state Executing{
    simulated event Tick(float fDeltaTime){}
}

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
    m_bShouldUpdateOvermind=true
}