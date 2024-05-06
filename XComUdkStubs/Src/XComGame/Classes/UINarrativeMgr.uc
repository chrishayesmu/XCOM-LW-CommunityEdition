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
    var UINarrativeMgr.EPreloadStatus PreloadStatus;
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
var private bool m_bTentpoleStarted;
var UI_FxsScreen m_kTargetScreen;
var const localized string m_stNarrativeOk;
var TCurrentOutput CurrentOutput;
var transient SkeletalMeshActor CurrentFaceFxTargetActor;
var transient XComUnitPawn CurrentFaceFxTargetPawn;
var private Vector m_vCurrentLookAt;
var private SeqEvent_HQUnits kHQUnits;
var delegate<OnNarrativeCompleteCallback> m_ActiveNarrativeCompleteCallback;
var delegate<PreRemoteEventCallback> m_ActivePreRemoteEventCallback;

delegate OnNarrativeCompleteCallback()
{
}

delegate PreRemoteEventCallback()
{
}

defaultproperties
{
    m_bIsModal=true
}