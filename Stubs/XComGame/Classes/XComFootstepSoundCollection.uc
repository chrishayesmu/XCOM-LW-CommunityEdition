class XComFootstepSoundCollection extends Object;
//complete stub
struct MaterialSoundPair
{
    var() XGGameData.EMaterialType MaterialType;
    var() SoundCue SoundCue;
    var() SoundCue SoundSplashCue;
};

var() array<MaterialSoundPair> FootstepSounds;

function SoundCue GetFootstepSoundInArray(int FootstepSoundIndex, bool bIsOutsideAndIsRaining){}
function PlayFootStepSound(Pawn P, int FootIndex, EMaterialType MaterialType, bool bIsOutsideAndIsRaining){}
