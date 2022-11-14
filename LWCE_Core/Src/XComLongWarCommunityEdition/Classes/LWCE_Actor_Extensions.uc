class LWCE_Actor_Extensions extends Object
    abstract;

simulated static function TakeDirectDamage(const Actor kSelf, const DamageEvent Dmg)
{
    if (XComPathingPawn(kSelf) != none)
    {
        // XComPathingPawn overrides this to do nothing
        return;
    }
    else if (XComSectopod(kSelf) != none)
    {
        TakeDirectDamage_XComSectopod(XComSectopod(kSelf), Dmg);
    }
    else if (XComUnitPawn(kSelf) != none)
    {
        TakeDirectDamage_XComUnitPawn(XComUnitPawn(kSelf), Dmg);
    }
    else if (XComFracLevelActor(kSelf) != none)
    {
        TakeDirectDamage_XComFracLevelActor(XComFracLevelActor(kSelf), Dmg);
    }
    else if (XComDestructibleActor(kSelf) != none)
    {
        TakeDirectDamage_XComDestructibleActor(XComDestructibleActor(kSelf), Dmg);
    }
    else
    {
        TakeDirectDamage_Actor(kSelf, Dmg);
    }
}

simulated static function TakeDirectDamage_Actor(const Actor kSelf, const DamageEvent Dmg)
{
    kSelf.TakeDamage(Dmg.DamageAmount, Dmg.EventInstigator.GetOwningPlayerController(), Dmg.HitLocation, Dmg.Momentum, Dmg.DamageType, Dmg.HitInfo, Dmg.DamageCauser);
}

simulated static function TakeDirectDamage_XComDestructibleActor(const XComDestructibleActor kSelf, const DamageEvent Dmg)
{
    local bool bAreaBurnImmune;

    bAreaBurnImmune = kSelf.Toughness != none && kSelf.Toughness.bImmuneToAreaBurnDamage && Dmg.DamageType == class'XComDamageType_AreaBurn';

    if (ClassIsChildOf(Dmg.DamageType, class'XComDamageType') && Dmg.DamageType.default.bCausesFracture && !bAreaBurnImmune)
    {
        TakeDirectDamage_Actor(kSelf, Dmg);
        kSelf.ApplyDamageToMe(Dmg);
    }
}

simulated static function TakeDirectDamage_XComFracLevelActor(const XComFracLevelActor kSelf, const DamageEvent Dmg)
{
    local float DamageRadius;

    kSelf.RecordDamageEvent(Dmg);

    if (Dmg.DamageType.default.bCausesFracture || kSelf.bAlwaysFracture)
    {
        DamageRadius = Dmg.DamageCauser.IsA('XComProjectile') ? XComProjectile(Dmg.DamageCauser).DamageRadius : 1.0;
        DamageRadius *= Dmg.DamageType.default.FracturedMeshRadiusMultiplier;
        kSelf.BreakOffPartsInRadius(Dmg.HitLocation, DamageRadius, VSize(Dmg.Momentum), /* bWantPhysChunksAndParticles */ true);
    }
}

private simulated static function TakeDirectDamage_XComSectopod(const XComSectopod kSelf, const DamageEvent Dmg)
{
    local XGUnit kUnit;
    local int iMaxHP, iOldHP, iNewHP;

    kUnit = XGUnit(kSelf.GetGameUnit());
    iOldHP = kUnit.GetUnitHP();
    iMaxHP = kUnit.GetUnitMaxHP();
    TakeDirectDamage_XComUnitPawn(kSelf, Dmg);
    iNewHP = kUnit.GetUnitHP();

    if (iNewHP != iOldHP)
    {
        kSelf.SetDamageLevel(iNewHP, iMaxHP);
    }
}

private simulated static function TakeDirectDamage_XComUnitPawn(const XComUnitPawn kSelf, const DamageEvent Dmg)
{
    // TODO
}
