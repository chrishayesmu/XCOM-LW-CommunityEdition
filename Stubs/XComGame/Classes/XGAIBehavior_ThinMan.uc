class XGAIBehavior_ThinMan extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

var array<XGUnit> m_arrValidPlagueTargets;

function bool CanHitAoETarget(out aoe_target kTarget){}
simulated function bool HasCustomAbilityValidityCheck(){}
simulated function bool IsAbilityValid(XGAbility kAbility){}
function Vector GetSingleTargetPlagueLocation(){}
simulated function SelectFireMode(XGAction_FireImmediate kFireAction, XGAbility_Targeted kAbility){}
simulated function PostBuildAbilities(){}
function UpdateValidPlagueTargets(){}
function bool CanAoEHit(array<XGUnit> arrTargetList, int iAbilityType){}
function bool PrefersLowCover(){}
