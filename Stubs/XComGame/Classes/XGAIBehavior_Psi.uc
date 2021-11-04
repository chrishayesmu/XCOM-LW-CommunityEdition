class XGAIBehavior_Psi extends XGAIBehavior;
//complete stub
var array<XGAbility_Targeted> m_arrPsiAbilities;

simulated function Init(XGUnit kUnit){}
simulated function float GetMaxEngageRange(){}
simulated function float GetMinEngageRange(){}
simulated function PostEquipInit(){}
function bool ShouldKeepHidden(){}
simulated function bool HasCustomAbilityValidityCheck(){}
simulated function OnMoveComplete(){}
simulated function bool GetFleeLocation(out Vector vCover, XGUnit kEnemy, optional bool bInternal, optional out string strFail){}
function bool HasBackupShotAbility(out XGAbility_Targeted kShot){}
function XGUnit SelectEnemyToEngage(){}
simulated function OnUnitEndTurn(){}
function AddBestPsiAbilityToList(out array<XGAbility_Targeted> arrAbilities_Out, int iType, optional bool bLowestWill){}
function XGUnit GetDrainTarget(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
