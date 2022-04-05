class LWCE_XGAbility_Extensions extends Object
    abstract;

static function CalcDamage(XGAbility_Targeted kSelf)
{
    local EItemType eWeaponGameplayType;
    local int iWeaponItemId;
    local LWCE_XGUnit kPrimTarget, kShooter;
    local bool bDoesSplashDamage;
    local XComWeapon kTemplate;

    kPrimTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());
    kShooter = LWCE_XGUnit(kSelf.m_kUnit);

    if (kSelf.m_kWeapon != none)
    {
        // TODO: change to integer type once all relevant weapon code is rewritten
        eWeaponGameplayType = kSelf.m_kWeapon.GameplayType();
        iWeaponItemId = class'LWCE_XGWeapon_Extensions'.static.GetItemId(kSelf.m_kWeapon);
    }

    if (!`GAMECORE.m_kAbilities.AbilityHasProperty(kSelf.GetType(), eProp_InvulnerableWorld))
    {
        kSelf.m_iActualEnvironmentDamage = `GAMECORE.CalcEnvironmentalDamage(iWeaponItemId, kSelf.GetType(), kShooter.GetCharacter().m_kChar, kShooter.m_aCurrentStats, kSelf.m_bCritical, kSelf.m_bHasHeightAdvantage, kSelf.m_fDistanceToTarget, kSelf.m_bHasFlank);

        if (kShooter.HasPerk(`LW_PERK_ID(Sapper)))
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
            kShooter.LastHitTarget = kPrimTarget;
        }

        switch (kSelf.GetType())
        {
            case eAbility_DeathBlossom:
                kSelf.m_iActualDamage = kShooter.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(DeathBlossomAddedDamage));
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kShooter, kSelf.m_kWeapon);
                break;
            case eAbility_PsiLance:
                kSelf.m_iActualDamage = `GAMECORE.CalcPsiLanceDamage(kShooter, kSelf.GetPrimaryTarget());
                break;
            case eAbility_Mindfray:
                kSelf.m_iActualDamage = `LWCE_TACCFG(iMindfrayDamage);
                break;
            case eAbility_ShotMayhem:
                kSelf.m_iActualDamage = `LWCE_TACCFG(iMayhemDamageBonusForSuppression);
                break;
            case eAbility_BullRush:
                kSelf.m_iActualDamage = kSelf.m_kUnit.m_aCurrentStats[eStat_Damage] + `LWCE_UTILS.RandInRange(`LWCE_TACCFG(BullRushAddedDamage));
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kShooter, kSelf.m_kWeapon);
                break;
            case eAbility_ShredderRocket:
                kSelf.m_iActualEnvironmentDamage *= 0.0;
                // Deliberate case fall-through
            default:
                kSelf.m_iActualDamage = `GAMECORE.CalcOverallDamage(iWeaponItemId, CalculateAbilityModifiedDamage(kSelf), kSelf.m_bCritical, kSelf.m_bReflected);
                break;
        }

        kTemplate = `CONTENTMGR.GetWeaponTemplate(eWeaponGameplayType);

        if (kTemplate != none && kTemplate.ProjectileTemplate != none)
        {
            bDoesSplashDamage = ClassIsChildOf(kTemplate.ProjectileTemplate.MyDamageType, class'XComDamageType_Explosion') && kTemplate.ProjectileTemplate.MyDamageType.default.bCausesFracture;
        }

        if (kPrimTarget != none && !bDoesSplashDamage)
        {
            if (kSelf.m_bHit && !kSelf.HasProperty(eProp_Psionic) && !kSelf.HasProperty(eProp_Stun))
            {
                kSelf.m_iActualDamage = kPrimTarget.AbsorbDamage(kSelf.m_iActualDamage, kShooter, kSelf.m_kWeapon);
            }
        }
    }
}

static function int CalcHitChance(XGAbility_Targeted kSelf)
{
    // TODO testing only
    return CalcHitChance_Original(kSelf);
}

