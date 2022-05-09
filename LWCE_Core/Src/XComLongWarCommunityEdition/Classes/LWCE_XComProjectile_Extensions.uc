class LWCE_XComProjectile_Extensions extends Object
    abstract;

static simulated function CalculateUnitDamage(XComProjectile kSelf)
{
    if (kSelf.bWillDoDamage)
    {
        if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot.GetType() == eAbility_RocketLauncher)
        {
            kSelf.MyDamageType = class'XComDamageType_Explosion';
        }

        if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot.GetType() == eAbility_ShredderRocket)
        {
            kSelf.MyDamageType = class'XComDamageType_NeedleExplosion';
        }

        if (kSelf.bIsHit || ClassIsChildOf(kSelf.MyDamageType, class'XComDamageType_Explosion'))
        {
            kSelf.Damage = float(kSelf.UnitDamage);
        }

        if (kSelf.Damage == 0.0)
        {
            kSelf.Damage = 0.0;
        }
    }

    if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && kSelf.GetGameWeapon() != none)
    {
        kSelf.DamageRadius = class'LWCE_XGAbility_Extensions'.static.GetRadius(XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot);
    }
}

static simulated function InitProjectile(XComProjectile kSelf, Vector Direction, optional bool bPreviewOnly = false, optional bool bCanDoDamage = true)
{
    local XGUnit kAttacker, kTargetToUse;
    local XComWeapon kWeapon;
    local XGAction kAction;
    local DamageDealingAction DamageAction;

    kSelf.AddProjectileEventListenter(`LWCE_GFX);

    kWeapon = XComWeapon(kSelf.Owner);
    kSelf.bPreview = bPreviewOnly;

    if (kSelf.Role == ROLE_Authority)
    {
        kSelf.InitPreview();
    }

    kAction = kWeapon.m_kPawn.GetGameUnit().GetAction();
    DamageAction = DamageDealingAction(kAction);

    if (NotEqual_InterfaceInterface(DamageAction, none))
    {
        DamageAction.GetProjectileDamage(bCanDoDamage, kSelf, kWeapon, kSelf.TargetPawn, kSelf.TargetUnit, kSelf.UnitDamage, kSelf.WorldDamage);
        kSelf.bIsHit = DamageAction.IsHit();
        kSelf.bWillDoDamage = bCanDoDamage && (kSelf.UnitDamage > 0 || kSelf.WorldDamage > 0);
        kSelf.WeaponType = kWeapon.m_kGameWeapon.GameplayType();
        kSelf.bTargetLocSeeking = kSelf.WeaponType == eItem_RocketLauncher || kSelf.WeaponType == eItem_BlasterLauncher || kSelf.WeaponType == eItem_Plague;

        if (kSelf.bTargetLocSeeking)
        {
            if (kWeapon.m_kPawn != none)
            {
                kSelf.TargetLocation = XComUnitPawn(kWeapon.m_kPawn).TargetLoc;
            }
            else
            {
                kSelf.TargetLocation = XGAction_Fire(kAction).GetTargetLoc();
            }
        }

        if (XGAction_Fire(kAction) != none && XGAction_Fire(kAction).m_bHumanTargeted)
        {
            kSelf.m_kHumanTargetedShot = XGAction_Fire(kAction).m_kShot;
            kSelf.m_vHumanTargetedLocation = XGAction_Fire(kAction).m_vHumanTargetedLocation;
        }
    }
    else if (XGUnit(kWeapon.m_kPawn.GetGameUnit()).m_bApplyingNeuralFeedback)
    {
        kSelf.HACK_bNeuralFeedbackProjectile = true;

        if (kSelf.IsA('XComProjectile_Shot'))
        {
            kSelf.bWillDoDamage = true;
            kSelf.m_bShowDamage = true;
            kSelf.m_bWasCrit = false;
        }
        else
        {
            XGUnit(kWeapon.m_kPawn.GetGameUnit()).m_bApplyingNeuralFeedback = false;
        }

        kSelf.bIsHit = true;
        kSelf.UnitDamage = XGUnit(kWeapon.m_kPawn.GetGameUnit()).m_iNeuralFeedbackDamage;
        kSelf.TargetUnit = XGUnit(kWeapon.m_kPawn.GetGameUnit()).m_kNeuralFeedbackTarget;
        kSelf.TargetPawn = kSelf.TargetUnit.GetPawn();
        kSelf.TargetLocation = kSelf.TargetPawn.GetHeadshotLocation();
    }

    kSelf.m_kFiredFromUnit = kWeapon.m_kPawn.GetGameUnit();
    kSelf.CalculateUnitDamage();
    kSelf.OverrideSpeed();

    kSelf.Init(Direction);
    kSelf.OriginalLocation = kSelf.Location;
    kSelf.OriginalVelocity = kSelf.Velocity;

    if (kSelf.fDelayBeforeMovement > 0.0)
    {
        kSelf.Velocity = vect(0.0, 0.0, 0.0);
    }

    if (`CHEATMGR_TAC != none && `CHEATMGR_TAC.bShowProjectilePath && !XComUnitPawn(XComWeapon(kSelf.Owner).Owner).GetGameUnit().GetPlayer().IsHumanPlayer())
    {
        kSelf.DrawDebugSphere(kSelf.Location, 10.0, 10, 0, 255, 0, true);
    }

    kSelf.NotifyListeners_OnInit();
    kAttacker = XGUnit(kSelf.m_kFiredFromUnit);
    kTargetToUse = kSelf.TargetUnit != none ? XGUnit(kSelf.TargetUnit) : none;

    if (kAttacker != none && kTargetToUse != none && kAttacker.GetTeam() != kTargetToUse.GetTeam() && !kSelf.bIsHit)
    {
        kTargetToUse.IdleStateMachine.PerformFlinch();
    }

    if (kSelf.bWillDoDamage && XComProjectile_FragGrenade(kSelf) == none)
    {
        kSelf.SetupFakeTouchEvents(kSelf.Location, kSelf.Velocity);
        kSelf.SetTimer(0.10, false, 'ProcessFakeTouchEvents', kSelf);
    }
}