class XComPresentationLayerBase extends Actor
	abstract
	notplaceable
	DependsOn(UIDialogueBox)
	dependsOn(XGNarrative);
//complete stub
enum EKismetUIVis
{
    eKismetUIVis_None,
    eKismetUIVis_Show,
    eKismetUIVis_Hide,
    eKismetUIVis_MAX
};

enum EProgressDialog
{
    eProgressDialog_None,
    eProgressDialog_Opening,
    eProgressDialog_Closing,
    eProgressDialog_Showing,
    eProgressDialog_MAX
};

var UIFxsMovieMgr m_kUIMovieMgr;
var UIInterfaceMgr m_kHUD;
var UIFxsMovie m_kModalHUD;
var UIPauseMenu m_kPauseMenu;
var UIOptionsPCScreen m_kPCOptions;
var UICredits m_kCredits;
var UIShellDifficulty m_kDifficulty;
var UIGameplayToggles m_kGameToggles;
var UIDebugSafearea m_kUIDebugSafeArea;
var UIControllerMap m_kControllerMap;
var UILoadGame m_kLoadUI;
var UILoadScreenAnimation m_kLoadAnimation;
var UISaveGame m_kSaveUI;
var UINarrativePopup m_kNarrativePopup;
var UINarrativeMgr m_kNarrativeUIMgr;
var UIItemCards m_kItemCard;
var UIInputDialogue m_kInputDialog;
var TInputDialogData m_kInputDialogData;
var UIMouseGuard m_kMouseGuard;
var UIProgressDialogue m_kProgressDialog;
var TProgressDialogData m_kProgressDialogData;
var EProgressDialog m_kProgressDialogStatus;
var EKismetUIVis m_ePendingKismetVisibility;
var EDifficultyLevel m_eDiff;
var const EUIMode m_eUIMode;
var UIReconnectController m_kControllerUnplugDialog;
var TProgressDialogData m_kControllerUnplugDialogData;
var UIKeybindingsPCScreen m_kPCKeybindings;
var XComKeybindingData m_kKeybindingData;
var UIMouseCursor m_kUIMouseCursor;
var UIVirtualKeyboard m_VirtualKeyboard;
var array< delegate<UpdateCallback> > m_arrUIUpdateCallbacks;
var float m_fUIUpdateFrequency;
var array<name> m_aStateStack;
var array<UIProtoScreen> m_aProtoStack;
var bool m_bIsGameDataReady;
var bool m_bInitialized;
var bool m_bIsIronman;
var bool m_bDisallowSaving;
var bool m_bIsPlayingGame;
var bool m_bGameOverTriggered;
var protectedwrite bool m_bPresLayerReady;
var bool m_bBlockSystemMessageDisplay;
var XGNarrative m_kNarrative;
var array<TItemUnlock> m_arrUnlocks;
var delegate<PostStateChangeCallback> m_postStateChangeCallback;
var array< delegate<PreClientTravelDelegate> > m_PreClientTravelDelegates;
var UIProtoScreen m_kProtoUI;
var UIMultiplayerPostMatchSummary m_kTestScreen;
var name m_LastPoppedState;
var const localized string m_strSaveWarning;
var const localized string m_strSelectSaveDeviceForLoadPrompt;
var const localized string m_strSelectSaveDeviceForSavePrompt;
var const localized string m_strOK;
var const localized string m_strErrHowToPlayNotAvailable;
var const localized string m_strPleaseReconnectController;
var const localized string m_strPleaseReconnectControllerPS3;
var const localized string m_strPleaseReconnectControllerPC;
var const localized string m_strPlayerEnteredUnfriendlyTitle;
var const localized string m_strPlayerEnteredUnfriendlyText;
var const localized string m_strShutdownOnlineGame;
var delegate<delActionAccept> __delActionAccept__Delegate;
var delegate<delActionCancel> __delActionCancel__Delegate;
var delegate<delNoParams> __delNoParams__Delegate;
var delegate<delAfterStorageDeviceCallbackSuccess> __delAfterStorageDeviceCallbackSuccess__Delegate;
var delegate<UpdateCallback> __UpdateCallback__Delegate;
var delegate<PostStateChangeCallback> __PostStateChangeCallback__Delegate;
var delegate<OnNarrativeCompleteCallback> __OnNarrativeCompleteCallback__Delegate;
var delegate<PreRemoteEventCallback> __PreRemoteEventCallback__Delegate;
var delegate<PreClientTravelDelegate> __PreClientTravelDelegate__Delegate;

delegate delActionAccept(string userInput, bool bWasSuccessful);

delegate delActionCancel();

delegate delNoParams();

delegate delAfterStorageDeviceCallbackSuccess();

delegate UpdateCallback();

delegate bool PostStateChangeCallback();

delegate OnNarrativeCompleteCallback();

