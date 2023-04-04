class LWCEEffect_Executioner extends LWCEEffect_Persistent;

var config int iAimBonus;
var config int iCritChanceBonus;
var config int iHealthPercentageThreshold;

function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown)
{
    local float fHealthPercent;

    // Executioner only applies to weapon attacks
    if (kAbility.GetWeaponTemplate() == none)
    {
        return;
    }

    fHealthPercent = kTarget.m_aCurrentStats[eStat_HP] / float(kTarget.LWCE_GetCharacter().GetCharacter().aStats[eStat_HP] + kTarget.m_aInventoryStats[eStat_HP]);

    if (fHealthPercent <= (iHealthPercentageThreshold / 100.0))
    {
        kBreakdown.AddHitChanceMod(EffectName, FriendlyName, iAimBonus);
        kBreakdown.AddCritChanceMod(EffectName, FriendlyName, iCritChanceBonus);
    }
}

defaultproperties
{
    EffectName="Executioner"
    DuplicateResponse=eDupe_Ignore
}