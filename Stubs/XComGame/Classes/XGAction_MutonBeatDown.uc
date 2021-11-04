class XGAction_MutonBeatDown extends XGAction_MatineeControlled
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_MutonBeatDown
{
    var int m_iDamage;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
};

var int m_iDamage;
var XGUnit m_kTargetedEnemy;
var private repnotify InitialReplicationData_XGAction_MutonBeatDown m_kInitialReplicationData_XGAction_MutonBeatDown;
var private bool m_bInitialReplicationDataReceived_XGAction_MutonBeatDown;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_MutonBeatDown;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function Init_MutonBeatDown(XGUnit kMuton, int iDamage, XGUnit kTargetedEnemy){}
simulated function RestorePawnFromMatineeControl(){}
simulated function SetUpPawnForMatineeControl(){}

