class XComSoundManager extends Actor
    notplaceable
    hidecategories(Navigation);

struct AmbientChannel
{
    var SoundCue Cue;
    var export editinline AudioComponent Component;
    var bool bHasPlayRequestPending;
};