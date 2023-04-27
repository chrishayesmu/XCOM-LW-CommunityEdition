class LWCECameraView_Firing extends XGCameraView_Cinematic;

var XComUnitPawn m_kShooter;
var XComUnitPawn m_kPawnTarget;
var Vector m_vTargetPos;
var LWCEAction_Fire m_kFireAction;
var Vector m_vCam;
var Vector m_vShot;
var float m_fShotDistance;
var float m_fProjectileCamTrigger;
var float m_fTargetCamTrigger;
var bool m_bShooterInvisible;
var bool m_bWaitingForProjectile;
var int m_iNumBursts;
var int m_iNumProjectilesPerBurst;
var XComProjectile m_kProjectile;
var array<XComProjectile> m_arrProjectiles;
var() InterpCurveFloat m_kProjectileSpeedCurve;
var name m_nmNextState;
var protected float HACK_fAbortTimer;

simulated function Init(LWCEAction_Fire kFireAction)
{
    m_kFireAction = kFireAction;
    m_kShooter = kFireAction.m_kPawn;
    m_bCanStack = true;
    m_bShooterInvisible = !m_kShooter.IsVisibleToTeam(GetALocalPlayerController().m_eTeam);
    m_vTargetPos = kFireAction.GetTargetLoc();
    m_kPawnTarget = kFireAction.GetTargetPawn();

    m_vShot = m_vTargetPos - GetMuzzleLoc();
    m_fShotDistance = VSize(m_vShot);
    m_vShot = Normal(m_vShot);

    GotoState('Playing');
}

simulated function Vector GetMuzzleLoc()
{
    local XComWeapon ActiveWeapon;
    local Vector vLoc;
    local Rotator rRot;

    ActiveWeapon = XComWeapon(m_kFireAction.m_kUnit.GetInventory().GetActiveWeapon().m_kEntity);

    if (ActiveWeapon != none)
    {
        vLoc = ActiveWeapon.GetMuzzleLoc();
    }
    else
    {
        m_kFireAction.m_kPawn.GetFireSocket(vLoc, rRot);
    }

    return vLoc;
}

simulated function OnProjectileSpawned(XComProjectile kProjectile)
{
    if (!IsInState('FollowingProjectiles'))
    {
        PushState('FollowingProjectiles');
    }

    m_arrProjectiles.AddItem(kProjectile);

    if (m_kProjectile == none)
    {
        FindBetterProjectile();
    }
}

simulated function OnImpact(XComProjectile kProjectile)
{
}

simulated function OnMovedPastTarget(XComProjectile kProjectile)
{
}

simulated function FindBetterProjectile()
{
}

simulated state Playing
{
Begin:
    PushState('BeforeFiring');

    // TODO: need a proper way to check if the ability is melee rather than the weapon
    if (m_kShooter.Weapon != none && !XComWeapon(m_kShooter.Weapon).m_kGameWeapon.IsMelee())
    {
        PushState('FollowingProjectiles');
        PushState(m_nmNextState);
    }
    else
    {
        m_kFireAction.CommenceFiring();
    }

    PushState('FiringComplete');
    stop;
}

simulated state BeforeFiring
{
    event PushedState()
    {
        if (m_bShooterInvisible)
        {
            if (m_kPawnTarget != none)
            {
                SetActorTarget(m_kPawnTarget);
            }
            else
            {
                SetLocationTarget(m_vTargetPos);
            }
        }
        else
        {
            SetActorTarget(m_kShooter);
        }
    }

Begin:
    Sleep(0.0);
    stop;
}

