class LWCEEffect_Ranger extends LWCEEffect_Persistent;

var config float fRangerDamageBonusPrimary;
var config float fRangerDamageBonusSidearm;

function float GetModifiedDamageModifierAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fBaseDamage, float fCurrentDamage)
{
    local LWCEWeaponTemplate kWeaponTemplate;

    kWeaponTemplate = kAbility.GetWeaponTemplate();
    `LWCE_LOG_CLS("GetModifiedDamageModifierAsAttacker: kWeaponTemplate = " $ kWeaponTemplate);

    if (!kAbilityEffect.IsA('LWCEEffect_ApplyWeaponDamage'))
    {
        `LWCE_LOG_CLS("GetModifiedDamageModifierAsAttacker: ability effect is not ApplyWeaponDamage, so not applying any bonus");
        return 0.0f;
    }

    if (kTarget == none)
    {
        // Ranger doesn't apply to area abilities
        return 0.0f;
    }

    if (kWeaponTemplate != none)
    {
        if (kWeaponTemplate.IsLarge())
        {
            return fRangerDamageBonusPrimary;
        }

        if (kWeaponTemplate.HasWeaponProperty(eWP_Pistol))
        {
            return fRangerDamageBonusSidearm;
        }
    }

    return 0.0f;
}

// When firing a pistol, look for the RangePenalty mod and remove it if present
function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown)
{
    local LWCEWeaponTemplate kWeaponTemplate;

    kWeaponTemplate = kAbility.GetWeaponTemplate();
    `LWCE_LOG_CLS("GetToHitModifiersAsAttacker called");

    if (kWeaponTemplate == none)
    {
        return;
    }

    if (!kWeaponTemplate.HasWeaponProperty(eWP_Pistol))
    {
        return;
    }

    `LWCE_LOG_CLS("GetToHitModifiersAsAttacker: removing RangePenalty mod");
    kBreakdown.RemoveHitChanceMod('RangePenalty');
}

defaultproperties
{
    EffectName="Ranger"
    DuplicateResponse=eDupe_Ignore
}