class XGAction_ChryssalidBirth_Alien extends XGAction_MatineeControlled;
//complete stub

enum eBirthActionStatus
{
    eBAS_None,
    eBAS_WaitForVictimAnimation,
    eBAS_WaitForGlamCam,
    eBAS_Completed,
    eBAS_MAX
};

struct InitialReplicationData_XGAction_ChryssalidBirth_Alien
{
    var XGUnit m_kHatchedFrom;
    var bool m_bHatchedFromNone;
};

var XGUnit m_kHatchedFrom;
var bool m_bGlamCamSuccess;
var private bool m_bInitialReplicationDataReceived_XGAction_ChryssalidBirth_Alien;
var eBirthActionStatus m_eBirthActionStatus;
var private repnotify InitialReplicationData_XGAction_ChryssalidBirth_Alien m_kInitialReplicationData_XGAction_ChryssalidBirth_Alien;

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function Init_ChryssalidBirth_Alien(XGUnit kChryssalid, XGUnit kHatchedFrom){}
simulated function string GetDebugHangLog(){}
simulated function SetUnitVisible(){}

simulated state Executing{}
