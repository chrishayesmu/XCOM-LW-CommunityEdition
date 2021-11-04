class XGAction_Berserk extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_Berserk
{
    var XGUnit m_kIntimidateTarget;
    var bool m_bIntimidateTargetNone;
};

var transient AnimNodeSequence tmpAnimSequence;
var bool m_bGlamCamActive;
var bool m_bInitialReplicationDataReceived_XGAction_Berserk;
var XGUnit m_kIntimidateTarget;
var repnotify InitialReplicationData_XGAction_Berserk m_kInitialReplicationData_XGAction_Berserk;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Berserk;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function bool InitBerserk(XGUnit kUnit, optional XGUnit kTarget){}
simulated function bool CanBePerformed(){}

simulated state Executing
{
    simulated function int GetIntimidateAbility(){}
    simulated function DoIntimidate(){}
}