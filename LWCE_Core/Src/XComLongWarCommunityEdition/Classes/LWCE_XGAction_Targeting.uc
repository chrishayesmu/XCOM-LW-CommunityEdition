class LWCE_XGAction_Targeting extends XGAction_Targeting;

simulated function bool CanBePerformed()
{
    local float fRadius;
    local Vector vCenter, vTargetLoc;
    local XGWeapon kWeapon;
    local int TileX, TileY, TileZ;

    if (m_bFired)
    {
        return false;
    }

    kWeapon = m_kUnit.GetInventory().GetActiveWeapon();

    if (kWeapon == none)
    {
        if (m_kShot != none && m_kShot.GetType() == eAbility_CivilianCover)
        {
            return true;
        }

        return false;
    }

    if (m_kShot != none && m_kShot.IsA('XGAbility_BullRush'))
    {
        return true;
    }

    if (kWeapon.IsMelee() && m_kUnit.IsMine())
    {
        if (TargetActor == none)
        {
            return true;
        }

        if (m_kUnit.IsPointInMeleeRange(TargetActor.Location))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    if ((`BATTLE.m_kDesc.m_bIsTutorial || class'Engine'.static.IsSonOfFacemelt()) && m_kUnit.IsMine())
    {
        if (XComTacticalGRI(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI)).DirectedExperience != none)
        {
            if (!XComTacticalGRI(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI)).DirectedExperience.m_bAllowFiring)
            {
                return false;
            }
        }

        if (!m_bTargetMustBeWithinCursorRange && m_kFireOnlyAtThisUnit != none && m_kFireOnlyAtThisUnit != m_kTargetedEnemy)
        {
            return false;
        }

        if (m_bTargetMustBeWithinCursorRange && m_kUnit.IsMine())
        {
            if (`GAMECORE.AbilityRequiresProjectilePreview(m_kShot))
            {
                if (`TACTICALGRI.m_kPrecomputedPath.iNumKeyframes <= 0)
                {
                    return false;
                }

                vCenter = `TACTICALGRI.m_kPrecomputedPath.GetEndPosition();
            }
            else
            {
                vCenter = m_vTarget;
            }

            fRadius = m_kShot.m_kWeapon.GetDamageRadius();

            switch (m_kShot.GetType())
            {
                case eAbility_Rift:
                    fRadius = `LWCE_TACCFG(fRiftRadius);
                    break;
                case eAbility_ShotDamageCover: // Psychokinetic Strike
                    fRadius = `LWCE_TACCFG(fPsychokineticStrikeRadius);
                    break;
                case eAbility_MEC_Barrage: // Collateral Damage
                    fRadius = `LWCE_TACCFG(fCollateralDamageRadius);
                    break;
                default:
                    break;
            }

            if (m_fAllowedCursorRange > float(0))
            {
                fRadius = m_fAllowedCursorRange;
            }

            if (m_bOnlyFireAtLocation)
            {
                vTargetLoc = m_vFireOnlyAtThisLocation;
            }
            else
            {
                vTargetLoc = m_kFireOnlyAtThisUnit.Location;
            }

            if (VSizeSq(vCenter - vTargetLoc) < Square(fRadius))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    if (m_kShot != none)
    {
        if (m_kShot.IsA('XGAbility_Grapple'))
        {
            return XGAbility_Grapple(m_kShot).bIsValid;
        }
        else if (m_kShot.IsA('XGAbility_Rift'))
        {
            return XGAbility_Rift(m_kShot).IsRiftValid();
        }
        else if (m_kShot.m_kWeapon != none && m_kShot.m_kWeapon.GameplayType() == eItem_BattleScanner)
        {
            vCenter = m_kCursor.GetTargetLocation();
            class'XComWorldData'.static.GetWorldData().GetTileCoordinatesFromPosition(vCenter, TileX, TileY, TileZ);
            return !class'XComWorldData'.static.GetWorldData().IsTileFullyOccupied(TileX, TileY, TileZ);
        }
    }

    return true;
}

simulated function bool SetChainedDistance(EAbility eInputAbilityType, optional out float fMinDistance)
{
    local LWCE_XGUnit kUnit;
    local name WeaponName;

    kUnit = LWCE_XGUnit(m_kUnit);

    if (!AbilityRequiresChainedDistance(eInputAbilityType) && eInputAbilityType != /* Psychokinetic Strike */ 14)
    {
        return false;
    }

    fMinDistance = 0.0f;

    switch (eInputAbilityType)
    {
        case eAbility_FlashBang:
            WeaponName = 'Item_FlashbangGrenade';
            break;
        case eAbility_FragGrenade:
            WeaponName = 'Item_HEGrenade';
            break;
        case eAbility_SmokeGrenade:
            WeaponName = 'Item_SmokeGrenade';
            break;
        case eAbility_AlienGrenade:
            WeaponName = 'Item_AlienGrenade';
            break;
        case eAbility_BattleScanner:
            WeaponName = 'Item_BattleScanner';
            break;
        case eAbility_GasGrenade:
            WeaponName = 'Item_ChemGrenade';
            break;
        case eAbility_GhostGrenade:
            WeaponName = 'Item_ShadowDevice';
            break;
        case eAbility_NeedleGrenade:
            WeaponName = 'Item_APGrenade';
            break;
        case eAbility_MEC_ProximityMine:
            WeaponName = 'Item_ProximityMineLauncher';
            break;
        case eAbility_MEC_GrenadeLauncher:
            WeaponName = 'Item_GrenadeLauncher';
            break;
        case eAbility_Plague:
            WeaponName = 'Item_AcidSpit';
            break;
        case eAbility_MimicBeacon:
            WeaponName = 'Item_MimicBeacon';
            break;
    }

    if (WeaponName != '')
    {
        fMinDistance = `LWCE_WEAPON(WeaponName).CalcAoERange(kUnit);
    }

    // TODO: centralize this stuff
    if (fMinDistance <= 1.0f)
    {
        switch (eInputAbilityType)
        {
            case eAbility_MEC_Barrage:
                fMinDistance = `METERSTOUNITS(27);
                break;
            case eAbility_Rift:
                fMinDistance = `METERSTOUNITS(100);
                break;
            case eAbility_ShotDamageCover: // Psychokinetic Strike
            case eAbility_Torch:           // Pyrokinesis
            case eAbility_TelekineticField:
            case eAbility_PsiInspiration:
                fMinDistance = `METERSTOUNITS(27) * (1.0f - (28.0f / (28.0f + kUnit.GetSituationalWill(/* bIncludeBaseStat */ true, /* bIncludeNeuralDamping */ false, /* bIncludeCombatStims */ false))));
                break;
            case eAbility_RocketLauncher:
            case eAbility_ShredderRocket:
                fMinDistance = XGWeapon(kUnit.GetInventory().GetPrimaryItemInSlot(eSlot_LeftBack)).LongRange();

                if (kUnit.LWCE_GetInventory().LWCE_HasItemOfType('Item_BlasterLauncher'))
                {
                    fMinDistance += `METERSTOUNITS(kUnit.GetOffense() - 65) / 4;

                    if (kUnit.m_iMovesActionsPerformed == 0)
                    {
                        if (kUnit.HasPerk(`LW_PERK_ID(FireInTheHole)))
                        {
                            fMinDistance += `METERSTOUNITS(10) / 4;
                        }

                        if (kUnit.HasPerk(`LW_PERK_ID(PlatformStability)))
                        {
                            fMinDistance += `METERSTOUNITS(10) / 4;
                        }
                    }
                }

                if (kUnit.HasPerk(`LW_PERK_ID(JavelinRockets)))
                {
                    fMinDistance *= 1.250;
                }

                if (kUnit.m_iMovesActionsPerformed > 0)
                {
                    if (kUnit.HasPerk(`LW_PERK_ID(SnapShot)))
                    {
                        fMinDistance *= 0.750;
                    }
                    else
                    {
                        fMinDistance *= 0.50;
                    }
                }

                break;
        }
    }

    if (fMinDistance > 1.0f)
    {
        m_kCursor.m_fMaxChainedDistance = fMinDistance;
        fMinDistance = 1.0f;
        return true;
    }

    fMinDistance = 1.0f;
    return false;
}

simulated function SetShot(XGAbility_Targeted kShot, bool bSetViaLocalPlayerInput, optional bool bForceOverride = false)
{
    local int I;
    local XGAbility_Targeted kTempTargetedAbility;
    local LWCE_XGAbility kCEAbility;
    local array<XGUnitNativeBase> arrEnemies;
    local array<float> arrEnemyDistSqs;
    local XGUnitNativeBase kTempUnit;
    local float fClosest;
    local Vector vTempLocation, vTargetDir;
    local XComUnitPawnNativeBase PrevMyUnit;

    if (m_bShotSetViaLocalPlayerInput && !bSetViaLocalPlayerInput && !bForceOverride)
    {
        return;
    }

    if (bSetViaLocalPlayerInput)
    {
        m_bShotSetViaLocalPlayerInput = true;
    }

    if (kShot == m_kShot || m_bSetShotDisabled)
    {
        return;
    }

    m_bResetTraceValues = false;
    m_kShot = kShot;
    m_kReplicatedShot = m_kShot;
    m_bShotIsBlocked = false;

    if (ExplosionEmitter != none)
    {
        ExplosionEmitter.ParticleSystemComponent.DeactivateSystem();
        ExplosionEmitter = none;
    }

    ClearTargetedActors();
    m_fSplashRadiusCache = -1.0;

    if (m_kShot.GetType() == eAbility_ShotDamageCover || m_kShot.GetType() == eAbility_DestroyTerrain || m_kShot.GetType() == eAbility_BullRush)
    {
        m_bModal = false;
    }
    else
    {
        m_bModal = true;
    }

    if (Owner != none && XComTacticalController(Owner).GetStateName() != 'PlayerDebugCamera')
    {
        SetStates();
    }

    if (m_kShot != none)
    {
        `TACTICALGRI.m_kPrecomputedPath.m_bBlasterBomb = false;

        if (m_kShot.m_kWeapon != none)
        {
            `TACTICALGRI.m_kPrecomputedPath.m_bBlasterBomb = m_kShot.m_kWeapon.GameplayType() == eItem_BlasterLauncher;
        }

        if (m_kPawn.IsA('XComSectopod'))
        {
            bClusterBombSetup = (m_kShot.iType == eAbility_ClusterBomb) && !XGAbility_ClusterBomb(m_kShot).CanFireWeapon();

            if (bClusterBombSetup)
            {
                bClusterBombSetup = m_kShot.CheckAvailable();
            }

            bClusterBombFiring = (m_kShot.iType == eAbility_ClusterBomb) && XGAbility_ClusterBomb(m_kShot).CanFireWeapon();
            XComSectopod(m_kPawn).EnableClusterBombTargeting(false);
        }

        if (m_kShot.iType == eAbility_MEC_ProximityMine)
        {
            m_bPleaseHitFriendlies = true;
        }
    }

    if (!`GAMECORE.AbilityRequiresProjectilePreview(m_kShot))
    {
        `TACTICALGRI.m_kPrecomputedPath.ClearPathGraphics();
    }

    ClearFlameThrowerUI();

    if (m_bOwnedByLocalPlayer && Role < ROLE_Authority)
    {
        ServerSetTargetAbility(kShot);
    }

    if (m_kShot != none && m_kShot.GetPrimaryTarget() != none && m_kShot.GetPrimaryTarget() != m_kUnit)
    {
        if (m_kShot.UtilizeCursorMoving())
        {
            if (m_kShot.m_kWeapon == none || (m_kShot.m_kWeapon.GameplayType() != eItem_RocketLauncher && m_kShot.m_kWeapon.GameplayType() != eItem_BlasterLauncher))
            {
                m_kTargetedEnemy = none;
                SetTargetActor(none);
            }

            SetUnitTarget(m_kShot.GetPrimaryTarget());
        }
        else
        {
            if (m_kTargetedEnemy != m_kShot.GetPrimaryTarget())
            {
                m_kTargetedEnemy = m_kShot.GetPrimaryTarget();
            }

            SetUnitTarget(m_kTargetedEnemy);
        }

        UpdateAimingView();

        if (m_kShot.UtilizeCursorMoving())
        {
            SetTargetActor(none);
        }
    }
    else
    {
        if (m_kShot == none || m_kShot.GetPrimaryTarget() == none || m_kShot.GetPrimaryTarget() == m_kUnit)
        {
            m_bResetTraceValues = true;
            TargetActor = none;

            if (AbilityIgnoresTargetedUnit(EAbility(m_kShot.iType)))
            {
                MoveCursor(none, EAbility(m_kShot.iType));
            }
            else
            {
                MoveCursor(m_kUnit, EAbility(m_kShot.iType));
            }

            if (m_kShot.iType == eAbility_Grapple)
            {
                PrevMyUnit = m_kUnit.GetPathingPawn().MyUnit;
                m_kUnit.GetPathingPawn().MyUnit = m_kUnit.GetPawn();
                XGAbility_Grapple(m_kShot).ComputeGrapplePath(m_vTarget);
                m_kUnit.GetPathingPawn().MyUnit = PrevMyUnit;
                SetTargetLoc(m_kUnit.GetPathingPawn().GetPathDestination());
            }

            if (m_kAimingView != none)
            {
                SetTargetLoc(m_kUnit.GetPawn().GetNoTargetLocation(m_kAimingView.IsA('XGCameraView_AimingThirdPerson')));
                m_kCursor.MoveToLocation(m_vTarget, true);
            }

            if (m_kShot.GetPrimaryTarget() != none)
            {
                m_kTargetedEnemy = m_kShot.GetPrimaryTarget();
                SetUnitTarget(m_kTargetedEnemy);
            }
            else
            {
                m_kTargetedEnemy = none;
                SetUnitTarget(m_kTargetedEnemy);
            }
            UpdateAimingView();
        }
        else
        {
            m_kTargetedEnemy = none;
            SetUnitTarget(m_kTargetedEnemy);
            UpdateAimingView();
        }
    }

    if (m_kShot.m_kWeapon != none && m_kShot.m_kWeapon.GameplayType() == eItem_RocketLauncher)
    {
        if (m_kShot.GetPrimaryTarget() == none)
        {
            m_kUnit.DetermineEnemiesInSight(arrEnemies, arrEnemyDistSqs, m_kUnit.Location, false);

            if (arrEnemies.Length > 0)
            {
                kTempUnit = arrEnemies[0];
                fClosest = arrEnemyDistSqs[0];

                for (I = 1; I < arrEnemies.Length; I++)
                {
                    if (arrEnemyDistSqs[I] < fClosest)
                    {
                        kTempUnit = arrEnemies[I];
                    }
                }
            }

            if (kTempUnit == none)
            {
                SetUnitTarget(kTempUnit);
                vTempLocation = m_kUnit.GetPawn().GetNoTargetLocation();
                vTargetDir = Normal(vTempLocation - m_kUnit.GetLocation());
                vTempLocation = m_kUnit.GetLocation() + (vTargetDir * (float(15 * 64) * 0.350));
                m_kCursor.MoveToLocation(vTempLocation, true);
            }
            else
            {
                MoveCursor(XGUnit(kTempUnit), EAbility(m_kShot.iType));
                SetUnitTarget(kTempUnit);
            }

            UpdateAimingView();
        }
    }

    m_arrInteractionList_ConstrainedByAbilities.Remove(0, m_arrInteractionList_ConstrainedByAbilities.Length);

    for (I = 0; I < m_kUnit.GetNumAbilities(); I++)
    {
        kTempTargetedAbility = XGAbility_Targeted(m_kUnit.m_aAbilities[I]);
        kCEAbility = LWCE_XGAbility(m_kUnit.m_aAbilities[I]);

        if (kCEAbility != none && LWCE_XGAbility(m_kShot) != none && kCEAbility.m_TemplateName == LWCE_XGAbility(m_kShot).m_TemplateName)
        {
            kCEAbility.GetTargets(m_arrInteractionList_ConstrainedByAbilities);
        }
        else if (kTempTargetedAbility != none && kTempTargetedAbility.GetType() == m_kShot.GetType() && kTempTargetedAbility.GetPrimaryTarget() != none)
        {
            if (m_kShot.GetType() == eAbility_GreaterMindMerge)
            {
                m_kShot.GetTargets(m_arrInteractionList_ConstrainedByAbilities);
            }
            else
            {
                m_arrInteractionList_ConstrainedByAbilities.AddItem(kTempTargetedAbility.GetPrimaryTarget());
            }
        }
    }

    if (m_kInitialUnitTarget != none)
    {
        InitializeAbilityToTargetedUnit(m_kInitialUnitTarget);
        m_kInitialUnitTarget = none;
    }

    // Vital Point Targeting
    if (m_kUnit.GetCharacter().HasUpgrade(135))
    {
        m_kUnit.DeactivatePerk(135);

        if (m_kShot.GetXenobiologyOverlaysBonusDamage() > 0)
        {
            m_kUnit.ActivatePerk(135, m_kShot.GetPrimaryTarget());
        }
    }
}

simulated function SetUnitTarget(XGUnitNativeBase kTarget)
{
    if (LWCE_XGAbility(m_kShot) != none)
    {
        LWCE_XGAbility(m_kShot).SetCurrentTarget(kTarget);
    }

    super.SetUnitTarget(kTarget);
}

simulated function bool TraceToTarget_XComUnitPawn()
{
    local bool bProcessEnemy;
    local XGUnit kTargetUnit;
    local XGAbility_Targeted kMatchingTargetAbility;
    local int I;
    local UITacticalHUD_AbilityContainer kTacticalHUDAbilityContainer;
    local string strHelpMsg;
    local LinearColor tempLinearColor;
    local Vector VSize;

    bProcessEnemy = false;

    if (TargetActor != none && XComUnitPawn(TargetActor) != none)
    {
        kTargetUnit = XGUnit(XComUnitPawn(TargetActor).GetGameUnit());

        if (kTargetUnit != none && m_bOwnedByLocalPlayer)
        {
            if (kTargetUnit.IsVisible())
            {
                if (!kTargetUnit.IsCivilian())
                {
                    for (I = 0; I < m_kUnit.m_iNumAbilities; I++)
                    {
                        kMatchingTargetAbility = XGAbility_Targeted(m_kUnit.m_aAbilities[I]);

                        if (kMatchingTargetAbility != none && (kMatchingTargetAbility.GetType() == m_kShot.GetType() || LWCE_XGAbility(kMatchingTargetAbility) != none) && kMatchingTargetAbility.GetPrimaryTarget() != none && kMatchingTargetAbility.GetPrimaryTarget() == kTargetUnit)
                        {
                            if (kMatchingTargetAbility != m_kShot)
                            {
                                m_kShot.SetFreeAim(false);
                                SetShot(kMatchingTargetAbility, m_bOwnedByLocalPlayer);
                                m_kShot.SetFreeAim(true);
                            }
                            else
                            {
                                SetTargetLoc(GetTargetPawn().GetHeadshotLocation());
                                m_kTargetedEnemy = kTargetUnit;
                            }
                        }
                    }

                    if (kTargetUnit.m_eTeam != m_kUnit.m_eTeam)
                    {
                        strHelpMsg = m_strTargetNameEnemy;
                        tempLinearColor = MakeLinearColor(0.50, 0.0, 0.0, 0.10);
                    }
                    else
                    {
                        strHelpMsg = m_strTargetNameFriend;
                        tempLinearColor = MakeLinearColor(0.50, 0.0, 0.0, 0.10);
                    }
                }
                else
                {
                    m_kTargetedEnemy = none;
                    TargetActor = none;
                    strHelpMsg = m_strTargetNameCivilian;
                    tempLinearColor = MakeLinearColor(0.50, 0.0, 0.0, 0.10);
                }

                if (m_kShot.GetType() == /* Psychokinetic Strike */ 14 || m_kShot.GetType() == eAbility_DestroyTerrain || m_kShot.GetType() == eAbility_BullRush)
                {
                    kTacticalHUDAbilityContainer = m_kPres.GetTacticalHUD().m_kAbilityHUD;

                    if (kTacticalHUDAbilityContainer != none)
                    {
                        kTacticalHUDAbilityContainer.UpdateHelpMessage(strHelpMsg);

                        VSize.X = 15.0;
                        VSize.Y = 15.0;
                        VSize.Z = 15.0;
                        `SHAPEMGR.DrawSphere(m_vTarget, VSize, tempLinearColor, false);
                    }
                }

                bProcessEnemy = true;
            }
            else
            {
                m_kTargetedEnemy = none;
                TargetActor = none;
            }
        }
    }

    return bProcessEnemy;
}

simulated state Executing
{
    simulated event BeginState(name P)
    {
        super.BeginState(P);
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
    }

    simulated event Tick(float dt)
    {
        super.Tick(dt);
    }

    simulated function DrawSplashRadius()
    {
        local Vector vCenter;
        local float fRadius, fRestrictedRange, fTest;
        local LinearColor CylinderColor;
        local bool bValid;
        local int iType;

        bValid = true;
        iType = m_kShot.GetType();

        if (`GAMECORE.AbilityRequiresProjectilePreview(m_kShot))
        {
            if (`TACTICALGRI.m_kPrecomputedPath.iNumKeyframes <= 0)
            {
                return;
            }

            vCenter = `TACTICALGRI.m_kPrecomputedPath.GetEndPosition();
        }
        else if (iType == eAbility_DeathBlossom)
        {
            vCenter = m_kUnit.Location;
        }
        else if (iType == eAbility_BullRush)
        {
            vCenter = m_kUnit.GetPathingPawn().GetPathDestination();
        }
        else if (iType == eAbility_MEC_Barrage || (m_kShot.m_kWeapon != none && m_kShot.m_kWeapon.GameplayType() == eItem_RocketLauncher))
        {
            // TODO: use weapon template to decide, not GameplayType
            vCenter = m_bShotIsBlocked ? m_vHitLocation : m_vTarget;
        }
        else
        {
            vCenter = m_vTarget;
        }

        fRadius = class'LWCE_XGAbility_Extensions'.static.GetRadius(m_kShot);

        if (iType == eAbility_Rift)
        {
            bValid = XGAbility_Rift(m_kShot).IsValidRiftTarget(vCenter);
        }

        if (iType == eAbility_ShredderRocket)
        {
            m_kShot.iType = eAbility_NeedleGrenade;
            UpdateShotTargetLocation(vCenter, fRadius);
            m_kShot.iType = eAbility_ShredderRocket;
        }
        else
        {
            UpdateShotTargetLocation(vCenter, fRadius);
        }

        fRestrictedRange = fRadius;

        if (m_bTargetMustBeWithinCursorRange)
        {
            if (m_fAllowedCursorRange > 0.0)
            {
                fRestrictedRange = m_fAllowedCursorRange;
            }

            if (m_bOnlyFireAtLocation)
            {
                fTest = VSizeSq(vCenter - m_vFireOnlyAtThisLocation);
            }
            else
            {
                fTest = VSizeSq(vCenter - m_kFireOnlyAtThisUnit.Location);
            }

            fRestrictedRange = Square(fRestrictedRange);
        }

        if (!bValid || (m_bTargetMustBeWithinCursorRange && fTest >= fRestrictedRange))
        {
            CylinderColor = `LWCE_TACCFG(AreaTargetingInvalidColor);
        }
        else if (m_iSplashHitsFriendliesCache > 0 || m_iSplashHitsFriendlyDestructibleCache > 0)
        {
            CylinderColor = `LWCE_TACCFG(AreaTargetingFriendliesInRadiusColor);
        }
        else
        {
            CylinderColor = `LWCE_TACCFG(AreaTargetingValidColor);
        }

        ExplosionEmitter.SetLocation(vCenter);
        ExplosionEmitter.SetDrawScale(fRadius / 48.0);
        ExplosionEmitter.SetRotation(rot(0, 0, 1));

        if (!ExplosionEmitter.ParticleSystemComponent.bIsActive)
        {
            ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
        }

        ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, 'RadiusColor', CylinderColor);

        if (iType != eAbility_Rift)
        {
            ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, 'RadiusColor', CylinderColor);
        }
    }

    simulated function RealizeNewTarget()
    {
        local XGAbility_Targeted kAbility;

        PlaySound(`SoundCue("TargetLockCue"), true);
        LookAtTargetedEnemy();

        if (m_kShot.GetPrimaryTarget() != m_kTargetedEnemy)
        {
            if (LWCE_XGAbility(m_kShot) != none)
            {
                LWCE_XGAbility(m_kShot).SetCurrentTarget(m_kTargetedEnemy);
            }
            else
            {
                kAbility = XGAbility_Targeted(m_kUnit.FindAbility(m_kShot.iType, m_kTargetedEnemy));

                if (kAbility != none)
                {
                    SetShot(kAbility, true);
                }
            }

        }
    }
}