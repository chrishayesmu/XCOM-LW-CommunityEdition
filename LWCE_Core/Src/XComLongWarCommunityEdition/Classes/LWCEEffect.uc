class LWCEEffect extends Object
    abstract;

var array<LWCECondition> TargetConditions;
var bool bApplyOnHit;
var bool bApplyOnMiss;

/// <summary>
/// Applies this effect to a target. Note that most effects should not deal damage directly here. For persistent effects, their damage mods will
/// be accounted for using the various hooks in LWCEEffect_Persistent.
/// </summary>
function name ApplyEffect(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility, optional out LWCE_TAbilityResult kResult) { return 'AA_Success'; }

/// <summary>
/// Apply this effect to the ability breakdown. Persistent effects should not generally add hit or crit mods here, as that will be handled by the LWCEAbilityToHitCalc
/// for the ability, using the special hooks in LWCEEffect_Persistent. One exception is setting the bForceHit/bPreventHit/etc flags in the ability breakdown.
/// </summary>
function ApplyToAbilityBreakdown(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, bool bIsHit, optional out LWCEAbilityUsageSummary kAbilityBreakdown);

/// <summary>
/// Get a preview for the damage this effect will do if used on the given target.
/// </summary>
function LWCE_TDamagePreview GetDamagePreview(LWCE_XGAbility kAbility, LWCE_XGUnit kSource, LWCE_XGUnit kTarget, out LWCE_TAbilityResult kAbilityResult);

defaultproperties
{
    bApplyOnHit=true
    bApplyOnMiss=false
}