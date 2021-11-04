class XGAction_FlightToggled extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_FlightToggled
{
    var bool m_bFlightToggle;
    var Vector m_vGroundHitLoc;
    var bool m_ForceReplication;
};

var repnotify InitialReplicationData_XGAction_FlightToggled m_kInitialReplicationData_XGAction_FlightToggled;
var bool m_bInitialReplicationDataReceived_XGAction_FlightToggled;
var bool m_bFlightToggle;
var Vector m_vGroundHitLoc;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_FlightToggled;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit, bool bFlightToggle, Vector vGroundHitLoc){}
simulated event SimulatedInit(){}
simulated function bool CanBePerformed(){}

simulated state Executing
{
    simulated event Tick(float fDeltaT){}
}

