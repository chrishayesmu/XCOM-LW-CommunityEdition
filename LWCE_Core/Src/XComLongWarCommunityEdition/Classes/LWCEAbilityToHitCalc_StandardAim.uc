class LWCEAbilityToHitCalc_StandardAim extends LWCEAbilityToHitCalc;

function int GetHitChance(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kAvailableTarget, optional out TShotInfo kShotInfo, optional out TShotResult kResult)
{
    local bool bAlwaysHit, bAlwaysMiss;
    local LWCE_XGUnit kShooter, kTarget;
    local int Index;

    // TODO: decouple the targeting from the XGAbility_Targeted class

    kShooter = LWCE_XGUnit(kAbility.m_kUnit);
    kTarget = LWCE_XGUnit(kAbility.GetPrimaryTarget());

    kAbility.m_iHitChance = 0;

    for (Index = 0; Index < 16; Index++)
    {
        kAbility.m_shotHUDHitChanceStats[Index].m_iAmount = 0;
    }

    class'LWCE_XGAbility_Extensions'.static.GetShotSummary(kAbility, kResult, kShotInfo);

    for (Index = 0; Index < kShotInfo.arrHitBonusValues.Length; Index++)
    {
        kAbility.m_iHitChance += kShotInfo.arrHitBonusValues[Index];

        // Special value: any bonus adding more than 255 aim at once guarantees a hit
        if (kShotInfo.arrHitBonusValues[Index] > 255)
        {
            bAlwaysHit = true;
        }
    }

    for (Index = 0; Index < kShotInfo.arrHitPenaltyValues.Length; Index++)
    {
        kAbility.m_iHitChance += kShotInfo.arrHitPenaltyValues[Index];

        // Same special value but for guaranteed misses
        if (kShotInfo.arrHitPenaltyValues[Index] < -255)
        {
            bAlwaysMiss = true;
        }
    }

    // Reaction fire logic is split between this and RollForHit for some reason. It would be nice to consolidate, but
    // since we clamp the hit chance in this function, that could technically result in a behavior change.
    if (kAbility.m_bReactionFire && kTarget != none && !kShooter.HasPerk(`LW_PERK_ID(Opportunist)) && !kShooter.HasPerk(`LW_PERK_ID(AdvancedFireControl)))
    {
        if (kTarget.m_bDashing)
        {
            kAbility.m_iHitChance *= `LWCE_TACCFG(fReactionFireAimMultiplierDashing);
        }
        else
        {
            kAbility.m_iHitChance *= `LWCE_TACCFG(fReactionFireAimMultiplier);
        }
    }

    if (bAlwaysHit)
    {
        kAbility.m_iHitChance = 100;
    }
    else if (bAlwaysMiss)
    {
        kAbility.m_iHitChance = 0;
    }
    else
    {
        kAbility.m_iHitChance = Clamp(kAbility.m_iHitChance, 1, 100);
    }

    kAbility.m_iHitChance_NonUnitTarget = 100;

    return kAbility.m_iHitChance;
}