// This function is reverse-engineered from its native version in XGAbility_Targeted.
// It is unmodified and unused; this version is only kept around to see what the native
// version does. Modifications should go in CalcHitChance.
private static function int CalcHitChance_Original(XGAbility_Targeted kSelf)
{
    local int iFinalWill, iHitPenalty;
    local XGUnit kTarget;

    if (kSelf.Role < ROLE_Authority)
    {
        // Native version has some extra logging here, we didn't bother reversing that
        return -1;
    }

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_NoHit))
    {
        return 0;
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_DeadEye))
    {
        return 100;
    }

    kTarget = kSelf.GetPrimaryTarget();

    if (kTarget == none)
    {
        return 0;
    }

    if (!kSelf.m_kGameCore.m_kAbilities.AbilityHasEffect(kSelf.iType, eEffect_Damage) && !kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_PsiRoll))
    {
        return 100;
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_Stun))
    {
        return kSelf.m_kGameCore.CalcStunChance(kTarget, kSelf.m_kUnit, kSelf.m_kWeapon);
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_PsiRoll))
    {
        if (kSelf.iType == eAbility_MindControl)
        {
            iHitPenalty = class'XGTacticalGameCoreNativeBase'.default.MIND_CONTROL_DIFFICULTY;
        }

        return kSelf.m_kUnit.WillTestChance(kTarget.m_aCurrentStats[eStat_Will], iHitPenalty, /* bUseArmorBonus */ true, /* bUseMindShieldBonus */ true, kTarget, /* iEvenStatsChanceToFail */ 50, /* unused */ iFinalWill);
    }

    kTarget.UpdateCoverBonuses(kSelf.m_kUnit);

    // This call is in the native code but its return value is unused; not clear yet if it has side effects
    kTarget.IsAffectedByAbility(eAbility_TakeCover);

    return kSelf.m_kGameCore.CalcBaseHitChance(kSelf.m_kUnit, kTarget, kSelf.m_bReactionFire);
}

static function int CalcHitModFromPerks(XGAbility_Targeted kSelf, int iHitChance, float fDistanceToTarget, bool bHeightAdvantage)
{
    // TODO testing only
    return CalcHitModFromPerks_Original(kSelf, iHitChance, fDistanceToTarget, bHeightAdvantage);
}

