class XGAction_FireCustom_Barrage extends Actor
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

var config float BarrageTime;
var config float BarrageRadius;
var config float BarrageTimeBetweenRetargets;
var config float BarrageStartAOEEffectTime;
var name Level1Weapon_AnimName;
var XGUnit m_kUnit;
var XComUnitPawn m_kPawn;
var XGWeapon CurrentWeapon;
var XComWeapon CurrentWeaponEntity;
var XGAction_Fire FireAction;
var AnimNodeSequence FinishAnimNodeSequence;
var float AnimTime;
var bool bWaitingToDestroyCover;
var bool bClearedToFire;
var bool bPlayedAOEEffects;
var int NumCustomFireNotifies;
var int LastNumCustomFireNotifies;
var Vector HitLocation;
var float RetargetTimer;
var array<Vector> ValidTargets;

simulated function Init(){}

auto state Idle
{}

simulated state Firing
{
    simulated event Tick(float fDeltaT){}
    simulated function DamageEnvironment(const out Vector InHitLocation){}
    function DamageUnits(const out Vector InHitLocation){}
    function FindNextTarget(float fDeltaT){}
}
