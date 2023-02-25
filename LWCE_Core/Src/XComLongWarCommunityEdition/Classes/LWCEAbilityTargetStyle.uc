class LWCEAbilityTargetStyle extends Object
    abstract;

function GatherTargets(const LWCE_XGAbility kAbility, out array<LWCE_TAvailableTarget> arrTargets);

function bool IsFreeAiming(const LWCE_XGAbility kAbility);

protected function bool IsUniversallyIgnored(const XGUnit kUnit)
{
    return class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit);
}