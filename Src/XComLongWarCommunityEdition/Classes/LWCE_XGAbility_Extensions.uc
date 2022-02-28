class LWCE_XGAbility_Extensions extends Object
    abstract;

static function CalcDamage(XGAbility_Targeted kAbility)
{
    local XGUnit kPrimTarget;
    local bool bDoesSplashDamage;
    local XComWeapon kTemplate;

    kPrimTarget = kAbility.GetPrimaryTarget();

    if (!`GAMECORE.m_kAbilities.AbilityHasProperty(kAbility.GetType(), eProp_InvulnerableWorld))
    {
        kAbility.m_iActualEnvironmentDamage = `GAMECORE.CalcEnvironmentalDamage(kAbility.m_kWeapon.ItemType(), kAbility.GetType(), kAbility.m_kUnit.GetCharacter().m_kChar, kAbility.m_kUnit.m_aCurrentStats, kAbility.m_bCritical, kAbility.m_bHasHeightAdvantage, kAbility.m_fDistanceToTarget, kAbility.m_bHasFlank);

        if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Sapper)))
        {
            kAbility.m_iActualEnvironmentDamage *= `LWCE_TACCFG(fSapperEnvironmentalDamageMultiplier);
        }

        if (kAbility.m_iActualEnvironmentDamage < 0)
        {
            kAbility.m_iActualEnvironmentDamage = 0;
        }
    }
    else
    {
        kAbility.m_iActualEnvironmentDamage = 0;
    }

    if (kAbility.DoesDamage() && !kAbility.m_bIgnoreCalculation)
    {
        if (kPrimTarget != none)
        {
            kAbility.m_kUnit.LastHitTarget = kPrimTarget;
        }

        switch (kAbility.GetType())
        {
            case eAbility_DeathBlossom:
                kAbility.m_iActualDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(DeathBlossomAddedDamage));
                kAbility.m_iActualDamage = kPrimTarget.AbsorbDamage(kAbility.m_iActualDamage, kAbility.m_kUnit, kAbility.m_kWeapon);
                break;
            case eAbility_PsiLance:
                kAbility.m_iActualDamage = `GAMECORE.CalcPsiLanceDamage(kAbility.m_kUnit, kAbility.GetPrimaryTarget());
                break;
            case eAbility_Mindfray:
                kAbility.m_iActualDamage = `LWCE_TACCFG(iMindfrayDamage);
                break;
            case eAbility_ShotMayhem:
                kAbility.m_iActualDamage = `LWCE_TACCFG(iMayhemDamageBonusForSuppression);
                break;
            case eAbility_BullRush:
                kAbility.m_iActualDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(BullRushAddedDamage));
                kAbility.m_iActualDamage = kPrimTarget.AbsorbDamage(kAbility.m_iActualDamage, kAbility.m_kUnit, kAbility.m_kWeapon);
                break;
            case eAbility_ShredderRocket:
                kAbility.m_iActualEnvironmentDamage *= 0.0;
                // Deliberate case fall-through
            default:
                kAbility.m_iActualDamage = `GAMECORE.CalcOverallDamage(kAbility.m_kWeapon.ItemType(), CalculateAbilityModifiedDamage(kAbility), kAbility.m_bCritical, kAbility.m_bReflected);
                break;
        }

        kTemplate = `CONTENTMGR.GetWeaponTemplate(kAbility.m_kWeapon.GameplayType());

        if (kTemplate != none && kTemplate.ProjectileTemplate != none)
        {
            bDoesSplashDamage = ClassIsChildOf(kTemplate.ProjectileTemplate.MyDamageType, class'XComDamageType_Explosion') && kTemplate.ProjectileTemplate.MyDamageType.default.bCausesFracture;
        }

        if (kPrimTarget != none && !bDoesSplashDamage)
        {
            if (kAbility.m_bHit && !kAbility.HasProperty(eProp_Psionic) && !kAbility.HasProperty(eProp_Stun))
            {
                kAbility.m_iActualDamage = kPrimTarget.AbsorbDamage(kAbility.m_iActualDamage, kAbility.m_kUnit, kAbility.m_kWeapon);
            }
        }
    }
}

