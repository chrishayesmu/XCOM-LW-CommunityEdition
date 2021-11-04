class XGAIBehavior_Sectoid extends XGAIBehavior_Psi;
//complete stub

simulated function float GetMaxEngageRange(){}
simulated function float GetMinEngageRange(){}
function bool ShouldKeepHidden(){}
simulated function bool GetFleeLocation(out Vector vCover, XGUnit kEnemy, optional bool bInternal, optional out string strFail){}
simulated function OnUnitEndTurn(){}
function bool PrefersLowCover(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
function ExecuteAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
function bool HasUnshieldedMechtoidsInView(){}
function bool CanSeeUnshieldedMechtoidsFrom(Vector vLoc){}
function bool IsBetterLocation(Vector vNewLoc, XComCoverPoint kNewCover){}
