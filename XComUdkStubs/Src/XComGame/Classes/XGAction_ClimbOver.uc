class XGAction_ClimbOver extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_ClimbOver
{
    var Vector m_vDestination;
    var float m_fDistance;
    var bool m_ForceReplication;
};

var Vector m_vDestination;
var float m_fDistance;
var private repnotify InitialReplicationData_XGAction_ClimbOver m_kInitialReplicationData_XGAction_ClimbOver;
var private bool m_bInitialReplicationDataReceived_XGAction_ClimbOver;

defaultproperties
{
    m_bReplicateFinalPawnLocation=true
    m_bBlocksInput=true
    m_bModal=false
    m_bRequiresAccuratePositioning=true
}