class XComCapturePointVolume extends Volume;

//complete stub

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
var() const name m_nFirstAlienEnteredRemoteEvent;
var() const name m_nCaptureAdvanceRemoteEvent;
var() const array<XComCapturePointVolume_CaptureEvent> m_arrCaptureEvents;
var export editinline ParticleSystemComponent m_kVisualizerEffect;
var XComCapturePointVolume m_kPreviousCapturePoint;
var XComCapturePointVolume m_kNextCapturePoint;
var int m_iCaptureProgress;
var int m_iWatchPlayerHandle;
var int m_iWatchUnitHandle;
var bool m_bHasAlienEnteredVolume;
var ECaptureState m_eCaptureState;
var SoundCue m_kHackingSoundCue;
var SoundCue m_kLockedSoundCue;
var SoundCue m_kSecureSoundCue;
var const localized string m_strCapturedMessage;
var const localized string m_strCapturingMessage;

simulated function Init(){}
event PostBeginPlay(){}
simulated function InitVisualizationComponent(){}
final simulated function LoadSoundCues(){}
final simulated function UpdateBorderEffect(){}
final simulated function UpdateIndicatorArrow(){}
final simulated function UpdateCaptureState(){}
simulated event Destroyed(){}
simulated function bool IsCaptured(){}
simulated function bool IsActive(){}
simulated function int TurnsUntilCaptured(){}
simulated event Touch(Actor kOther, PrimitiveComponent kOtherComp, Vector kHitLocation, Vector kHitNormal){}
simulated event UnTouch(Actor kOther){}
final simulated function OnActivePlayerChanged(){}
final simulated function AdvanceCapture(){}
simulated function OnCapturePointActorDestroyed(){}
final simulated function OnActiveUnitChanged(){}
