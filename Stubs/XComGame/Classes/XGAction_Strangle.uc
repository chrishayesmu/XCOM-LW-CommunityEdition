class XGAction_Strangle extends XGAction
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_Strangle
{
    var XGUnit m_kTarget;
    var XGAbility_Targeted m_kAbility;
};

var XGUnit m_kTarget;
var Vector m_vAttackDir;
var XGAbility_Targeted m_kAbility;
var Vector m_vLookAt;
var repnotify InitialReplicationData_XGAction_Strangle m_kInitialReplicationData_XGAction_Strangle;
var bool m_bInitialReplicationDataReceived_XGAction_Strangle;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Strangle;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function Init(XGAbility_Targeted kAbility){}
simulated event SimulatedInit(){}
simulated function UpdateAttackDir(){}
simulated function RemoveCameraLookat(){}

auto state Idle
{
}
simulated state Executing
{
}
