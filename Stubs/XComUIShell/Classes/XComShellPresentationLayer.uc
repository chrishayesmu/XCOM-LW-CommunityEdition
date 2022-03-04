class XComShellPresentationLayer extends XComPresentationLayerBase
    hidecategories(Navigation);

const UNCANCELLABLE_PROGRESS_DIALOGUE_TIMEOUT = 10;

var XComShell m_kXComShell;
var UIShell m_kShellScreen;
var UIFinalShell m_kFinalShellScreen;

simulated function UIShellScreen(){}
simulated function UIFinalShellScreen(){}
simulated function EnterMainMenu(){}

simulated state State_FinalShell extends BaseScreenState
{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}