simulated state FollowingProjectiles
{
    simulated event PushedState()
    {
        m_kFireAction.CommenceFiring();
    }

    simulated function OnImpact(XComProjectile kProjectile)
    {
        if (m_kPawnTarget != none && m_kPawnTarget.GetGameUnit().IsDead())
        {
            DramaticEnding();
        }
        else
        {
            RemoveProjectile(kProjectile);
        }
    }

    simulated function OnMovedPastTarget(XComProjectile kProjectile)
    {
        RemoveProjectile(kProjectile);
    }

    simulated function DramaticEnding()
    {
        m_nmNextState = 'DramaticEnding';
        PopState();
    }

    simulated function NonDramaticEnding()
    {
        m_nmNextState = 'NonDramaticEnding';
        PopState();
    }

    simulated event Tick(float fDeltaT)
    {
        HACK_fAbortTimer += fDeltaT;

        if (HACK_fAbortTimer > 5.0f)
        {
            NonDramaticEnding();
            return;
        }

        if (!CurrentProjectileValid())
        {
            NonDramaticEnding();
        }
    }

    simulated function FindBetterProjectile()
    {
        local XComProjectile kProjectile;

        foreach m_arrProjectiles(kProjectile)
        {
            if (kProjectile == none)
            {
                continue;
            }

            if (VSizeSq(GetLookAt() - m_vTargetPos) > (VSizeSq(kProjectile.Location - m_vTargetPos) + 64.0f))
            {
                FollowProjectile(kProjectile);
                return;
            }
        }
    }

    simulated function FollowProjectile(XComProjectile kProjectile)
    {
        m_kProjectile = kProjectile;
        SetActorTarget(kProjectile);
    }

    simulated function bool CurrentProjectileValid()
    {
        if (m_kFireAction.m_kShot != none && !m_kFireAction.m_kShot.IsGrenadeAbility() && m_kFireAction.m_kShot.IsBlasterLauncherShot() && (!m_kFireAction.m_kShot.m_bHit || `GAMECORE.m_kAbilities.AbilityHasProperty(m_kFireAction.m_kShot.iType, 2)) || `GAMECORE.m_kAbilities.AbilityHasEffect(m_kFireAction.m_kShot.iType, 5))
        {
            return false;
        }

        if (m_kProjectile == none)
        {
            return true;
        }

        if (m_kProjectile.bHasExploded)
        {
            return false;
        }

        return true;
    }

    simulated function bool IsGoodProjectile(XComProjectile kProjectile)
    {
        return kProjectile != none;
    }

    simulated function RemoveProjectile(XComProjectile kBadProjectile)
    {
        local int iProjectile;

        if (m_kProjectile == kBadProjectile)
        {
            SetLocationTarget(m_kProjectile.Location);
            m_bWaitingForProjectile = true;
        }

        for (iProjectile = 0; iProjectile < m_arrProjectiles.Length; iProjectile++)
        {
            if (m_arrProjectiles[iProjectile] == kBadProjectile)
            {
                m_arrProjectiles[iProjectile] = none;
            }
        }
    }

    simulated function float GetSpeedFromCurve(float fDistanceFromDestination)
    {
        if (m_kProjectile != none)
        {
            return FMax(1.0, class'Helpers'.static.S_EvalInterpCurveFloat(m_kProjectileSpeedCurve, fDistanceFromDestination));
        }
        else
        {
            return super(XGCameraView).GetSpeedFromCurve(fDistanceFromDestination);
        }
    }

Begin:
    stop;
}

simulated state DramaticEnding
{
    simulated event PushedState()
    {
        if (m_kProjectile == none)
        {
            if (m_kPawnTarget != none)
            {
                SetActorTarget(m_kPawnTarget);
            }
            else
            {
                SetLocationTarget(m_vTargetPos);
            }
        }
    }

Begin:
    Sleep(2.0);
    PopState();
    stop;
}

simulated state NonDramaticEnding
{
    ignores PushedState;

Begin:
    if (!m_kFireAction.IsReflected())
    {
        if (m_kPawnTarget != none)
        {
            SetActorTarget(m_kPawnTarget);
        }
        else
        {
            SetLocationTarget(m_vTargetPos);
        }

        Sleep(1.0);
    }

    PopState();
    stop;
}

simulated state FiringComplete
{
Begin:
    m_kFireAction.CameraIsDone();
    PopState();
    stop;
}

defaultproperties
{
    m_kProjectileSpeedCurve=(Points=/* Array type was not detected. */)
    bTickIsDisabled=false
}