static simulated function int CalculateAbilityModifiedDamage(XGAbility_Targeted kAbility)
{
    local int iWeaponDamage, iTotalDamage, iDamageBonusItemId;
    local int iWeaponItemId;
    local XGWeapon kWeapon;
    local LWCE_TWeapon kTWeapon;

    iTotalDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage];
    kWeapon = kAbility.m_kWeapon;

    if (kWeapon == none)
    {
        return iTotalDamage;
    }

    kTWeapon = `LWCE_TWEAPON_FROM_XG(kWeapon);
    iWeaponItemId = kTWeapon.iItemId;
    iWeaponDamage = kTWeapon.iDamage;

    // Weapon class is used here to represent the weapon tech tier
    // TODO: GetWeaponClass needs a LWCE equivalent
    switch (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()))
    {
        case 1: // Ballistic
        case 3: // Gauss
            iDamageBonusItemId = `LW_ITEM_ID(AlloyJacketedRounds);
            break;
        case 2: // Laser
        case 4: // Pulse
            iDamageBonusItemId = `LW_ITEM_ID(EnhancedBeamOptics);
            break;
        case 5: // Plasma
            iDamageBonusItemId = `LW_ITEM_ID(PlasmaStellerator);
            break;
        default:
            iDamageBonusItemId = 0;
            break;
    }

    // If unit has an applicable +damage item, apply it
    if (iDamageBonusItemId > 0)
    {
        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, iDamageBonusItemId))
        {
            if (kTWeapon.iSize == 1)
            {
                iTotalDamage += 1;
            }
        }
    }

    switch (kAbility.GetType())
    {
        case eAbility_ShotStandard:
        case eAbility_RapidFire:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kWeapon.HasProperty(eWP_Support)) // SAWs/LMGs
                {
                    iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForMachineGuns);
                }

                if (kWeapon.HasProperty(eWP_Sniper))
                {
                    iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForSniperRifles);
                }
            }

            break;
        case eAbility_ShotMayhem:
            iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForSuppression);
            break;
        case eAbility_NeedleGrenade:
        case eAbility_MEC_GrenadeLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                iTotalDamage += 2;
            }
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
        case eAbility_MEC_ProximityMine:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Sapper)))
            {
                iTotalDamage += `LWCE_TACCFG(iSapperDamageBonus);
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kAbility.GetType() == eAbility_MEC_ProximityMine)
                {
                    iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForProximityMines);
                }
                else
                {
                    iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForGrenades);
                }
            }

            break;
        case eAbility_ShredderRocket:
            // This function doesn't use the weapon damage for most things, because it's added later, but Shredder Rocket depends on it
            // specifically. We adjust the damage of Shredder up or down based on the multiplier, while still not adding the base
            // weapon damage itself.
            if (`LWCE_TACCFG(fShredderRocketDamageMultiplier) <= 1.0)
            {
                iTotalDamage -= int(float(iWeaponDamage) * `LWCE_TACCFG(fShredderRocketDamageMultiplier));
            }
            else
            {
                iTotalDamage += int(float(iWeaponDamage) * (`LWCE_TACCFG(fShredderRocketDamageMultiplier) - 1));
            }

            // Deliberate fall-through
        case eAbility_RocketLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForRocketLaunchers);
            }

            break;
        case eAbility_PrecisionShot:
            if (kAbility.m_bCritical)
            {
                if (iWeaponItemId == `LW_ITEM_ID(GaussLongRifle))
                {
                    iTotalDamage += `LWCE_TACCFG(iPrecisionShotDamageBonusForGaussSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(SniperRifle))
                {
                    iTotalDamage += `LWCE_TACCFG(iPrecisionShotDamageBonusForBallisticSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(PulseSniperRifle))
                {
                    iTotalDamage += `LWCE_TACCFG(iPrecisionShotDamageBonusForPulseSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(LaserSniperRifle))
                {
                    iTotalDamage += `LWCE_TACCFG(iPrecisionShotDamageBonusForLaserSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
                {
                    iTotalDamage += `LWCE_TACCFG(iPrecisionShotDamageBonusForPlasmaSniper);
                }
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Sniper))
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForSniperRifles);
            }

            break;
        case eAbility_ShotFlush:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Support)) // LMGs/SAWs
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForMachineGuns);
            }

            iTotalDamage -= ((iWeaponDamage + 1) / 2);
            break;
        case eAbility_MEC_Barrage:
            iTotalDamage -= (iWeaponDamage - 1);
            break;
        case eAbility_DisablingShot:
            iTotalDamage -= (iWeaponDamage - 1);
            break;
        case eAbility_MEC_Flamethrower:
            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                iTotalDamage += 3;
            }

            break;
        case eAbility_MEC_KineticStrike:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(MECCloseCombat)))
            {
                iTotalDamage += `LWCE_TACCFG(iMecCloseCombatDamageBonus);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                iTotalDamage += 3;
            }

            // +3 damage for each extra Kinetic Strike Module. Take away 3 because we know there's at least one KSM equipped
            iTotalDamage -= 3;

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[1] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[2] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[3] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            break;
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(BringEmOn)) && kAbility.m_bCritical)
    {
        iTotalDamage += Min(4, 1 + (kAbility.m_kUnit.GetNumSquadVisibleEnemies(kAbility.m_kUnit) / 3));
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(KillerInstinct)) && kAbility.m_bCritical && kAbility.m_kUnit.RunAndGunPerkActive())
    {
        iTotalDamage += ((iWeaponDamage + 2) / 3);
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Ranger)))
    {
        if (kTWeapon.iSize == 1)
        {
            iTotalDamage += `LWCE_TACCFG(iRangerDamageBonusPrimary);
        }

        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iTotalDamage += `LWCE_TACCFG(iRangerDamageBonusPistol);
        }
    }

    if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 16) > 0) // Reflex Pistols
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iTotalDamage += `LWCE_TACCFG(iReflexPistolsDamageBonus);
        }
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(VitalPointTargeting)))
    {
        if (kAbility.GetPrimaryTarget() != none && kAbility.GetType() != eAbility_MEC_Barrage)
        {
            if (`GAMECORE.m_kAbilities.HasAutopsyTechForChar(kAbility.GetPrimaryTarget().m_kCharacter.m_kChar.iType))
            {
                if (kWeapon.HasProperty(eWP_Pistol))
                {
                    iTotalDamage += `LWCE_TACCFG(iVitalPointTargetingDamageBonusPistol);
                }
                else
                {
                    iTotalDamage += `LWCE_TACCFG(iVitalPointTargetingDamageBonusPrimary);
                }
            }
        }
    }

    if (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()) == 5)
    {
        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 4) > 0) // Enhanced Plasma
        {
            iTotalDamage += `LWCE_TACCFG(iEnhancedPlasmaDamageBonus);
        }
    }

    if (kAbility.m_bCritical && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
    {
        iTotalDamage += 1;
    }

    if (kAbility.m_bCritical)
    {
        if (iWeaponItemId == `LW_ITEM_ID(PlasmaRifle) && !kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
        {
            iTotalDamage += 1;
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexCannon))
        {
            if (VSize(kAbility.m_kUnit.Location -kAbility. GetPrimaryTarget().Location) <= float(`TILESTOUNITS(4)))
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexRifle))
        {
            if (kAbility.GetPrimaryTarget().IsFlankedByLoc(kAbility.m_kUnit.Location) || kAbility.GetPrimaryTarget().IsFlankedBy(kAbility.m_kUnit) || !kAbility.GetPrimaryTarget().IsInCover())
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
        {
            if (VSize(kAbility.m_kUnit.Location - kAbility.GetPrimaryTarget().Location) >= float(`TILESTOUNITS(35)))
            {
                iTotalDamage += 1;
            }
        }
    }

    if (iWeaponItemId == `LW_ITEM_ID(PlasmaDragon) && kAbility.GetPrimaryTarget().IsFlying())
    {
        iTotalDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(ParticleCannon) && kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
    {
        iTotalDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(HeavyPlasmaRifle) && kAbility.m_kUnit.IsAffectedByAbility(eAbility_Aim))
    {
        iTotalDamage += 1;
    }

    if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(InTheZone)) && kAbility.m_kUnit.m_iNumTimesUsedInTheZone > 0)
    {
        iTotalDamage = Max(iTotalDamage - kAbility.m_kUnit.m_iNumTimesUsedInTheZone, 1 - iWeaponDamage);
    }

    return iTotalDamage;
}

static simulated function string GetHelpText(XGAbility kSelf)
{
    local int iAbilityId;
    local string strText;

    iAbilityId = kSelf.GetType();

    if (iAbilityId <= 255)
    {
        strText = class'XGAbilityTree'.default.HelpMessages[iAbilityId];

        if (XGAbility_Targeted(kSelf) != none)
        {
            strText = Repl(strText, "<XGAbility:PossibleDamage/>", GetPossibleDamage(XGAbility_Targeted(kSelf)));
        }
    }

    // TODO: support help messages for custom abilities if we ever add those
    return strText;
}

/*
 * For healing abilities, returns the healing amount; for other abilities, returns the modified weapon damage, including
 * the weapon's base damage (if any).
 */
static simulated function int GetPossibleDamage(XGAbility_Targeted kAbility)
{
    local int iPossibleDamage, iHealing;

    if (kAbility.m_kWeapon != none)
    {
        iPossibleDamage = CalculateAbilityModifiedDamage(kAbility) + `LWCE_TWEAPON_FROM_XG(kAbility.m_kWeapon).iDamage;
    }

    if (kAbility.GetType() == eAbility_Mindfray)
    {
        return `LWCE_TACCFG(iMindfrayDamage);
    }

    if (kAbility.GetType() == eAbility_MedikitHeal)
    {
        iHealing = `LWCE_TACCFG(iMedikitHealBase);

        if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Savior)))
        {
            iHealing += `LWCE_TACCFG(iSaviorHealBonus);
        }

        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 64) > 0) // Improved Medikit
        {
            iHealing += `LWCE_TACCFG(iImprovedMedikitHealBonus);
        }

        if (kAbility.GetPrimaryTarget().GetCharacter().HasUpgrade(`LW_PERK_ID(SmartMacrophages)))
        {
            iHealing += `LWCE_TACCFG(iSmartMacrophagesHealBonus);
        }

        return iHealing;
    }

    if (kAbility.GetType() == eAbility_RepairSHIV)
    {
        return `LWCE_TACCFG(iRepairHealBaseXCOM);
    }

    if (kAbility.GetType() == eAbility_Repair)
    {
        return `LWCE_TACCFG(iRepairHealBaseAliens);
    }

    return iPossibleDamage;
}

static simulated function float GetRadius(XGAbility_Targeted kAbility)
{
    local int iWeaponId;
    local float fRadius;
    local XGWeapon kWeapon;

    kWeapon = kAbility.m_kWeapon;

    if (kWeapon != none)
    {
        fRadius = kWeapon.m_kTWeapon.iRadius;
        iWeaponId = kWeapon.ItemType(); // TODO: LWCE version of this
    }

    switch (kAbility.GetType())
    {
        case eAbility_BullRush:
            fRadius = `LWCE_TACCFG(fBullRushRadius);
            break;
        case eAbility_Rift:
            fRadius = `LWCE_TACCFG(fRiftRadius);
            break;
        case eAbility_TelekineticField:
            fRadius = `LWCE_TACCFG(fTelekineticFieldRadius);
            break;
        case eAbility_ShotOverload:
            fRadius = `LWCE_TACCFG(fOverloadRadius);
            break;
        case eAbility_DeathBlossom:
            fRadius = `LWCE_TACCFG(fDeathBlossomRadius);
            break;
        case eAbility_PsiInspiration:
            fRadius = `LWCE_TACCFG(fPsiInspirationRadius);
            break;
        case eAbility_MEC_Barrage:
            fRadius = `LWCE_TACCFG(fCollateralDamageRadius);
            break;
        case eAbility_MEC_ElectroPulse:
            fRadius = class'XGAbility_Electropulse'.default.ElectroPulseXY_Range;
            break;
        case eAbility_ShredderRocket:
            if (`LWCE_TACCFG(fShredderRocketRadiusOverride) >= 0.0)
            {
                fRadius = `LWCE_TACCFG(fShredderRocketRadiusOverride);
            }
            else
            {
                fRadius *= `LWCE_TACCFG(fShredderRocketRadiusMultiplier);
            }

            break;
        case eAbility_ShotDamageCover: // Psychokinetic Strike
            fRadius = 2.0 * 96.0 * Sqrt(float(kAbility.m_kUnit.ReplicateActivatePerkData_ToString()) / 100.0);
            break;
        default:
            break;
    }

    switch (iWeaponId)
    {
        case `LW_ITEM_ID(RocketLauncher):
        case `LW_ITEM_ID(BlasterLauncher):
        case `LW_ITEM_ID(RecoillessRifle):
        case `LW_ITEM_ID(GrenadeLauncher):
        case `LW_ITEM_ID(ProximityMineLauncher):
            if (kWeapon.m_kOwner != none && kWeapon.m_kOwner.GetCharacter().HasUpgrade(`LW_PERK_ID(DangerZone)))
            {
                fRadius *= Sqrt(1.60);
            }

            break;
        case `LW_ITEM_ID(HEGrenade):
            if (kWeapon.m_kOwner != none && kWeapon.m_kOwner.GetCharacter().HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                fRadius *= Sqrt(2.0);
            }

            break;
    }

    return fRadius;
}