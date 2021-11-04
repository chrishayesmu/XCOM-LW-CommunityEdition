class XGAbility_Rift extends XGAbility_GameCore
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct native ExecutionReplicationInfo_XGAbility_Rift
{
    var Vector m_spawnPoint;
};

var Vector m_spawnPoint;
var repnotify ExecutionReplicationInfo_XGAbility_Rift m_kExecutionReplicationInfo_XGAbility_Rift;
var bool m_bExecutionReplicationInfoReceived_XGAbility_Rift;
var bool bIsValid;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_kExecutionReplicationInfo_XGAbility_Rift;
}

simulated event ReplicatedEvent(name VarName){}
protected simulated function bool InternalIsExecutionReplicationComplete(){}
simulated function ApplyEffect(){}
simulated function bool IsValidRiftTarget(Vector vLocation){}
simulated function Vector GetRiftLocation(){}
simulated function bool IsRiftValid(){}
