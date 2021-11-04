class XGAIBehavior_Sectopod extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

var bool m_bHasAoETarget;
var bool m_bTargetSet;

simulated function bool ShouldFlee(){}
function int GetPrimaryAttackType(){}
simulated function FilterAbilities(out array<XGAbility> arrAbilities, optional bool bLastResort){}
function bool CanHitAoETarget(out aoe_target kTarget){}
simulated function bool HasValidAoETarget(){}
simulated function InitPredeterminedAbility(XGAbility kAbility){}
simulated function SelectFireMode(XGAction_FireImmediate kFireAction, XGAbility_Targeted kAbility){}
function XGUnit GetValidClusterBombTarget(){}
simulated function Vector SectopodDecideNextDestination(){}
simulated function bool MoveUnit(){}
simulated function bool HasMaxRepairsThisTurn(){}
simulated function bool IsAcceptableTeamAttackAbility(XGAbility kAbility){}
