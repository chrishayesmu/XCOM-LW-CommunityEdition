class XComFootstepSoundCollection extends Object
    dependson(XGGameData);

struct MaterialSoundPair
{
    var() EMaterialType MaterialType;
    var() SoundCue SoundCue;
    var() SoundCue SoundSplashCue;
};

var() array<MaterialSoundPair> FootstepSounds;