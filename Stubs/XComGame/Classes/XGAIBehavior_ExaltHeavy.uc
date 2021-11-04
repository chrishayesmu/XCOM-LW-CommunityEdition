class XGAIBehavior_ExaltHeavy extends XGAIBehavior_Exalt
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function PostBuildAbilities(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
function bool CanHitAoETarget(out aoe_target kTarget){}
function bool HasSuppressTarget(out XGAbility_Targeted kAbility_Out){}
function bool EnemyCanSeeUnitsInCapZone(XGUnit kEnemy){}
