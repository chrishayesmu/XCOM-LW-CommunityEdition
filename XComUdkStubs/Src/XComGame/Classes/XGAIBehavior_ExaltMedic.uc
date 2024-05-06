class XGAIBehavior_ExaltMedic extends XGAIBehavior_Exalt
    notplaceable
    hidecategories(Navigation);

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

delegate int DecreasingScoreSort(teammate_vulnerability kA, teammate_vulnerability kB)
{
}