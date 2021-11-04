class UIProgressDialogue extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub
struct TProgressDialogData
{
    var string strTitle;
    var string strDescription;
    var string strAbortButtonText;
    var delegate<ButtonPressCallback> fnCallback;
    var delegate<ProgressDialogOpenCallback> fnProgressDialogOpenCallback;
};
var TProgressDialogData m_kData;
var delegate<ButtonPressCallback> m_fnCallback;
var delegate<ButtonPressCallback> __ButtonPressCallback__Delegate;
var delegate<ProgressDialogOpenCallback> __ProgressDialogOpenCallback__Delegate;

delegate ButtonPressCallback();
delegate ProgressDialogOpenCallback();

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TProgressDialogData kData){}
simulated function OnInit(){}
simulated function DelayedRemoval(){}
event Tick(float DeltaTime){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnCancel(optional string strOption){}
simulated function Show(){}
simulated function UpdateData(string Title, string Description){}
final simulated function AS_SetTitle(string Text){}
final simulated function AS_SetDescription(string Text){}
final simulated function AS_SetButtonHelp(string buttonText, string Icon){}
