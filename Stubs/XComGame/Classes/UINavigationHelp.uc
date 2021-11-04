class UINavigationHelp extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub
const HELP_OPTION_IDENTIFIER = "buttonHelp";

enum EButtonIconPC
{
    eButtonIconPC_Prev_Soldier,
    eButtonIconPC_Next_Soldier,
    eButtonIconPC_Hologlobe,
    eButtonIconPC_Details,
    eButtonIconPC_Back,
    eButtonIconPC_Pause,
    eButtonIconPC_MAX
};

var int LEFT_HELP_CONTAINER_PADDING;
var int RIGHT_HELP_CONTAINER_PADDING;
var int CENTER_HELP_CONTAINER_PADDING;
var const localized string m_strBackButtonLabel;
var delegate<onHelpBarInitializedDelegate> m_notifyHelpBarLoadedDelegate;
var array< delegate<onButtonClickedDelegate> > m_arrButtonClickDelegates;
var delegate<onHelpBarInitializedDelegate> __onHelpBarInitializedDelegate__Delegate;
var delegate<onButtonClickedDelegate> __onButtonClickedDelegate__Delegate;

delegate onHelpBarInitializedDelegate();
delegate onButtonClickedDelegate();

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, delegate<onHelpBarInitializedDelegate> Delegate){}
simulated function OnInit(){}
function SetButtonDelegate(int DelegateIndex, optional delegate<onButtonClickedDelegate> mouseCallback){}
function bool HasDelegate(delegate<onButtonClickedDelegate> mouseCallback){}
function ClearButtonHelp(){}
function AddBackButton(optional delegate<onButtonClickedDelegate> mouseCallback){}
function AddBackTextButton(delegate<onButtonClickedDelegate> mouseCallback){}
function AddLeftHelp(string Label, string gamepadIcon, optional delegate<onButtonClickedDelegate> mouseCallback, optional bool IsDisabled){}
function AddRightHelp(string Label, string gamepadIcon, optional delegate<onButtonClickedDelegate> mouseCallback, optional bool IsDisabled){}
function AddCenterHelp(string Label, string gamepadIcon, optional delegate<onButtonClickedDelegate> mouseCallback, optional bool IsDisabled){}

simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function SetButtonType(string strButtonType){}
final simulated function AS_SetLeftHelpPadding(int Padding){}
final simulated function AS_SetRightHelpPadding(int Padding){}
final simulated function AS_SetCenterHelpPadding(int Padding){}
final simulated function AS_AddLeftButtonHelp(int Id, string Label, string Icon, bool Disabled){}
simulated function AS_AddRightButtonHelp(int Id, string Label, string Icon, bool Disabled){}
final simulated function AS_AddCenterButtonHelp(int Id, string Label, string Icon, bool Disabled){}
final simulated function AS_SetButtonType(string buttonType){}
simulated function Remove(){}