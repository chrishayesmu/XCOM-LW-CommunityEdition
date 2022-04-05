class LWCE_XComUnitPawn_Extensions extends Object
    abstract;

static simulated function ApplyShredderRocket(XComUnitPawn kSelf, const DamageEvent Dmg, bool enemyOfUnitHit)
{
    local int iAbilityId, iShredDuration;
    local LWCE_TWeapon kInstigatorWeapon;
    local LWCE_XGUnit kVictim, kInstigator;
    local XComPresentationLayer kPres;
    local XComUIBroadcastWorldMessage kBroadcastWorldMessage;

    if (kSelf.Role != ROLE_Authority)
    {
        return;
    }

    if (Dmg.EventInstigator == none)
    {
        return;
    }

    if (Dmg.DamageType == class'XComDamageType_Psionic')
    {
        return;
    }

    kVictim = LWCE_XGUnit(kSelf.GetGameUnit());
    kInstigator = LWCE_XGUnit(Dmg.EventInstigator);
    kInstigatorWeapon = `LWCE_TWEAPON_FROM_XG(kInstigator.GetInventory().GetActiveWeapon());
    iAbilityId = kInstigator.GetUsedAbility();

    if (iAbilityId == eAbility_ShredderRocket)
    {
        iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromRocket);
    }
    else if (!kInstigator.IsAlien_CheckByCharType() &&
             `GAMECORE.WeaponHasProperty(kInstigator.GetInventory().GetActiveWeapon().ItemType(), eWP_Support) &&
             kInstigator.HasPerk(`LW_PERK_ID(ShredderAmmo)))
    {
        iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromPerk);
    }
    else if (kInstigator.IsAugmented() &&
             iAbilityId == eAbility_ShotStandard &&
             kInstigator.HasPerk(`LW_PERK_ID(ShredderAmmo)))
    {
        // TODO: rapid fire should probably be able to apply shred for MECs also; make configurable
        iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromPerk);
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInstigator.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ShredderAmmo)) && kInstigatorWeapon.iSize == 1)
    {
        iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromSmallItem);
    }
    else if (kInstigator.IsAlien_CheckByCharType() && kInstigator.HasPerk(`LW_PERK_ID(ShredderAmmo)))
    {
        if (iAbilityId == eAbility_AlienGrenade)
        {
            iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromEnemyGrenade);
        }
        else
        {
            iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromEnemyWeapon);
        }
    }

    // This check added in LWCE, in case any of the durations are configured to 0
    if (iShredDuration == 0)
    {
        return;
    }

    kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, iShredDuration);

    kPres = XComPresentationLayer(XComPlayerController(`WORLDINFO.GetALocalPlayerController()).m_Pres);

    kVictim.UpdateUnitBuffs();
    kBroadcastWorldMessage = kPres.GetWorldMessenger().Message(`GAMECORE.GetUnexpandedLocalizedMessageString(eULS_Shredded), kVictim.GetLocation(), eColor_Bad,,, kSelf.m_eTeamVisibilityFlags,,,, class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

    if (kBroadcastWorldMessage != none)
    {
        XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kBroadcastWorldMessage).Init_UnexpandedLocalizedString(eULS_Shredded, kVictim.GetLocation(), eColor_Bad, kSelf.m_eTeamVisibilityFlags);
    }
}

static function DoDeathOnOutsideOfBounds(XComUnitPawn kSelf)
{
    local Vector vZero;

    if (kSelf.m_kGameUnit != none && !XGUnit(kSelf.m_kGameUnit).IsDead())
    {
        XGUnit(kSelf.m_kGameUnit).m_bMPForceDeathOnMassiveTakeDamage = true;
        XGUnit(kSelf.m_kGameUnit).OnTakeDamage(1000000, class'XComDamageType_Plasma', none, vZero, vZero);
    }
}

static simulated function TakeDirectDamage(XComUnitPawn kSelf, const DamageEvent Dmg)
{
    local LWCE_XGUnit kDamageDealer, kSelfUnit;
    local DamageEvent actualDamage;
    local bool bEnemyOfUnitHit, bWasAlive, bWasVisibleOnlyWithBioelectricSkin;

    kDamageDealer = LWCE_XGUnit(Dmg.EventInstigator);
    kSelfUnit = LWCE_XGUnit(kSelf.GetGameUnit());

    if (!kSelfUnit.CanTakeDamage())
    {
        return;
    }

    if (kSelfUnit.m_bIsDoingBullRush && kDamageDealer == kSelfUnit && Dmg.DamageType == class'XComDamageType_Melee')
    {
        return;
    }

    bWasAlive = kSelfUnit.GetUnitHP() > 0;
    bWasVisibleOnlyWithBioelectricSkin = kSelfUnit.m_bEnableBioElectricParticles && !kSelf.IsVisible();
    actualDamage = Dmg;

    if (Dmg.EventInstigator != none && kDamageDealer != none)
    {
        bEnemyOfUnitHit = kDamageDealer.GetTeam() != kSelfUnit.GetTeam();
    }

    if (ClassIsChildOf(Dmg.DamageType, class'XComDamageType_Explosion'))
    {
        if (XComProjectile(Dmg.DamageCauser) != none)
        {
            if (!kDamageDealer.HasPerk(`LW_PERK_ID(TandemWarheads)))
            {
                actualDamage.DamageAmount = int(0.50 + (float(Dmg.DamageAmount) * (1.0 - FMin(1.0, 0.750 * Square(VSize(Dmg.DamageCauser.Location - kSelf.Location) / XComProjectile(Dmg.DamageCauser).DamageRadius)))));
            }

            // Adjust damage by -1, 0, or 1
            actualDamage.DamageAmount = Max(0, (actualDamage.DamageAmount + `SYNC_RAND_STATIC(3) - 1));
        }
    }

    actualDamage.DamageAmount = kSelfUnit.OnTakeDamage(actualDamage.DamageAmount, Dmg.DamageType, kDamageDealer, Dmg.HitLocation, Dmg.Momentum, Dmg.DamageCauser);

    // Shows popup with DR number
    kSelfUnit.SetTimer(0.50, false, 'DebugTreads');

    if (actualDamage.DamageAmount > 0)
    {
        class'LWCE_Actor_Extensions'.static.TakeDirectDamage_Actor(kSelf, actualDamage);
    }

    if (kSelfUnit.m_kBehavior != none && kSelfUnit.m_kBehavior.m_kPod != none)
    {
        kSelfUnit.m_kBehavior.m_kPod.OnTakeDamage();
    }

    if (!kSelfUnit.IsAlive() && bWasAlive)
    {
        kSelf.DamageEvent_CauseOfDeath = Dmg;

        if (kDamageDealer != none)
        {
            kDamageDealer.RecordKill(kSelfUnit, ClassIsChildOf(Dmg.DamageType, class'XComDamageType_Explosion'));

            if (kDamageDealer.IsMine() && kSelfUnit.GetCharType() == eChar_Mechtoid && kSelfUnit.m_bHadShieldThisTurn)
            {
                XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_Shieldbuster);
            }

            if (kDamageDealer.IsMine() && bWasVisibleOnlyWithBioelectricSkin)
            {
                XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_TinglingSensation);
            }
        }
    }
    else if (kSelfUnit.IsAlive())
    {
        if (kDamageDealer != none)
        {
            kDamageDealer.RecordWounding(kSelfUnit);
        }

        ApplyShredderRocket(kSelf, Dmg, bEnemyOfUnitHit);
    }
}