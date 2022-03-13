class LWCE_XGAbility_Extensions extends Object
    abstract;

static function CalcDamage(XGAbility_Targeted kSelf)
{
    local XGUnit kPrimTarget;
    local bool bDoesSplashDamage;
    local XComWeapon kTemplate;

    kPrimTarget = kSelf.GetPrimaryTarget();

    if (!`GAMECORE.m_kAbilities.AbilityHasProperty(kSelf.GetType(), eProp_InvulnerableWorld))
    {
        kSelf.m_iActualEnvironmentDamage = `GAMECORE.CalcEnvironmentalDamage(kSelf.m_kWeapon.ItemType(), kSelf.GetType(), kSelf.m_kUnit.GetCharacter().m_kChar, kSelf.m_kUnit.m_aCurrentStats, kSelf.m_bCritical, kSelf.m_bHasHeightAdvantage, kSelf.m_fDistanceToTarget, kSelf.m_bHasFlank);

        if (kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Sapper)))
        {
            kSelf.m_iActualEnvironmentDamage *= `LWCE_TACCFG(fSapperEnvironmentalDamageMultiplier);
        }

        if (kSelf.m_iActualEnvironmentDamage < 0)
        {
            kSelf.m_iActualEnvironmentDamage = 0;
        }
    }
    else
    {
        kSelf.m_iActualEnvironmentDamage = 0;
    }

    if (kSelf.DoesDamage() && !kSelf.m_bIgnoreCalculation)
    {
        if (kPrimTarget != none)
        {
            kSelf.m_kUnit.LastHitTarget = kPrimTarget;
        }

        switch (kSelf.GetType())
        {
            case eAbility_DeathBlossom:
                kSelf.m_iActualDamage = kSelf.m_kUnit.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(DeathBlossomAddedDamage));
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kSelf.m_kUnit, kSelf.m_kWeapon);
                break;
            case eAbility_PsiLance:
                kSelf.m_iActualDamage = `GAMECORE.CalcPsiLanceDamage(kSelf.m_kUnit, kSelf.GetPrimaryTarget());
                break;
            case eAbility_Mindfray:
                kSelf.m_iActualDamage = `LWCE_TACCFG(iMindfrayDamage);
                break;
            case eAbility_ShotMayhem:
                kSelf.m_iActualDamage = `LWCE_TACCFG(iMayhemDamageBonusForSuppression);
                break;
            case eAbility_BullRush:
                kSelf.m_iActualDamage = kSelf.m_kUnit.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(BullRushAddedDamage));
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kSelf.m_kUnit, kSelf.m_kWeapon);
                break;
            case eAbility_ShredderRocket:
                kSelf.m_iActualEnvironmentDamage *= 0.0;
                // Deliberate case fall-through
            default:
                kSelf.m_iActualDamage = `GAMECORE.CalcOverallDamage(kSelf.m_kWeapon.ItemType(), CalculateAbilityModifiedDamage(kSelf), kSelf.m_bCritical, kSelf.m_bReflected);
                break;
        }

        kTemplate = `CONTENTMGR.GetWeaponTemplate(kSelf.m_kWeapon.GameplayType());

        if (kTemplate != none && kTemplate.ProjectileTemplate != none)
        {
            bDoesSplashDamage = ClassIsChildOf(kTemplate.ProjectileTemplate.MyDamageType, class'XComDamageType_Explosion') && kTemplate.ProjectileTemplate.MyDamageType.default.bCausesFracture;
        }

        if (kPrimTarget != none && !bDoesSplashDamage)
        {
            if (kSelf.m_bHit && !kSelf.HasProperty(eProp_Psionic) && !kSelf.HasProperty(eProp_Stun))
            {
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kSelf.m_kUnit, kSelf.m_kWeapon);
            }
        }
    }
}

