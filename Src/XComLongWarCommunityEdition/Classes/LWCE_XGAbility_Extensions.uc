class LWCE_XGAbility_Extensions extends Object
    abstract
    dependson(LWCE_XGUnit);

static function AddCritChanceStat(XGAbility_Targeted kSelf, out int iCritChance, int iDelta, optional int iPerkId, optional string strForceTitle)
{
    local EPerkBuffCategory ePerkCategory;
    local int Index;

    if (iDelta == 0)
    {
        return;
    }

    if (iPerkId < ePerk_MAX)
    {
        kSelf.AddCritChanceStat(iCritChance, iDelta, /* strTitle */, EPerkType(iPerkId));
        return;
    }

    iCritChance += iDelta;

    // Look for an open spot in the HUD listing for this stat
    for (Index = 0; Index < 16; Index++)
    {
        if (kSelf.m_shotHUDCritChanceStats[Index].m_iAmount == 0)
        {
            break;
        }
    }

    if (Index == 16)
    {
        // No room to show this on the HUD, uh oh
        return;
    }

    ePerkCategory = iDelta > 0 ? ePerkBuff_Bonus : ePerkBuff_Penalty;
    kSelf.m_shotHUDCritChanceStats[Index].m_iAmount = iDelta;
    kSelf.m_shotHUDCritChanceStats[Index].m_iPerk = iPerkId;

    if (strForceTitle != "")
    {
        kSelf.m_shotHUDCritChanceStats[Index].m_strTitle = strForceTitle;
    }
    else
    {
        kSelf.m_shotHUDCritChanceStats[Index].m_strTitle = `LWCE_PERKS_TAC.GetPerkName(iPerkId, ePerkCategory);
    }
}

static function AddHitChanceStat(XGAbility_Targeted kSelf, out int iHitChance, int iDelta, optional int iPerkId)
{
    local EPerkBuffCategory ePerkCategory;
    local int Index;

    if (iDelta == 0)
    {
        return;
    }

    if (iPerkId < ePerk_MAX)
    {
        kSelf.AddHitChanceStat(iHitChance, iDelta, /* strTitle */, EPerkType(iPerkId));
        return;
    }

    iHitChance += iDelta;

    // Look for an open spot in the HUD listing for this stat
    for (Index = 0; Index < 16; Index++)
    {
        if (kSelf.m_shotHUDHitChanceStats[Index].m_iAmount == 0)
        {
            break;
        }
    }

    if (Index == 16)
    {
        // No room to show this on the HUD, uh oh
        return;
    }

    ePerkCategory = iDelta > 0 ? ePerkBuff_Bonus : ePerkBuff_Penalty;
    kSelf.m_shotHUDHitChanceStats[Index].m_iAmount = iDelta;
    kSelf.m_shotHUDHitChanceStats[Index].m_iPerk = iPerkId;
    kSelf.m_shotHUDHitChanceStats[Index].m_strTitle = `LWCE_PERKS_TAC.GetPerkName(iPerkId, ePerkCategory);
}

static function int CalcCriticalChance_Original(XGAbility_Targeted kSelf)
{
    local XGUnit kShooter, kTarget;

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_NoHit))
    {
        return 0;
    }

    if (kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_Stun))
    {
        return 0;
    }

    if (kSelf.GetPrimaryTarget() == none)
    {
        return 0;
    }

    if (!kSelf.m_kGameCore.m_kAbilities.AbilityHasProperty(kSelf.iType, eProp_FireWeapon))
    {
        return 0;
    }

    if (kSelf.iType == eAbility_PsiLance || kSelf.iType == eAbility_MEC_Barrage)
    {
        return 0;
    }

    kShooter = kSelf.m_kUnit;
    kTarget = kSelf.GetPrimaryTarget();

    return kSelf.m_kGameCore.CalcCritChance(kSelf.m_kWeapon.GameplayType(),
                                            kShooter.m_kCharacter.m_kChar,
                                            kShooter.m_aCurrentStats,
                                            kTarget,
                                            kShooter,
                                            kTarget.m_iCurrentCoverValue,
                                            kSelf.m_bHasHeightAdvantage,
                                            kSelf.m_fDistanceToTarget,
                                            kSelf.m_bHasFlank,
                                            kSelf.m_bReactionFire,
                                            /* iWeaponBonus */ 0);
}

function int CalcCritModFromPerks_Original(XGAbility_Targeted kSelf, XGAbility_Targeted kAbility, int iCritChance, float fDistanceToTarget, bool heightAdvantage)
{
    local int Index;
    local XGUnit kShooter, kTarget;

    // TODO: is kAbility in the signature just kSelf??
    kShooter = kSelf.m_kUnit;
    kTarget = kSelf.GetPrimaryTarget();

    if (kTarget == none)
    {
        return 0;
    }

    if (kSelf.iCategory == 2)
    {
        return 0;
    }

    for (Index = 0; Index < 16; Index++)
    {
        kSelf.m_shotHUDCritChanceStats[Index].m_iAmount = 0;
    }

    if (kShooter.m_kCharacter.m_kChar.aUpgrades[ePerk_DisablingShot] != 0 && kAbility.iType == eAbility_DisablingShot)
    {
        return 0;
    }

    if (kTarget.m_kCharacter.m_kChar.aUpgrades[ePerk_Resilience] != 0)
    {
        return 0;
    }
}

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

// This function is reverse-engineered from its native version in XGAbility_Targeted.
// It is unmodified and unused; this version is only kept around to see what the native
// version does.
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

static simulated function int GetCriticalChance(XGAbility_Targeted kSelf)
{
    local int Index;
    local TShotInfo kInfo;

    kSelf.m_iCriticalChance = 0;

    GetCritSummary(kSelf, kInfo);

    for (Index = 0; Index < kInfo.arrCritBonusValues.Length; Index++)
    {
        kSelf.m_iCriticalChance += kInfo.arrCritBonusValues[Index];
    }

    for (Index = 0; Index < kInfo.arrCritPenaltyValues.Length; Index++)
    {
        kSelf.m_iCriticalChance += kInfo.arrCritPenaltyValues[Index];
    }

    kSelf.m_iCriticalChance = Clamp(kSelf.m_iCriticalChance, 0, 100);

    return kSelf.m_iCriticalChance;
}

