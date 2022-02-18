class Highlander_XGAbility_Extensions extends Object;

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
            kAbility.m_iActualEnvironmentDamage *= `HL_TACCFG(fSapperEnvironmentalDamageMultiplier);
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
                kAbility.m_iActualDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage] + `HL_UTILS.RandInRange(`HL_TACCFG(DeathBlossomAddedDamage));
                kAbility.m_iActualDamage = kPrimTarget.AbsorbDamage(kAbility.m_iActualDamage, kAbility.m_kUnit, kAbility.m_kWeapon);
                break;
            case eAbility_PsiLance:
                kAbility.m_iActualDamage = `GAMECORE.CalcPsiLanceDamage(kAbility.m_kUnit, kAbility.GetPrimaryTarget());
                break;
            case eAbility_Mindfray:
                kAbility.m_iActualDamage = `HL_TACCFG(iMindfrayDamage);
                break;
            case eAbility_ShotMayhem:
                kAbility.m_iActualDamage = `HL_TACCFG(iMayhemDamageBonusForSuppression);
                break;
            case eAbility_BullRush:
                kAbility.m_iActualDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage] + `HL_UTILS.RandInRange(`HL_TACCFG(BullRushAddedDamage));
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
    local int iBaseDamage, iDamage, iDamageBonusItemId;
    local int iWeaponItemId;
    local XGWeapon kWeapon;
    local HL_TWeapon kTWeapon;

    iDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage];
    kWeapon = kAbility.m_kWeapon;

    if (kWeapon == none)
    {
        return iDamage;
    }

    kTWeapon = `HL_TWEAPON_FROM_XG(kWeapon);
    iWeaponItemId = kTWeapon.iItemId;

    iBaseDamage = kTWeapon.iDamage;

    // Weapon class is used here to represent the weapon tech tier
    // TODO: GetWeaponClass needs a Highlander equivalent
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
                iDamage += 1;
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
                    iDamage += `HL_TACCFG(iMayhemDamageBonusForMachineGuns);
                }

                if (kWeapon.HasProperty(eWP_Sniper))
                {
                    iDamage += `HL_TACCFG(iMayhemDamageBonusForSniperRifles);
                }
            }

            break;
        case eAbility_ShotMayhem:
            iDamage += `HL_TACCFG(iMayhemDamageBonusForSuppression);
            break;
        case eAbility_NeedleGrenade:
        case eAbility_MEC_GrenadeLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                iDamage += 2;
            }
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
        case eAbility_MEC_ProximityMine:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Sapper)))
            {
                iDamage += `HL_TACCFG(iSapperDamageBonus);
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kAbility.GetType() == eAbility_MEC_ProximityMine)
                {
                    iDamage += `HL_TACCFG(iMayhemDamageBonusForProximityMines);
                }
                else
                {
                    iDamage += `HL_TACCFG(iMayhemDamageBonusForGrenades);
                }
            }

            break;
        case eAbility_ShredderRocket:
            iDamage -= int(float(iBaseDamage) * `HL_TACCFG(fShredderRocketDamageMultiplier));
        case eAbility_RocketLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                iDamage += `HL_TACCFG(iMayhemDamageBonusForRocketLaunchers);
            }

            break;
        case eAbility_PrecisionShot:
            if (kAbility.m_bCritical)
            {
                if (iWeaponItemId == `LW_ITEM_ID(GaussLongRifle))
                {
                    iDamage += `HL_TACCFG(iPrecisionShotDamageBonusForGaussSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(SniperRifle))
                {
                    iDamage += `HL_TACCFG(iPrecisionShotDamageBonusForBallisticSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(PulseSniperRifle))
                {
                    iDamage += `HL_TACCFG(iPrecisionShotDamageBonusForPulseSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(LaserSniperRifle))
                {
                    iDamage += `HL_TACCFG(iPrecisionShotDamageBonusForLaserSniper);
                }

                if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
                {
                    iDamage += `HL_TACCFG(iPrecisionShotDamageBonusForPlasmaSniper);
                }
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Sniper))
            {
                iDamage += `HL_TACCFG(iMayhemDamageBonusForSniperRifles);
            }

            break;
        case eAbility_ShotFlush:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Support)) // LMGs/SAWs
            {
                iDamage += `HL_TACCFG(iMayhemDamageBonusForMachineGuns);
            }

            iDamage -= ((iBaseDamage + 1) / 2);
            break;
        case eAbility_MEC_Barrage:
            iDamage -= (iBaseDamage - 1);
            break;
        case eAbility_DisablingShot:
            iDamage -= (iBaseDamage - 1);
            break;
        case eAbility_MEC_Flamethrower:
            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                iDamage += 3;
            }

            break;
        case eAbility_MEC_KineticStrike:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(MECCloseCombat)))
            {
                iDamage += `HL_TACCFG(iMecCloseCombatDamageBonus);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                iDamage += 3;
            }

            // +3 damage for each extra Kinetic Strike Module. Take away 3 because we know there's at least one KSM equipped
            iDamage -= 3;

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[1] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[2] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[3] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            break;
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(BringEmOn)) && kAbility.m_bCritical)
    {
        iDamage += Min(4, 1 + (kAbility.m_kUnit.GetNumSquadVisibleEnemies(kAbility.m_kUnit) / 3));
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(KillerInstinct)) && kAbility.m_bCritical && kAbility.m_kUnit.RunAndGunPerkActive())
    {
        iDamage += ((iBaseDamage + 2) / 3);
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Ranger)))
    {
        if (kTWeapon.iSize == 1)
        {
            iDamage += `HL_TACCFG(iRangerDamageBonusPrimary);
        }

        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iDamage += `HL_TACCFG(iRangerDamageBonusPistol);
        }
    }

    if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 16) > 0) // Reflex Pistols
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iDamage += `HL_TACCFG(iReflexPistolsDamageBonus);
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
                    iDamage += `HL_TACCFG(iVitalPointTargetingDamageBonusPistol);
                }
                else
                {
                    iDamage += `HL_TACCFG(iVitalPointTargetingDamageBonusPrimary);
                }
            }
        }
    }

    if (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()) == 5)
    {
        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 4) > 0) // Enhanced Plasma
        {
            iDamage += `HL_TACCFG(iEnhancedPlasmaDamageBonus);
        }
    }

    if (kAbility.m_bCritical && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
    {
        iDamage += 1;
    }

    if (kAbility.m_bCritical)
    {
        if (iWeaponItemId == `LW_ITEM_ID(PlasmaRifle) && !kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
        {
            iDamage += 1;
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexCannon))
        {
            if (VSize(kAbility.m_kUnit.Location -kAbility. GetPrimaryTarget().Location) <= float(`TILESTOUNITS(4)))
            {
                iDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexRifle))
        {
            if (kAbility.GetPrimaryTarget().IsFlankedByLoc(kAbility.m_kUnit.Location) || kAbility.GetPrimaryTarget().IsFlankedBy(kAbility.m_kUnit) || !kAbility.GetPrimaryTarget().IsInCover())
            {
                iDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
        {
            if (VSize(kAbility.m_kUnit.Location - kAbility.GetPrimaryTarget().Location) >= float(`TILESTOUNITS(35)))
            {
                iDamage += 1;
            }
        }
    }

    if (iWeaponItemId == `LW_ITEM_ID(PlasmaDragon) && kAbility.GetPrimaryTarget().IsFlying())
    {
        iDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(ParticleCannon) && kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
    {
        iDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(HeavyPlasmaRifle) && kAbility.m_kUnit.IsAffectedByAbility(eAbility_Aim))
    {
        iDamage += 1;
    }

    if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(InTheZone)) && kAbility.m_kUnit.m_iNumTimesUsedInTheZone > 0)
    {
        iDamage = Max(iDamage - kAbility.m_kUnit.m_iNumTimesUsedInTheZone, 1 - iBaseDamage);
    }

    return iDamage;
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
        iPossibleDamage = CalculateAbilityModifiedDamage(kAbility) + `HL_TWEAPON_FROM_XG(kAbility.m_kWeapon).iDamage;
    }

    if (kAbility.GetType() == eAbility_Mindfray)
    {
        return `HL_TACCFG(iMindfrayDamage);
    }

    if (kAbility.GetType() == eAbility_MedikitHeal)
    {
        iHealing = `HL_TACCFG(iMedikitHealBase);

        if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Savior)))
        {
            iHealing += `HL_TACCFG(iSaviorHealBonus);
        }

        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 64) > 0) // Improved Medikit
        {
            iHealing += `HL_TACCFG(iImprovedMedikitHealBonus);
        }

        if (kAbility.GetPrimaryTarget().GetCharacter().HasUpgrade(`LW_PERK_ID(SmartMacrophages)))
        {
            iHealing += `HL_TACCFG(iSmartMacrophagesHealBonus);
        }

        return iHealing;
    }

    if (kAbility.GetType() == eAbility_RepairSHIV)
    {
        return `HL_TACCFG(iRepairHealBaseXCOM);
    }

    if (kAbility.GetType() == eAbility_Repair)
    {
        return `HL_TACCFG(iRepairHealBaseAliens);
    }

    return iPossibleDamage;
}