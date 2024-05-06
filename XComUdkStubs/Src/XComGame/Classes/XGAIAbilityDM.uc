class XGAIAbilityDM extends Actor
    notplaceable
    hidecategories(Navigation);

const MAX_HIT_CHANCE_FOR_SUPPRESS = 50;

struct ability_data
{
    var XGAbility kAbility;
    var int iPriority;
    var string strDebug;
};

var XGUnit m_kUnit;
var XGAIPlayer m_kPlayer;
var XGAIBehavior m_kBehavior;
var array<ability_data> m_arrAbilityList;
var array<string> m_strAbilities;
var int m_iTotalPriority;
var XGAbility_Targeted m_kShotAbility;
var XGAbility m_kAbility;
var int m_nAbilities;
var bool m_bHasPredeterminedAbility;
var bool m_bShouldAvoidMovement;
var bool m_bHasStrongAttack;
var EAbility m_eLastUsedAbility;
var XGUnit m_kAttackTarget;
var array<int> m_arrFailures;
var XGAIAbilityRules m_kRules;
var int m_iConditions;