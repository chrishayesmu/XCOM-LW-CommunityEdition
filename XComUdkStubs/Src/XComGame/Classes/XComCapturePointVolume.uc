class XComCapturePointVolume extends Volume
    hidecategories(Navigation,Movement,Display);

enum ECaptureState
{
    eUncontested,
    eHeld,
    eInDanger,
    ECaptureState_MAX
};

struct XComCapturePointVolume_CaptureEvent
{
    var() name m_nEventName;
    var() int m_iTurnsRemaining;
};

struct CheckpointRecord
{
    var int m_iCaptureProgress;
    var bool m_bHasAlienEnteredVolume;
};

var() const XComLevelActor m_kActorBeingCaptured;
var() const int m_iTurnsToCapture;
var() const int m_iCaptureSequenceIndex;
var() private const name m_nFirstAlienEnteredRemoteEvent;
var() private const name m_nCaptureAdvanceRemoteEvent;
var() private const array<XComCapturePointVolume_CaptureEvent> m_arrCaptureEvents;
var private export editinline ParticleSystemComponent m_kVisualizerEffect;
var private XComCapturePointVolume m_kPreviousCapturePoint;
var private XComCapturePointVolume m_kNextCapturePoint;
var private int m_iCaptureProgress;
var private int m_iWatchPlayerHandle;
var private int m_iWatchUnitHandle;
var private bool m_bHasAlienEnteredVolume;
var privatewrite ECaptureState m_eCaptureState;
var private SoundCue m_kHackingSoundCue;
var private SoundCue m_kLockedSoundCue;
var private SoundCue m_kSecureSoundCue;
var const localized string m_strCapturedMessage;
var const localized string m_strCapturingMessage;

defaultproperties
{
    m_iTurnsToCapture=2
    bStatic=false
    bHidden=false

    begin object name=ParticleSystemComponent0 class=ParticleSystemComponent
        HiddenEditor=true
    end object

    m_kVisualizerEffect=ParticleSystemComponent0
    Components.Add(ParticleSystemComponent0)
}