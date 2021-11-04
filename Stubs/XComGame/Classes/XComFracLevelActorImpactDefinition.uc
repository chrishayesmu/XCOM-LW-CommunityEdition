class XComFracLevelActorImpactDefinition extends Object
    native(Level)
	dependson(XGGameData);
//compmlete stub

struct native WeaponImpact
{
    var() class<XComDamageType> EffectDamageType;
    var() editinline EffectCue EffectTemplate;
};

struct native MaterialImpact
{
    var() EMaterialType MaterialType;
    var() array<WeaponImpact> WeaponBasedEffects;
    var() StaticMesh EdgeBaseDebrisModel_Large;
    var() editinline EffectCue EffectTemplate;
};

var() array<MaterialImpact> MaterialBasedEffects;
var() EmitterInstanceParameterSet DefaultInstanceParameterSet;

simulated event ParticleSystemComponent SpawnFracturedEffect(XComFracLevelActor FracActor, EffectCue Cue, Box EffectBox, Vector Rotation){}
simulated event ParticleSystemComponent SpawnEffect(XComFracLevelActor FracActor, EffectCue Cue, Vector EffectLocation, Vector EffectRotation, const out array<ParticleSysParam> InstanceParameters){}
simulated event SpawnGroundDebris(XComFracLevelActor FracActor, const out Box PlacementBox, float GroundZ){}
