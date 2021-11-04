class UIPauseMenu extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation)
	dependsOn(UIDialogueBox);
//complete stub

var int m_iCurrentSelection;
var int MAX_OPTIONS;
var bool m_bIsIronman;
var bool m_bAllowSaving;
var bool m_bBlockInputWhileExiting;
var const localized string m_sPauseMenu;
var const localized string m_sSaveGame;
var const localized string m_sReturnToGame;
var const localized string m_sSaveAndExitGame;
var const localized string m_sLoadGame;
var const localized string m_sControllerMap;
var const localized string m_sInputOptions;
var const localized string m_sAbortMission;
var const localized string m_sExitGame;
var const localized string m_sXComDatabase;
var const localized string m_sQuitGame;
var const localized string m_sAccept;
var const localized string m_sCancel;
var const localized string m_sAcceptInvitations;
var const localized string m_kExitGameDialogue_title;
var const localized string m_kExitGameDialogue_body;
var const localized string m_kExitMPRankedGameDialogue_body;
var const localized string m_kExitMPUnrankedGameDialogue_body;
var const localized string m_kQuitGameDialogue_title;
var const localized string m_kQuitGameDialogue_body;
var const localized string m_kQuitMPRankedGameDialogue_body;
var const localized string m_kQuitMPUnrankedGameDialogue_body;
var const localized string m_sRestartLevel;
var const localized string m_sRestartConfirm_title;
var const localized string m_sRestartConfirm_body;
var const localized string m_sChangeDifficulty;
var const localized string m_sViewSecondWave;
var const localized string m_sUnableToSaveTitle;
var const localized string m_sUnableToSaveBody;
var const localized string m_sSavingIsInProgress;
var const localized string m_sUnableToAbortTitle;
var const localized string m_sUnableToAbortBody;
var const localized string m_kSaveAndExitGameDialogue_title;
var const localized string m_kSaveAndExitGameDialogue_body;
var int m_optReturnToGame;
var int m_optSave;
var int m_optLoad;
var int m_optRestart;
var int m_optChangeDifficulty;
var int m_optViewSecondWave;
var int m_optControllerMap;
var int m_optOptions;
var int m_optXComDatabase;
var int m_optExitGame;
var int m_optQuitGame;
var int m_optAbortMission;
var int m_optAcceptInvite;


simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, bool IsIronman, optional bool bAllowSaving=TRUE){}
simulated function OnInit(){}
simulated event ModifyHearSoundComponent(AudioComponent AC){}
simulated function bool OnUnrealCommand(int ucmd, int Actionmask){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnUAccept(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated event ScreenFinish(){}
function SaveAndExit(){}
function Disconnect(){}
function ExitGameDialogue(){}
simulated function ExitGameDialogueCallback(EUIAction eAction){}
simulated function ExitMPGameDialogueCallback(EUIAction eAction){}
function IronmanSaveAndExitDialogue(){}
simulated function IronmanSaveAndExitDialogueCallback(EUIAction eAction){}
function UnableToSaveDialogue(bool bSavingInProgress){}
function UnableToAbortDialogue(){}
function RestartMissionDialogue(){}
simulated function RestartMissionDialgoueCallback(EUIAction eAction){}
function QuitGameDialogue(){}
simulated function QuitGameDialogueCallback(EUIAction eAction){}
simulated function QuitGameMPRankedDialogueCallback(EUIAction eAction){}
simulated function OnUCancel(){}
simulated function OnUDPadUp(){}
simulated function OnUDPadDown(){}
simulated function SetSelected(int iTarget){}
simulated function int GetSelected(){}
simulated function BuildMenu(){}
simulated function SetHelp(int Index, string Text, string buttonIcon){}
simulated function AS_SetTitle(string Title){}
simulated function AS_AddOption(int Index, string DisplayText, int iState){}
simulated function AS_Selected(int iTarget){}
simulated function AS_Clear(){}
