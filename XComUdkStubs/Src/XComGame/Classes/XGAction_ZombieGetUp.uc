class XGAction_ZombieGetUp extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_ZombieGetUp
{
    var XGUnit m_kSpawnedFrom;
    var bool m_bSpawnedFromNone;
};

var transient AnimNodeSequence tmpAnimSequence;
var XGUnit m_kSpawnedFrom;
var private repnotify repretry InitialReplicationData_XGAction_ZombieGetUp m_kInitialReplicationData_XGAction_ZombieGetUp;
var private bool m_bInitialReplicationDataReceived_XGAction_ZombieGetUp;

defaultproperties
{
    m_bModal=false
}