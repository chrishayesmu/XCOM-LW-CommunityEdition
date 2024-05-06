class XGAction_FireCustom_Barrage extends Actor
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

var config float BarrageTime;
var config float BarrageRadius;
var config float BarrageTimeBetweenRetargets;
var config float BarrageStartAOEEffectTime;
var private name Level1Weapon_AnimName;
var private XGUnit m_kUnit;
var private XComUnitPawn m_kPawn;
var private XGWeapon CurrentWeapon;
var private XComWeapon CurrentWeaponEntity;
var private XGAction_Fire FireAction;
var private AnimNodeSequence FinishAnimNodeSequence;
var private float AnimTime;
var private bool bWaitingToDestroyCover;
var private bool bClearedToFire;
var private bool bPlayedAOEEffects;
var private int NumCustomFireNotifies;
var private int LastNumCustomFireNotifies;
var private Vector HitLocation;
var private float RetargetTimer;
var private array<Vector> ValidTargets;

defaultproperties
{
    Level1Weapon_AnimName=FF_BarrageA
}