class XGSoundMgr extends XGStrategyActor;

var XComHQSoundCollection.EMusicCue m_eCurrentMusic;
var XComHQSoundCollection.EAmbienceCue m_eCurrentAmbience;
var SoundCue CurrentAmbienceCue;
var export editinline AudioComponent AmbientSoundComponent;
var XComHQSoundCollection m_kSounds;
var array<SoundCue> PendingPostMovieSounds;

function PlaySFX(SoundCue sndSFX) {}
function Tick(float DeltaTime) {}
function PlayAmbience(XComHQSoundCollection.EAmbienceCue eCue) {}
function OnAmbienceLoaded(Object LoadedObject) {}
function StopAmbience() {}
function PlayMusic(XComHQSoundCollection.EMusicCue eCue) {}
function OnMusicLoaded(Object LoadedObject) {}
function StopMusic() {}
function StopAll() {}
function Init(XComHQSoundCollection kSounds) {}

DefaultProperties
{
}
