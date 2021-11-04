class XGAction_FireCustom_Flamethrower extends Actor
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

var config float SweepAngle;
var config float Range;
var config int NumSweeps;
var config string SecondaryFire_ParticleEffectPath;
var config string SecondaryFire_Elerium_ParticleEffectPath;
var config string FillFire_ParticleEffectPath;
var config string FlameDamage_ParticleEffectPath;
var config string FlameKill_ParticleEffectPath;
var config bool SweepFullCircle;
var bool bClearedToFire;
var config float ChanceToSetFire;
var config float FireProcessingInterval;
var config float FireChance_Level1;
var config float FireChance_Level2;
var config float FireChance_Level3;
var config float LengthUpdateSpeed;
var XGAction_Fire FireAction;
var XGUnit m_kUnit;
var XComUnitPawn m_kPawn;
var Vector PawnDirectionVector;
var float SweepTime;
var float FiredTime;
var float ElapsedSweepTime;
var float StartFiringTime;
var float StopFiringTime;
var float SweepAimOffsetStop_Pawn;
var float SweepAimOffsetStop_Game;
var float SweepOffsetMultiplier;
var float RangeInUnits;
var Vector ToTargetDir;
var name Prev_FFSequenceAnimName;
var AnimNodeSequence FFSequence;
var int PotentialFireColumnsProcessed;
var array<XGUnitNativeBase> UnitsSetOnFire;
var int UnitsSetOnFireProcessed;
var array<Vector> SecondaryFires;
var int SecondaryFiresProcessed;
var float FireLevelTotal;
var array<int> FiresToSet;
var float FireProcessingTimer;
var int FireDamage;
var ParticleSystem SecondaryFireFX;
var ParticleSystem FillFireFX;

simulated function Init(){}

auto state Idle
{
}
simulated state Firing
{
    simulated function SetFires(){}
    simulated event Tick(float fDeltaT){}
    simulated function SetupFiringTimings(){}
    simulated function bool TargetUnitsPanicking(){}
}
