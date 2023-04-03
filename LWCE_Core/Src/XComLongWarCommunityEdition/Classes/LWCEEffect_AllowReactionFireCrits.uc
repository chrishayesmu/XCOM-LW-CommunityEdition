class LWCEEffect_AllowReactionFireCrits extends LWCEEffect_Persistent;

function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown)
{
    kBreakdown.bPreventCrit = false;
}