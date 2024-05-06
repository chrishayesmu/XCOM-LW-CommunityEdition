class XGAction_ClimbLadder extends XGAction
    native(Action)
    nativereplication
    notplaceable
    hidecategories(Navigation);

struct native InitialReplicationData_XGAction_ClimbLadder
{
    var XComLadder m_kLadder;
    var float m_fDistance;
    var Vector StartLocation;
};

var private ESingleAnim m_eAnimationGetOn;
var private ESingleAnim m_eAnimationClimb;
var private ESingleAnim m_eAnimationGetOff;
var EDiscState eDisc;
var private XComLadder m_kLadder;
var Vector m_vSource;
var Vector m_vDestination;
var float m_fDistance;
var private Vector m_vFacing;
var private bool m_bAscending;
var private bool m_bHalfLoop;
var private bool m_bInitialReplicationDataReceived_XGAction_ClimbLadder;
var private int m_iAnimsLooped;
var private int m_iWholeLoops;
var private AnimNodeSequence TempNode;
var transient float fLadderHeight;
var private repnotify repretry InitialReplicationData_XGAction_ClimbLadder m_kInitialReplicationData_XGAction_ClimbLadder;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}