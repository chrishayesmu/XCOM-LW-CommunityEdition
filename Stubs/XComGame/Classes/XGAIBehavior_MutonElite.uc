class XGAIBehavior_MutonElite extends XGAIBehavior_Muton
    notplaceable
    hidecategories(Navigation);

simulated function InitTurn(){}
function UpdateDefended(){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