delegate PreRemoteEventCallback();

delegate PreClientTravelDelegate(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel);

simulated function UIInterfaceMgr GetHUD(){}
simulated function UIFxsMovie GetModalHUD(){}
simulated function UIDisplayMovie Get3DMovie(){}
simulated function UIFxsMovieMgr GetUIMgr(){}
simulated function UIMessageMgr GetMessenger(){}
simulated function UIAnchoredMessageMgr GetAnchoredMessenger(){}
simulated function UINarrativeCommLink GetUIComm(){}
simulated function UIWorldMessageMgr GetWorldMessenger(){}
simulated function Init(){}
event PreBeginPlay(){}
event Destroyed(){}
simulated event OnCleanupWorld(){}
private final simulated function Cleanup(){}
simulated function OnGameInviteAccepted(bool bWasSuccessful){}
simulated function OnGameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful){}
simulated function ProcessSystemMessages(){}
simulated function OnSystemMessageAdd(string sMessage, string sTitle){}
function SanitizeSystemMessages(){}
simulated function HideUIForCinematics(){}
function SetNarrativeMgr(XGNarrative kNarrative){}
simulated function ShowUIForCinematics(){}
simulated function PreRender(){}
function AddPreClientTravelDelegate(delegate<PreClientTravelDelegate> dOnPreClientTravel){}
function ClearPreClientTravelDelegate(delegate<PreClientTravelDelegate> dOnPreClientTravel){}
simulated function OnLocalPlayerTeamTypeReceived(ETeam eLocalPlayerTeam){}
simulated function UIUpdate(){}
simulated function PreClientTravel(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel){}
simulated function SubscribeToUIUpdate(delegate<UpdateCallback> fCallback){}
simulated function UnsubscribeToUIUpdate(delegate<UpdateCallback> fCallback){}
simulated function KillAllUIStates(){}
simulated function ClearAllUIScreens(){}
simulated function ClearUIToHUD();
simulated function InitUIScreens(){}
simulated function InitMouseCursor(){}
simulated function Update();
simulated function bool GetMouseCoords(out Vector2D vMouseCoords){}
reliable client simulated function bool UIPreloadNarrative(XComNarrativeMoment Moment){}
reliable client simulated function bool UINarrative(XComNarrativeMoment Moment, optional Actor kFocusActor, optional delegate<OnNarrativeCompleteCallback> InNarrativeCompleteCallback, optional delegate<PreRemoteEventCallback> InPreRemoteEventCallback, optional Vector vOffset, optional bool bUISound, optional bool bFirstRunOnly, optional float FadeSpeed=0.50){}
simulated function DumpUnreferencedNarrativeEnums();
simulated function DumpNarrativesNotInHistory();
reliable client simulated function bool CheckNarrative(){}
reliable client simulated function UITellMeMore();
simulated function UIInvitationsMenu(){}
reliable client simulated function UIItemUnlock(TItemUnlock kUnlock){}
reliable client simulated function bool UIKeyboard(string sTitle, string sDefaultText, delegate<delActionAccept> del_OnAccept, delegate<delActionCancel> del_OnCancel, bool bValidateText, optional int maxCharLimit=256){}
reliable client simulated function UIDifficulty(optional bool bInGame){}
reliable client simulated function UIGameplayToggles(optional bool bInGame){}
private final simulated function OnVirtualKeyboardInputComplete(bool bWasSuccessful){}
simulated function ShowUnfriendlyTextWarningDialog(){}
simulated function PopupDebugDialog(string strTitle, string strMessage);
simulated function ShowMultiplayerLoadoutWarningDialog(string Str){}
simulated function UIRaiseDialog(TDialogueBoxData kData){}
simulated function bool UIIsShowingDialog(){}
simulated function UISetDialogBoxClosedDelegate(delegate<delNoParams> Del){}
simulated function UIProgressDialog(TProgressDialogData kData){}
simulated function UICloseProgressDialog();
simulated function UIControllerUnplugDialog(int ControllerId, optional bool bInOptionsScreen){}
simulated function bool IsShowingReconnectControllerDialog(){}
simulated function UICloseControllerUnplugDialog(){}
simulated function UIInputDialog(TInputDialogData kData){}
simulated function UIRaiseMouseGuard(){}
simulated function UILowerMouseGuard(){}
simulated function UIItemCard(TItemCard tCardData){}
simulated function HandleInvalidStorage(string SelectStoragePrompt, delegate<delAfterStorageDeviceCallbackSuccess> delSuccessCallback){}
simulated function ShowSaveWarningDialog(string sWarningText){}
simulated function WarningAcknowledged(UIDialogueBox.EUIAction eAction){}
simulated function ShowStorageDevicePrompt(string sPromptText){}
private final simulated function ShowStorageDevicePromptCallback(UIDialogueBox.EUIAction eAction){}
function OnCloseOSStorageDevicePromptCallback(bool bWasSuccessful){}
function bool PlayerCanSave(){}
simulated function UISaveScreen(){}
simulated function UILoadScreen(){}
simulated function UILoadAnimation(bool bShow){}
simulated function bool IsBusy(){}
simulated function UIEndGame();
simulated function UIShutdownOnlineGame(){}
simulated function UIControllerMap(){}
simulated function UIPauseMenu(bool bIronman, optional bool bAllowCinematicMode, optional bool bDisallowSaving){}
simulated function bool IsPauseMenuRaised(){}
simulated function bool IsLoadingTentpole(){}
simulated function bool IsDialogBoxShown(){}
simulated function ToggleUIWhenPaused(bool bShow);
simulated function bool AllowSaving(){}
simulated function bool ISCONTROLLED(){}
simulated function UIKeybindingsPCScreen(){}
simulated function UpdateShortcutText();
simulated function UIPCOptions(){}
simulated function bool IsPCOptionsRaised(){}
reliable client simulated function UICredits(bool isGameOver){}
simulated function UITestScreen(){}
simulated function UIToggleSafearea(){}
simulated function UIStatus(){}
simulated function bool DoNarrativeByMissonType(int eType, int EShipType, optional Actor kFocusActor){}
simulated function bool DoNarrativeByPawnType(XGGameData.EPawnType eType, optional Actor kFocusActor){}
simulated function bool GetNarrativeConversation(out name kConversation, XComNarrativeMoment kNarrativeMoment, optional bool bPreloading){}
simulated function int GetTimesPlayed(XComNarrativeMoment kNarrativeMoment){}
simulated function UIPlayMovie(string strMovieName, optional bool Wait=true, optional bool bLoop){}
function AudioComponent Speak(string strText, optional AudioDevice.ETTSSpeaker eSpeaker=5){}
simulated function UIStopMovie(){}
simulated function ClearInput(){}
simulated function UIProtoScreen GetProtoUI(){}
simulated function UIProtoScreen GetProtoUIAtIndex(int iIndex){}
simulated function int GetProtoUIStackLength(){}
simulated function AddProtoScreen(UIProtoScreen kScreen){}
simulated function ProtoRemove(class<UIProtoScreen> TargetClass, optional UIFxsMovie targetMovie=m_kHUD){}
simulated function bool IsProtoUIBusy(){}
simulated function bool IsInStack(name targetStateName, optional bool bShouldLogStateStack){}
simulated function name GetCurrentState(){}
simulated function name GetPrevState(){}
simulated function PrintStateStack();
simulated function PrintProtoScreenStack(){}
simulated function PokeGfx(string Cmd, optional string Value){}
simulated function HideLoadingScreen(){}
function FirstMissionBinkPlaying(){}
function CreateTutorialSave(){}
simulated function bool IsGameplayOptionEnabled(XGGameData.EGameplayOption Option){}
simulated function OnTurnTimerExpired();
simulated function ChangeDifficutly(int difficutlyLevel);
simulated function int GetDifficulty();
simulated function bool ShouldAnchorTipsToRight(){}
function bool OnSystemMessage_AutomatchGameFull();

