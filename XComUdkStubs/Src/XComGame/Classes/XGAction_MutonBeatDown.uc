class XGAction_MutonBeatDown extends XGAction_MatineeControlled
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_MutonBeatDown
{
    var int m_iDamage;
    var XGUnit m_kTargetedEnemy;
    var bool m_bTargetedEnemyNone;
};

var int m_iDamage;
var XGUnit m_kTargetedEnemy;
var private repnotify repretry InitialReplicationData_XGAction_MutonBeatDown m_kInitialReplicationData_XGAction_MutonBeatDown;
var private bool m_bInitialReplicationDataReceived_XGAction_MutonBeatDown;

defaultproperties
{
    m_VariableLinkName="Muton"
}