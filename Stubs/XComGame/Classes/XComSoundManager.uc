class XComSoundManager extends Actor;
//complete stub

struct AmbientChannel
{
    var SoundCue Cue;
    var export editinline AudioComponent Component;
    var bool bHasPlayRequestPending;
};

protected function SetAmbientCue(out AmbientChannel Ambience, SoundCue NewCue){}
protected function StartAmbience(out AmbientChannel Ambience, optional float FadeInTime=0.50){}
protected function StopAmbience(out AmbientChannel Ambience, optional float FadeOutTime=1.0){}
function PlayMusic(SoundCue NewMusicCue, optional float FadeInTime){}
function StopMusic(optional float FadeOutTime=1.0){}
function Init();