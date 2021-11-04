class XGCameraView_Firing extends XGCameraView_Cinematic
    native(Core);
//complete stub

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

simulated function Init(XGAction_Fire kFireAction){}
simulated function Vector GetMuzzleLoc(){}
simulated function Vector GetWeaponLoc(){}
simulated function Rotator GetWeaponRot(){}
simulated function bool IsMoving(){}
simulated function int GetNumProjectilesExpected(){}
simulated function OnProjectileSpawned(XComProjectile kProjectile){}
simulated function OnImpact(XComProjectile kProjectile);
simulated function OnMovedPastTarget(XComProjectile kProjectile);
simulated function FindBetterProjectile();

simulated state Playing
{}
simulated state BeforeFiring
{
    event PushedState(){}
}
simulated state FollowingProjectiles
{
    simulated event PushedState(){}
    simulated function OnImpact(XComProjectile kProjectile){}
    simulated function OnMovedPastTarget(XComProjectile kProjectile){}
    simulated function DramaticEnding(){}
    simulated function NonDramaticEnding(){}
    simulated event Tick(float fDeltaT){}
    simulated function FindBetterProjectile(){}
    simulated function FollowProjectile(XComProjectile kProjectile){}
    simulated function bool CurrentProjectileValid(){}
    simulated function bool IsGoodProjectile(XComProjectile kProjectile){}
    simulated function RemoveProjectile(XComProjectile kBadProjectile){}
    simulated function float GetSpeedFromCurve(float fDistanceFromDestination){}
}
simulated state DramaticEnding
{
    simulated event PushedState(){}
}
simulated state NonDramaticEnding
{
    simulated event PushedState();
}
simulated state FiringComplete
{}
