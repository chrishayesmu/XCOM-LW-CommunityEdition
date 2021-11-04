class XGAction_Perception extends XGAction;
//complete stub

enum eWaitStatus
{
    eWS_Begin_CameraWait,
    eWS_Pause,
    eWS_ReactAnim,
    eWS_Done,
    eWS_MAX
};

var Vector m_vPerceptionLoc;
var float m_fPauseTime;
var Vector vLookAt;
var transient DynamicSMActor_Spawnable VisualizerActor;
var transient AnimNodeSequence m_TmpNode;
var int m_tempMovementNodeIndex;
var name m_nmAnim;
var eWaitStatus m_eWaitStatus;

function bool Init(XGUnit kUnit, Vector vPerceptionLoc){}
simulated event SimulatedInit(){}
simulated function PlaySoldierResponse();
simulated function StaticMesh GetVisualizerMesh(){}
simulated function DrawPerception(Vector vLoc){}
simulated function ResetPauseTime(){}
simulated function string GetDebugHangLog(){}

simulated state Executing
{
    simulated function BeginRMA(){}
    simulated function EndRMA(){}
    simulated event EndState(name N){}
}

