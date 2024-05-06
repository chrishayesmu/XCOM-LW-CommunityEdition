class XGAIAbilityRules extends Actor
    notplaceable
    hidecategories(Navigation);

const AC_SUPPRESSED = 1;
const AC_OVERWATCHED = 2;
const AC_NOT_FLANKED = 4;
const AC_ALONE = 8;
const AC_OUTNUMBERED = 16;
const AC_ABORTED_MOVE = 32;
const AC_CAN_MELEE_ATTACK = 64;
const AC_CANNOT_ATTACK = 128;
const AC_NO_OVERHEAD_CLEARANCE = 256;
const AC_TERRORIST = 512;
const SCORE_CUSTOM = -999;

struct ability_condition
{
    var EAbility EAbility;
    var int bsCondition;
};

struct ability_score
{
    var float fOS;
    var float fDS;
    var float fIS;
};

var array<ability_condition> m_arrRequirement;
var array<ability_condition> m_arrRestriction;
var array<ability_score> m_arrScore;