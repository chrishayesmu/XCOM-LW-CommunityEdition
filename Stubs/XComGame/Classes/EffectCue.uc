class EffectCue extends Object
    native(Particle)
    hidecategories(Object);
//complete stub
struct native ParticleSystemEntry
{
    var() ParticleSystem ParticleSystem;
    var() float Weight;

    structdefaultproperties
    {
        ParticleSystem=none
        Weight=1.0
    }
};

var() export editinline array<export editinline ParticleSystemEntry> ParticleSystems;

native function int PickParticleSystemIndexToUse();
function ParticleSystem PickParticleSystemToUse(){}
function ParticleSystemComponent PlayOnActor(Actor A, optional SkeletalMeshComponent AttachMesh, optional SkeletalMeshSocket AttachSocket, optional float WarmupTime=-1.0, optional EmitterInstanceParameterSet ParameterSet){}
static function ParticleSystemComponent SpawnEffect(WorldInfo Info, EffectCue kCue, Vector kLocation, Rotator kRotation){}
static function ParticleSystemComponent SpawnEffectWithInstanceParams(WorldInfo Info, EffectCue kCue, Vector kLocation, Rotator kRotation, const out array<ParticleSysParam> InstanceParameters, optional float WarmupTime=-1.0, optional Vector Scale){}
