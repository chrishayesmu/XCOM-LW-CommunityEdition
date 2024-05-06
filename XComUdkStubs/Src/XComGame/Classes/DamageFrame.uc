class DamageFrame extends Object
    native(Core);

var DamageEvent Event;
var bool bActive;
var float LastStartTime;
var native const transient Array_Mirror Regions;
var native const transient MultiMap_Mirror DamagedActors;
var const export editinline transient array<export editinline ParticleSystemComponent> SpawnedPSCs;
var const int MaxDesiredParticlesPerEvent;

defaultproperties
{
    Event=(DamageAmount=0,EventInstigator=none,HitLocation=(X=0.0,Y=0.0,Z=0.0),Momentum=(X=0.0,Y=0.0,Z=0.0),DamageType=none,HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName=None,HitComponent=none),DamageCauser=none,bRadialDamage=false,Radius=0.0,bIsHit=false,IgnoredActors=none,Target=none,bDamagesUnits=true,bCausesSurroundingAreaDamage=true,bDebug=false,FilterBox=(Min=(X=0.0,Y=0.0,Z=0.0),Max=(X=0.0,Y=0.0,Z=0.0),IsValid=0),kShot=none)
    MaxDesiredParticlesPerEvent=16
}