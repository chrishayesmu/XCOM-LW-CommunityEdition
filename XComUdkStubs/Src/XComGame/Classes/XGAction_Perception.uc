class XGAction_Perception extends XGAction
    notplaceable
    hidecategories(Navigation);

enum eWaitStatus
{
    eWS_Begin_CameraWait,
    eWS_Pause,
    eWS_ReactAnim,
    eWS_Done,
    eWS_MAX
};

var protected Vector m_vPerceptionLoc;
var protected float m_fPauseTime;
var protected Vector vLookAt;
var protected transient DynamicSMActor_Spawnable VisualizerActor;
var protected transient AnimNodeSequence m_TmpNode;
var protected int m_tempMovementNodeIndex;
var name m_nmAnim;
var eWaitStatus m_eWaitStatus;

defaultproperties
{
    m_bBlocksInput=true
}