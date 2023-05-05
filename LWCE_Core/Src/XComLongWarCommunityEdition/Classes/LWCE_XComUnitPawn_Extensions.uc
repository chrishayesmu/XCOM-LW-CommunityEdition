class LWCE_XComUnitPawn_Extensions extends Object
    abstract;

static simulated function ApplyShredderRocket(XComUnitPawn kSelf, const DamageEvent Dmg, bool enemyOfUnitHit)
{
    local int iAbilityId, iShredDuration;
    local LWCEWeaponTemplate kInstigatorWeapon;
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
    kInstigatorWeapon = LWCE_XGWeapon(kInstigator.GetInventory().GetActiveWeapon()).m_kTemplate;
    iAbilityId = kInstigator.GetUsedAbility();

    if (iAbilityId == eAbility_ShredderRocket)
    {
        iShredDuration = `LWCE_TACCFG(iShredderDebuffDurationFromRocket);
    }
    else if (!kInstigator.IsAlien_CheckByCharType() &&
             kInstigatorWeapon.HasProperty('Support') &&
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
    else if (kInstigator.LWCE_GetCharacter().HasItemInInventory('Item_ShredderAmmo') && kInstigatorWeapon.IsLarge())
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

static function AttachItem(XComUnitPawn kSelf, Actor A, name SocketName, bool bIsRearBackPackItem, out MeshComponent kFoundMeshComponent)
{
    local LWCEWeaponTemplate kWeapon;
    local MeshComponent MeshComp;
    local Vector vModelScale;
    local bool bHideItem;
    local int Index;
    local name nmPrimaryWeapon;

    //`LWCE_LOG_CLS("AttachItem: kSelf = " $ kSelf $ ", A = " $ A $ ", SocketName = " $ SocketName $ ", bIsRearBackPackItem = " $ bIsRearBackPackItem $ ", kFoundMeshComponent = " $ kFoundMeshComponent);

    if (kFoundMeshComponent != none)
    {
        kSelf.Mesh.AttachComponentToSocket(kFoundMeshComponent, SocketName);
    }
    else if (A != none)
    {
        foreach A.ComponentList(class'MeshComponent', MeshComp)
        {
            if (!kSelf.IsA('XComMecPawn'))
            {
                MeshComp.SetScale(kSelf.bIsFemale ? 0.750 : 0.850);
            }

            nmPrimaryWeapon = '';

            if (A.IsA('SkeletalMeshActorSpawnable'))
            {
                if (LWCE_XComHumanPawn(kSelf) != none)
                {
                    for (Index = 0; Index < LWCE_XComHumanPawn(kSelf).ActiveAttachments.Length; Index++)
                    {
                        if (SocketName == LWCE_XComHumanPawn(kSelf).ActiveAttachments[Index].SocketName)
                        {
                            // TODO: ActiveAttachments needs a version that uses LWCE names instead of EItemType
                            nmPrimaryWeapon = LWCE_XComHumanPawn(kSelf).m_nmPrimaryWeapon;
                            //Index = LWCE_XComHumanPawn(kSelf).ActiveAttachments[Index].ItemType;
                            break;
                        }
                    }
                }

                if (LWCE_XComTank(kSelf) != none)
                {
                    if (SocketName == class'XGInventory'.default.m_SocketNames[eSlot_RightHand])
                    {
                        nmPrimaryWeapon = LWCE_XComTank(kSelf).m_nmPrimaryWeapon;
                    }
                }
            }
            else if (XComWeapon(A) != none)
            {
                nmPrimaryWeapon = class'LWCE_XGWeapon_Extensions'.static.GetItemName(XComWeapon(A).m_kGameWeapon);
            }

            if (nmPrimaryWeapon != '')
            {
                kWeapon = `LWCE_WEAPON(nmPrimaryWeapon);

                if (kWeapon != none)
                {
                    vModelScale.X = kWeapon.vModelScale.X > 0 ? (kWeapon.vModelScale.X / 100.0) : 1.0;
                    vModelScale.Y = kWeapon.vModelScale.Y > 0 ? (kWeapon.vModelScale.Y / 100.0) : 1.0;
                    vModelScale.Z = kWeapon.vModelScale.Z > 0 ? (kWeapon.vModelScale.Z / 100.0) : 1.0;

                    MeshComp.SetScale3D(vModelScale);
                }
            }

            kSelf.Mesh.AttachComponentToSocket(MeshComp, SocketName);

            kFoundMeshComponent = MeshComp;
            MeshComp.SetLightEnvironment(kSelf.LightEnvironment);
            MeshComp.SetShadowParent(kSelf.Mesh);
            MeshComp.CastShadow = false;
            MeshComp.PrestreamTextures(1.0, true);
        }
    }

    if (kFoundMeshComponent != none)
    {
        if (!bIsRearBackPackItem)
        {
            for (Index = 0; Index < kSelf.HiddenSlots.Length; Index++)
            {
                if (class'XGInventory'.default.m_SocketNames[kSelf.HiddenSlots[Index]] == SocketName)
                {
                    bHideItem = true;
                    break;
                }
            }
        }

        if (bIsRearBackPackItem || bHideItem)
        {
            // In base game, this is MeshComp and not kFoundMeshComponent; seems like a bug
            kFoundMeshComponent.SetHidden(true);
        }
    }

    kSelf.MarkAuxParametersAsDirty(kSelf.m_bAuxParamNeedsPrimary, kSelf.m_bAuxParamNeedsSecondary, kSelf.m_bAuxParamUse3POutline);
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

static event PostInitAnimTree(XComUnitPawn kSelf, SkeletalMeshComponent SkelComp)
{
    local XComAnimNodeCover LocalCoverNode;
    local AnimNodeAdditiveBlending LocalAdditiveBlendNode;
    local AnimNodeBlendPerBone LocalBlendPerBoneNode;

    // Section: XComUnitPawnNativeBase.PostInitAnimTree
    if (SkelComp == kSelf.Mesh && kSelf.Mesh.Animations != none)
    {
        // LWCE: fix None access of WeaponStateNode
        kSelf.WeaponStateNode = XComAnimNodeWeaponState(kSelf.Mesh.Animations.FindAnimNode('WeaponStateNode'));

        if (kSelf.WeaponStateNode != none)
        {
            kSelf.WeaponStateNode.SetActiveChild(0, 0.0);
        }

        kSelf.FlyingLegMaskNode = AnimNodeBlendPerBone(kSelf.Mesh.Animations.FindAnimNode('FlyingLegMaskNode'));
        kSelf.OpenCloseStateNode = AnimNode_MultiBlendPerBone(kSelf.Mesh.Animations.FindAnimNode('OpenCloseStateNode'));

        if (kSelf.OpenCloseStateNode != none)
        {
            if (kSelf.m_eOpenCloseState != eUP_None)
            {
                kSelf.XComUpdateOpenCloseStateNode(kSelf.m_eOpenCloseState, true);
            }
        }

        kSelf.TurnNode = XComAnimNodeBlendSynchTurning(kSelf.Mesh.Animations.FindAnimNode('Turning'));
        kSelf.MovementNode = XComAnimNodeBlendByMovementType(kSelf.Mesh.Animations.FindAnimNode('Movement'));
        kSelf.CrouchNode = AnimNodeBlendList(kSelf.Mesh.Animations.FindAnimNode('Crouch'));
        kSelf.MirrorNode = AnimNodeMirror(kSelf.Mesh.Animations.FindAnimNode('Mirror'));
        kSelf.CrouchStateNode = AnimNodeBlendList(kSelf.Mesh.Animations.FindAnimNode('CrouchState'));
        kSelf.AimingNode = XComAnimNodeAiming(kSelf.Mesh.FindAnimNode('Aiming'));

        kSelf.StandingAimToggle = AnimNodeBlend(kSelf.Mesh.FindAnimNode('StandingAimToggle'));
        kSelf.StandingAimOffsetNode = AnimNodeAimOffset(kSelf.Mesh.FindAnimNode('StandingAimOffset'));
        kSelf.LowCoverAimOffsetNode = AnimNodeAimOffset(kSelf.Mesh.FindAnimNode('LowCoverAimOffset'));
        kSelf.HighCoverAimOffsetNode = AnimNodeAimOffset(kSelf.Mesh.FindAnimNode('HighCoverAimOffset'));
        kSelf.ActionNode = XComAnimNodeBlendByAction(kSelf.Mesh.Animations.FindAnimNode('Action'));
        kSelf.IdleNode = XComAnimNodeIdle(kSelf.Mesh.Animations.FindAnimNode('Idle'));
        kSelf.LeftHandIK = SkelControlLimb(SkelComp.FindSkelControl('LeftHandIK'));
        kSelf.RightHandIK = SkelControlLimb(SkelComp.FindSkelControl('RightHandIK'));

        if (kSelf.LeftHandIK != none)
        {
            kSelf.LeftHandIK.SetSkelControlStrength(0.0, 0.0);
        }

        if (kSelf.RightHandIK != none)
        {
            kSelf.RightHandIK.SetSkelControlStrength(0.0, 0.0);
        }

        kSelf.CheckSelfFlankedSystem();
        kSelf.CoverNodes.Length = 0;

        foreach kSelf.Mesh.AllAnimNodes(class'XComAnimNodeCover', LocalCoverNode)
        {
            kSelf.CoverNodes.AddItem(LocalCoverNode);
        }

        kSelf.SuppressedNodes.Length = 0;
        kSelf.WeaponDownNodes.Length = 0;

        foreach kSelf.Mesh.AllAnimNodes(class'AnimNodeAdditiveBlending', LocalAdditiveBlendNode)
        {
            if (LocalAdditiveBlendNode.NodeName == 'WeaponDown')
            {
                kSelf.WeaponDownNodes.AddItem(LocalAdditiveBlendNode);
                continue;
            }

            if (LocalAdditiveBlendNode.NodeName == 'DefaultSuppressBlend')
            {
                kSelf.SuppressedNodes.AddItem(LocalAdditiveBlendNode);
            }
        }

        kSelf.SpineMaskNodes.Length = 0;

        foreach kSelf.Mesh.AllAnimNodes(class'AnimNodeBlendPerBone', LocalBlendPerBoneNode)
        {
            if (LocalBlendPerBoneNode.NodeName == 'BlendPerBone_SpineMask')
            {
                LocalBlendPerBoneNode.SetBlendTarget(1.0, 0.0);
                kSelf.SpineMaskNodes.AddItem(LocalBlendPerBoneNode);
            }
        }

        if (kSelf.ActionNode != none)
        {
            kSelf.fStopDistanceNoCover = kSelf.ComputeAnimationRMADistance('MV_RunFwd_StopA');
            kSelf.fStopDistanceCover = kSelf.ComputeAnimationRMADistance('AC_HR_Run2CoverStartA');
        }

        kSelf.BuildFootIKData();
    }

    // Section: XComUnitPawn.PostInitAnimTree
    if (kSelf.MovementNode != none)
    {
        kSelf.MovementNode.SetActiveChild(1, 0.0);
    }

    if (kSelf.CrouchNode != none)
    {
        kSelf.CrouchNode.SetActiveChild(1, 0.0);
    }
}

static function SetupForMatinee(XComUnitPawn kSelf, optional Actor MatineeBase, optional bool bDisableFootIK, optional bool bDisableGenderBlender)
{
    if (kSelf.m_bInMatinee)
    {
        kSelf.ReturnFromMatinee();
    }

    if (MatineeBase != none)
    {
        kSelf.SetBase(MatineeBase);
    }

    if (bDisableFootIK)
    {
        kSelf.EnableFootIK(false);
    }

    if (kSelf.MirrorNode != none)
    {
        kSelf.MirrorNode.bEnableMirroring = false;
    }

    kSelf.PushCollisionCylinderEnable(false);
    kSelf.Mesh.bUpdateSkelWhenNotRendered = true;
    kSelf.bSkipRotateToward = true;
    kSelf.SetPhysics(PHYS_Interpolating);
    kSelf.ResetIKTranslations();
    kSelf.Mesh.SaveAnimSets();

    // LWCE: fix None access of m_kGameUnit in some scenarios
    if (kSelf.m_kGameUnit != none && !kSelf.m_kGameUnit.IdleStateMachine.IsDormant())
    {
        kSelf.m_bWasIdleBeforeMatinee = true;
        kSelf.m_kGameUnit.IdleStateMachine.GoDormant(none, true, true);
    }

    kSelf.m_bInMatinee = true;
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
                `ONLINEEVENTMGR.UnlockAchievement(AT_Shieldbuster);
            }

            if (kDamageDealer.IsMine() && bWasVisibleOnlyWithBioelectricSkin)
            {
                `ONLINEEVENTMGR.UnlockAchievement(AT_TinglingSensation);
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