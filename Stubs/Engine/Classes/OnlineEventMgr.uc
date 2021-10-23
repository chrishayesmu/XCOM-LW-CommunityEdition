class OnlineEventMgr extends Object
    native;
//complete stub
enum ESystemMessageType
{
    SystemMessage_None,
    SystemMessage_Disconnected,
    SystemMessage_GameFull,
    SystemMessage_GameUnavailable,
    SystemMessage_VersionMismatch,
    SystemMessage_QuitReasonLogout,
    SystemMessage_QuitReasonDlcDevice,
    SystemMessage_InvitePermissionsFailed,
    SystemMessage_InviteSystemError,
    SystemMessage_QuitReasonLinkLost,
    SystemMessage_QuitReasonInactiveUser,
    SystemMessage_QuitReasonLostConnection,
    SystemMessage_QuitReasonOpponentDisconnected,
    SystemMessage_BootInviteFailed,
    SystemMessage_LostConnection,
    SystemMessage_ChatRestricted,
    SystemMessage_InviteRankedError,
    SystemMessage_SystemLinkClientVersionNewer,
    SystemMessage_SystemLinkClientVersionOlder,
    SystemMessage_SystemLinkServerVersionNewer,
    SystemMessage_SystemLinkServerVersionOlder,
    SystemMessage_CorruptedSave,
    SystemMessage_InviteServerVersionOlder,
    SystemMessage_InviteClientVersionOlder,
    SystemMessage_End,
    SystemMessage_MAX
};
var OnlineSubsystem OnlineSub;
var int LocalUserIndex;
var int InviteUserIndex;
var const localized string m_sSystemMessageTitles[24];
var const localized string m_sSystemMessageStrings[24];
var const localized string m_sSystemMessageStringsXBOX[24];
var const localized string m_sSystemMessageStringsPS3[24];
var protected array<ESystemMessageType> m_eSystemMessageQueue;
var protected array< delegate<SystemMessageAdded> > m_dSystemMessageAddedListeners;
var protected array< delegate<SystemMessagePopped> > m_dSystemMessagePoppedListeners;
var const localized string m_sAcceptingGameInvitation;
var protected bool m_bCurrentlyTriggeringInvite;
var protected bool m_bCurrentlyTriggeringBootInvite;
var protected bool m_bTriggerInvitesAfterMessages;
var protected bool m_bBootInviteChecked;
var bool m_bPassedOnlineConnectivityCheck;
var bool m_bPassedOnlinePlayPermissionsCheck;
var bool m_bAccessingOnlineDataDialogue;
var bool m_bMPConfirmExitDialogOpen;
var bool m_bControllerUnplugged;
var protected array<OnlineGameSearchResult> m_tAcceptedGameInviteResults;
var protected array< delegate<CheckReadyForGameInviteAccept> > m_dCheckReadyForGameInviteAcceptListeners;
var protected array< delegate<GameInviteAccepted> > m_dGameInviteAcceptedListeners;
var protected array< delegate<GameInviteComplete> > m_dGameInviteCompleteListeners;
var float m_fMPLoadTimeout;


delegate SystemMessageAdded(string sSystemMessage, string sSystemTitle) {}
delegate SystemMessagePopped(string sSystemMessage, string sSystemTitle)
{
    //return;
}

delegate DisplaySystemMessageComplete()
{
    //return;
}

delegate bool CheckReadyForGameInviteAccept()
{
    //return ReturnValue;
}

delegate GameInviteAccepted(bool bWasSuccessful)
{
    //return;
}

delegate GameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful) {}

event Init(){}
event Tick(float DeltaTime);

