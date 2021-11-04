class XGAction_Close extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct native InitialReplicationData_XGAction_Close
{
    var bool m_bOpen;
    var bool m_bForceReplicate;
};

var bool m_bOpen;
var bool m_bInitialReplicationDataReceived_XGAction_Close;
var repnotify InitialReplicationData_XGAction_Close m_kInitialReplicationData_XGAction_Close;
var transient AnimNodeSequence m_TmpNode;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Close;
}

simulated event ReplicatedEvent(name VarName){super.ReplicatedEvent(VarName);}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, optional bool bClose=true){}
function bool CanBePerformed(){}

simulated state Executing
{
}
