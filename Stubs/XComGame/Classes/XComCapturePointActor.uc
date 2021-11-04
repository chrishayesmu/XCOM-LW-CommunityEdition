class XComCapturePointActor extends XComFriendlyDestructibleActor
    hidecategories(Navigation);
//complete stub

enum ECapturePointActorEffect
{
    eInactive,
    eActive,
    eCaptured,
    eDestroyed,
    ECapturePointActorEffect_MAX
};

struct CheckpointRecord_XComCapturePointActor extends CheckpointRecord
{
    var ECapturePointActorEffect m_eEffect;
};

var() const SoundCue m_kActiveLoopCue;
var() const SoundCue m_kCapturedCue;
var() const SoundCue m_kDestroyedCue;
var() const ParticleSystem m_kActiveParticleSystem;
var() const ParticleSystem m_kCapturedParticleSystem;
var() const ParticleSystem m_kDestroyedParticleSystem;
var() const MaterialInstanceConstant m_kActiveMIC;
var() const MaterialInstanceConstant m_kHackedMIC;
var XComCapturePointVolume m_kCapturePointVolume;
var export editinline AudioComponent m_kAudioComponent;
var export editinline ParticleSystemComponent m_kParticleSystemComponent;
var ECapturePointActorEffect m_eEffect;

simulated function SetParentVolume(XComCapturePointVolume kCapturePointVolume){}
simulated function SetCapturePointEffect(ECapturePointActorEffect eEffect){}
simulated function NotifyActive();
simulated function NotifyCaptured();
simulated event SetupDLE(){}
simulated event PostBeginPlay(){}
function bool ShouldSaveForCheckpoint(){}
function ApplyCheckpointRecord(){}

auto simulated state _Pristine
{
    simulated function NotifyActive(){}
    simulated function NotifyCaptured(){}
}

simulated state _Destroyed
{
    simulated event BeginState(name PreviousStateName)
	{}
}
defaultproperties
{
}