static simulated function int CalculateAbilityModifiedDamage(XGAbility_Targeted kSelf)
{
    local int iWeaponDamage, iTotalDamage, iDamageBonusItemId;
    local int iWeaponItemId;
    local XGWeapon kWeapon;
    local LWCE_TWeapon kTWeapon;

    iTotalDamage = kSelf.m_kUnit.m_aCurrentStats[eStat_Damage];
    kWeapon = kSelf.m_kWeapon;

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
        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kSelf.m_kUnit.GetCharacter().m_kChar.kInventory, iDamageBonusItemId))
        {
            if (kTWeapon.iSize == 1)
            {
                iTotalDamage += 1;
            }
        }
    }

    switch (kSelf.GetType())
    {
        case eAbility_ShotStandard:
        case eAbility_RapidFire:
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
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
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                iTotalDamage += 2;
            }
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
        case eAbility_MEC_ProximityMine:
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Sapper)))
            {
                iTotalDamage += `LWCE_TACCFG(iSapperDamageBonus);
            }

            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kSelf.GetType() == eAbility_MEC_ProximityMine)
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
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForRocketLaunchers);
            }

            break;
        case eAbility_PrecisionShot:
            if (kSelf.m_bCritical)
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

            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Sniper))
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForSniperRifles);
            }

            break;
        case eAbility_ShotFlush:
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Support)) // LMGs/SAWs
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
            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kSelf.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                iTotalDamage += 3;
            }

            break;
        case eAbility_MEC_KineticStrike:
            if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(MECCloseCombat)))
            {
                iTotalDamage += `LWCE_TACCFG(iMecCloseCombatDamageBonus);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kSelf.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                iTotalDamage += 3;
            }

            // +3 damage for each extra Kinetic Strike Module. Take away 3 because we know there's at least one KSM equipped
            iTotalDamage -= 3;

            if (kSelf.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[1] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kSelf.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[2] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kSelf.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[3] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            break;
    }

    if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(BringEmOn)) && kSelf.m_bCritical)
    {
        iTotalDamage += Min(4, 1 + (kSelf.m_kUnit.GetNumSquadVisibleEnemies(kSelf.m_kUnit) / 3));
    }

    if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(KillerInstinct)) && kSelf.m_bCritical && kSelf.m_kUnit.RunAndGunPerkActive())
    {
        iTotalDamage += ((iWeaponDamage + 2) / 3);
    }

    if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Ranger)))
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

    if ((kSelf.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 16) > 0) // Reflex Pistols
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iTotalDamage += `LWCE_TACCFG(iReflexPistolsDamageBonus);
        }
    }

    if (kSelf.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(VitalPointTargeting)))
    {
        if (kSelf.GetPrimaryTarget() != none && kSelf.GetType() != eAbility_MEC_Barrage)
        {
            if (`GAMECORE.m_kAbilities.HasAutopsyTechForChar(kSelf.GetPrimaryTarget().m_kCharacter.m_kChar.iType))
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
        if ((kSelf.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 4) > 0) // Enhanced Plasma
        {
            iTotalDamage += `LWCE_TACCFG(iEnhancedPlasmaDamageBonus);
        }
    }

    if (kSelf.m_bCritical && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kSelf.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
    {
        iTotalDamage += 1;
    }

    if (kSelf.m_bCritical)
    {
        if (iWeaponItemId == `LW_ITEM_ID(PlasmaRifle) && !kSelf.GetPrimaryTarget().IsVulnerableToElectropulse())
        {
            iTotalDamage += 1;
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexCannon))
        {
            if (VSize(kSelf.m_kUnit.Location -kSelf. GetPrimaryTarget().Location) <= float(`TILESTOUNITS(4)))
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexRifle))
        {
            if (kSelf.GetPrimaryTarget().IsFlankedByLoc(kSelf.m_kUnit.Location) || kSelf.GetPrimaryTarget().IsFlankedBy(kSelf.m_kUnit) || !kSelf.GetPrimaryTarget().IsInCover())
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
        {
            if (VSize(kSelf.m_kUnit.Location - kSelf.GetPrimaryTarget().Location) >= float(`TILESTOUNITS(35)))
            {
                iTotalDamage += 1;
            }
        }
    }

    if (iWeaponItemId == `LW_ITEM_ID(PlasmaDragon) && kSelf.GetPrimaryTarget().IsFlying())
    {
        iTotalDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(ParticleCannon) && kSelf.GetPrimaryTarget().IsVulnerableToElectropulse())
    {
        iTotalDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(HeavyPlasmaRifle) && kSelf.m_kUnit.IsAffectedByAbility(eAbility_Aim))
    {
        iTotalDamage += 1;
    }

    if (kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(InTheZone)) && kSelf.m_kUnit.m_iNumTimesUsedInTheZone > 0)
    {
        iTotalDamage = Max(iTotalDamage - kSelf.m_kUnit.m_iNumTimesUsedInTheZone, 1 - iWeaponDamage);
    }

    return iTotalDamage;
}

static simulated function string GetHelpText(XGAbility kSelf)
{
    local int iAbilityId;
    local string strText;
    local XGAbility_Targeted kTargeted;

    iAbilityId = kSelf.GetType();
    kTargeted = XGAbility_Targeted(kSelf);

    if (iAbilityId <= 255)
    {
        strText = class'XGAbilityTree'.default.HelpMessages[iAbilityId];
    }

    if (strText != "")
    {
        strText = Repl(strText, "<XGAbility:Duration/>", kSelf.iDuration / 2);
        strText = Repl(strText, "<XGameCore:RepairShivHP/>", `LWCE_TACCFG(iRepairHealBaseXCOM));
        strText = Repl(strText, "<XGAbility:StunHP/>", 3); // Not sure why this is a variable, it never seems to change

        if (kTargeted != none)
        {
            strText = Repl(strText, "<XGAbility:PossibleDamage/>", GetPossibleDamage(kTargeted));

            if (kTargeted.m_kWeapon != none)
            {
                strText = Repl(strText, "<XGAbility:WeaponName/>", kTargeted.m_kWeapon.m_kTWeapon.strName);
            }
        }
    }

    // TODO: support help messages for custom abilities if we ever add those
    return strText;
}

