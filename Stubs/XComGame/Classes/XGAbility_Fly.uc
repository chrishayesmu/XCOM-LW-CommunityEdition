class XGAbility_Fly extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

const FLIGHT_CHECK_DISTANCE_BELOW_UNIT = -1024.0f;

var XComPathingPawn PathingPawn;
var Vector vTargetLocation;

function ShotInit(int iAbility, array<XGUnit> arrTargets, XGWeapon kWeapon, optional bool bReactionFire=false){}
native function bool InternalCheckAvailable();
simulated event bool CheckCanLand(){}
simulated function ApplyEffect(){}
function ApplyCost(){}