static simulated function GetCritSummary(XGAbility_Targeted kSelf, out TShotInfo kInfo)
{
    local TShotHUDStat kStat;
    local int I, iBackpackItem, iCritStat, iMod;
    local array<int> arrItems;
    local XGParamTag kTag;
    local XGTacticalGameCore kGameCore;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGUnit kShooter, kTarget;
    local XGWeapon kWeapon;

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    kGameCore = XGTacticalGameCore(kSelf.m_kGameCore);
    kPerksMgr = `LWCE_PERKS_TAC;
    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());
    kWeapon = kSelf.m_kWeapon;

    if (!kSelf.ShouldShowCritPercentage())
    {
        return;
    }

    if (kSelf.iType == eAbility_PsiLance || kSelf.iType == eAbility_DisablingShot)
    {
        return;
    }

    if (kSelf.HasProperty(eProp_NoHit) || kSelf.HasProperty(eProp_Stun))
    {
        return;
    }

    if (kTarget == none)
    {
        return;
    }

    if (!kGameCore.m_kAbilities.AbilityHasEffect(kSelf.iType, eEffect_Damage))
    {
        return;
    }

    if (kSelf.m_bReactionFire && !kShooter.HasPerk(`LW_PERK_ID(Opportunist)))
    {
        return;
    }

    if (kWeapon != none && kWeapon.m_kTWeapon.aProperties[eWP_Melee] > 0)
    {
        return;
    }

    if (kTarget.IsHunkeredDown() && !kSelf.m_bHasFlank)
    {
        return;
    }

    if (kTarget.IsStrangling())
    {
        return;
    }

    if (kTarget.HasPerk(`LW_PERK_ID(Resilience)))
    {
        return;
    }

    if (kSelf.m_bReactionFire && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kTarget.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ChameleonSuit)))
    {
        return;
    }

    if (kTarget.HasPerk(`LW_PERK_ID(BodyShield)) && kTarget.GetClosestVisibleEnemy() == kShooter)
    {
        return;
    }

    // Baseline stat
    iCritStat = kShooter.m_aCurrentStats[eStat_CriticalShot];

    if (kShooter.HasBonus(`LW_PERK_ID(Concealment)))
    {
        // When this bonus is applied, the unit's crit chance stat is modified.
        // Just account for this crit chance for now, add it to the shot stats later.
        iCritStat -= 30; // hard-coded because so is the applied bonus
    }

    if (iCritStat > 0)
    {
        // TODO add a string, base game doesn't have one (presumably because only enemies can get crit stat)
        kInfo.arrCritBonusStrings.AddItem("STRING MISSING");
        kInfo.arrCritBonusValues.AddItem(iCritStat);
    }
    else if (iCritStat < 0)
    {
        kInfo.arrCritPenaltyStrings.AddItem("STRING MISSING");
        kInfo.arrCritPenaltyValues.AddItem(iCritStat);
    }

    if (kWeapon != none)
    {
        I = kGameCore.GetTWeapon(kWeapon.ItemType()).iCritical;

        if (I > 0)
        {
            kInfo.arrCritBonusStrings.AddItem(kSelf.m_strBonusCritWeapon);
            kInfo.arrCritBonusValues.AddItem(I);
        }
    }

    kGameCore.GetBackpackItemArray(kShooter.GetCharacter().m_kChar.kInventory, arrItems);
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    for (iBackpackItem = 0; iBackpackItem < arrItems.Length; iBackpackItem++)
    {
        iMod = kGameCore.GetUpgradeAbilities(arrItems[iBackpackItem], eStat_CriticalShot);
        kTag.StrValue0 = kGameCore.GetTWeapon(arrItems[iBackpackItem]).strName;

        if (arrItems[iBackpackItem] == `LW_ITEM_ID(TargetingModule) ||
            arrItems[iBackpackItem] == `LW_ITEM_ID(AlloyBipod) ||
            arrItems[iBackpackItem] == `LW_ITEM_ID(NeuralGunlink) ||
            arrItems[iBackpackItem] == `LW_ITEM_ID(IlluminatorGunsight))
        {
            if (kWeapon.HasProperty(eWP_Pistol))
            {
                iMod = 0;
            }
        }

        if (iMod > 0)
        {
            kInfo.arrCritBonusStrings.AddItem(class'XComLocalizer'.static.ExpandString(kSelf.m_strItemBonus));
            kInfo.arrCritBonusValues.AddItem(iMod);
        }
        else if (iMod < 0)
        {
            kInfo.arrCritPenaltyStrings.AddItem(class'XComLocalizer'.static.ExpandString(kSelf.m_strItemPenalty));
            kInfo.arrCritPenaltyValues.AddItem(iMod);
        }
    }

    if (!kTarget.m_bInSmokeBomb && !kTarget.IsFlying())
    {
        if (kSelf.m_bHasFlank || !kTarget.IsInCover())
        {
            if (kSelf.m_bHasFlank)
            {
                kInfo.arrCritBonusStrings.AddItem(kSelf.m_strBonusFlanking);
            }
            else
            {
                kInfo.arrCritBonusStrings.AddItem(kSelf.m_strBonusCritEnemyNotInCover);
            }

            kInfo.arrCritBonusValues.AddItem(kGameCore.GetFlankingCritBonus(true));
        }
    }

    if (kTarget.IsHardened())
    {
        kInfo.arrCritPenaltyStrings.AddItem(kSelf.m_strPenaltyCritEnemyHardened);

        if (kWeapon.ItemType() != `LW_ITEM_ID(GaussLongRifle))
        {
            kInfo.arrCritPenaltyValues.AddItem(-1 * kGameCore.GetHardenedCritBonus());
        }
        else
        {
            kInfo.arrCritPenaltyValues.AddItem(-1 * kGameCore.GetHardenedCritBonus() / 2);
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(Executioner)) && kTarget.IsInExecutionerRange())
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Executioner)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iExecutionerCritChanceBonus));
    }

    for (I = 0; I < 16; I++)
    {
        kStat = kSelf.m_shotHUDCritChanceStats[I];

        if (kStat.m_iAmount != 0)
        {
            if (kStat.m_iPerk == `LW_PERK_ID(MagPistols)) // Mag Pistols
            {
                kStat.m_strTitle = kSelf.m_strBonusCritPistol;
            }

            if (kStat.m_iPerk == `LW_PERK_ID(CombatDrugs))
            {
                kStat.m_iAmount = `LWCE_TACCFG(iCombatDrugsCritChanceBonus);
            }

            if (kStat.m_iPerk == `LW_PERK_ID(PrecisionShot))
            {
                if (kStat.m_iAmount > 0)
                {
                    kInfo.arrCritBonusStrings.AddItem(kStat.m_strTitle);
                    kInfo.arrCritBonusValues.AddItem(kStat.m_iAmount);
                }
                else
                {
                    kInfo.arrCritPenaltyStrings.AddItem(kStat.m_strTitle);
                    kInfo.arrCritPenaltyValues.AddItem(kStat.m_iAmount);
                }
            }
        }
    }

    if (kShooter.IsAffectedByAbility(eAbility_AdrenalNeurosympathy))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(AdrenalNeurosympathy)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iAdrenalNeurosympathyCritChanceBonus));
    }

    if (!kShooter.IsVisibleEnemy(kTarget))
    {
        // Take squadsight crit penalty unless performing Precision Shot with a sniper rifle
        if (kSelf.iType != eAbility_PrecisionShot || kWeapon.HasProperty(eWP_Overheats))
        {
            kInfo.arrCritPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(SquadSight)));
            kInfo.arrCritPenaltyValues.AddItem(`LWCE_TACCFG(iSquadsightCritChancePenalty));
        }
    }

    if (kShooter.HasBonus(`LW_PERK_ID(Concealment)))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Concealment)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iConcealmentCritChanceBonus));
    }

    if (kShooter.HasPerk(`LW_PERK_ID(Sharpshooter)))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Sharpshooter)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iSharpshooterCritChanceBonus));
    }

    if (kShooter.HasPerk(`LW_PERK_ID(SCOPEUpgrade)) && !kWeapon.HasProperty(eWP_Pistol))
    {
        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kShooter.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(LaserSight)))
        {
            kInfo.arrCritBonusStrings.AddItem(kGameCore.GetTWeapon(`LW_ITEM_ID(LaserSight)).strName);
            kInfo.arrCritBonusValues.AddItem(class'XGTacticalGameCore'.default.FOUNDRY_SCOPE_CRIT_BONUS / 2);
        }

        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kShooter.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(SCOPE)))
        {
            kInfo.arrCritBonusStrings.AddItem(kGameCore.GetTWeapon(`LW_ITEM_ID(SCOPE)).strName);
            kInfo.arrCritBonusValues.AddItem(class'XGTacticalGameCore'.default.FOUNDRY_SCOPE_CRIT_BONUS);
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(InTheZone)))
    {
        if (kShooter.m_iNumTimesUsedInTheZone > 0)
        {
            kInfo.arrCritPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(InTheZone)));
            kInfo.arrCritPenaltyValues.AddItem(kShooter.m_iNumTimesUsedInTheZone * `LWCE_TACCFG(iInTheZoneCritPenaltyPerShot));
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(LoneWolf)) && kShooter.HasBonus(`LW_PERK_ID(LoneWolf)))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(LoneWolf)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iLoneWolfCritChanceBonus));
    }

    if (kShooter.HasPerk(`LW_PERK_ID(Aggression)) && kShooter.HasBonus(`LW_PERK_ID(Aggression)))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Aggression)));
        kInfo.arrCritBonusValues.AddItem(kShooter.GetAggressionBonus());
    }

    if (kShooter.HasPerk(`LW_PERK_ID(DepthPerception)) && kShooter.HasHeightAdvantageOver(kTarget))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(DepthPerception)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iDepthPerceptionCritChanceBonus));
    }

    if (kShooter.HasPerk(`LW_PERK_ID(PlatformStability)) && kShooter.m_iMovesActionsPerformed == 0)
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(PlatformStability)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iPlatformStabilityCritChanceBonus));
    }

    if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kShooter.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ReaperPack)))
    {
        if (kWeapon != none && !kWeapon.HasProperty(eWP_Pistol))
        {
            kInfo.arrCritBonusStrings.AddItem(kGameCore.GetTWeapon(`LW_ITEM_ID(ReaperPack)).strName);
            kInfo.arrCritBonusValues.AddItem(16); // TODO: replace this with a stat from Reaper Pack itself
        }
    }

    if (kShooter.HasPerk(`LW_PERK_ID(AdrenalineSurge)) && kShooter.HasBonus(`LW_PERK_ID(AdrenalineSurge)))
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(AdrenalineSurge)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iAdrenalineSurgeCritChanceBonus));
    }

    if (kShooter.m_bInCombatDrugs)
    {
        kInfo.arrCritBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(CombatDrugs)));
        kInfo.arrCritBonusValues.AddItem(`LWCE_TACCFG(iCombatDrugsCritChanceBonus));
    }

    `LWCE_MOD_LOADER.AddCritChanceModifiers(kSelf, kInfo);
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
    local TShotInfo kInfo;
    local TShotResult kResult;
    local int Index;

    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());

    if (kSelf.HasProperty(eProp_PsiRoll))
    {
        kSelf.m_iHitChance = GetPsiHitChance(kSelf);
        return kSelf.m_iHitChance;
    }

    for (Index = 0; Index < 16; Index++)
    {
        kSelf.m_shotHUDHitChanceStats[Index].m_iAmount = 0;
    }

    GetShotSummary(kSelf, kResult, kInfo);

    for (Index = 0; Index < kInfo.arrHitBonusValues.Length; Index++)
    {
        kSelf.m_iHitChance += kInfo.arrHitBonusValues[Index];
    }

    for (Index = 0; Index < kInfo.arrHitPenaltyValues.Length; Index++)
    {
        kSelf.m_iHitChance += kInfo.arrHitPenaltyValues[Index];
    }

    // Reaction fire logic is split between this and RollForHit for some reason. It would be nice to consolidate, but
    // since we clamp the hit chance in this function, that could technically result in a behavior change.
    if (kSelf.m_bReactionFire && kTarget != none && !kShooter.HasPerk(`LW_PERK_ID(Opportunist)) && !kShooter.HasPerk(`LW_PERK_ID(AdvancedFireControl)))
    {
        if (kTarget.m_bDashing)
        {
            kSelf.m_iHitChance *= `LWCE_TACCFG(fReactionFireAimMultiplierDashing);
        }
        else
        {
            kSelf.m_iHitChance *= `LWCE_TACCFG(fReactionFireAimMultiplier);
        }
    }

    kSelf.m_iHitChance = Clamp(kSelf.m_iHitChance, 1, 100);
    kSelf.m_iHitChance_NonUnitTarget = 100;

    return kSelf.m_iHitChance;
}

static simulated function int GetPsiHitChance(XGAbility_Targeted kSelf)
{
    local bool bIncludeBaseWill, bIncludeNeuralDamping, bIncludeCombatStims;
    local int iAttackerWill, iDefenderWill, iFinalWillMod, iHitChance, iHitChanceModifier, iTemp;
    local LWCE_XGUnit kAttacker, kDefender;

    if (!kSelf.HasProperty(eProp_PsiRoll))
    {
        return -1;
    }

    kAttacker = LWCE_XGUnit(kSelf.m_kUnit);
    kDefender = LWCE_XGUnit(kSelf.GetPrimaryTarget());

    if (kDefender == none)
    {
        return -1;
    }

    if (kSelf.iType == eAbility_PsiPanic && kDefender.HasPerk(`LW_PERK_ID(NeuralDamping)))
    {
        return 0;
    }

    // Apply a per-ability hit penalty
    switch (kSelf.iType)
    {
        case eAbility_Mindfray:
            iHitChanceModifier = `LWCE_TACCFG(iMindfrayHitModifier);
            break;
        case eAbility_PsiPanic:
            iHitChanceModifier = `LWCE_TACCFG(iPsiPanicHitModifier);
            break;
        case eAbility_MindControl:
        case eAbility_PsiControl:
            iHitChanceModifier = `LWCE_TACCFG(iMindControlHitModifier);
            break;
        default:
            iHitChanceModifier = 0;
            break;
    }

    // Determine the will of both units. Since we're using a native method to do the actual will test, and that
    // native method already accounts for the base unit will, we never include that ourselves.
    bIncludeBaseWill = false;
    bIncludeNeuralDamping = true;
    bIncludeCombatStims = kSelf.iType == eAbility_PsiPanic; // Stims only help on panic

    iDefenderWill = kDefender.GetSituationalWill(bIncludeBaseWill, bIncludeNeuralDamping, bIncludeCombatStims);
    iAttackerWill = kAttacker.GetSituationalWill(bIncludeBaseWill, false, false); // Attacker doesn't get these bonuses ever

    // Will vs will, plus any modifier on the ability itself
    iFinalWillMod = iAttackerWill - iDefenderWill + iHitChanceModifier;

    // Since the native function WillTestChance has some modifiers based on the game difficulty, we have to
    // temporarily set the difficulty to 0, then set it back right after
    iTemp = `BATTLE.m_kDesc.m_iDifficulty;
    `BATTLE.m_kDesc.m_iDifficulty = 0;
    iHitChance = kAttacker.WillTestChance(0, iFinalWillMod, false, false, kDefender);
    `BATTLE.m_kDesc.m_iDifficulty = iTemp;

    `LWCE_LOG_CLS("GetPsiHitChance: iDefenderWill = " $ iDefenderWill $ ", iAttackerWill = " $ iAttackerWill $ ", iHitChanceModifier = " $ iHitChanceModifier $ ", iHitChance = " $ iHitChance);

    return iHitChance;
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

static simulated function int GetScatterChance(XGAbility_Targeted kSelf, float fUnrealDist)
{
    local int iEffectiveAim;
    local float fScatter;
    local LWCE_XGUnit kShooter;

    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    iEffectiveAim = kShooter.GetOffense();

    if (kShooter.HasPerk(`LW_PERK_ID(PlatformStability)) && kShooter.m_iMovesActionsPerformed == 0)
    {
        iEffectiveAim += `LWCE_TACCFG(iPlatformStabilityAimBonusForRockets);
    }

    if (kShooter.HasPerk(`LW_PERK_ID(FireInTheHole)) && kShooter.m_iMovesActionsPerformed == 0)
    {
        iEffectiveAim += `LWCE_TACCFG(iFireInTheHoleAimBonusForRockets);
    }

    iEffectiveAim = Clamp(iEffectiveAim, 0, 120);
    fScatter = class'XGTacticalGameCore'.default.MIN_SCATTER * ( (120.0f - iEffectiveAim) / 120.0f );

    // I have no idea where most of this comes from
    fScatter *= (fUnrealDist / (20.0f * 64.0f));
    fScatter /= 1.50f;
    fScatter *= Sqrt(2.0f);
    fScatter *= 10.0f;

    if (kShooter.m_iMovesActionsPerformed > 0)
    {
        if (kShooter.HasPerk(`LW_PERK_ID(SnapShot)))
        {
            fScatter *= `LWCE_TACCFG(fRocketScatterMultiplierAfterMoveWithSnapShot);
        }
        else
        {
            fScatter *= `LWCE_TACCFG(fRocketScatterMultiplierAfterMove);
        }
    }

    kSelf.m_iHitChance = int(fScatter);
    return kSelf.m_iHitChance;
}

