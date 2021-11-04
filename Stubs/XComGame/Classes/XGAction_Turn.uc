class XGAction_Turn extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialiReplicationData_XGAction_Turn
{
    var Vector m_vFacePoint;
    var bool m_bIgnoreMovingCursor;
    var bool m_bForceReplicate;
};

var transient Vector m_vFacePoint;
var transient Vector m_vFaceDir;
var bool m_bIgnoreMovingCursor;
var transient bool m_bInitialReplicationDataReceived_XGAction_Turn;
var repnotify transient InitialiReplicationData_XGAction_Turn m_kInitialReplicationData_XGAction_Turn;
var float m_fTurnTimer;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Turn;
}

simulated event ReplicatedEvent(name VarName){}
function bool Init(XGUnit kUnit, Vector vFaceLoc, optional bool bIgnoreMovingCursor){}
simulated event SimulatedInit(){}
simulated function bool InternalIsInitialReplicationComplete(){}

simulated state Executing
{
    simulated function bool ShouldTurn(){}
}