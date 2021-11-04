class XGAIBehavior_ExaltMedic extends XGAIBehavior_Exalt
    notplaceable
    hidecategories(Navigation);
//complete stub

const REGEN_PHEROMONE_LOCATION_BUMP = 100;
const MIN_HEAL_ENEMY_DISTANCE = 384;
const MIN_SELF_HEAL_ENEMY_DISTANCE = 768.0f;

struct teammate_vulnerability
{
    var XGUnit kUnit;
    var int iScore;

};

struct smoke_target
{
    var bool bValid;
    var Vector vTargetLoc;
    var array<teammate_vulnerability> kTargets;
    var int iScore;

};

var smoke_target m_kSmokeTarget;
//var delegate<DecreasingScoreSort> __DecreasingScoreSort__Delegate;

delegate int DecreasingScoreSort(teammate_vulnerability kA, teammate_vulnerability kB){}
function bool IsMovingToAttack(){}
function int GetMinMoveDistance(){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}
simulated function bool HasValidManeuver(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
function bool IsBetterLocation(Vector vNewLoc, XComCoverPoint kNewCover){}
function PreMarkTurnStartedInit(){}
simulated function PostBuildAbilities(){}
function UpdateSmokeTargets(){}
function int CalcAvgEnemyHitDamage(){}
function int ScoreVulnerability(XGUnit kUnit, int iAvgDamage){}
function bool ScoreTeamVulnerability(out array<teammate_vulnerability> arrVul){}
function float GetSmokeDimensions(out float fRadius, out float fHeight){}
function RemoveFurthestTargetFromList(out array<XGUnit> arrTargets){}
function FindSmokeBombDestination(array<teammate_vulnerability> arrVul, out smoke_target kSmokeTarget_out){}
function Vector AdjustDestForEnemyVectors(Vector vDest, const out array<XGUnit> arrEnemies, float fSmokeRadius){}
function FillSmokeTargetInfo(out smoke_target kTarget, const out array<XGUnit> arrTargets, const out array<teammate_vulnerability> arrVul, Vector vDest){}
function int GetAccumulatedVulScore(const array<XGUnit> arrTargets, array<teammate_vulnerability> arrVul, out array<teammate_vulnerability> arrVulTargets){}