simulated state BaseScreenState
{
	simulated function InitState(){}
simulated function Activate(){}
simulated function Deactivate(){}
simulated event PushedState(){}
simulated event ContinuedState(){}
simulated event PausedState(){}
simulated event PoppedState(){}
simulated function RemoveSelfStateFromStack(){}
}
simulated state TentPoleScreenState extends BaseScreenState
{
    simulated function Activate(){}
    simulated function Deactivate(){}
}

simulated state PROTOBaseScreenState extends BaseScreenState
{
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}
}

simulated state State_InterfaceMgr extends BaseScreenState
{
    simulated event PoppedState(){}
    simulated function Activate(){}
    simulated function Deactivate();
}
simulated state State_UINarrative extends BaseScreenState
{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnLoseFocus(){}
    simulated function OnReceiveFocus(){}
}

simulated state State_ShellDifficulty extends BaseScreenState
{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_GameplayToggles extends BaseScreenState
{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}

simulated state State_VirtualKeyboard extends BaseScreenState
{
simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_ProgressDialog extends BaseScreenState
{
    simulated function UIProgressDialog(TProgressDialogData kData){}
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
    simulated function UICloseProgressDialog(){}
}
simulated state State_InputDialog extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_ItemCard extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}
simulated state State_SaveScreen extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}

simulated state State_LoadScreen extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}
simulated state State_ControllerMap extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}

simulated state State_PauseMenu extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_PCKeybindings extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_PCOptions extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_UICredits extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}
simulated state State_TestScreen extends BaseScreenState
{
	simulated function Activate(){}
    simulated function Deactivate(){}
 
}

