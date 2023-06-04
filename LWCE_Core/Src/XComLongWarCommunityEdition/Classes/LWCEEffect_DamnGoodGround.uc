class LWCEEffect_DamnGoodGround extends LWCEEffect_Persistent;

var config int iAimBonus;
var config int iDefenseBonus;

function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kBreakdown)
{
    // Only applies to weapon attacks
    if (kAbility.GetWeaponTemplate() == none)
    {
        return;
    }

    if (kAttacker.HasHeightAdvantageOver(kTarget))
    {
        kBreakdown.AddHitChanceMod(EffectName, FriendlyName, iAimBonus);
    }
}

function GetToHitModifiersAsDefender(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kBreakdown)
{
    // Only applies to weapon attacks
    if (kAbility.GetWeaponTemplate() == none)
    {
        return;
    }

    if (kTarget.HasHeightAdvantageOver(kAttacker))
    {
        kBreakdown.AddHitChanceMod(EffectName, FriendlyName, -1 * iDefenseBonus);
    }
}

defaultproperties
{
    EffectName="DamnGoodGround"
    DuplicateResponse=eDupe_Ignore
}