class XComTacticalSoundManager extends XComSoundManager
    notplaceable
    hidecategories(Navigation);
//complete stub

enum ERainIntensity
{
    eRain_NoRain,
    eRain_LightRain,
    eRain_MediumRain,
    eRain_HeavyRain,
    eRain_MAX
};

var const XComTacticalSoundInfo_Names DefaultAmbienceInfo;
var AmbientChannel BackgroundChannel;
var AmbientChannel OverlayChannel;
var AmbientChannel RainChannel;
var transient array<int> CombatMusicTracks;
var array<string> CombatMusicCues;
var bool bCombatMusicRequestInFlight;
var bool bEnablePersistentAudio;
var ERainIntensity CurrentRainIntensity;

function Init(){}
function BattleDependentInit(){}
function LoadAmbiences(){}
function OnBackgroundLoaded(Object LoadedObject){}
function OnOverlayLoaded(Object LoadedObject){}
function EnablePersistentAudio(bool bEnable){}
function OnXComPawnIndoorOutdoorOrSelected(XComPawn Unit){}
function SetRainIntensity(ERainIntensity NewRainIntensity){}
function OnRainCueLoaded(Object LoadedArchetype){}
function OnXComPawnIndoorOutdoor(Object Params){}
function OnXComPawnSelected(Object Params){}
function StartAllAmbience(){}
function StopAllAmbience(){}
function StartBackgroundChannel(){}
function StopBackgroundChannel(){}
function StartOverlayChannel(){}
function StopOverlayChannel(){}
function PlayCombatMusic(){}
function OnCombatMusicLoaded(Object LoadedObject){}
function StopCombatMusic(){}
function bool IsMusicPlaying(){}
