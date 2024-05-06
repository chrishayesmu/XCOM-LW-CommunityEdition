class XGAction_RMA_ActionAnim extends XGAction
    notplaceable
    hidecategories(Navigation);

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
var XGAction_RMA_ActionAnim.eRMAWaitStatus m_eWaitStatus;
var XGCameraView_Cinematic m_kActionView;
var Vector Destination;
var float Distance;
var Actor AssociatedActor;
var protected Vector vLookAt;
var XGUnit m_kResponder;
var bool m_bOnLookAt;
var bool bWasInCover;
var private bool m_bInitialReplicationDataReceived_XGAction_RMA_ActionAnim;
var float WaitForCameraTimer;
var private repnotify repretry InitialReplicationData_XGAction_RMA_ActionAnim m_kInitialReplicationData_XGAction_RMA_ActionAnim;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
    m_bShouldUpdateOvermind=true
}