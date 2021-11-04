class XGAbility_BullRush extends XGAbility_Targeted
    native(Core)
    notplaceable;
//complete stub

struct native ExecutionReplicationInfo_XGAbility_BullRush
{
	    var int m_iDamage;
    var XGUnit m_kUnitTarget;
    var bool m_bUnitTargetNone;
    var Actor m_kWall;
    var bool m_bWallNone;
    var Vector m_vDestination;
    var bool m_bValidDestination;
    var bool m_bForceReplicate;
};

var Vector m_vDestination;
var Actor m_kWall;
var int m_iDamage;
var XGUnit m_kUnitTarget;
var bool m_bValidDestination;
var private bool m_bExecutionReplicationInfoReceived_XGAbility_BullRush;
var private repnotify ExecutionReplicationInfo_XGAbility_BullRush m_kExecutionReplicationInfo_XGAbility_BullRush;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_bValidDestination, m_kExecutionReplicationInfo_XGAbility_BullRush;
}

simulated event ReplicatedEvent(name VarName){}

function InitBullRush(Actor kWall, XGUnit kTarget, bool bValidDestination){}
simulated function EndTurnCheck(){}
protected simulated function bool InternalIsExecutionReplicationComplete(){}
native function bool InternalCheckAvailable();
simulated function ApplyEffect(){}
simulated function SetDestination(Vector vDestination){}
simulated function DrawDestination(bool bValid);