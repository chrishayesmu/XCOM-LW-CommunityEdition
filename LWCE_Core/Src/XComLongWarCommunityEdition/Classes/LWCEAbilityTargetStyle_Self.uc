class LWCEAbilityTargetStyle_Self extends LWCEAbilityTargetStyle;

function GatherTargets(const LWCE_XGAbility kAbility, out array<LWCE_TAvailableTarget> arrTargets)
{
    local LWCE_TAvailableTarget kTarget;

    kTarget.kPrimaryTarget = LWCE_XGUnit(kAbility.m_kUnit);
    arrTargets.AddItem(kTarget);
}