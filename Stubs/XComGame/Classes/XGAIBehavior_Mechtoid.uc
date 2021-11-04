class XGAIBehavior_Mechtoid extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGUnit m_kLastTarget;
var bool m_bForceMoveCloser;

simulated function Vector GetPodRevealMoveToLocation(XGUnit kTarget){}
function bool GetEngageLocation(out Vector vCover, XGUnit kEnemy, optional bool bOutOfRange, optional out string strFail){}
simulated function InitTurn(){}
simulated function DoAttack(XGUnit kEnemy){}
simulated function array<XGUnit> UpdateValidTargets(array<XGUnit> arrValidTargetsList){}
simulated function bool ShouldAvoidMovement(){}
simulated function FilterAbilities(out array<XGAbility> arrAbilities, optional bool bLastResort){}
simulated function bool ShouldFlee(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function bool HasVulnerableTarget(array<XGAbility> arrAbilities, optional out XGUnit kTarget){}
