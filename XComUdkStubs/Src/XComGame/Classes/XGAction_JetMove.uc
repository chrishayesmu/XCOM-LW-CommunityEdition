class XGAction_JetMove extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_JetMove
{
    var bool m_bCanAscend;
    var int m_iWholeLoops;
    var bool m_bHalfLoop;
    var bool m_bAscend;
    var bool m_bForceReplication;
};

var private XComAnimNodeBlendByAction.EAnimAction m_eAnimationBegin;
var private XComAnimNodeBlendByAction.EAnimAction m_eAnimationLoop;
var private XComAnimNodeBlendByAction.EAnimAction m_eAnimationEnd;
var private bool m_bCanAscend;
var private bool m_bHalfLoop;
var private bool m_bAscend;
var private bool m_bInitialReplicationDataReceived_XGAction_JetMove;
var private int m_iAnimsLooped;
var private int m_iWholeLoops;
var private AnimNodeSequence TempNode;
var private repnotify InitialReplicationData_XGAction_JetMove m_kInitialReplicationData_XGAction_JetMove;

defaultproperties
{
    m_iWholeLoops=1
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
}