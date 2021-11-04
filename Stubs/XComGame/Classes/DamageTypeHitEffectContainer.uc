class DamageTypeHitEffectContainer extends Object;
//complete stub
struct DamageEffectMap
{
    var() class<DamageType> DamageTypeClass;
    var() XComPawnHitEffect HitEffect;
};

var() array<MaterialInterface> DecalMaterials;
var() array<DamageEffectMap> DamageTypeToHitEffectMap;
var(Death) ParticleSystem DeathEffect;
var(Death) SoundCue DeathSound;

simulated function XComPawnHitEffect GetHitEffectsTemplateForDamageType(class<DamageType> DamageType, optional bool bExactClass){}
simulated function MaterialInterface GetDecalMaterial(){}
