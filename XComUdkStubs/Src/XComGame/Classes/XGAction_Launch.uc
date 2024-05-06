class XGAction_Launch extends XGAction_Move_Direct
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_Launch
{
    var XGAbility_Launch m_kLaunchAbility;
};

var private XComAnimNodeBlendByAction.EAnimAction m_eAnimation[3];
var private int m_iAnimsLooped;
var private int m_iWholeLoops;
var private int m_iCount;
var private int m_iAnim;
var private bool m_bLaunchComplete;
var private bool m_bInitialReplicationDataReceived_XGAction_Launch;
var bool m_bAddedLookat;
var bool m_bLaunchInitialized;
var Vector m_vTeleportHeight;
var float m_fDistToGround;
var private repnotify InitialReplicationData_XGAction_Launch m_kInitialReplicationData_XGAction_Launch;
var XGAbility_Launch m_kLaunchAbility;
var Vector m_vCurrLookat;

defaultproperties
{
    m_iWholeLoops=3
    m_bReplicateFinalPawnLocation=true
}