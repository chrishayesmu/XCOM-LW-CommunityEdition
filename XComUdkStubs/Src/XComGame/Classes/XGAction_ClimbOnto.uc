class XGAction_ClimbOnto extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_ClimbOnto
{
    var Vector m_vDestination;
    var float m_fDistance;
    var bool m_ForceReplication;
};

var Vector m_vDestination;
var float m_fDistance;
var Vector m_vDirection;
var AnimNodeSequence m_SeqToFinish;
var float m_fTemp;
var float m_fTemp2;
var private repnotify InitialReplicationData_XGAction_ClimbOnto m_kInitialReplicationData_XGAction_ClimbOnto;
var private bool m_bInitialReplicationDataReceived_XGAction_ClimbOnto;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}