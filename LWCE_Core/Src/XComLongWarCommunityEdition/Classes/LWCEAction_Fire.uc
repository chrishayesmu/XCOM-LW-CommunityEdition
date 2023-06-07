class LWCEAction_Fire extends LWCEAction;

var LWCE_XGUnit m_kTargetUnit;
var LWCE_XGUnit m_kUnit;
var XComUnitPawn m_kPawn;
var LWCE_XGWeapon m_kWeapon;

var XGCameraView m_kAimingView;
var LWCECameraView_Firing m_kFiringView;
var XGCameraView_Midpoint m_kMidpointView;
var LWCE_XGAbility m_kAbility;
var LWCE_XComPresentationLayer m_kPres;

var protected Vector m_vTarget;
var protected int m_iAimingIterations;

var protected bool m_bAttackerVisibleToEnemy;
var protected bool m_bCameraIsReady;
var protected bool m_bFiringPanDone;
var protected bool m_bGlamCamActive;
var protected bool m_bProjectileWillBeVisibleToEnemy;
var protected bool m_bUpdateAnimRot;
var protected bool m_bUseAimAtTargetMissPercentage;

function Init()
{
    super.Init();

    m_kPres = `LWCE_TACPRES;
}

function Vector GetTargetLoc()
{
    return m_vTarget;
}

function XComUnitPawn GetTargetPawn()
{
    return m_kTargetUnit != none ? XComUnitPawn(m_kTargetUnit.m_kPawn) : none;
}

function ForAbilityContext(const out LWCE_TAbilityInputContext kInputContext, const out LWCE_TAbilityResult kResult)
{
    m_kAbility = kInputContext.Ability;
    m_kUnit = LWCE_XGUnit(kInputContext.Source);
    m_kTargetUnit = LWCE_XGUnit(kInputContext.PrimaryTarget);

    if (m_kUnit != none)
    {
        m_kPawn = m_kUnit.GetPawn();
        m_vTarget = GetTargetPawn().GetHeadshotLocation(); // TODO: adjust for hit/miss
    }
}

function bool IsHit()
{
    return m_kAbility.HitResultIsHit(m_kAbility.m_kResult);
}

function bool IsInLowCover(XGUnit kUnit)
{
    if (kUnit.IsInCover() && kUnit.GetCoverType() == CT_MidLevel)
    {
        return true;
    }

    return false;
}

function bool IsReflected()
{
    return false; // TODO
}

function bool IsThirdPersonAiming()
{
    if (m_kAimingView != none && m_kAimingView.IsA('XGCameraView_AimingThirdPerson'))
    {
        return true;
    }

    return false;
}

function Vector NonUnitTargetAdjustedForMiss()
{
    local Vector vAdjustTarget, VDir, vFinalDir;
    local int iMinDistance, iDistanceToUse, iAngleToUse;
    local float fAngleInRadians, perkModRadius;

    if (m_kAbility != none && (m_kAbility.m_kWeapon.GameplayType() == eItem_RocketLauncher) || m_kAbility.m_kWeapon.GameplayType() == eItem_BlasterLauncher)
    {
        perkModRadius = m_kAbility.m_kWeapon.GetDamageRadius();

        iMinDistance = int(perkModRadius * 0.50);
        iDistanceToUse = `SYNC_RAND(int(perkModRadius - iMinDistance)) + iMinDistance;

        iAngleToUse = `SYNC_RAND(120);
        iAngleToUse -= 60;
        fAngleInRadians = float(iAngleToUse) * 0.017453290;

        VDir = m_vTarget - m_kUnit.GetLocation();
        VDir.Z = 0.0;
        VDir = Normal(VDir);

        vFinalDir.X = (VDir.X * Cos(fAngleInRadians)) - (VDir.Y * Sin(fAngleInRadians));
        vFinalDir.Y = (VDir.X * Sin(fAngleInRadians)) + (VDir.Y * Cos(fAngleInRadians));
        vFinalDir.Z = VDir.Z;

        vAdjustTarget = (vFinalDir * iDistanceToUse) + m_vTarget;
    }
    else
    {
        vAdjustTarget = m_vTarget;
    }

    return vAdjustTarget;
}

function SetTargetForPawn(Vector vTarget)
{
    if (vTarget != m_kPawn.TargetLoc)
    {
        m_kPawn.TargetLoc = vTarget;
    }
}

function Vector TargetAdjustedForMiss()
{
    local Vector vAdjustTarget;
    local float Distance, Multiplier, Pct;
    local XComUnitPawn TargetPawn;

    TargetPawn = GetTargetPawn();

    if (TargetPawn != none && TargetPawn.CylinderComponent != none)
    {
        Distance = VSize(TargetPawn.Location - m_kPawn.Location);
        Pct = FClamp((Distance - TargetPawn.CloseRangeMissDistance) / (TargetPawn.NormalMissDistance - TargetPawn.CloseRangeMissDistance), 0.0, 1.0);
        Multiplier = TargetPawn.CloseRangeMissAngleMultiplier + (Pct * (TargetPawn.NormalMissAngleMultiplier - TargetPawn.CloseRangeMissAngleMultiplier));
        vAdjustTarget = m_kUnit.AdjustTargetForMiss(m_kTargetUnit, Multiplier, true);
    }
    else
    {
        vAdjustTarget = m_vTarget;
    }

    return vAdjustTarget;
}

function UpdateAnimationRotation(float dt)
{
    local bool bTurn;

    bTurn = true;

    if (GetTargetPawn() != m_kPawn && GetTargetPawn() != none)
    {
        if (m_bUseAimAtTargetMissPercentage)
        {
            m_kPawn.SmoothAimAtTarget(dt, m_vTarget + ((m_kPawn.TargetLoc - m_vTarget) * m_kPawn.AimAtTargetMissPercent), bTurn);
        }
        else
        {
            m_kPawn.SmoothAimAtTarget(dt, m_kPawn.TargetLoc, bTurn);
        }
    }
    else if (GetTargetPawn() == none && m_vTarget != vect(0.0, 0.0, 0.0))
    {
        m_kPawn.SmoothAimAtTarget(dt, m_vTarget, bTurn);
    }
}

function CameraIsDone()
{
}

function CommenceFiring()
{
}

state Executing
{
    function CameraIsDone()
    {
        if (m_bGlamCamActive)
        {
            m_bGlamCamActive = false;
        }

        `BATTLE.CameraMoveComplete(XComTacticalController(m_kUnit.PRES().Owner));
    }

    function CommenceFiring()
    {
        m_bCameraIsReady = true;
    }

    function FireWeapon()
    {
        m_kPawn.m_eWeaponState = eAnimWeaponState_Fire;

        if (m_kUnit.bSteppingOutOfCover)
        {
            m_kPawn.SetSuppressionNodes(false, 0.0);
        }

        m_bCameraIsReady = true;
    }

    function SetTargetForFiring()
    {
        m_kPawn.MovementNode.SetActiveChild(eMoveType_Stationary, 0.10);

        if (m_kTargetUnit == none && m_kAbility != none && !m_kAbility.m_bHit_NonUnitTarget)
        {
            `LWCE_LOG_CLS("Setting target: NonUnitTargetAdjustedForMiss");
            SetTargetForPawn(NonUnitTargetAdjustedForMiss());
        }
        else if (m_kTargetUnit != none && !IsHit())
        {
            `LWCE_LOG_CLS("Setting target: TargetAdjustedForMiss");
            SetTargetForPawn(TargetAdjustedForMiss());
        }
        else
        {
            `LWCE_LOG_CLS("Setting target: m_vTarget");
            SetTargetForPawn(m_vTarget);
        }
    }

    function SetupFiringPanToEnemy()
    {
        if (`CHEATMGR_TAC != none && `CHEATMGR_TAC.bThirdPersonAllTheTime)
        {
            return;
        }

        if (m_kUnit.IsSuppressionExecuting())
        {
            return;
        }

        if (IsThirdPersonAiming())
        {
            return;
        }

        if (!m_bFiringPanDone && !m_kUnit.IsMine() || !`BATTLE.m_kGlamMgr.m_bGlamBusy)
        {
            m_bFiringPanDone = true;

            m_kFiringView = Spawn(class'LWCECameraView_Firing', Owner);
            m_kFiringView.Init(self);

            m_kMidpointView = Spawn(class'XGCameraView_Midpoint', Owner);
            m_kMidpointView.SetShooter(m_kUnit);
            m_kMidpointView.SetTarget(m_vTarget);

            if (m_kTargetUnit != none && m_kTargetUnit != m_kUnit)
            {
                m_kTargetUnit.SetDiscState(eDS_AttackTarget);
            }
        }
    }

    event Tick(float fDeltaT)
    {
        if (GetALocalPlayerController().CheatManager != none && `CHEATMGR_TAC.bDebugTargetting)
        {
            `SHAPEMGR.DrawSphere(m_vTarget, vect(20.0, 20.0, 20.0), MakeLinearColor(1.0, 0.0, 0.0, 0.60), false);
            `SHAPEMGR.DrawSphere(m_kPawn.TargetLoc, vect(20.0, 20.0, 20.0), MakeLinearColor(0.0, 1.0, 0.0, 0.60), false);
        }

        if (m_bUpdateAnimRot)
        {
            UpdateAnimationRotation(fDeltaT);
        }
    }

Begin:
    if (!`BATTLE.m_kGlamMgr.m_bGlamBusy)
    {
        SetupFiringPanToEnemy();
        Sleep(0.0);

        if (XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kCameraManager.IsTrackingFiringUnit(m_kUnit))
        {
            `LWCE_LOG_CLS("Firing unit " $ m_kUnit $ " is being tracked; setting wait flag");
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kCameraManager.SetCameraWaitFlag();
        }

        while (XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kCameraManager.WaitForCamera())
        {
            `LWCE_LOG_CLS("Waiting for camera");
            Sleep(0.050);
        }
    }

    m_kWeapon = LWCE_XGWeapon(m_kUnit.GetInventory().GetActiveWeapon());
    m_bUpdateAnimRot = true;

    if (!m_bAttackerVisibleToEnemy && m_bProjectileWillBeVisibleToEnemy)
    {
        // This doesn't always seem to work, e.g. when Floaters shoot from out of LoS, they aren't always shown to the player
        m_kUnit.m_bForceVisible = true;
        class'XComWorldData'.static.GetWorldData().UpdateVisibility();
    }

    if (m_kPawn.AimingNode != none && m_kTargetUnit != m_kUnit)
    {
        if (!m_kUnit.IsInCover())
        {
            m_iAimingIterations = 0;

            while (!m_kPawn.TurnNode.FinishedTurning() && !m_kPawn.IsAimedAtTargetLoc() && m_iAimingIterations < 500)
            {
                m_bUpdateAnimRot = true;

                Sleep(0.0);
                m_iAimingIterations++;
            }

            m_bUpdateAnimRot = false;
        }
    }

    SetTargetForFiring();
    m_bUpdateAnimRot = true;
    m_bUseAimAtTargetMissPercentage = true;
    FireWeapon();

    while (m_kPawn.m_eWeaponState == eAnimWeaponState_Fire)
    {
        Sleep(0.0);
    }

    CompleteAction();
}