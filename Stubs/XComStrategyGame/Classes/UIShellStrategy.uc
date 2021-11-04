class UIShellStrategy extends UIPauseMenu;

//complete stub
enum EStratShellOptions
{
    eSSO_UncontrolledStart,
    eSSO_ControlledStart,
    eSSO_LoadGame,
    eSSO_Overmind,
    eSSO_Ironman,
    eSSO_Demo,
    eSSO_DebugStart,
    eSSO_MAX
};

var bool m_bCompletedControlledGame;
var bool m_bReceivedIronmanWarning;
var const localized string m_strTitle;
var const localized string m_strNewGame;
var const localized string m_strLoadGame;
var const localized string m_strDebugStrategyStart;
var const localized string m_strDifficultyTitle;
var const localized string m_strDifficultyEasy;
var const localized string m_strDifficultyNormal;
var const localized string m_strDifficultyHard;
var const localized string m_strDifficultyImpossible;
var const localized string m_strControlTitle;
var const localized string m_strControlBody;
var const localized string m_strControlOK;
var const localized string m_strControlCancel;
var const localized string m_strIronmanTitle;
var const localized string m_strIronmanBody;
var const localized string m_strIronmanOK;
var const localized string m_strIronmanCancel;
var const localized string m_strEasyDesc;
var const localized string m_strNormalDesc;
var const localized string m_strHardDesc;
var const localized string m_strClassicDesc;
var const localized string m_strIronmanLabel;
var const localized string m_strTutorialLabel;


simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, bool bIronman, optional bool bAllowSaving){}
simulated function DisconnectGame(){}
function ToggleIronman(){}
function ToggleControlledStart(){}
function ConfirmIronmanDialogue(){}
simulated function ConfirmIronmanCallback(UIDialogueBox.EUIAction eAction){}
function ConfirmControlDialogue(){}
simulated function ConfirmControlCallback(UIDialogueBox.EUIAction eAction){}

state ShellMenu{
    event BeginState(name P){}
    simulated function OnUAccept(){}
    simulated function BuildMenu(){}
    simulated function OnUCancel(){}
}
state DifficultyMenu{
    event BeginState(name P){}
    simulated function OnUAccept(){}
    simulated function BuildMenu(){}
    simulated function OnUCancel(){}
}

