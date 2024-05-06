class XGCameraView_Firing extends XGCameraView_Cinematic
    native(Core)
    notplaceable
    hidecategories(Navigation);

var XComUnitPawn m_kShooter;
var XComUnitPawn m_kPawnTarget;
var Vector m_vTargetPos;
var XGAction_Fire m_kFireAction;
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

defaultproperties
{
    m_bWaitingForProjectile=true
    // m_kProjectileSpeedCurve=(Points=/* Array type was not detected. */)
    m_fMouseFOV=30.0
    bTickIsDisabled=false
}