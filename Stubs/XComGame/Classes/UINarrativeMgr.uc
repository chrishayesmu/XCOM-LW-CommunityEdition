class UINarrativeMgr extends TickableStateObject
    native(UI);

enum EPreloadStatus
{
    ePendingPreload,
    ePreloaded,
    eNoPreloadRequested,
    EPreloadStatus_MAX
};

struct native TConversation
{
    var name CueName;
    var SoundCue ResolvedCue;
    var XComConversationNode ConversationNode;
    var export editinline AudioComponent AudioComponent;
    var bool bPendingAudioLoad;
    var bool bPendingMapLoad;
    var delegate<OnNarrativeCompleteCallback> m_NarrativeCompleteCallback;
    var delegate<PreRemoteEventCallback> m_PreRemoteEventCallback;
    var XComNarrativeMoment NarrativeMoment;
    var bool bFirstLineStarted;
    var bool bMuffled;
    var Actor ActorToLookAt;
    var bool bFadedToBlack;
    var bool bNoAudio;
    var EPreloadStatus PreloadStatus;
    var bool bUISound;
    var Vector Location;
};

struct native TPreloadedConversation
{
    var name CueName;
    var SoundCue ResolvedCue;
    var XComNarrativeMoment NarrativeMoment;
    var bool bWasPreloadingWhenAddedToMgr;
};

struct native TCurrentOutput
{
    var string strTitle;
    var string strImage;
    var string strText;
    var float fTimeStarted;
    var float fDuration;
};

var transient array<TPreloadedConversation> PendingPreloadConversations;
var transient array<TPreloadedConversation> PreloadedConversations;
var transient array<TConversation> PendingConversations;
var array<TConversation> m_arrConversations;
var array<TConversation> m_arrVOOnlyConversations;
var bool m_bIsModal;
var bool bActivelyPlayingConversation;
var bool bLoadingTentpole;
var bool bPaused;
var bool bWasPausedWhenStartFadeToBlack;
var transient bool bPodRevealHappend;
var bool m_bTentpoleStarted;
var UI_FxsScreen m_kTargetScreen;
var const localized string m_stNarrativeOk;
var TCurrentOutput CurrentOutput;
var transient SkeletalMeshActor CurrentFaceFxTargetActor;
var transient XComUnitPawn CurrentFaceFxTargetPawn;
var Vector m_vCurrentLookAt;
var SeqEvent_HQUnits kHQUnits;
var delegate<OnNarrativeCompleteCallback> m_ActiveNarrativeCompleteCallback;
var delegate<PreRemoteEventCallback> m_ActivePreRemoteEventCallback;
var delegate<OnNarrativeCompleteCallback> __OnNarrativeCompleteCallback__Delegate;
var delegate<PreRemoteEventCallback> __PreRemoteEventCallback__Delegate;

delegate OnNarrativeCompleteCallback();

delegate PreRemoteEventCallback();
simulated function Init();

simulated function ShutDown(){}
simulated function SetPaused(bool bPause){}
function bool AnyActiveConversations(){}
simulated function StopNarrative(XComNarrativeMoment Narrative){}
simulated function StopConversations(){}
function XComConversationNode GetConversationNode(SoundCue SndCue, optional SoundNode SndNode){}
native function UpdateXMPHelper();
simulated function EndCurrentConversation(optional bool bDontStartNextConversation){}
simulated function NextDialogueLine(optional Actor FaceFxTargetActor){}
simulated function HideComm(){}
simulated function ShowComm(){}
simulated function CheckForNextConversation(){}
simulated function CheckConversationFullyLoaded(optional bool bForceStart){}
simulated event OnConversationPreLoaded(SoundCue LoadedSoundCue){}
simulated event OnConversationLoaded(SoundCue LoadedSoundCue){}
simulated function OnStreamedLevelLoaded(name LevelName){}
simulated function StartFadeToBlack(optional float Speed=0.50){}
simulated function StartFadeFromBlack(){}
native function LoadConversationAsync(const out name SoundCueName, bool bPreloading){};
simulated function bool PreloadConversation(name nmConversation, XComNarrativeMoment NarrativeMoment){}
simulated function CheckAndHandlePreloadedConversations(out TConversation PendingConversation){}
simulated function ClearConversationQueueOfNonTentpoles(){}
simulated function bool AddConversation(name nmConversation, delegate<OnNarrativeCompleteCallback> InNarrativeCompleteCallback, delegate<PreRemoteEventCallback> InPreRemoteEventCallback, XComNarrativeMoment NarrativeMoment, Actor FocusActor, Vector vOffset, bool bUISound, float FadeSpeed){}
simulated function BeginVOOnlyConversation(int iIndex){}
simulated function OnVOOnlyConversationFinished(AudioComponent AC){}
simulated function OnAudioComponentFinished(AudioComponent AC){}
simulated function BeginConversation(){}
simulated function StartTentpoleRemoteEvent(){}
simulated function FinishConversation0(){}
simulated function UpdateConversationDialogueBox(){}
simulated function BeginNarrative(){}
simulated function SkeletalMeshActor SpeakerToActor(EXComSpeakerType eSpeaker){}
simulated function string SpeakerToPortait(EXComSpeakerType eSpeaker){}
event Tick(float fDeltaTime);
simulated function FadeoutAllVOOnlyOfType(ENarrativeMomentType eType){}
simulated function MuffleVOOnly(){}
simulated function UnMuffleVOOnly(){}
simulated function StartCinematicSound(){}
simulated function StopCinematicSound(){}

simulated state TentpoleRemoteEvent
{
    event Tick(float DeltaTime){}
}
simulated state LookAtCursorCameraTransition
{
    event Tick(float fDeltaTime){}
    simulated function RemoveLookAt(){}
}
simulated state FadingToBlack
{
    event Tick(float fDeltaTime){}
}
defaultproperties
{
    m_bIsModal=true
}