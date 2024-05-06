class XGAbility_Fly extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);

const FLIGHT_CHECK_DISTANCE_BELOW_UNIT = -1024.0f;

var XComPathingPawn PathingPawn;
var Vector vTargetLocation;