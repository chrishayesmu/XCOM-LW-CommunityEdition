class XGAIAbilityDM extends Actor;
//complete stub

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
var XGTacticalGameCoreData.EAbility m_eLastUsedAbility;
var XGUnit m_kAttackTarget;
var array<int> m_arrFailures;
var XGAIAbilityRules m_kRules;
var int m_iConditions;

function int UpdatePriority(XGAbility kAbility, out string strAbilities){}
function float AI_GetScoreModifier(XGAbility kAbility){}
function XGAbility_Targeted GetBestShot(out int iBestHitChance){}
function bool IsSuppressValid(XGAbility kAbility){}
function bool IsMindMergeValid(XGAbility kAbility, optional out string strDebugFailure){}
function bool AI_IsValidOption(XGAbility kAbility, optional out string strDebugFailure){}
function string AI_GetDbgTxt(XGAbility kAbility){}
function int AI_GetScore(XGAbility kAbility, out string strAbilities){}
function float GetLowHPBonus(XGAbility_Targeted kAbility){}
function float GetBaseShotOffenseScore(XGAbility kAbility){}
function float GetBaseShotDefenseScore(XGAbility kAbility){}
function float GetBaseShotIntangiblesScore(XGAbility kAbility){}
function float AI_OffenseScore(XGAbility kAbility){}
function float AI_DefenseScore(XGAbility kAbility){}
function float AI_IntangiblesScore(XGAbility kAbility, float fOS, float fDS){}
function bool IsWeaponAbility(optional XGAbility kAbility=m_kAbility){}
function bool IsMoveAbility(){}
function bool IsLaunchAbility(){}
function XGWeapon GetWeapon(){}
function XGUnit GetTarget(){}
function InitTurn(XGUnit kUnit){}
function AddFailedAbility(){}
function PerformGreaterMindMerge(){}
function XGAbility GetBestAbilityOption(int iAbilityType, optional XGUnit kTarget=none){}
function bool InitPredeterminedAbility(out string strDebug){}
function bool IsBetterShotOption(XGAbility_Targeted kAbility, XGAbility_Targeted kBestSoFar){}
function UpdateTopShotOption(optional XGAbility kAbility=none){}
function PrepAbility(out XGAbility kAbility){}
function InitAbilities(optional bool bDisableTeamAttack=false){}
function RebuildAbilityList(optional bool bResetStrings=true){}
function bool HasShotAbility(){}
function UseShotAbility(string strReason){}
function XGAbility RefreshAbility(){}
function bool UseLastResortAbility(string strReason){}
function DrawDebugLabel(Canvas kCanvas, out Vector vScreenPos){}
function bool IsValidAbility(){}
function int GetTopAbilityOption(int iType, optional bool bCivilian=false){}
function RemoveAbilityString(string kSubstring){}
function RemoveStandardShots(){}
function AddAbilityOption(XGAbility kAbility, optional bool bForcePriority=false, optional out string strDebugFailure){}
function ReplaceAbilityOption(int iAbilityIdx, XGAbility kAbility){}
function SelectAbility(){}
function UpdateAbilityDisplay(ability_data kAbility){}
function bool HasShotOn(XGUnit kDesiredTarget){}
function bool PassesFlankingFilter(XGAbility kAbility, out string strDebugFailures){}
function bool PassesMovementFilter(XGAbility kAbility, out string strDebugFailure){}
function bool PassesManeuverFilter(XGAbility kAbility){}
function bool IsCivilian(XGUnit kTarget){}
function bool PassesShotFilter(XGAbility kAbility, out string strDebugFailure){}
function InvalidateMovement(){}
function bool HasCheatOverride(optional XGAbility kAbility=none){}
function XGAbility_Targeted GetCheatOverrideAbility(){}
function bool HasCheatOverrideDisable(optional XGAbility kAbility=none){}
function bool AddOrFilterAbility(XGAbility kAbility, out string strDebugFailure, optional bool bDisableTeamAttack){}
function bool PassesTeamAttackSuppress(XGAbility kAbility){}
function bool PassesGrenadeFilter(XGAbility kAbility, XGUnit kTarget){}
function bool PassesTeamAttackFlanker(XGAbility kAbility){}
function bool AddOrFilterTeamAttackAbilities(XGAbility kAbility, out string strDebugFailure){}
function bool IsDefensiveAbility(){}
function XGAbility_Targeted GetTargetedAbility(){}
function Execute(){}
