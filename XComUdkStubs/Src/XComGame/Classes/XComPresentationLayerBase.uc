class XComPresentationLayerBase extends Actor
    abstract
    dependson(XGNarrative)
    notplaceable
    hidecategories(Navigation);

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

var protected UIFxsMovieMgr m_kUIMovieMgr;
var protected UIInterfaceMgr m_kHUD;
var protected UIFxsMovie m_kModalHUD;
var protected UIPauseMenu m_kPauseMenu;
var UIOptionsPCScreen m_kPCOptions;
var protected UICredits m_kCredits;
var UIShellDifficulty m_kDifficulty;
var UIGameplayToggles m_kGameToggles;
var protected UIDebugSafearea m_kUIDebugSafeArea;
var protected UIControllerMap m_kControllerMap;
var protected UILoadGame m_kLoadUI;
var protected UILoadScreenAnimation m_kLoadAnimation;
var protected UISaveGame m_kSaveUI;
var UINarrativePopup m_kNarrativePopup;
var UINarrativeMgr m_kNarrativeUIMgr;
var protectedwrite UIItemCards m_kItemCard;
var protected UIInputDialogue m_kInputDialog;
var TInputDialogData m_kInputDialogData;
var protected UIMouseGuard m_kMouseGuard;
var protected UIProgressDialogue m_kProgressDialog;
var TProgressDialogData m_kProgressDialogData;
var EProgressDialog m_kProgressDialogStatus;
var EKismetUIVis m_ePendingKismetVisibility;
var protected EDifficultyLevel m_eDiff;
var const EUIMode m_eUIMode;
var protected UIReconnectController m_kControllerUnplugDialog;
var TProgressDialogData m_kControllerUnplugDialogData;
var protected UIKeybindingsPCScreen m_kPCKeybindings;
var XComKeybindingData m_kKeybindingData;
var UIMouseCursor m_kUIMouseCursor;
var UIVirtualKeyboard m_VirtualKeyboard;
var protected array< delegate<UpdateCallback> > m_arrUIUpdateCallbacks;
var float m_fUIUpdateFrequency;
var protected array<name> m_aStateStack;
var protected array<UIProtoScreen> m_aProtoStack;
var protected bool m_bIsGameDataReady;
var bool m_bInitialized;
var protected bool m_bIsIronman;
var protected bool m_bDisallowSaving;
var protected bool m_bIsPlayingGame;
var protected bool m_bGameOverTriggered;
var protectedwrite bool m_bPresLayerReady;
var bool m_bBlockSystemMessageDisplay;
var XGNarrative m_kNarrative;
var protected array<TItemUnlock> m_arrUnlocks;
var delegate<PostStateChangeCallback> m_postStateChangeCallback;
var array< delegate<PreClientTravelDelegate> > m_PreClientTravelDelegates;
var protected UIProtoScreen m_kProtoUI;
var protected UIMultiplayerPostMatchSummary m_kTestScreen;
var privatewrite name m_LastPoppedState;
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

delegate delActionAccept(string userInput, bool bWasSuccessful)
{
}

delegate delActionCancel()
{
}

delegate delNoParams()
{
}

delegate delAfterStorageDeviceCallbackSuccess()
{
}

delegate UpdateCallback()
{
}

delegate bool PostStateChangeCallback()
{
}

delegate OnNarrativeCompleteCallback()
{
}

delegate PreRemoteEventCallback()
{
}

delegate PreClientTravelDelegate(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
}

defaultproperties
{
    m_kInputDialogData=(strTitle="<NO DATA PROVIDED>",strInputBoxText="",iMaxChars=27)
    m_kProgressDialogData=(strTitle="<NO DATA PROVIDED>",strDescription="",strAbortButtonText="<DEFAULT ABORT>")
    m_kControllerUnplugDialogData=(strTitle="<NO DATA PROVIDED>",strDescription="",strAbortButtonText="<DEFAULT ABORT>")
    m_fUIUpdateFrequency=0.050
}