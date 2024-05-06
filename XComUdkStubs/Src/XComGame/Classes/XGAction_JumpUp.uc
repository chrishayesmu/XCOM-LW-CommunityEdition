class XGAction_JumpUp extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_JumpUp
{
    var Vector m_vDestination;
    var float m_fDistance;
    var bool m_ForceReplication;
};

var Vector m_vDestination;
var float m_fDistance;
var float fPawnHalfHeight;
var int StartAnim;
var int StopAnim;
var bool bUpdateZ;
var private bool m_bInitialReplicationDataReceived_XGAction_JumpUp;
var private repnotify InitialReplicationData_XGAction_JumpUp m_kInitialReplicationData_XGAction_JumpUp;
var AnimNodeSequence ActiveAnimSeq;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}