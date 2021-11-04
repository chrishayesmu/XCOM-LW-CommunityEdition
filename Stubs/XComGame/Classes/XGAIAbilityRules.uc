class XGAIAbilityRules extends Actor
    notplaceable
    hidecategories(Navigation)
dependson(XGTacticalGameCoreData);

//complete stub

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

function string GetConditionString(int bsCondition){}
function BuildConditions(){}
function BuildScores(){}
function int UpdateConditions(XGAIBehavior kBehavior){}
function Init(){}
function ScoreAbility(EAbility iAbility, optional float fOS=-999.0, optional float fDS=-999.0, optional float fIS=-999.0){}
function bool HasCustomOffenseScore(int iAbility){}
function bool HasCustomDefenseScore(int iAbility){}
function bool HasCustomIntangiblesScore(int iAbility){}
function float GetOffenseScore(int iAbility){}
function float GetDefenseScore(int iAbility){}
function float GetIntangiblesScore(int iAbility){}
function bool HasRequirements(int iAb){}
function bool PassesRequirements(int iAbility, int iCurrentConditions, out string strDebugFailure){}
function bool HasRestrictions(int iAb){}
function bool PassesRestrictions(int iAbility, int iCurrentConditions, out string strDebugFailures){}
function SetAbilityRequirement(EAbility eAb, int bsCondition){}
function SetAbilityRestriction(EAbility eAb, int bsCondition){}
function bool MeetsRequirement(int iIdx, int bsCondition, out string strCondition){}
function bool HasRestriction(int iIdx, int bsCondition){}
function bool IsValidOption(XGAbility kAbility, XGUnit kUnit, out string strDebugFailure){}
