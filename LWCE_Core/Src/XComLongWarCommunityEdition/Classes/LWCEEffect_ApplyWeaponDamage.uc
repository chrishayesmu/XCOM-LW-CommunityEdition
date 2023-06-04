class LWCEEffect_ApplyWeaponDamage extends LWCEEffect
    dependson(LWCEStandardDamageCalculator, LWCEWeaponTemplate);

struct DamageModifier
{
    var LWCEStandardDamageCalculator.EOperation Op;
    var delegate<LWCEStandardDamageCalculator.CustomOperation> CustomOpFn;
    var float fValue;
};

var bool bDealEnvironmentalDamage;
var bool bDealUnitDamage;

var DamageModifier ModifyBaseEnvironmentDamage; // If set, modifies the effect's base environmental damage. The original value is taken from the weapon used.
var DamageModifier ModifyBaseWeaponDamage;      // If set, modifies the effect's base damage. The original value is taken from the weapon used.

var delegate<OverrideCalc> ModifyBaseEnvironmentDamageCalcFn; // If set, this function is used instead of the weapon's base environmental damage, and the ModifyBaseEnvironmentDamage struct is ignored.
var delegate<OverrideCalc> ModifyBaseWeaponDamageCalcFn;      // If set, this function is used instead of the weapon's base damage, and the ModifyBaseWeaponDamage struct is ignored.

delegate int OverrideCalc(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility);

function name ApplyEffect(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, optional out LWCE_TAbilityResult kResult)
{
    return 'AA_Success';
}

function ApplyToAbilityBreakdown(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, bool bIsHit, optional out LWCEAbilityUsageSummary kAbilityBreakdown)
{
    // TODO
}

