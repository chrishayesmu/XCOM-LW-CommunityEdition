class EffectCue extends Object
    native(Particle)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native ParticleSystemEntry
{
    var() ParticleSystem ParticleSystem;
    var() float Weight;

    structdefaultproperties
    {
        Weight=1.0
    }
};

var() export editinline array<export editinline ParticleSystemEntry> ParticleSystems;