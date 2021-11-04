class XGAbility_Launch extends XGAbility_Targeted
    native(Core);
//complete stub

var Vector m_vDestination;
var XComPathingPawn PathingPawn;

simulated event ReplicatedEvent(name VarName){}
native function bool InternalCheckAvailable();
simulated function ApplyEffect(){}
simulated function SetDestination(Vector vDestination){}
simulated function DrawDestination();