static simulated function int GetHitChance(XGAbility_Targeted kSelf)
{
    if (kSelf.HasProperty(eProp_PsiRoll))
    {
        return kSelf.m_iHitChance;
    }

    if (kSelf.GetType() == eAbility_ShotStun) // Arc Thrower
    {
        return int(float(kSelf.m_iHitChance) * class'XGTacticalGameCore'.default.UFO_PSI_LINK_SURVIVE);
    }

    if (kSelf.m_kWeapon == none)
    {
        return kSelf.m_iHitChance;
    }

    if (kSelf.GetPrimaryTarget() == none)
    {
        return kSelf.m_iHitChance;
    }

    kSelf.m_iHitChance_NonUnitTarget = 0;

    if (kSelf.m_kWeapon.HasProperty(eWP_Pistol) && !kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Ranger)))
    {
        if (VSize(kSelf.GetPrimaryTarget().GetLocation() - kSelf.m_kUnit.GetLocation()) > (float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS) * float(64)))
        {
            kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= int(((VSize(kSelf.GetPrimaryTarget().GetLocation() - kSelf.m_kUnit.GetLocation()) / float(64)) - float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS)) * (float(class'XGTacticalGameCore'.default.HQASSAULT_MAX_DAYS) / float(10)));
            kSelf.m_iHitChance_NonUnitTarget += int(((VSize(kSelf.GetPrimaryTarget().GetLocation() - kSelf.m_kUnit.GetLocation()) / float(64)) - float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS)) * (float(class'XGTacticalGameCore'.default.HQASSAULT_MAX_DAYS) / float(10)));
        }
    }

    if (kSelf.m_kWeapon.HasProperty(eWP_Rifle) && kSelf.m_kWeapon.HasProperty(eWP_Overheats)) // Battle Rifles
    {
        if (kSelf.m_kUnit.m_iMovesActionsPerformed > 0)
        {
            kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= 10;
            kSelf.m_iHitChance_NonUnitTarget += 10;
        }
    }

    if (kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(SnapShot)))
    {
        if (kSelf.m_kUnit.GetCharacter().m_kChar.eClass == eSC_Sniper)
        {
            if (kSelf.m_kUnit.m_iMovesActionsPerformed >= 1)
            {
                if (!kSelf.m_kWeapon.HasProperty(16) || kSelf.m_kUnit.m_bDoubleTapActivated)
                {
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += 10;
                    kSelf.m_iHitChance_NonUnitTarget -= 10;
                }
            }
        }
    }

    if (kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Deadeye)))
    {
        if (kSelf.GetPrimaryTarget().IsFlying())
        {
            kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += 15;
            kSelf.m_iHitChance_NonUnitTarget -= 15;
        }
    }

    if (kSelf.GetPrimaryTarget().IsFlankedBy(kSelf.m_kUnit))
    {
        if (kSelf.GetPrimaryTarget().m_bInDenseSmoke)
        {
            kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= 20;
            kSelf.m_iHitChance_NonUnitTarget += 20;
        }

        if (kSelf.GetPrimaryTarget().m_bInSmokeBomb)
        {
            kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= 20;
            kSelf.m_iHitChance_NonUnitTarget += 20;
        }
    }

    if (`GAMECORE.IsOptionEnabled(30)) // Green Fog
    {
        if (!kSelf.m_kUnit.IsAI())
        {
            if (class'XGTacticalGameCore'.default.ContBalance_Normal[1].iScientists1 == 1)
            {
                if (`BATTLE.m_iTurn <= class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1)
                {
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= `BATTLE.m_iTurn;
                    kSelf.m_iHitChance_NonUnitTarget += `BATTLE.m_iTurn;
                }
                else
                {
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1;
                    kSelf.m_iHitChance_NonUnitTarget += class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1;
                }
            }
        }
    }

    if (kSelf.m_bReactionFire)
    {
        if (kSelf.GetPrimaryTarget().CanUseCover())
        {
            if (kSelf.GetPrimaryTarget().IsFlankedByLoc(kSelf.m_kUnit.Location))
            {
                if (!kSelf.GetPrimaryTarget().IsFlying())
                {
                    // If flanking target on overwatch, remove their cover bonus
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += kSelf.GetPrimaryTarget().m_iCurrentCoverValue;
                    kSelf.m_iHitChance_NonUnitTarget -= kSelf.GetPrimaryTarget().m_iCurrentCoverValue;
                }
            }
            else
            {
                if (kSelf.GetPrimaryTarget().IsSuppressedBy(kSelf.m_kUnit) && !kSelf.GetPrimaryTarget().IsFlying())
                {
                    // Suppression reaction fire ignores a percentage of the target's cover
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += ((kSelf.GetPrimaryTarget().m_iCurrentCoverValue * class'XGTacticalGameCore'.default.ContBalance_Normal[0].iScientists1) / 100);
                    kSelf.m_iHitChance_NonUnitTarget -= ((kSelf.GetPrimaryTarget().m_iCurrentCoverValue * class'XGTacticalGameCore'.default.ContBalance_Normal[0].iScientists1) / 100);
                }
            }
        }
    }
    else
    {
        if (kSelf.GetPrimaryTarget().CanUseCover() && kSelf.GetPrimaryTarget().IsInCover() && !kSelf.GetPrimaryTarget().IsFlankedBy(kSelf.m_kUnit) && !kSelf.GetPrimaryTarget().IsFlying())
        {
            if (kSelf.GetPrimaryTarget().IsFlankedByLoc(kSelf.m_kUnit.Location))
            {
                kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += kSelf.GetPrimaryTarget().m_iCurrentCoverValue;
                kSelf.m_iHitChance_NonUnitTarget -= kSelf.GetPrimaryTarget().m_iCurrentCoverValue;
            }
            else if (kSelf.GetPrimaryTarget().GetCharacter().HasUpgrade(`LW_PERK_ID(LowProfile)))
            {
                // Upgrade low cover to full if target has Low Profile
                if (kSelf.GetPrimaryTarget().m_iCurrentCoverValue == `GAMECORE.LOW_COVER_BONUS)
                {
                    kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] -= (`GAMECORE.HIGH_COVER_BONUS - `GAMECORE.LOW_COVER_BONUS);
                    kSelf.m_iHitChance_NonUnitTarget += (`GAMECORE.HIGH_COVER_BONUS - `GAMECORE.LOW_COVER_BONUS);
                }
            }
        }
    }

    if (kSelf.m_iHitChance_NonUnitTarget != 0)
    {
        kSelf.m_iHitChance = kSelf.CalcHitChance();
        kSelf.m_iHitChance = kSelf.CalcHitModFromPerks(kSelf.m_iHitChance, 0.0, false);
        kSelf.m_kUnit.m_aCurrentStats[eStat_Offense] += kSelf.m_iHitChance_NonUnitTarget;
    }

    kSelf.m_iHitChance_NonUnitTarget = 100;

    return kSelf.m_iHitChance;
}

