class XGAction_Climb extends XGAction
    notplaceable
    hidecategories(Navigation);

struct native InitialReplicationData_XGAction_Climb
{
    var float m_fDistance;
    var Vector m_vSource;
    var Vector m_vDestination;
    var bool m_bForceReplicate;
};

var private ESingleAnim m_eAnimationGetOn;
var private ESingleAnim m_eAnimationClimb;
var private ESingleAnim m_eAnimationGetOff;
var Vector m_vSource;
var Vector m_vDestination;
var float m_fDistance;
var private bool m_bAscending;
var private bool m_bInitialReplicationDataReceived_XGAction_Climb;
var private int m_iAnimsLooped;
var private int m_iWholeLoops;
var private float m_fPartialLoop;
var private AnimNodeSequence TempNode;
var private repnotify repretry InitialReplicationData_XGAction_Climb m_kInitialReplicationData_XGAction_Climb;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}