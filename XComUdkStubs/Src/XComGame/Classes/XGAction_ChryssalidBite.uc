class XGAction_ChryssalidBite extends XGAction_MatineeControlled
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_ChryssalidBite
{
    var int m_iDamage;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
};

var int m_iDamage;
var XGUnit m_kTargetedEnemy;
var private repnotify repretry InitialReplicationData_XGAction_ChryssalidBite m_kInitialReplicationData_XGAction_ChryssalidBite;
var private bool m_bInitialReplicationDataReceived_XGAction_ChryssalidBite;

defaultproperties
{
    m_VariableLinkName="Cryssalid"
}