protected function SetActiveController(int ControllerId){}
protected function OnControllerStatusChanged(int ControllerId, bool bIsConnected){}
function string GetSystemMessageString(ESystemMessageType eMessageType){}
function string GetSystemMessageTitle(ESystemMessageType eMessageType){}
native function EngineLevelDisconnect();
function SetShuttleToMPMainMenu(bool ShouldShuttle);
function SetShuttleToStartMenu(bool ShouldShuttle);
function bool ShouldStartBootInviteProcess(){}
function SetBootInviteChecked(bool bChecked){}
function bool IsCurrentlyTriggeringBootInvite(){}
function ClearCurrentlyTriggeringBootInvite(){}
function StartGameBootInviteProcess(){}
function GameBootInviteAccept(){}
function bool TriggerAcceptedInvite(){}
function SwitchUsersThenTriggerAcceptedInvite();
function OnGameInviteAcceptedUser0(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function OnGameInviteAcceptedUser1(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function OnGameInviteAcceptedUser2(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function OnGameInviteAcceptedUser3(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function InviteFailed(ESystemMessageType eSystemMessage, optional bool bTravelToMPMenus){}
function ControllerNotReadyForInvite(){}
function OnLoginUIComplete(bool Success){}
function bool HasAcceptedInvites(){}
function ClearAcceptedInvites(){}
function AddCheckReadyForGameInviteAcceptDelegate(delegate<CheckReadyForGameInviteAccept> dCheckReadyForGameInviteAccept){}
function ClearCheckReadyForGameInviteAcceptDelegate(delegate<CheckReadyForGameInviteAccept> dCheckReadyForGameInviteAccept){}
function AddGameInviteAcceptedDelegate(delegate<GameInviteAccepted> dGameInviteAcceptedDelegate){}
function ClearGameInviteAcceptedDelegate(delegate<GameInviteAccepted> dGameInviteAcceptedDelegate){}
function OnGameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful){}
function AddGameInviteCompleteDelegate(delegate<GameInviteComplete> dGameInviteCompleteDelegate){}
function ClearGameInviteCompleteDelegate(delegate<GameInviteComplete> dGameInviteCompleteDelegate){}
function bool IsAcceptingGameInvite(){}
event ActivateAllSystemMessages(optional bool bTriggerInvitesAfterAllMessages){}
function OnDisplaySystemMessageComplete_All(){}
function ActivateNextSystemMessage(optional delegate<DisplaySystemMessageComplete> dOnDisplaySystemMessageComplete){}
function DisplaySystemMessage(string sSystemMessage, string sSystemTitle, optional delegate<DisplaySystemMessageComplete> dOnDisplaySystemMessageComplete){}
function OnDisplaySystemMessageComplete(){}
native function QueueNetworkErrorMessage(string ErrorMsg);
event ShowSystemMessageOnMPMenus(ESystemMessageType eMessageType){}
event QueueSystemMessage(ESystemMessageType eMessageType, optional bool bIgnoreMsgAdd){}
function bool OnSystemMessage_AutomatchGameFull();
function bool LastGameWasAutomatch();
function AddSystemMessageAddedDelegate(delegate<SystemMessageAdded> dSystemMessageAddedDelegate){}
function ClearSystemMessageAddedDelegate(delegate<SystemMessageAdded> dSystemMessageAddedDelegate){}
function PeekSystemMessage(out string sSystemMessage, out string sSystemTitle){}
function PopSystemMessage(out string sSystemMessage, out string sSystemTitle){}
function AddSystemMessagePoppedDelegate(delegate<SystemMessagePopped> dSystemMessagePoppedDelegate){}
function ClearSystemMessagePoppedDelegate(delegate<SystemMessagePopped> dSystemMessagePoppedDelegate){}
function int ClearSystemMessages(optional bool bClearCritialSystemMessages){}
function int NumSystemMessages(){}
function bool IsSystemMessageQueued(ESystemMessageType MsgType){}
function RemoveAllSystemMessagesOfType(ESystemMessageType MsgType){}
function DebugPrintSystemMessageQueue();

function SystemMessageCleanup(){}
// Export UOnlineEventMgr::execStartMPLoadTimeout(FFrame&, void* const)
native function StartMPLoadTimeout();

// Export UOnlineEventMgr::execGetMPLoadTimeout(FFrame&, void* const)
native function float GetMPLoadTimeout();

event OnMPLoadTimeout();

function ReturnToMPMainMenuBase();

function bool IsAtMPMainMenu();