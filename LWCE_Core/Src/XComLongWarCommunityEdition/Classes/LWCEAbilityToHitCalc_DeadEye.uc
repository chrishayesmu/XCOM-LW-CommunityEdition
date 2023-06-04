class LWCEAbilityToHitCalc_DeadEye extends LWCEAbilityToHitCalc;

function ApplyToAbilityBreakdown(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, LWCEAbilityUsageSummary kAbilityBreakdown)
{
    kAbilityBreakdown.bForceHit = true;
}

function int GetFinalHitChance(LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kAbilityBreakdown)
{
    return 100;
}