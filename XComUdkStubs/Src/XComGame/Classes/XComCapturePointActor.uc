class XComCapturePointActor extends XComFriendlyDestructibleActor
    hidecategories(Navigation);

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
var private XComCapturePointVolume m_kCapturePointVolume;
var private export editinline AudioComponent m_kAudioComponent;
var private export editinline ParticleSystemComponent m_kParticleSystemComponent;
var private ECapturePointActorEffect m_eEffect;