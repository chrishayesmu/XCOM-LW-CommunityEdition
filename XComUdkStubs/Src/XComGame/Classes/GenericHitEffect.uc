class GenericHitEffect extends XComEmitter
    hidecategories(Navigation);

var() SoundCue HitSound;

defaultproperties
{
    HitSound=SoundCue'WP_AssaultRifleModern.MachineGunDirtCue'

    begin object name=ParticleSystemComponent0
        bOverrideLODMethod=true
        SecondsBeforeInactive=0.0
        LODMethod=ParticleSystemLODMethod.PARTICLESYSTEMLODMETHOD_DirectSet
    end object
}