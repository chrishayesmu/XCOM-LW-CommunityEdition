class XGAction_ZombieGetUp extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_ZombieGetUp
{
    var XGUnit m_kSpawnedFrom;
    var bool m_bSpawnedFromNone;
};

var transient AnimNodeSequence tmpAnimSequence;
var XGUnit m_kSpawnedFrom;
var private repnotify InitialReplicationData_XGAction_ZombieGetUp m_kInitialReplicationData_XGAction_ZombieGetUp;
var private bool m_bInitialReplicationDataReceived_XGAction_ZombieGetUp;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_ZombieGetUp;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function Init_Zombie_GetUp(XGUnit kUnit, XGUnit kSpawnedFrom){}
simulated function bool CanBePerformed(){}

simulated state Executing
{}