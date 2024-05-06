class DamageTypeHitEffectContainer extends Object;

struct DamageEffectMap
{
    var() class<DamageType> DamageTypeClass;
    var() XComPawnHitEffect HitEffect;
};

var() array<MaterialInterface> DecalMaterials;
var() array<DamageEffectMap> DamageTypeToHitEffectMap;
var(Death) ParticleSystem DeathEffect;
var(Death) SoundCue DeathSound;