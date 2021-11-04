class XGAction_ChryssalidBite extends XGAction_MatineeControlled
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_ChryssalidBite
{
    var int m_iDamage;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
};

var int m_iDamage;
var XGUnit m_kTargetedEnemy;
var private repnotify InitialReplicationData_XGAction_ChryssalidBite m_kInitialReplicationData_XGAction_ChryssalidBite;
var private bool m_bInitialReplicationDataReceived_XGAction_ChryssalidBite;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_ChryssalidBite;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function Init_ChryssalidBite(XGUnit kChryssalid, int iDamage, XGUnit kTargetedEnemy){}
simulated function RestorePawnFromMatineeControl(){}
