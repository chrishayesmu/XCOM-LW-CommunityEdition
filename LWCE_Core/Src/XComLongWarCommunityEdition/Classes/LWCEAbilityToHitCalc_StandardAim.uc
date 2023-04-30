class LWCEAbilityToHitCalc_StandardAim extends LWCEAbilityToHitCalc;

var bool bCanCrit; // If false, crit chance for this ability is always zero.

var bool bReactionFire; // Reaction fire is less accurate (specifics depend on the movement and the target), and cannot crit. Both of these things
                        // can be modified by effects on either the source or the target of the ability.
var int iBuiltInHitMod;
var int iBuiltInCritMod;

function ApplyToAbilityBreakdown(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, LWCEAbilityUsageSummary kAbilityPreview)
{
    local LWCE_XGUnit kAttackingUnit, kTargetUnit;
    local LWCEArmorTemplate kArmor;
    local LWCEEquipmentTemplate kEquipment;
    local LWCEAppliedEffect kEffect;
    local LWCE_XGWeapon kWeapon;
    local LWCE_TCharacterStats kStatChanges;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGTacticalGameCore kGameCore;
    local array<name> arrItems;
    local int iBackpackItem, iMod;
    local string strSourceFriendlyName;

    kAttackingUnit = LWCE_XGUnit(kAbility.m_kUnit);
    kTargetUnit = kTarget.kPrimaryTarget;
    kWeapon = LWCE_XGWeapon(kAbility.m_kWeapon);
    kGameCore = `LWCE_GAMECORE;
    kPerksMgr = `LWCE_PERKS_TAC;

    if (kTargetUnit == none && kTarget.arrAdditionalTargets.Length > 0)
    {
        kTargetUnit = kTarget.arrAdditionalTargets[0];
    }

    if (kTargetUnit == none)
    {
        return;
    }

    kAttackingUnit.UpdateUnitBuffs();
    kTargetUnit.UpdateUnitBuffs();
    kTargetUnit.UpdateCoverBonuses(kAttackingUnit);
    kArmor = `LWCE_ARMOR(kTargetUnit.LWCE_GetCharacter().GetInventory().nmArmor);

    if (kAttackingUnit.LWCE_GetCharacter().HasCharacterProperty(eCP_MeleeOnly))
    {
        // Add hit chance mod for UI to show, even though we're forcing a hit
        kAbilityPreview.bForceHit = true;
        kAbilityPreview.AddHitChanceMod('MeleeDefaultAim', kAbility.m_strBonusAim, 100);
        return;
    }

    // Baseline unit stats
    iMod = kAttackingUnit.LWCE_GetCharacter().GetCharacter().aStats[eStat_Offense];
    kAbilityPreview.AddHitChanceMod('UnitAimStat', kAbility.m_strBonusAim, iMod);

    iMod = kAttackingUnit.LWCE_GetCharacter().GetCharacter().aStats[eStat_CriticalShot];
    kAbilityPreview.AddCritChanceMod('UnitCritStat', "STRING TBD", iMod);

    // Bonuses innate to the ability
    iMod = iBuiltInHitMod;
    kAbilityPreview.AddHitChanceMod('AbilityBuiltInAim', kAbility.strName, iMod);

    iMod = iBuiltInCritMod;
    kAbilityPreview.AddCritChanceMod('AbilityBuiltInCrit', kAbility.strName, iMod);

    // Weapon stat bonuses
    if (kWeapon != none)
    {
        iMod = kWeapon.m_kTemplate.kStatChanges.iAim;
        kAbilityPreview.AddHitChanceMod('WeaponAimStat', kWeapon.m_kTemplate.strName, iMod);

        iMod = kWeapon.m_kTemplate.kStatChanges.iCriticalChance;
        kAbilityPreview.AddCritChanceMod('WeaponCritStat', kWeapon.m_kTemplate.strName, iMod);
    }

    // Mmodifiers from small items
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

            iMod = kStatChanges.iAim;
            kAbilityPreview.AddHitChanceMod('EquipmentAimStat', kEquipment.strName, iMod);

            iMod = kStatChanges.iCriticalChance;
            kAbilityPreview.AddCritChanceMod('EquipmentCritStat', kEquipment.strName, iMod);
        }
    }

    // Target's cover
    if (!kTargetUnit.IsFlankedBy(kAttackingUnit) && !kTargetUnit.IsFlankedByLoc(kAttackingUnit.Location) && kTargetUnit.IsInCover())
    {
        // Add cover; XGUnit.m_iCurrentCoverValue includes more than just cover for some reason, like smoke, so don't use it
        iMod = kTargetUnit.GetTrueCoverValue(kAttackingUnit);

        if (iMod == `LWCE_TACCFG(LOW_COVER_BONUS))
        {
            strSourceFriendlyName = kAbility.m_strPenaltyLowCover;
        }
        else
        {
            strSourceFriendlyName = kAbility.m_strPenaltyHighCover;
        }

        kAbilityPreview.AddHitChanceMod('CoverBonus', strSourceFriendlyName, -1 * iMod);
    }

    // Crit chance bonus for flanked or uncovered enemies
    if (!kTargetUnit.IsFlying())
    {
        if (!kTargetUnit.IsInCover())
        {
            iMod = kGameCore.GetFlankingCritBonus(true);
            kAbilityPreview.AddCritChanceMod('UncoveredCritBonus', kAbility.m_strBonusCritEnemyNotInCover, iMod);

        }
        else if (kTargetUnit.IsFlankedByLoc(kAttackingUnit.Location) || kTargetUnit.IsFlankedBy(kAttackingUnit))
        {
            iMod = kGameCore.GetFlankingCritBonus(true);
            kAbilityPreview.AddCritChanceMod('FlankedCritBonus', kAbility.m_strBonusFlanking, iMod);
        }
    }

    iMod = kTargetUnit.LWCE_GetCharacter().GetCharacter().aStats[eStat_Defense];

    if (kArmor != none)
    {
        kArmor.GetStatChanges(kStatChanges, kTargetUnit.LWCE_GetCharacter().GetCharacter());
        iMod += kStatChanges.iDefense;
    }

    kAbilityPreview.AddHitChanceMod('TargetDefense', kAbility.m_strPenaltyDefense, iMod);

    // Target is flying
    if (kTargetUnit.HasAirEvadeBonus())
    {
        kAbilityPreview.AddHitChanceMod('FlyingBonus', kAbility.m_strPenaltyEvasion, -1 * `LWCE_TACCFG(iFlyingDefenseBonus));
    }

    // Aiming Angles
    if (kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(AimingAngles)))
    {
        iMod = kGameCore.CalcAimingAngleMod(kAttackingUnit, kTargetUnit);

        kAbilityPreview.AddHitChanceMod('AimingAngles', kPerksMgr.GetBonusTitle(`LW_PERK_ID(AimingAngles)), iMod);
    }

    // Height advantage (for shooter)
    if (kAttackingUnit.HasHeightAdvantageOver(kTargetUnit))
    {
        kAbilityPreview.AddHitChanceMod('HeightAdvantage', kAbility.m_strHeightBonus, `LWCE_TACCFG(iHeightAdvantageAimBonus));
    }

    // Weapon range to target
    iMod = kWeapon.m_kTemplate.CalcRangeMod(kAttackingUnit, kTargetUnit);

    if (iMod > 0)
    {
        kAbilityPreview.AddHitChanceMod('RangeBonus', kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(RangeBonus)), iMod);
    }
    else if (iMod < 0)
    {
        kAbilityPreview.AddHitChanceMod('RangePenalty', kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(RangePenalty)), iMod);
    }

    // Crit penalty for enemies at squadsight range
    if (!kAttackingUnit.IsVisibleEnemy(kTargetUnit))
    {
        kAbilityPreview.AddCritChanceMod('FlankedCritBonus', kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(SquadSight)), `LWCE_TACCFG(iSquadsightCritChancePenalty));
    }

    // TODO: for civilians, add an effect that modifiers their chance to be hit based on config eCivilianHitChanceCalcStyle

    // Go through source/target effects and give them a chance to modify the hit chance
    foreach kAttackingUnit.m_arrAppliedEffects(kEffect)
    {
        kEffect.m_kEffect.GetToHitModifiersAsAttacker(kAttackingUnit, kTargetUnit, kAbility, kAbilityPreview);
    }

    foreach kTargetUnit.m_arrAppliedEffects(kEffect)
    {
        kEffect.m_kEffect.GetToHitModifiersAsDefender(kAttackingUnit, kTargetUnit, kAbility, kAbilityPreview);
    }

    // Reaction fire logic is split between this and RollForHit for some reason. It would be nice to consolidate, but
    // since we clamp the hit chance in this function, that could technically result in a behavior change.
    // TODO: split calculations into phases
    if (kAbility.m_bReactionFire && kTargetUnit != none && !kAttackingUnit.HasPerk(`LW_PERK_ID(Opportunist)) && !kAttackingUnit.HasPerk(`LW_PERK_ID(AdvancedFireControl)))
    {
        if (kTargetUnit.m_bDashing)
        {
            iMod = -1 * `LWCE_TACCFG(fReactionFireAimMultiplierDashing) * kAbilityPreview.GetUncappedHitChance();
        }
        else
        {
            iMod = -1 * `LWCE_TACCFG(fReactionFireAimMultiplier) * kAbilityPreview.GetUncappedHitChance();
        }

        strSourceFriendlyName = ""; // never visible to player
        kAbilityPreview.AddHitChanceMod('ReactionFirePenalty', strSourceFriendlyName, iMod);

        // Reaction fire can't crit by default; abilities can override this in their own effects as needed
        kAbilityPreview.bPreventCrit = true;
    }
}

function int GetFinalCritChance(LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kAbilityPreview)
{
    if (kAbilityPreview.bForceCrit)
    {
        return 100;
    }

    if (kAbilityPreview.bPreventCrit)
    {
        return 0;
    }

    return Clamp(kAbilityPreview.GetUncappedCritChance(), 0, 100);
}

function int GetFinalHitChance(LWCE_XGAbility kAbility, LWCEAbilityUsageSummary kAbilityPreview)
{
    if (kAbilityPreview.bForceHit)
    {
        return 100;
    }

    if (kAbilityPreview.bPreventHit)
    {
        return 0;
    }

    // TODO: verify that reaction fire can have 0% chance to hit
    return Clamp(kAbilityPreview.GetUncappedHitChance(), kAbility.m_bReactionFire ? 0 : 1, 100);
}