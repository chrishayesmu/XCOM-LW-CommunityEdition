class LWCEEffect_Executioner extends LWCEEffect_Persistent;

var config int iExecutionerAimBonus;
var config int iExecutionerCritChanceBonus;
var config int iExecutionerHealthPercentageThreshold;

function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown)
{
    local float fHealthPercent;

    // Executioner only applies to weapon attacks
    if (kAbility.GetWeaponTemplate() == none)
    {
        return;
    }

    fHealthPercent = kTarget.m_aCurrentStats[eStat_HP] / float(kTarget.LWCE_GetCharacter().GetCharacter().aStats[eStat_HP] + kTarget.m_aInventoryStats[eStat_HP]);

    if (fHealthPercent <= (iExecutionerHealthPercentageThreshold / 100.0))
    {
        kBreakdown.AddHitChanceMod(EffectName, FriendlyName, iExecutionerAimBonus);
        kBreakdown.AddCritChanceMod(EffectName, FriendlyName, iExecutionerCritChanceBonus);
    }
}

defaultproperties
{
    EffectName="Executioner"
    DuplicateResponse=eDupe_Ignore
}