class XGAIBehavior_Elder extends XGAIBehavior_Psi
    notplaceable
    hidecategories(Navigation);
//complete stub

const MAX_PATHING_CAP = 8;

var array<XGUnit> m_arrGuards;
var XGUnit m_kDrainTarget;
var array<XGUnit> m_arrThreats;

simulated function InitTurn(){}
function XGUnit GetDrainTarget(){}function int GetPrimaryAttackType(){}
simulated function float GetMaxEngageRange(){}
simulated function float GetMinEngageRange(){}
simulated function Vector GetPodRevealMoveToLocation(XGUnit kTarget){}
function float GetMaxPathDistanceConstraint(float fDefaultLength){}
simulated function OnGuardDeath(XGUnit kGuard){}
simulated function bool UpdateThreats(){}
function bool CanHitAoETarget(out aoe_target kTarget){}
simulated function XGUnit FindDrainTarget(){}
simulated function FilterAbilities(out array<XGAbility> arrAbilities, optional bool bLastResort){}
function bool HasCustomMoveOption(){}
function EnterCustomMoveState(){}
function Vector FindBestElderLocationAlongPath(Vector vDestination, XGUnit kTargetToView){}
function Vector GetPointAwayFromEnemy(XGUnit kEnemy, float fDist){}
