class UIGollop extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGGollopUI GetMgr(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int ucmd, array<string> parsedArgs){}
simulated function bool OnAccept(optional string Arg){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Arg){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function name GetViewState(int iView){}
simulated function GoToView(int iView){}
simulated function AS_SetData(string _titleLabel, string _buttonLabel, bool buttonDisabled){}
event Destroyed(){}
