class LWCEAction_Fire extends LWCEAction;

var LWCE_XGUnit m_kTargetedEnemy;
var LWCE_XGUnit m_kUnit;
var XComUnitPawn m_kPawn;

var XGCameraView m_kAimingView;
var LWCECameraView_Firing m_kFiringView;
var XGCameraView_Midpoint m_kMidpointView;
var LWCE_XGAbility m_kShot;
var LWCE_XComPresentationLayer m_kPres;

var protected Vector m_vTarget;
var protected bool m_bCameraIsReady;
var protected bool m_bFiringPanDone;
var protected bool m_bGlamCamActive;

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
    return m_kTargetedEnemy != none ? XComUnitPawn(m_kTargetedEnemy.m_kPawn) : none;
}

function ForAbilityContext(const out LWCE_TAbilityInputContext kInputContext, const out LWCE_TAbilityResult kResult)
{
    m_kShot = kInputContext.Ability;
    m_kUnit = LWCE_XGUnit(kInputContext.Source);
    m_kTargetedEnemy = LWCE_XGUnit(kInputContext.PrimaryTarget);

    if (m_kUnit != none)
    {
        m_kPawn = m_kUnit.GetPawn();
        m_vTarget = m_kPawn.GetHeadshotLocation(); // TODO: adjust for hit/miss
    }
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

            if (m_kTargetedEnemy != none && m_kTargetedEnemy != m_kUnit)
            {
                m_kTargetedEnemy.SetDiscState(eDS_AttackTarget);
            }
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

    if (m_kTargetedEnemy != none)
    {
        m_kTargetedEnemy.SetDiscState(eDS_AttackTarget);
    }

    // Hide the tactical HUD while visualizing
    m_kPres.HUDHide();


    CompleteAction();
}