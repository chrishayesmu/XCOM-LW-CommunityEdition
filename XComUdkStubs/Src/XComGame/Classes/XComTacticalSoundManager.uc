class XComTacticalSoundManager extends XComSoundManager
    notplaceable
    hidecategories(Navigation);

enum ERainIntensity
{
    eRain_NoRain,
    eRain_LightRain,
    eRain_MediumRain,
    eRain_HeavyRain,
    eRain_MAX
};

var const XComTacticalSoundInfo_Names DefaultAmbienceInfo;
var protectedwrite AmbientChannel BackgroundChannel;
var protectedwrite AmbientChannel OverlayChannel;
var protectedwrite AmbientChannel RainChannel;
var private transient array<int> CombatMusicTracks;
var private array<string> CombatMusicCues;
var private bool bCombatMusicRequestInFlight;
var bool bEnablePersistentAudio;
var privatewrite ERainIntensity CurrentRainIntensity;

defaultproperties
{
    // DefaultAmbienceInfo=XComTacticalSoundInfo_Names'SoundCollections.XComTacticalSoundInfo'
    CombatMusicCues.Add("CombatMusic1.ActionMusic1Cue")
    CombatMusicCues.Add("CombatMusic2.ActionMusic2Cue")
    CombatMusicCues.Add("CombatMusic3.ActionMusic3Cue")
    CombatMusicCues.Add("CombatMusic4.ActionMusic4Cue")
    CombatMusicCues.Add("CombatMusic5.ActionMusic5Cue")
    CombatMusicCues.Add("CombatMusic6.ActionMusic6Cue")
    CombatMusicCues.Add("CombatMusic7.ActionMusic7Cue")
    CombatMusicCues.Add("CombatMusic8.ActionMusic8Cue")
    CombatMusicCues.Add("CombatMusic9.ActionMusic9Cue")
    bEnablePersistentAudio=true
}