static simulated function GetShotSummary(XGAbility_Targeted kSelf, out TShotResult kResult, out TShotInfo kInfo)
{
    local float fDistanceToTarget, fOverDistance;
    local int iBackpackItem, iDefense, iMod, iType;
    local array<int> arrItems;
    local XGParamTag kTag;
    local LWCE_XGUnit kShooter, kTarget;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGTacticalGameCore kGameCore;
    local XGWeapon kWeapon;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());
    kWeapon = kSelf.m_kWeapon;
    kPerksMgr = `LWCE_PERKS_TAC;
    iType = kSelf.iType;

    // TODO: we might need to be clearing unit buffs and applying bonuses/penalties here

    if (kSelf.HasProperty(eProp_PsiRoll))
    {
        // TODO
        return;
    }

    if (kWeapon == none)
    {
        return;
    }

    if (kTarget == none)
    {
        return;
    }

    kResult.strTargetName = kTarget.SafeGetCharacterName();

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    kSelf.m_iHitChance_NonUnitTarget = 100;

    if (kSelf.ShouldShowPercentage())
    {
        kResult.iPossibleDamage = -1 * GetPossibleDamage(kSelf);
    }
    else if (iType == eAbility_MedikitHeal || iType == eAbility_RepairSHIV || iType == eAbility_Repair)
    {
        kResult.iPossibleDamage = GetPossibleDamage(kSelf);
    }

    kResult.bKillshot = (kTarget.GetUnitHP() + kResult.iPossibleDamage) <= 0;

    if (kTarget.m_bVIP) // Probably right, needs confirmation
    {
        if (kTarget.m_kCharacter.m_kChar.iType == eChar_Civilian || kShooter.m_kCharacter.m_kChar.aProperties[eCP_MeleeOnly] != 0)
        {
            kInfo.arrHitBonusStrings.AddItem(kSelf.m_strBonusAim);
            kInfo.arrHitBonusValues.AddItem(100);
            return;
        }
    }

    if (kSelf.HasProperty(eProp_Stun))
    {
        kInfo.arrHitBonusStrings.AddItem(kSelf.m_strChanceToStun);

        if (iType == eAbility_ShotStun)
        {
            // Arc Thrower stun
            // TODO probably broken with the rewrite
            kInfo.arrHitBonusValues.AddItem(int(float(kSelf.m_iHitChance) * class'XGTacticalGameCore'.default.UFO_PSI_LINK_SURVIVE));
        }
        else
        {
            // This should only be drone hacking
            kInfo.arrHitBonusValues.AddItem(kSelf.m_iHitChance);
        }

        // Nothing else applies to these abilities
        return;
    }

    // No more special cases, now we can calculate the hit chance
    kGameCore = LWCE_XGTacticalGameCore(kSelf.m_kGameCore);
    fDistanceToTarget = VSize(kTarget.GetLocation() - kShooter.GetLocation());

    // Baseline unit aim
    iMod = kShooter.m_aCurrentStats[eStat_Offense];

    if (iMod > 0)
    {
        kInfo.arrHitBonusStrings.AddItem(kSelf.m_strBonusAim);
        kInfo.arrHitBonusValues.AddItem(iMod);
    }
    else if (iMod < 0)
    {
        // No idea who would mod the game to give someone negative aim, but may as well handle it
        kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strBonusAim);
        kInfo.arrHitPenaltyValues.AddItem(iMod);
    }

    // Weapon aim
    // TODO localization might not be needed here
    if (kWeapon != none)
    {
        iMod = kGameCore.GetWeaponStatBonus(eStat_Offense, kWeapon.ItemType(), kShooter.GetCharacter().m_kChar);

        if (iMod > 0)
        {
            kTag.StrValue0 = kWeapon.m_kTWeapon.strName;
            kInfo.arrHitBonusStrings.AddItem(class'XComLocalizer'.static.ExpandString(kSelf.m_strItemBonus));
            kInfo.arrHitBonusValues.AddItem(iMod);
        }
        else if (iMod < 0)
        {
            kTag.StrValue0 = kWeapon.m_kTWeapon.strName;
            kInfo.arrHitPenaltyStrings.AddItem(class'XComLocalizer'.static.ExpandString(kSelf.m_strItemPenalty));
            kInfo.arrHitPenaltyValues.AddItem(iMod);
        }
    }

    // Aim modifiers from small items
    kGameCore.GetBackpackItemArray(kShooter.GetCharacter().m_kChar.kInventory, arrItems);

    for (iBackpackItem = 0; iBackpackItem < arrItems.Length; iBackpackItem++)
    {
        if (kWeapon != none && !kWeapon.HasProperty(eWP_Pistol))
        {
            iMod = kGameCore.GetUpgradeAbilities(arrItems[iBackpackItem], eStat_Offense);
            //kTag.StrValue0 = kGameCore.GetTWeapon(arrItems[iBackpackItem]).strName; // TODO

            if (iMod > 0)
            {
                kInfo.arrHitBonusStrings.AddItem(kGameCore.GetTWeapon(arrItems[iBackpackItem]).strName);
                kInfo.arrHitBonusValues.AddItem(iMod);
            }
            else if (iMod < 0)
            {
                kInfo.arrHitPenaltyStrings.AddItem(kGameCore.GetTWeapon(arrItems[iBackpackItem]).strName);
                kInfo.arrHitPenaltyValues.AddItem(iMod);
            }
        }
    }

    // Target's cover
    kTarget.UpdateCoverBonuses(kShooter);
    `LWCE_LOG_CLS("Before accounting for cover");

    if (!kTarget.IsFlankedBy(kShooter) && !kTarget.IsFlankedByLoc(kShooter.Location) && kTarget.IsInCover())
    {
        `LWCE_LOG_CLS("Accounting for cover");

        // Add cover; XGUnit.m_iCurrentCoverValue includes more than just cover for some reason, like smoke, so don't use it
        iMod = kTarget.GetTrueCoverValue(kShooter);

        if (iMod == kGameCore.LOW_COVER_BONUS)
        {
            kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strPenaltyLowCover);
        }
        else
        {
            kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strPenaltyHighCover);
        }

        kInfo.arrHitPenaltyValues.AddItem(-1 * iMod);

        // Hunker Down bonus
        if (kTarget.IsAffectedByAbility(eAbility_TakeCover))
        {
            kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strHunker);
            kInfo.arrHitPenaltyValues.AddItem(-1 * iMod);
        }

        // Upgrade low cover to full if target has Low Profile
        // TODO: how is this supposed to interact with Hunker Down?
        if (kTarget.HasPerk(`LW_PERK_ID(LowProfile)))
        {
            if (iMod == kGameCore.LOW_COVER_BONUS)
            {
                iMod = kGameCore.HIGH_COVER_BONUS - kGameCore.LOW_COVER_BONUS;

                kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(LowProfile)));
                kInfo.arrHitPenaltyValues.AddItem(iMod);
            }
        }

        `LWCE_LOG_CLS("kSelf.m_bReactionFire: " $ kSelf.m_bReactionFire);
        `LWCE_LOG_CLS("kTarget.IsSuppressedBy(kShooter): " $ kTarget.IsSuppressedBy(kShooter));
        // TODO: this needs more testing
        if (kSelf.m_bReactionFire && kTarget.IsSuppressedBy(kShooter))
        {
            // Suppression reaction fire ignores a percentage of the target's cover
            iMod = kTarget.GetTrueCoverValue(kShooter) - int(kTarget.GetTrueCoverValue(kShooter) * (`LWCE_TACCFG(fSuppressionReactionFireCoverPenetration) / 100.0f));
            `LWCE_LOG_CLS("Suppression: iMod = " $ iMod);

            if (iMod > 0)
            {
                kInfo.arrHitBonusStrings.AddItem(""); // never visible to player
                kInfo.arrHitBonusValues.AddItem(iMod);
            }
        }
    }

    // Baseline unit defense
    iDefense = kTarget.GetCharacter().m_kChar.aStats[eStat_Defense] + kGameCore.GetArmorStatBonus(eStat_Defense, kTarget.GetCharacter().m_kChar.kInventory.iArmor, kTarget.GetCharacter().m_kChar);
    `LWCE_LOG_CLS("Unit defense: " $ iDefense);

    if (iDefense > 0)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strPenaltyDefense);
        kInfo.arrHitPenaltyValues.AddItem(-1 * iDefense);
    }
    else if (iDefense < 0)
    {
        kInfo.arrHitBonusStrings.AddItem(kSelf.m_strPenaltyDefense);
        kInfo.arrHitBonusValues.AddItem(-1 * iDefense);
    }

    // Flying units
    if (kTarget.HasAirEvadeBonus())
    {
        kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strPenaltyEvasion);
        kInfo.arrHitPenaltyValues.AddItem(-1 * kGameCore.AIR_EVADE_DEF);
    }

    // Acid
    if (kShooter.IsPoisoned())
    {
        kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strPoison);
        kInfo.arrHitPenaltyValues.AddItem(-1 * kGameCore.POISONED_AIM_PENALTY);
    }

    // Adrenal Neurosympathy
    if (kShooter.IsAffectedByAbility(eAbility_AdrenalNeurosympathy))
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(AdrenalNeurosympathy)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iAdrenalNeurosympathyAimBonus));
    }

    // Adrenaline Surge
    if (kShooter.HasBonus(`LW_PERK_ID(AdrenalineSurge)))
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(AdrenalineSurge)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iAdrenalineSurgeAimBonus));
    }

    // Aiming Angles
    if (kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(AimingAngles)))
    {
        iMod = kGameCore.CalcAimingAngleMod(kShooter, kTarget);

        if (iMod > 0)
        {
            kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(AimingAngles)));
            kInfo.arrHitBonusValues.AddItem(iMod);
        }
    }

    // Automated Threat Assessment
    if (kTarget.HasBonus(`LW_PERK_ID(AutomatedThreatAssessment)))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(AutomatedThreatAssessment)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iAutomatedThreatAssessmentDefenseBonus));
    }

    // Band of Warriors (officer perk)
    if (kShooter.HasPerk(`LW_PERK_ID(BandOfWarriors)))
    {
        iMod = kSelf.m_kGameCore.CalcInternationalAimBonus();

        if (iMod > 0)
        {
            kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(BandOfWarriors)));
            kInfo.arrHitBonusValues.AddItem(iMod);
        }
    }

    // Battle Rifle movement penalty
    if (kSelf.m_kWeapon.HasProperty(eWP_Rifle) && kSelf.m_kWeapon.HasProperty(eWP_Overheats))
    {
        if (kShooter.m_iMovesActionsPerformed > 0)
        {
            kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strFlankText);
            kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iBattleRifleSecondActionAimPenalty));
        }
    }

    // Blood Call
    if (kShooter.HasBonus(`LW_PERK_ID(BloodCall)))
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(BloodCall)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iBloodCallAimBonus));
    }

    // Body Shield
    if (kTarget.HasPerk(`LW_PERK_ID(BodyShield)) && kTarget.GetClosestVisibleEnemy() == kShooter)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(BodyShield)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iBodyShieldAimPenalty));
    }

    // Catching Breath
    if (kShooter.m_bWasJustStrangling && kShooter.GetCharType() != eChar_Seeker)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.m_strPenaltyTitle[ePerk_CatchingBreath]);
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iCatchingBreathAimPenalty));
    }

    // Damn Good Ground (for target)
    if (kTarget.HasBonus(`LW_PERK_ID(DamnGoodGround)) && kTarget.HasHeightAdvantageOver(kShooter))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(DamnGoodGround)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iDamnGoodGroundDefenseBonus));
    }

    // Deadeye bonus vs flyers
    if (kShooter.HasPerk(`LW_PERK_ID(Deadeye)) && kTarget.IsFlying())
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Deadeye)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iDeadeyeAimBonus));
    }

    // Disabling Shot penalty
    if (iType == eAbility_DisablingShot)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(DisablingShot)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iDisablingShotAimPenalty));
    }

    // Disoriented (Flashbangs)
    if (kShooter.HasPenalty(`LW_PERK_ID(Disoriented)))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(Disoriented)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iDisorientedAimPenalty));
    }

    // Distortion Field
    if (kTarget.HasBonus(`LW_PERK_ID(DistortionField)))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(DistortionField)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iDistortionFieldDefenseBonus));
    }

    // Esprit de Corps
    if (kTarget.m_kSquad != none && kTarget.m_kSquad.SquadHasStarOfTerra(/* PowerA */ true))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(EspritDeCorps)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iEspritDeCorpsDefenseBonus));
    }

    // Executioner
    if (kShooter.HasPerk(`LW_PERK_ID(Executioner)) && kTarget.IsInExecutionerRange())
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Executioner)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iExecutionerAimBonus));
    }

    // Flush
    if (iType == eAbility_ShotFlush)
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Flush)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iFlushAimBonus));
    }

    // Green Fog second wave option: aim penalty per turn of battle
    if (kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(GreenFog)))
    {
        if (!kShooter.IsAI())
        {
            iMod = int(`BATTLE.m_iTurn * `LWCE_TACCFG(fGreenFogAimLossPerTurn));
            iMod = Clamp(iMod, `LWCE_TACCFG(iGreenFogMaximumAimLoss), 0);

            if (iMod < 0)
            {
                kInfo.arrHitPenaltyStrings.AddItem(kSelf.m_strBonusCritDistance);
                kInfo.arrHitPenaltyValues.AddItem(iMod);
            }
        }
    }

    // Height advantage (for shooter)
    if (kShooter.HasHeightAdvantageOver(kTarget))
    {
        kInfo.arrHitBonusStrings.AddItem(kSelf.m_strHeightBonus);
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iHeightAdvantageAimBonus));

        if (kShooter.HasPerk(`LW_PERK_ID(DamnGoodGround)))
        {
            kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(DamnGoodGround)));
            kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iDamnGoodGroundAimBonus));
        }

        if (kShooter.HasPerk(`LW_PERK_ID(DepthPerception)))
        {
            kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(DepthPerception)));
            kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iDepthPerceptionAimBonus));
        }
    }

    // Holo-Targeting
    if (kTarget.IsTracerBeamed())
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(HoloTargeting)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iHoloTargetingAimBonus));
    }

    // Hyper-Reactive Pupils
    if (kShooter.HasBonus(`LW_PERK_ID(HyperReactivePupils)))
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(HyperReactivePupils)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iHyperReactivePupilsAimBonus));
    }

    // Lone Wolf
    if (kShooter.HasPerk(`LW_PERK_ID(LoneWolf)) && kShooter.HasBonus(`LW_PERK_ID(LoneWolf)))
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(LoneWolf)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iLoneWolfAimBonus));
    }

    // Mindfray
    // TODO: Mindfray is supposed to stack, how is that done?
    if (kShooter.HasPenalty(`LW_PERK_ID(Mindfray)))
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(Mindfray)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iMindfrayAimPenalty));
    }

    // Platform Stability
    if (kShooter.HasPerk(`LW_PERK_ID(PlatformStability)) && kShooter.m_iMovesActionsPerformed == 0)
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(PlatformStability)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iPlatformStabilityAimBonus));
    }

    // Rapid Fire penalty
    if (iType == eAbility_RapidFire)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(RapidFire)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iRapidFireAimPenalty));
    }

    // Red Fog
    if (kShooter.m_iBWAimPenalty != 0)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(BattleFatigue)));
        kInfo.arrHitPenaltyValues.AddItem(kShooter.m_iBWAimPenalty);
    }

    // Semper Vigilans
    // TODO: does Semper Vigilans still apply if flanked?
    if (kTarget.HasBonus(`LW_PERK_ID(SemperVigilans)) && kTarget.IsInCover())
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(SemperVigilans)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iSemperVigilansDefenseBonus));
    }

    // Sharpshooter
    if (kShooter.HasPerk(`LW_PERK_ID(Sharpshooter)) && kTarget.GetTrueCoverValue(kShooter) == kGameCore.HIGH_COVER_BONUS)
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetBonusTitle(`LW_PERK_ID(Sharpshooter)));
        kInfo.arrHitBonusValues.AddItem(`LWCE_TACCFG(iSharpshooterAimBonus));
    }

    // Smoke grenades
    if (kTarget.m_bInSmokeBomb)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(SmokeGrenade)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iSmokeGrenadeDefenseBonus));

        // Smoke with Dense Smoke perk
        if (kTarget.m_bInDenseSmoke)
        {
            kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(DenseSmoke)));
            kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iDenseSmokeDefenseBonus));
        }
    }

    // Snap Shot movement penalty for sniper rifles
    if (kShooter.HasPerk(`LW_PERK_ID(SnapShot)))
    {
        // Note that LMGs are also MoveLimited weapons, so if a mod gives Snap Shot to an LMG unit, they'll also get this penalty
        if (kWeapon.HasProperty(eWP_MoveLimited) && kShooter.m_iMovesActionsPerformed > 0 && !kShooter.m_bDoubleTapActivated)
        {
            kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(SnapShot)));
            kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iSnapShotAimPenalty));
        }
    }

    // Suppression
    if (kShooter.IsBeingSuppressed())
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(Suppression)));
        kInfo.arrHitPenaltyValues.AddItem(`LWCE_TACCFG(iSuppressionAimPenalty));
    }

    // Tactical Sense
    if (kTarget.HasPerk(`LW_PERK_ID(TacticalSense)) && kTarget.GetTacticalSenseCoverBonus() > 0)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(ePerk_TacticalSense));
        kInfo.arrHitPenaltyValues.AddItem(-1 * kTarget.GetTacticalSenseCoverBonus());
    }

    // Telekinetic Field
    if (kTarget.IsInTelekineticField())
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(TelekineticField)));
        kInfo.arrHitPenaltyValues.AddItem(-1 * `LWCE_TACCFG(iTelekineticFieldDefenseBonus));
    }

    // Weapon range penalties
    iMod = kGameCore.CalcRangeModForWeapon(class'LWCE_XGWeapon_Extensions'.static.GetItemId(kWeapon), kShooter, kTarget);

    if (kWeapon.HasProperty(eWP_Pistol))
    {
        // With Ranger: negate the range penalty
        if (iMod < 0 && kShooter.HasPerk(`LW_PERK_ID(Ranger)))
        {
            iMod = 0;
        }

        // Without Ranger: use a custom range calculation for penalties (not for bonuses)
        if (!kShooter.HasPerk(`LW_PERK_ID(Ranger)))
        {
            fOverDistance = (fDistanceToTarget - `LWCE_TACCFG(fPistolMaxEffectiveRange)) / 64.0f;

            if (fOverDistance > 0.0f)
            {
                iMod = int(fOverDistance * `LWCE_TACCFG(fPistolAimPenaltyPerMeter));
            }
        }
    }

    if (iMod > 0)
    {
        kInfo.arrHitBonusStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(RangeBonus)));
        kInfo.arrHitBonusValues.AddItem(iMod);
    }
    else if (iMod < 0)
    {
        kInfo.arrHitPenaltyStrings.AddItem(kPerksMgr.GetPenaltyTitle(`LW_PERK_ID(RangePenalty)));
        kInfo.arrHitPenaltyValues.AddItem(iMod);
    }

    `LWCE_MOD_LOADER.AddHitChanceModifiers(kSelf, kInfo);

    if (kSelf.ShouldShowCritPercentage())
    {
        GetCritSummary(kSelf, kInfo);
    }
}

static simulated function GetUIHitChance(XGAbility_Targeted kSelf, out int iUIHitChance, out int iUICriticalChance)
{
    iUIHitChance = kSelf.GetHitChance();
    iUICriticalChance = kSelf.GetCriticalChance();
}

static function RollForHit(XGAbility_Targeted kSelf, XGAction_Fire kFireAction)
{
    local float fRoll, fChance;
    local int iAdjustedChance;
    local string strMessage;
    local LWCE_XGUnit kShooter, kTarget;
    local XGParamTag kTag;
    local XGTacticalGameCore kGameCore;
    local XComUIBroadcastWorldMessage kBroadcastWorldMessage;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kShooter = LWCE_XGUnit(kSelf.m_kUnit);
    kTarget = LWCE_XGUnit(kSelf.GetPrimaryTarget());
    kSelf.m_bHit = false;

    if (kSelf.m_kGameCore == none)
    {
        kSelf.GetTacticalGameCore();
    }

    kGameCore = XGTacticalGameCore(kSelf.m_kGameCore);

    if (kFireAction != none && kSelf.IsRocketShot())
    {
        kFireAction.m_kTargetedEnemy = none;
    }

    if ( (kFireAction != none && kFireAction.m_kTargetedEnemy == none) || kSelf.HasProperty(eProp_EnvironmentRoll) && !kSelf.HasEffect(eEffect_Damage))
    {
        if (kSelf.HasProperty(eProp_ScatterTarget))
        {
            HandleAbilityScatter(kSelf, kFireAction, kShooter);
        }
        else
        {
            kSelf.m_fDistanceToTarget = VSize(kShooter.GetLocation() - kSelf.m_vTargetLocation) / 64.0f;
            kSelf.m_iHitChance_NonUnitTarget = 100;
            kSelf.m_bHit = true;
        }

        kSelf.CalcDamage();
        return;
    }

    if (kSelf.HasProperty(eProp_PsiRoll))
    {
        // Psi Panic always "hits"; whether the target actually panics is figured out later
        if (`CHEATMGR_TAC.bDeadEye || kSelf.iType == eAbility_PsiPanic)
        {
            kSelf.m_bHit = true;
        }
        else if (`CHEATMGR_TAC.bNoLuck)
        {
            kSelf.m_bHit = false;
        }
        else
        {
            if (kSelf.iType == eAbility_MindControl || kSelf.iType == eAbility_PsiControl)
            {
                iAdjustedChance = kGameCore.MIND_CONTROL_DIFFICULTY;
            }

            kSelf.m_bHit = kShooter.PassesWillTest(kTarget.ReplicateActivatePerkData_ToString(2), iAdjustedChance, false, kTarget);

            if (kSelf.m_bHit && XGBattle_SP(`BATTLE) != none && kSelf.iType == eAbility_MindControl)
            {
                if (kTarget.GetCharacter().m_kChar.iType == eChar_Ethereal || kTarget.GetCharacter().m_kChar.iType == eChar_EtherealUber)
                {
                    XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_Xavier);

                    // Marks that this unit has mind controlled an Ethereal, making them eligible to learn Rift
                    kShooter.GetCharacter().m_kChar.aUpgrades[ePerk_MindControl] += 2;
                }
            }

            if (kSelf.HasEffect(eEffect_Damage))
            {
                kSelf.CalcDamage();
            }
        }

        // TODO: still not entirely sure about this conditional. Only Mindfray should fall into this.
        if (kSelf.HasEffect(eEffect_Damage))
        {
            goto LabelSkipReflect;
        }
    }

    if (kShooter.IsPanicActive())
    {
        kSelf.m_iHitChance -= kGameCore.PANIC_SHOT_HIT_PENALTY;
    }

    if ( (kSelf.m_iHitChance == 100 || kSelf.HasProperty(eProp_Stun) ) && !kSelf.m_bReactionFire)
    {
        kSelf.m_bHit = true;
    }
    else
    {
        if (`CHEATMGR_TAC.bDeadEye)
        {
            fChance = 1.0;
        }
        else if (`CHEATMGR_TAC.bNoLuck)
        {
            fChance = 0.0;
        }
        else
        {
            iAdjustedChance = kSelf.GetHitChance();
            fChance = float(iAdjustedChance) / 100.0f;
        }

        if (kTarget != none)
        {
            if (kSelf.m_bReactionFire)
            {
                // Sectopods, Mechtoids, SHIVs and MECs are all easier to hit with reaction fire than other units (unless they have Lightning Reflexes or the attacker doesn't take reaction fire aim penalties)
                if (kTarget.GetCharacter().m_kChar.iType == eChar_Sectopod || kTarget.GetCharacter().m_kChar.iType == eChar_Mechtoid || kTarget.IsATank() || kTarget.IsAugmented())
                {
                    if (!kTarget.HasPerk(ePerk_LightningReflexes))
                    {
                        if (!kShooter.HasPerk(ePerk_Opportunist) && !kShooter.HasPerk(ePerk_AdvancedFireControl))
                        {
                            fChance /= `LWCE_TACCFG(fReactionFireAimDivisorLargeTarget);
                        }
                    }
                }

                if (kTarget.HasPerk(ePerk_LightningReflexes))
                {
                    fChance *= kTarget.m_bLightningReflexesUsed ? `LWCE_TACCFG(fReactionFireAimMultiplierUsedLightningReflexes) : `LWCE_TACCFG(fReactionFireAimMultiplierUnusedLightningReflexes);

                    if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kTarget.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ChameleonSuit)))
                    {
                        fChance *= `LWCE_TACCFG(fReactionFireAimMultiplierWithChameleonSuit);
                    }

                    kTarget.m_bLightningReflexesUsed = true;

                    strMessage = kGameCore.GetUnexpandedLocalizedMessageString(eULS_LightningReflexesUsed);

                    if (kShooter.IsMine() || kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(PerfectInformation)))
                    {
                        // Include hit chance information
                        strMessage $= ": " $ int(100.0 * fChance) $ "%";
                    }

                    kBroadcastWorldMessage = `PRES.GetWorldMessenger().Message(strMessage,
                                                                               kTarget.GetLocation(),
                                                                               eColor_Good,
                                                                               /* _eBehavior */,
                                                                               /* _sId */,
                                                                               kShooter.m_eTeamVisibilityFlags,
                                                                               /* _bUseScreenLocationParam */,
                                                                               /* _vScreenLocationParam */,
                                                                               /* _displayTime */,
                                                                               class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

                    if (kBroadcastWorldMessage != none)
                    {
                        XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kBroadcastWorldMessage).Init_UnexpandedLocalizedString(eULS_LightningReflexesUsed, kTarget.GetLocation(), eColor_Good, kShooter.m_eTeamVisibilityFlags);
                    }
                }
            }

            kSelf.m_bHit = kGameCore.RollForHit(fChance, kShooter.GetCharacter().m_kChar, kTarget.GetCharacter().m_kChar, fRoll);

            if (!kSelf.m_bReactionFire)
            {
                kSelf.m_bReflected = kGameCore.CalcReflection(kSelf.iType, kSelf.m_kWeapon.GameplayType(), kShooter.GetCharacter().m_kChar, kTarget.GetCharacter().m_kChar, kSelf.m_bHit);
            }

            if (kSelf.m_bReflected)
            {
                kTag.StrValue0 = kTarget.SafeGetCharacterName();
                kBroadcastWorldMessage = `PRES.GetWorldMessenger().Message(class'XComLocalizer'.static.ExpandString(kGameCore.m_aExpandedLocalizedStrings[eELS_UnitReflectedAttack]),
                                                                           kTarget.GetLocation(),
                                                                           eColor_Bad,
                                                                           /* _eBehavior */,
                                                                           /* _sId */,
                                                                           kShooter.m_eTeamVisibilityFlags,
                                                                           /* _bUseScreenLocationParam */,
                                                                           /* _vScreenLocationParam */,
                                                                           /* _displayTime */,
                                                                           class'XComUIBroadcastWorldMessage_UnitReflectedAttack');

                if (kBroadcastWorldMessage != none)
                {
                    XComUIBroadcastWorldMessage_UnitReflectedAttack(kBroadcastWorldMessage).Init_UnitReflectedAttack(kTarget, kTarget.GetLocation(), eColor_Bad, kShooter.m_eTeamVisibilityFlags);
                    kSelf.m_bHit = true;
                }
            }
        }
    }

    // Not entirely sure a goto to this point is right, the decompiler had some trouble with this code
    LabelSkipReflect:
    if ( (!kSelf.m_bReactionFire || kShooter.GetCharacter().HasUpgrade(ePerk_Opportunist)) && kSelf.iType != eAbility_ShotMayhem)
    {
        if (kSelf.m_bHit && !kSelf.m_bReflected && kTarget != none && !kTarget.IsCivilian() && kSelf.GetCriticalChance() > 0)
        {
            kSelf.RollForCritical();
        }
    }

    kSelf.CalcDamage();

    if (kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(PerfectInformation)) && kTarget != none)
    {
        `PRES.MSGArmorFragments(kSelf);
    }

    if (kSelf.m_bReactionFire)
    {
        `PRES.MSGOverwatchShot(kSelf);
    }
}

