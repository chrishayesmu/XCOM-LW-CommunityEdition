class XGAction_Teleport extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_Teleport
{
    var Vector m_vDestination;
    var float m_fDistance;
};

var Vector m_vDestination;
var float m_fDistance;
var private repnotify InitialReplicationData_XGAction_Teleport m_kInitialReplicationData_XGAction_Teleport;
var private bool m_bInitialReplicationDataReceived_XGAction_Teleport;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Teleport;
}

simulated event ReplicationEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
function bool CanBePerformed(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