// This function is reverse-engineered from its native version in XGAbility_Targeted.
// It is unmodified and unused; this version is only kept around to see what the native
// version does. Modifications should go in CalcHitModFromPerks.
private static function int CalcHitModFromPerks_Original(XGAbility_Targeted kSelf, int iHitChance, float fDistanceToTarget, bool heightAdvantage)
{
    local int Index, iRangeMod;
    local XGUnit kTarget;

    if (kSelf.Role < ROLE_Authority)
    {
        // Some error logging we didn't bother to reverse
        return -1;
    }

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    for (Index = 0; Index < 16; Index++)
    {
        kSelf.m_shotHUDHitChanceStats[Index].m_iAmount = 0;
    }

    kTarget = kSelf.GetPrimaryTarget();

    if (kTarget == none)
    {
        return 0;
    }

    iRangeMod = kSelf.m_kGameCore.CalcRangeModForWeapon(kSelf.m_kWeapon.GameplayType(), kSelf.m_kUnit, kTarget);

    if (iRangeMod != 0)
    {
        kSelf.AddHitChanceStat(iHitChance, iRangeMod, "Range for weapon mods", iRangeMod > 0 ? ePerk_ItemRangeBonus : ePerk_ItemRangePenalty);
    }

    if (kSelf.m_kUnit.IsBeingSuppressed())
    {
        kSelf.AddHitChanceStat(iHitChance, -1 * kSelf.m_kGameCore.CalcSuppression(), "suppression aim penalty", ePerk_SuppressedActive);
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_Flush] != 0 && kSelf.iType == eAbility_ShotFlush)
    {
        kSelf.AddHitChanceStat(iHitChance, 20, "hit chance bonus with flush", ePerk_Flush);
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_GeneMod_Pupils] != 0 && kSelf.m_kUnit.m_bMissedLastShot)
    {
        kSelf.AddHitChanceStat(iHitChance, 10, "hit chance bonus for hyper-reactive pupils", ePerk_GeneMod_Pupils);
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_GeneMod_AdrenalineSurge] != 0 && kSelf.m_kUnit.GetUnitHP() < kSelf.m_kUnit.GetUnitMaxHP())
    {
        kSelf.AddHitChanceStat(iHitChance, 10, "hit chance bonus with adrenaline surge", EPerkType(`LW_PERK_ID(AdrenalineSurge)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(AdrenalineSurge));
    }

    if (kSelf.m_bHasHeightAdvantage)
    {
        if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_DamnGoodGround] != 0)
        {
            kSelf.AddHitChanceStat(iHitChance, 10, "additional hit chance bonus from damn good ground", EPerkType(`LW_PERK_ID(DamnGoodGround)));
            kSelf.m_kUnit.AddBonus(`LW_PERK_ID(DamnGoodGround));
        }

        if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_GeneMod_DepthPerception] != 0)
        {
            kSelf.AddHitChanceStat(iHitChance, 5, "additional hit chance for depth perception", EPerkType(`LW_PERK_ID(DepthPerception)));
            kSelf.m_kUnit.AddBonus(`LW_PERK_ID(DepthPerception));
        }
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_SnapShot] != 0)
    {
        if (kSelf.m_kGameCore.m_arrWeapons[kSelf.m_kWeapon.GameplayType()].aProperties[eWP_MoveLimited] != 0 && kSelf.m_kUnit.m_iMovesActionsPerformed > 0)
        {
            kSelf.AddHitChanceStat(iHitChance, -10, "Snap shot hit chance penalty", EPerkType(`LW_PERK_ID(SnapShot)));
            kSelf.m_kUnit.AddPenalty(`LW_PERK_ID(SnapShot));
        }
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_Executioner] != 0)
    {
        if (kTarget.m_aCurrentStats[eStat_HP] <= 0.5 * (kTarget.m_kCharacter.m_kChar.aStats[eStat_HP] + kTarget.m_aInventoryStats[eStat_HP]))
        {
            kSelf.AddHitChanceStat(iHitChance, 10, "Executioner Perk +20 Aim bonus if enemy has 50% hp or less.", EPerkType(`LW_PERK_ID(Executioner)));
            kSelf.m_kUnit.AddBonus(`LW_PERK_ID(Executioner));
            kTarget.AddPenalty(`LW_PERK_ID(Executioner));

            // Not sure why this is needed when we just added the penalty ourselves
            kTarget.CallUpdateUnitBuffs();
        }
    }

    // No idea why the second check exists here, but it does
    if (kTarget.IsTracerBeamed() && kTarget != kSelf.m_kUnit)
    {
        kSelf.AddHitChanceStat(iHitChance, 10, "tracer beams +aim against all tracer beamed enemies", EPerkType(`LW_PERK_ID(HoloTargeting)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(HoloTargeting));
        kTarget.AddPenalty(`LW_PERK_ID(HoloTargeting));
    }

    if (kSelf.m_kUnit.IsAffectedByAbility(ePerk_GeneMod_Adrenal))
    {
        kSelf.AddHitChanceStat(iHitChance, 10, "adrenal neurosymapthy aim bonus", EPerkType(`LW_PERK_ID(AdrenalNeurosympathy)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(AdrenalNeurosympathy));
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[ePerk_PlatformStability] != 0)
    {
        if (kSelf.m_kUnit.m_iMovesActionsPerformed == 0 || (kSelf.m_kUnit.m_iMovesActionsPerformed == 1 && kSelf.m_kUnit.m_bFreeFireActionTaken) )
        {
            kSelf.AddHitChanceStat(iHitChance, 10, "platform stability aim bonus", EPerkType(`LW_PERK_ID(PlatformStability)));
            kSelf.m_kUnit.AddBonus(`LW_PERK_ID(PlatformStability));
        }
    }

    if (kTarget.m_kCharacter.m_kChar.aUpgrades[ePerk_BodyShield] != 0)
    {
        if (kTarget.GetClosestVisibleEnemy() == kSelf.m_kUnit)
        {
            kSelf.AddHitChanceStat(iHitChance, -20, "Body Shield defense bonus / aim penalty", ePerk_BodyShield);
            kTarget.AddBonus(ePerk_BodyShield);
        }
        else
        {
            kTarget.RemoveBonus(ePerk_BodyShield);
        }
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(Sharpshooter)] != 0 && kTarget.IsInCover() && kTarget.GetCoverType() == CT_Standing)
    {
        kSelf.AddHitChanceStat(iHitChance, kSelf.m_kGameCore.URBAN_AIM, "urban medal aim bonus", EPerkType(`LW_PERK_ID(Sharpshooter)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(Sharpshooter));
    }

    if (kSelf.m_kUnit.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(BandOfWarriors)] != 0)
    {
        kSelf.AddHitChanceStat(iHitChance, kSelf.m_kGameCore.CalcInternationalAimBonus(), "International medal aim bonus", EPerkType(`LW_PERK_ID(BandOfWarriors)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(BandOfWarriors));
    }

    if (kSelf.m_kUnit.HasCouncilFightBonus())
    {
        kSelf.AddHitChanceStat(iHitChance, kSelf.m_kGameCore.COUNCIL_FIGHT_BONUS, "Council medal aim bonus", EPerkType(`LW_PERK_ID(LoneWolf)));
        kSelf.m_kUnit.AddBonus(`LW_PERK_ID(LoneWolf));
    }

    if (kSelf.WorldInfo.NetMode == NM_Standalone && kSelf.m_kGameCore.IsOptionEnabled(eGO_AimingAngles))
    {
        kSelf.AddHitChanceStat(iHitChance, kSelf.m_kGameCore.CalcAimingAngleMod(kSelf.m_kUnit, kTarget), "Aiming angle aim bonus", ePerk_AimingAnglesBonus);
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_Stun))
    {
        // Presumably stun is handled elsewhere
        iHitChance = 100;
    }

    if (kSelf.iType == eAbility_RapidFire)
    {
        iHitChance -= 15;
    }
    else if (kSelf.iType == eAbility_DisablingShot)
    {
        iHitChance -= 10;
    }

    if (kSelf.m_kUnit.m_bWasJustStrangling && kSelf.m_kUnit.m_kCharacter.m_kChar.iType == eChar_Seeker)
    {
        iHitChance -= 50; // Catching Breath
    }

    iHitChance = Clamp(iHitChance, 1, 100);

    return iHitChance;
}

static simulated function int CalculateAbilityModifiedDamage(XGAbility_Targeted kSelf)
{
    local int iWeaponDamage, iTotalDamage, iDamageBonusItemId;
    local int iWeaponItemId;
	local TInventory kInventory;
    local XGWeapon kWeapon;
    local LWCE_TWeapon kTWeapon;
    local LWCE_XGUnit kShooter;

    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    iTotalDamage = kShooter.m_aCurrentStats[eStat_Damage];
	kInventory = kShooter.m_kCEChar.kInventory;
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
        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, iDamageBonusItemId))
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
            if (kShooter.HasPerk(`LW_PERK_ID(Mayhem)))
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
            if (kShooter.HasPerk(`LW_PERK_ID(AlienGrenades)))
            {
                iTotalDamage += 2;
            }
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
        case eAbility_MEC_ProximityMine:
            if (kShooter.HasPerk(`LW_PERK_ID(Sapper)))
            {
                iTotalDamage += `LWCE_TACCFG(iSapperDamageBonus);
            }

            if (kShooter.HasPerk(`LW_PERK_ID(Mayhem)))
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
            if (kShooter.HasPerk(`LW_PERK_ID(Mayhem)))
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

            if (kShooter.HasPerk(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Sniper))
            {
                iTotalDamage += `LWCE_TACCFG(iMayhemDamageBonusForSniperRifles);
            }

            break;
        case eAbility_ShotFlush:
            if (kShooter.HasPerk(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Support)) // LMGs/SAWs
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
            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                iTotalDamage += 3;
            }

            break;
        case eAbility_MEC_KineticStrike:
            if (kShooter.HasPerk(`LW_PERK_ID(MECCloseCombat)))
            {
                iTotalDamage += `LWCE_TACCFG(iMecCloseCombatDamageBonus);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, `LW_ITEM_ID(TheThumper)))
            {
                iTotalDamage += 3;
            }

            // +3 damage for each extra Kinetic Strike Module. Take away 3 because we know there's at least one KSM equipped
            iTotalDamage -= 3;

            if (kInventory.arrLargeItems[1] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kInventory.arrLargeItems[2] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            if (kInventory.arrLargeItems[3] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iTotalDamage += 3;
            }

            break;
    }

    if (kShooter.HasPerk(`LW_PERK_ID(BringEmOn)) && kSelf.m_bCritical)
    {
        iTotalDamage += Min(4, 1 + (kShooter.GetNumSquadVisibleEnemies(kShooter) / 3));
    }

    if (kShooter.HasPerk(`LW_PERK_ID(KillerInstinct)) && kSelf.m_bCritical && kShooter.RunAndGunPerkActive())
    {
        iTotalDamage += ((iWeaponDamage + 2) / 3);
    }

    if (kShooter.HasPerk(`LW_PERK_ID(Ranger)))
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

    if ((kShooter.GetCharacter().m_kChar.aUpgrades[123] & 16) > 0) // Reflex Pistols
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iTotalDamage += `LWCE_TACCFG(iReflexPistolsDamageBonus);
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(VitalPointTargeting)))
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
        if ((kShooter.GetCharacter().m_kChar.aUpgrades[123] & 4) > 0) // Enhanced Plasma
        {
            iTotalDamage += `LWCE_TACCFG(iEnhancedPlasmaDamageBonus);
        }
    }

    if (kSelf.m_bCritical && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, `LW_ITEM_ID(TargetingModule)))
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
            if (VSize(kShooter.Location -kSelf. GetPrimaryTarget().Location) <= float(`TILESTOUNITS(4)))
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexRifle))
        {
            if (kSelf.GetPrimaryTarget().IsFlankedByLoc(kShooter.Location) || kSelf.GetPrimaryTarget().IsFlankedBy(kShooter) || !kSelf.GetPrimaryTarget().IsInCover())
            {
                iTotalDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
        {
            if (VSize(kShooter.Location - kSelf.GetPrimaryTarget().Location) >= float(`TILESTOUNITS(35)))
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

    if (iWeaponItemId == `LW_ITEM_ID(HeavyPlasmaRifle) && kShooter.IsAffectedByAbility(eAbility_Aim))
    {
        iTotalDamage += 1;
    }

    if (kShooter.HasPerk(`LW_PERK_ID(InTheZone)) && kShooter.m_iNumTimesUsedInTheZone > 0)
    {
        iTotalDamage = Max(iTotalDamage - kShooter.m_iNumTimesUsedInTheZone, 1 - iWeaponDamage);
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
    local LWCE_XGUnit kShooter, kTarget;

    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
	kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());

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

    if (kTarget == none)
    {
        return kSelf.m_iHitChance;
    }

    kSelf.m_iHitChance_NonUnitTarget = 0;

    if (kSelf.m_kWeapon.HasProperty(eWP_Pistol) && !kShooter.HasPerk(`LW_PERK_ID(Ranger)))
    {
        if (VSize(kTarget.GetLocation() - kShooter.GetLocation()) > (float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS) * float(64)))
        {
            kShooter.m_aCurrentStats[eStat_Offense] -= int(((VSize(kTarget.GetLocation() - kShooter.GetLocation()) / float(64)) - float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS)) * (float(class'XGTacticalGameCore'.default.HQASSAULT_MAX_DAYS) / float(10)));
            kSelf.m_iHitChance_NonUnitTarget += int(((VSize(kTarget.GetLocation() - kShooter.GetLocation()) / float(64)) - float(class'XGTacticalGameCore'.default.HQASSAULT_MIN_DAYS)) * (float(class'XGTacticalGameCore'.default.HQASSAULT_MAX_DAYS) / float(10)));
        }
    }

    if (kSelf.m_kWeapon.HasProperty(eWP_Rifle) && kSelf.m_kWeapon.HasProperty(eWP_Overheats)) // Battle Rifles
    {
        if (kShooter.m_iMovesActionsPerformed > 0)
        {
            kShooter.m_aCurrentStats[eStat_Offense] -= 10;
            kSelf.m_iHitChance_NonUnitTarget += 10;
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(SnapShot)))
    {
        if (kShooter.GetCharacter().m_kChar.eClass == eSC_Sniper)
        {
            if (kShooter.m_iMovesActionsPerformed >= 1)
            {
                if (!kSelf.m_kWeapon.HasProperty(16) || kShooter.m_bDoubleTapActivated)
                {
                    kShooter.m_aCurrentStats[eStat_Offense] += 10;
                    kSelf.m_iHitChance_NonUnitTarget -= 10;
                }
            }
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(Deadeye)))
    {
        if (kTarget.IsFlying())
        {
            kShooter.m_aCurrentStats[eStat_Offense] += 15;
            kSelf.m_iHitChance_NonUnitTarget -= 15;
        }
    }

    if (kTarget.IsFlankedBy(kShooter))
    {
        if (kTarget.m_bInDenseSmoke)
        {
            kShooter.m_aCurrentStats[eStat_Offense] -= 20;
            kSelf.m_iHitChance_NonUnitTarget += 20;
        }

        if (kTarget.m_bInSmokeBomb)
        {
            kShooter.m_aCurrentStats[eStat_Offense] -= 20;
            kSelf.m_iHitChance_NonUnitTarget += 20;
        }
    }

    if (`GAMECORE.IsOptionEnabled(30)) // Green Fog
    {
        if (!kShooter.IsAI())
        {
            if (class'XGTacticalGameCore'.default.ContBalance_Normal[1].iScientists1 == 1)
            {
                if (`BATTLE.m_iTurn <= class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1)
                {
                    kShooter.m_aCurrentStats[eStat_Offense] -= `BATTLE.m_iTurn;
                    kSelf.m_iHitChance_NonUnitTarget += `BATTLE.m_iTurn;
                }
                else
                {
                    kShooter.m_aCurrentStats[eStat_Offense] -= class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1;
                    kSelf.m_iHitChance_NonUnitTarget += class'XGTacticalGameCore'.default.ContBalance_Normal[1].iEngineers1;
                }
            }
        }
    }

    if (kSelf.m_bReactionFire)
    {
        if (kTarget.CanUseCover())
        {
            if (kTarget.IsFlankedByLoc(kShooter.Location))
            {
                if (!kTarget.IsFlying())
                {
                    // If flanking target on overwatch, remove their cover bonus
                    kShooter.m_aCurrentStats[eStat_Offense] += kTarget.m_iCurrentCoverValue;
                    kSelf.m_iHitChance_NonUnitTarget -= kTarget.m_iCurrentCoverValue;
                }
            }
            else
            {
                if (kTarget.IsSuppressedBy(kShooter) && !kTarget.IsFlying())
                {
                    // Suppression reaction fire ignores a percentage of the target's cover
                    kShooter.m_aCurrentStats[eStat_Offense] += ((kTarget.m_iCurrentCoverValue * class'XGTacticalGameCore'.default.ContBalance_Normal[0].iScientists1) / 100);
                    kSelf.m_iHitChance_NonUnitTarget -= ((kTarget.m_iCurrentCoverValue * class'XGTacticalGameCore'.default.ContBalance_Normal[0].iScientists1) / 100);
                }
            }
        }
    }
    else
    {
        if (kTarget.CanUseCover() && kTarget.IsInCover() && !kTarget.IsFlankedBy(kShooter) && !kTarget.IsFlying())
        {
            if (kTarget.IsFlankedByLoc(kShooter.Location))
            {
                kShooter.m_aCurrentStats[eStat_Offense] += kTarget.m_iCurrentCoverValue;
                kSelf.m_iHitChance_NonUnitTarget -= kTarget.m_iCurrentCoverValue;
            }
            else if (kTarget.HasPerk(`LW_PERK_ID(LowProfile)))
            {
                // Upgrade low cover to full if target has Low Profile
                if (kTarget.m_iCurrentCoverValue == `GAMECORE.LOW_COVER_BONUS)
                {
                    kShooter.m_aCurrentStats[eStat_Offense] -= (`GAMECORE.HIGH_COVER_BONUS - `GAMECORE.LOW_COVER_BONUS);
                    kSelf.m_iHitChance_NonUnitTarget += (`GAMECORE.HIGH_COVER_BONUS - `GAMECORE.LOW_COVER_BONUS);
                }
            }
        }
    }

    if (kSelf.m_iHitChance_NonUnitTarget != 0)
    {
        kSelf.m_iHitChance = CalcHitChance(kSelf);
        kSelf.m_iHitChance = CalcHitModFromPerks(kSelf, kSelf.m_iHitChance, 0.0, false);
        kShooter.m_aCurrentStats[eStat_Offense] += kSelf.m_iHitChance_NonUnitTarget;
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
    local LWCE_XGUnit kShooter, kTarget;

    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());

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

        if (kShooter.HasPerk(`LW_PERK_ID(Savior)))
        {
            iHealing += `LWCE_TACCFG(iSaviorHealBonus);
        }

        // TODO convert to normal perk
        if ((kSelf.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 64) > 0) // Improved Medikit
        {
            iHealing += `LWCE_TACCFG(iImprovedMedikitHealBonus);
        }

        if (kTarget.HasPerk(`LW_PERK_ID(SmartMacrophages)))
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
    local LWCE_XGUnit kShooter;

    kWeapon = kSelf.m_kWeapon;

    if (kWeapon != none)
    {
        fRadius = kWeapon.m_kTWeapon.iRadius;
        iWeaponId = class'LWCE_XGWeapon_Extensions'.static.GetItemId(kWeapon);
        kShooter = LWCE_XGUnit(kWeapon.m_kOwner);
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
            if (kWeapon.m_kOwner != none && kShooter.HasPerk(`LW_PERK_ID(DangerZone)))
            {
                fRadius *= Sqrt(1.60);
            }

            break;
        case `LW_ITEM_ID(HEGrenade):
            if (kWeapon.m_kOwner != none && kShooter.HasPerk(`LW_PERK_ID(AlienGrenades)))
            {
                fRadius *= Sqrt(2.0);
            }

            break;
    }

    return fRadius;
}