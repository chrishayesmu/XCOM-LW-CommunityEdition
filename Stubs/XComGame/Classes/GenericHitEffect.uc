class GenericHitEffect extends XComEmitter
    hidecategories(Navigation);
//complete stub
var() SoundCue HitSound;

simulated event PostBeginPlay()
{
    super(Emitter).PostBeginPlay();
    PlaySound(HitSound);
}