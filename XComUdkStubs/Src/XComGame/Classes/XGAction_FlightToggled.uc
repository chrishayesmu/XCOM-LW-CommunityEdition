class XGAction_FlightToggled extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_FlightToggled
{
    var bool m_bFlightToggle;
    var Vector m_vGroundHitLoc;
    var bool m_ForceReplication;
};

var private repnotify InitialReplicationData_XGAction_FlightToggled m_kInitialReplicationData_XGAction_FlightToggled;
var private bool m_bInitialReplicationDataReceived_XGAction_FlightToggled;
var bool m_bFlightToggle;
var Vector m_vGroundHitLoc;

defaultproperties
{
    m_bBlocksInput=true
    m_bConstantCombat=true
}