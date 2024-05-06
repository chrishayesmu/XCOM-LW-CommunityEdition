class XGAction_Teleport extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_Teleport
{
    var Vector m_vDestination;
    var float m_fDistance;
};

var Vector m_vDestination;
var float m_fDistance;
var private repnotify InitialReplicationData_XGAction_Teleport m_kInitialReplicationData_XGAction_Teleport;
var private bool m_bInitialReplicationDataReceived_XGAction_Teleport;

defaultproperties
{
    m_bModal=false
}