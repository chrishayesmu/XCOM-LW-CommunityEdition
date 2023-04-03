class LWCEEffect_Ranger extends LWCEEffect_Persistent;

var config float fRangerDamageBonusPrimary;
var config float fRangerDamageBonusSidearm;

function float GetModifiedDamageModifierAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, bool bIsHit, bool bIsCrit, LWCEEffect kAbilityEffect, float fBaseDamage, float fCurrentDamage)
{
    local LWCEWeaponTemplate kWeaponTemplate;

    kWeaponTemplate = kAbility.GetWeaponTemplate();
    `LWCE_LOG_CLS("LWCEEffect_Ranger.GetModifiedDamageModifierAsAttacker: kWeaponTemplate = " $ kWeaponTemplate);

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

function GetToHitModifiersAsAttacker(LWCE_XGUnit kAttacker, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out LWCEAbilityUsageSummary kBreakdown)
{
    // TODO: if firing pistol, look for range penalty and remove it from the breakdown
}

defaultproperties
{
    EffectName="Ranger"
    DuplicateResponse=eDupe_Ignore
}