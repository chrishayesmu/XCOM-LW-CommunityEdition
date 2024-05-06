class XComProjectileImpactActor extends Actor
    native(Graphics)
    notplaceable
    hidecategories(Navigation,Object);

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

    structdefaultproperties
    {
        SpawnDecalEveryXthHit=1
    }
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

defaultproperties
{
    DefaultDecalThickness=50.0
    DefaultDecalScale=100.0
    DefaultDecalBackfaceAngle=0.0010
}