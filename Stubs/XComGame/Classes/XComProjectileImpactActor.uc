class XComProjectileImpactActor extends Actor
    native(Graphics)
	DependsOn(XGGameData);
//complete stub

struct native XComMaterialDamageType
{
    var() ParticleSystem SurfaceImpactFX;
    var() editinline DecalCue Decals;
    var() DecalProperties PrimaryDecalProperties;
    var DecalProperties TopLayerDecalProperties;
    var() editinline DecalCue SecondaryDecals;
    var() DecalProperties SecondaryDecalProperties;
    var editinline DecalCue SubLayerDecals;
    var DecalProperties SubLayerDecalProperties;
    var() SoundCue ImpactSoundCue;
    var() bool bUseDefaultDecal;
    var() int SpawnDecalEveryXthHit;
    var() EMaterialType MaterialType;
};

var() array<XComMaterialDamageType> MaterialSpecificImpactData;
var() editinline DecalCue DefaultImpactDecals;
var() DecalProperties DefaultImpactDecalProperties;
var int CurrentlySelectImpactIndex;
var Actor ImpactedActor;
var Vector HitLocation;
var Vector HitNormal;
var TraceHitInfo TraceInfo;
var Vector TraceLocation;
var Vector TraceNormal;
var Rotator RealRotation;
var Actor TraceActor;
var export editinline AudioComponent ImpactSound;
var const float DefaultDecalThickness;
var const float DefaultDecalScale;
var const float DefaultDecalBackfaceAngle;
var bool bIsPooledActor;
var bool bIsCurrentlyInUse;
var XComProjectileImpactActor ActorTemplate;

native simulated function InitImpactActorFromPool(XComProjectile ActorOwner);
simulated function SpawnDecal(){}
simulated function DestroyImpactActor(){}
simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent){}
simulated function bool SpawnEffect(){}
simulated function bool CalcMaterialAtHitPosition(){}
simulated function PlayImpactSound(){}
simulated function Init(){}
