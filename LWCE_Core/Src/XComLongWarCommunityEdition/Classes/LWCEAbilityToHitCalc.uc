class LWCEAbilityToHitCalc extends Object
    abstract;

function ApplyToAbilityBreakdown(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, LWCEAbilityUsageSummary kAbilityBreakdown);

function int GetFinalCritChance(LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kAbilityBreakdown);
function int GetFinalHitChance(LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kAbilityBreakdown);