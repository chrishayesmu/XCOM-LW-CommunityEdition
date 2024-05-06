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
    DefaultAmbienceInfo=XComTacticalSoundInfo_Names'SoundCollections.XComTacticalSoundInfo'
    CombatMusicCues(0)="CombatMusic1.ActionMusic1Cue"
    CombatMusicCues(1)="CombatMusic2.ActionMusic2Cue"
    CombatMusicCues(2)="CombatMusic3.ActionMusic3Cue"
    CombatMusicCues(3)="CombatMusic4.ActionMusic4Cue"
    CombatMusicCues(4)="CombatMusic5.ActionMusic5Cue"
    CombatMusicCues(5)="CombatMusic6.ActionMusic6Cue"
    CombatMusicCues(6)="CombatMusic7.ActionMusic7Cue"
    CombatMusicCues(7)="CombatMusic8.ActionMusic8Cue"
    CombatMusicCues(8)="CombatMusic9.ActionMusic9Cue"
    bEnablePersistentAudio=true
}