/*
 * For healing abilities, returns the healing amount; for other abilities, returns the modified weapon damage, including
 * the weapon's base damage (if any).
 */
static simulated function int GetPossibleDamage(XGAbility_Targeted kSelf)
{
    local int iPossibleDamage, iHealing;

    if (kSelf.m_kWeapon != none)
    {
        iPossibleDamage = CalculateAbilityModifiedDamage(kSelf) + `LWCE_TWEAPON_FROM_XG(kSelf.m_kWeapon).iDamage;
    }

    if (kSelf.GetType() == eAbility_Mindfray)
    {
        return `LWCE_TACCFG(iMindfrayDamage);
    }

    if (kSelf.GetType() == eAbility_MedikitHeal)
    {
        iHealing = `LWCE_TACCFG(iMedikitHealBase);

        if (kSelf.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Savior)))
        {
            iHealing += `LWCE_TACCFG(iSaviorHealBonus);
        }

        if ((kSelf.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 64) > 0) // Improved Medikit
        {
            iHealing += `LWCE_TACCFG(iImprovedMedikitHealBonus);
        }

        if (kSelf.GetPrimaryTarget().GetCharacter().HasUpgrade(`LW_PERK_ID(SmartMacrophages)))
        {
            iHealing += `LWCE_TACCFG(iSmartMacrophagesHealBonus);
        }

        return iHealing;
    }

    if (kSelf.GetType() == eAbility_RepairSHIV)
    {
        return `LWCE_TACCFG(iRepairHealBaseXCOM);
    }

    if (kSelf.GetType() == eAbility_Repair)
    {
        return `LWCE_TACCFG(iRepairHealBaseAliens);
    }

    return iPossibleDamage;
}

static simulated function float GetRadius(XGAbility_Targeted kSelf)
{
    local int iWeaponId;
    local float fRadius;
    local XGWeapon kWeapon;

    kWeapon = kSelf.m_kWeapon;

    if (kWeapon != none)
    {
        fRadius = kWeapon.m_kTWeapon.iRadius;
        iWeaponId = kWeapon.ItemType(); // TODO: LWCE version of this
    }

    switch (kSelf.GetType())
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
            fRadius = 2.0 * 96.0 * Sqrt(float(kSelf.m_kUnit.ReplicateActivatePerkData_ToString()) / 100.0);
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