protected static function HandleAbilityScatter(XGAbility_Targeted kSelf, XGAction_Fire kFireAction, LWCE_XGUnit kShooter)
{
    local float fDistanceOffTarget, fCoefficient, fRads, fYaw, fScatter;
    local int iEffectiveAim;
    local Rotator rRotate;
    local Vector vDest, vDir;

    vDest = kFireAction.m_bShotIsBlocked ? kFireAction.m_vHitLocation : kFireAction.GetTargetLoc();
    kSelf.m_vTargetLocation = vDest;
    VDir = vDest - kShooter.GetLocation();

    if (kShooter.IsHuman())
    {
        kSelf.m_fDistanceToTarget = VSize(VDir);

        iEffectiveAim = kShooter.GetOffense();

        if (kShooter.HasPerk(`LW_PERK_ID(PlatformStability)) && kShooter.m_iMovesActionsPerformed == 0)
        {
            iEffectiveAim += `LWCE_TACCFG(iPlatformStabilityAimBonusForRockets);
        }

        if (kShooter.HasPerk(`LW_PERK_ID(FireInTheHole)) && kShooter.m_iMovesActionsPerformed == 0)
        {
            iEffectiveAim += `LWCE_TACCFG(iFireInTheHoleAimBonusForRockets);
        }

        iEffectiveAim = Clamp(iEffectiveAim, 0, 120);
        fScatter = class'XGTacticalGameCore'.default.MIN_SCATTER * ( (120.0f - iEffectiveAim) / 120.0f );

        // Randomly roll for how far off target we are. This will later be tempered by the soldier's aim.
        // Long War first pulls a coefficient, which is sampled using the natural log and ultimately ends
        // up in the range [0, Infinity]. As the natural log approaches infinity asymptotically and very slowly,
        // the practical range of this ends up being roughly [0, 3.5], though the true practical range depends on
        // how small the numbers returned by SYNC_FRAND can be.
        //
        // This number then multiplies the cosine and sine of a random number in the range [0, 2 * Pi].
        // The cosine determines the rocket's yaw, i.e. how different the angle is to the left or right (where forward is
        // the direction the rocket was intended to travel).
        // The sine is used to establish a distance modifier; that is, if the original location was intended to land at
        // a distance of X from the shooter, the sine modifies X and applies it to the new angle instead.
        fRads = 6.2831850f * `SYNC_FRAND_STATIC;
        fCoefficient = Sqrt(Abs(2.0f * Loge(`SYNC_FRAND_STATIC)));
        fYaw = fCoefficient * Cos(fRads);
        fDistanceOffTarget = fCoefficient * Sin(fRads);

        if (kShooter.m_iMovesActionsPerformed > 0)
        {
            if (kShooter.HasPerk(`LW_PERK_ID(SnapShot)))
            {
                fScatter *= `LWCE_TACCFG(fRocketScatterMultiplierAfterMoveWithSnapShot);
            }
            else
            {
                fScatter *= `LWCE_TACCFG(fRocketScatterMultiplierAfterMove);
            }
        }

        if (!kFireAction.m_kShot.IsBlasterLauncherShot())
        {
            rRotate.Yaw = int( (Atan(fScatter / 20.0f) * fYaw) * 10430.220 );
            VDir = VDir >> rRotate;
            VDir = Normal(VDir);
            fDistanceOffTarget *= fScatter * kSelf.m_fDistanceToTarget / 20.0f;
            fDistanceOffTarget += kSelf.m_fDistanceToTarget;
            kSelf.m_vTargetLocation = kShooter.GetLocation() + (vDir * fDistanceOffTarget);
        }

        kShooter.SetTimer(1.0f, false, 'DelayRocketFire');

        if (VSize(vDest - kSelf.m_vTargetLocation) >= 336.0)
        {
            kShooter.SetTimer(5.0f, false, 'DelaySpeechRocketScatter');
        }
    }

    kFireAction.SetTargetLoc(kSelf.m_vTargetLocation);
    kSelf.m_bHit = false;
    kSelf.m_bHit_NonUnitTarget = true;
}