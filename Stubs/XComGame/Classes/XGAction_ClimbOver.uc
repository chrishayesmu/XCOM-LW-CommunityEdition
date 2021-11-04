class XGAction_ClimbOver extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_ClimbOver
{
    var Vector m_vDestination;
    var float m_fDistance;
    var bool m_ForceReplication;
};

var Vector m_vDestination;
var float m_fDistance;
var repnotify InitialReplicationData_XGAction_ClimbOver m_kInitialReplicationData_XGAction_ClimbOver;
var bool m_bInitialReplicationDataReceived_XGAction_ClimbOver;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_ClimbOver;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
simulated event SimulatedInit(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
simulated function bool CanBePerformed(){}
simulated function InternalCompleteAction(){}

simulated state Executing
{
}