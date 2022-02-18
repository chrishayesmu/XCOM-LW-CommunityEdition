class Highlander_XGAction_Targeting extends XGAction_Targeting;

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
                if (XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.iNumKeyframes <= 0)
                {
                    return false;
                }

                vCenter = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.GetEndPosition();
            }
            else
            {
                vCenter = m_vTarget;
            }

            fRadius = m_kShot.m_kWeapon.GetDamageRadius();

            switch (m_kShot.GetType())
            {
                case eAbility_Rift:
                    fRadius = `HL_TACCFG(fRiftRadius);
                    break;
                case eAbility_ShotDamageCover: // Psychokinetic Strike
                    fRadius = `HL_TACCFG(fPsychokineticStrikeRadius);
                    break;
                case eAbility_MEC_Barrage: // Collateral Damage
                    fRadius = `HL_TACCFG(fCollateralDamageRadius);
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
            if (XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.iNumKeyframes <= 0)
            {
                return;
            }

            vCenter = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.GetEndPosition();
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
            vCenter = m_bShotIsBlocked ? m_vHitLocation : m_vTarget;
        }
        else
        {
            vCenter = m_vTarget;
        }

        if (`BATTLE.m_kDesc.m_bIsTutorial)
        {
            if (`PRES.GetTacticalHUD().m_kAbilityHUD.m_iUseOnlyAbility != -1 && `PRES.GetTacticalHUD().m_kAbilityHUD.m_iUseOnlyAbility != `PRES.GetTacticalHUD().m_kAbilityHUD.m_iCurrentIndex)
            {
                bValid = false;
            }
        }

        if (m_kShot.m_kWeapon != none)
        {
            fRadius = m_kShot.m_kWeapon.GetDamageRadius();
        }

        // TODO move into config
        switch (iType)
        {
            case eAbility_BullRush:
                fRadius = `HL_TACCFG(fBullRushRadius);
                break;
            case eAbility_Rift:
                fRadius = `HL_TACCFG(fRiftRadius);
                bValid = XGAbility_Rift(m_kShot).IsValidRiftTarget(vCenter);
                break;
            case eAbility_TelekineticField:
                fRadius = `HL_TACCFG(fTelekineticFieldRadius);
                break;
            case eAbility_ShotOverload:
                fRadius = `HL_TACCFG(fOverloadRadius);
                break;
            case eAbility_DeathBlossom:
                fRadius = `HL_TACCFG(fDeathBlossomRadius);
                break;
            case eAbility_PsiInspiration:
                fRadius = `HL_TACCFG(fPsiInspirationRadius);
                break;
            case eAbility_MEC_Barrage:
                fRadius = `HL_TACCFG(fCollateralDamageRadius);
                break;
            case eAbility_MEC_ElectroPulse:
                fRadius = class'XGAbility_Electropulse'.default.ElectroPulseXY_Range;
                break;
            case eAbility_ShredderRocket:
                if (`HL_TACCFG(fShredderRocketRadiusOverride) >= 0.0)
                {
                    // TODO: factor in radius increases like Danger Zone when using override
                    fRadius = `HL_TACCFG(fShredderRocketRadiusOverride);
                }
                else
                {
                    fRadius *= `HL_TACCFG(fShredderRocketRadiusMultiplier);
                }

                break;
            case eAbility_ShotDamageCover: // Psychokinetic Strike
                fRadius = float(2 * 96) * Sqrt(float(m_kUnit.ReplicateActivatePerkData_ToString()) / float(100));
                break;
            default:
                break;
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
            CylinderColor = `HL_TACCFG(AreaTargetingInvalidColor);
        }
        else if (m_iSplashHitsFriendliesCache > 0 || m_iSplashHitsFriendlyDestructibleCache > 0)
        {
            CylinderColor = `HL_TACCFG(AreaTargetingFriendliesInRadiusColor);
        }
        else
        {
            CylinderColor = `HL_TACCFG(AreaTargetingValidColor);
        }

        ExplosionEmitter.SetLocation(vCenter);
        ExplosionEmitter.SetDrawScale(fRadius / 48.0);
        ExplosionEmitter.SetRotation(rot(0, 0, 1));

        if (!ExplosionEmitter.ParticleSystemComponent.bIsActive)
        {
            ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
        }

        ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, name("RadiusColor"), CylinderColor);

        if (iType != eAbility_Rift)
        {
            ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, name("RadiusColor"), CylinderColor);
        }
    }
}