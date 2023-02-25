class LWCEAbilityTargetStyle_Single extends LWCEAbilityTargetStyle;

var bool bIncludeSelf;

function GatherTargets(const LWCE_XGAbility kAbility, out array<LWCE_TAvailableTarget> arrTargets)
{
    local LWCE_TAvailableTarget kLWCE_TAvailableTarget, kEmptyLWCE_TAvailableTarget;
    local LWCE_XGUnit kAbilityOwner;
    local XGUnit kPotentialTarget;

    arrTargets.Length = 0;
    kAbilityOwner = LWCE_XGUnit(kAbility.m_kUnit);

    foreach kAbilityOwner.AllActors(class'XGUnit', kPotentialTarget)
    {
        if (!bIncludeSelf && kPotentialTarget == kAbilityOwner)
        {
            continue;
        }

        if (IsUniversallyIgnored(kPotentialTarget))
        {
            continue;
        }

        // TODO: account for abilities with AoE and populate AdditionalTargets

        kLWCE_TAvailableTarget = kEmptyLWCE_TAvailableTarget;
        kLWCE_TAvailableTarget.kPrimaryTarget = LWCE_XGUnit(kPotentialTarget);

        arrTargets.AddItem(kLWCE_TAvailableTarget);
    }
}

function bool IsFreeAiming(const LWCE_XGAbility kAbility)
{
    return false;
}