function LWCE_TDamagePreview GetDamagePreview(LWCE_XGAbility kAbility, LWCE_XGUnit kSource, LWCE_XGUnit kTarget, out LWCE_TAbilityResult kAbilityResult)
{
    local LWCE_TDamagePreview kPreview;
    local delegate<LWCEWeaponTemplate.CalcBonusWeaponDamage> CalcBonusWeaponDamageFn;
    local LWCEAppliedEffect kAppliedEffect;
    local LWCE_XGWeapon kWeapon;
    local int Index;
    local float fBaseDamage, fModifiedDamage, fMaxDR, fMinDR;

    kPreview.kPrimaryTarget = kTarget;
    kWeapon = LWCE_XGWeapon(kAbility.m_kWeapon);

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview");

    if (!bDealUnitDamage)
    {
        `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview, bDealUnitDamage is false");
        return kPreview;
    }

    // ------------------------------------------------------------
    // Base damage calculations
    // ------------------------------------------------------------

    GetWeaponBaseDamage(kSource, kTarget, kAbility, fBaseDamage);
    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: fBaseDamage from weapon = " $ fBaseDamage);

    // Incorporate source unit effects to base damage
    foreach kSource.m_arrAppliedEffects(kAppliedEffect)
    {
        fBaseDamage += kAppliedEffect.m_kEffect.GetBaseDamageModifierAsAttacker(kSource, kTarget, kAbility, kAbilityResult, self, fBaseDamage);
    }

    // Incorporate target unit effects to base damage
    foreach kTarget.m_arrAppliedEffects(kAppliedEffect)
    {
        fBaseDamage += kAppliedEffect.m_kEffect.GetBaseDamageModifierAsDefender(kSource, kTarget, kAbility, kAbilityResult, self, fBaseDamage);
    }

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: fBaseDamage final = " $ fBaseDamage);

    // ------------------------------------------------------------
    // Modified damage calculations
    // ------------------------------------------------------------

    fModifiedDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage];
    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: fModifiedDamage from stats = " $ fModifiedDamage);

    // Let the weapon add any modified damage adjustments first
    // TODO let weapons modify their base damage too
    for (Index = 0; Index < kWeapon.m_kTemplate.arrBonusWeaponDamageFn.Length; Index++)
    {
        CalcBonusWeaponDamageFn = kWeapon.m_kTemplate.arrBonusWeaponDamageFn[Index];
        fModifiedDamage += CalcBonusWeaponDamageFn(kSource, kTarget, kAbility);
    }

    // Incorporate source unit effects to modified damage
    foreach kSource.m_arrAppliedEffects(kAppliedEffect)
    {
        fModifiedDamage += kAppliedEffect.m_kEffect.GetModifiedDamageModifierAsAttacker(kSource, kTarget, kAbility, kAbilityResult, self, fBaseDamage, fModifiedDamage);
    }

    // Incorporate target unit effects to modified damage
    foreach kTarget.m_arrAppliedEffects(kAppliedEffect)
    {
        fModifiedDamage += kAppliedEffect.m_kEffect.GetModifiedDamageModifierAsDefender(kSource, kTarget, kAbility, kAbilityResult, self, fBaseDamage, fModifiedDamage);
    }

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: fModifiedDamage final = " $ fModifiedDamage);

    // ------------------------------------------------------------
    // Flat damage calculations
    // ------------------------------------------------------------

    // TODO: add support for flat damage modifiers

    // Calculate the damage range based on what we have right now. Base damage can't be negative,
    // but modified damage can.
    fBaseDamage = Max(0, fBaseDamage);
    class'LWCEStandardDamageCalculator'.static.GetDamageRollRange(class'LWCE_XGAbility'.static.HitResultIsCritical(kAbilityResult), fBaseDamage, fModifiedDamage, kPreview.iMinDamage, kPreview.iMaxDamage);

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: damage roll range = " $ kPreview.iMinDamage $ ", " $ kPreview.iMaxDamage);

    // ------------------------------------------------------------
    // Damage reduction calculations
    // ------------------------------------------------------------

    // TODO: need a way that supports fractional DR in character/unit stats
    fMinDR = CalculateBaseDamageReduction(kSource, kTarget, kWeapon);
    fMaxDR = fMinDR;

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: base DR = " $ fMinDR);

    // Incorporate source unit effects to damage reduction
    foreach kSource.m_arrAppliedEffects(kAppliedEffect)
    {
        fMinDR += kAppliedEffect.m_kEffect.GetDamageReductionModifierAsAttacker(kSource, kTarget, kAbility, kAbilityResult, self, kPreview.iMinDamage, fMinDR);
        fMaxDR += kAppliedEffect.m_kEffect.GetDamageReductionModifierAsAttacker(kSource, kTarget, kAbility, kAbilityResult, self, kPreview.iMaxDamage, fMaxDR);
    }

    // Incorporate target unit effects to damage reduction
    foreach kTarget.m_arrAppliedEffects(kAppliedEffect)
    {
        fMinDR += kAppliedEffect.m_kEffect.GetDamageReductionModifierAsDefender(kSource, kTarget, kAbility, kAbilityResult, self, kPreview.iMinDamage, fMinDR);
        fMaxDR += kAppliedEffect.m_kEffect.GetDamageReductionModifierAsDefender(kSource, kTarget, kAbility, kAbilityResult, self, kPreview.iMaxDamage, fMaxDR);
    }

    fMinDR = FClamp(fMinDR, 0, kPreview.iMinDamage);
    fMaxDR = FClamp(fMaxDR, 0, kPreview.iMaxDamage);

    `LWCE_LOG_CLS("ApplyWeaponDamage: GetDamagePreview: fMinDR = " $ fMinDR $ ", fMaxDR = " $ fMaxDR);

    kPreview.iMinDamageReduction = FFloor(fMinDR);
    kPreview.iMaxDamageReduction = FCeil(fMaxDR);
    kPreview.iMinDamage -= FCeil(fMinDR); // Worst case scenario
    kPreview.iMaxDamage -= FFloor(fMaxDR); // Best case scenario

    // ------------------------------------------------------------
    // Post-DR damage effects
    // ------------------------------------------------------------

    // TODO add post-DR effects

    return kPreview;
}

protected function float CalculateBaseDamageReduction(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGWeapon kWeapon)
{
    local float fDR;

    // TODO: need a float source for DR stat
    fDR += kTarget == none ? 0.0f : float(kTarget.LWCE_GetCharacter().GetCharacter().aStats[eStat_DamageReduction]);
    fDR += kWeapon == none ? 0.0f : -1 * kWeapon.m_kTemplate.kStatChanges.fDamageReductionPenetration;

    // TODO add equipment DR pen

    // Modifiers from small items
    /*
    arrItems = kAttackingUnit.LWCE_GetCharacter().GetAllBackpackItems();

    if (kWeapon != none && !kWeapon.HasProperty(eWP_Pistol))
    {
        for (iBackpackItem = 0; iBackpackItem < arrItems.Length; iBackpackItem++)
        {
            kEquipment = LWCEEquipmentTemplate(`LWCE_ITEM(arrItems[iBackpackItem]));

            // Make sure this isn't the weapon we're firing, which is already accounted for
            if (kEquipment == kWeapon.m_kTemplate)
            {
                continue;
            }

            kEquipment.GetStatChanges(kStatChanges, kAttackingUnit.LWCE_GetCharacter().GetCharacter());
            fDR += -1 * kStatChanges.fDamageReductionPenetration;
        }
    }
*/

    if (kTarget != none && kSource != none && kTarget.IsInCover() && !kTarget.IsFlankedBy(kSource) && !kTarget.IsFlankedByLoc(kSource.Location))
    {
        if (kTarget.GetTrueCoverValue(kSource) == `LWCE_TACCFG(LOW_COVER_BONUS))
        {
            fDR += `LWCE_TACCFG(fLowCoverDRBonus);
        }
        else
        {
            fDR += `LWCE_TACCFG(fHighCoverDRBonus);
        }
    }

    return fDR;
}

protected function GetWeaponBaseDamage(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, out float fBaseDamage, optional out float fEnvironmentDamage)
{
    local LWCE_XGWeapon kWeapon;

    kWeapon = LWCE_XGWeapon(kAbility.m_kWeapon);

    fBaseDamage = kWeapon.m_kTemplate.iDamage;
    fEnvironmentDamage = kWeapon.m_kTemplate.iEnvironmentDamage;

    if (ModifyBaseWeaponDamageCalcFn != none)
    {
        fBaseDamage = ModifyBaseWeaponDamageCalcFn(kSource, kTarget, kAbility);
    }
    else
    {
        class'LWCEStandardDamageCalculator'.static.ApplyOperation(fBaseDamage, ModifyBaseWeaponDamage.fValue, ModifyBaseWeaponDamage.Op, ModifyBaseWeaponDamage.CustomOpFn);
    }

    if (ModifyBaseEnvironmentDamageCalcFn != none)
    {
        fEnvironmentDamage = ModifyBaseEnvironmentDamageCalcFn(kSource, kTarget, kAbility);
    }
    else
    {
        class'LWCEStandardDamageCalculator'.static.ApplyOperation(fEnvironmentDamage, ModifyBaseEnvironmentDamage.fValue, ModifyBaseEnvironmentDamage.Op, ModifyBaseEnvironmentDamage.CustomOpFn);
    }
}