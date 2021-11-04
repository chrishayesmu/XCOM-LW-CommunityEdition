class XGAIBehavior_Cyberdisc extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);
//complete stub

function AddPriorityFlightDestinations(out array<XComCoverPoint> Points){}
function bool CanAoEHit(array<XGUnit> arrTargetList, int iAbilityType){}
function bool CanDeathBlossom(optional out XGAbility_Targeted kAbility_Out){}
simulated function bool CanFly(){}
function bool GetEngageLocation(out Vector vCover, XGUnit kEnemy, optional bool bOutOfRange, optional out string strFail){}
simulated function int GetMaxFlightDuration(){}
simulated function float GetMoveOffenseScore(){}
simulated function Vector GetPodRevealMoveToLocation(XGUnit kTarget){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
function float GetReasonableAttackRange(){}
simulated function bool HasPredeterminedAbility(){}
