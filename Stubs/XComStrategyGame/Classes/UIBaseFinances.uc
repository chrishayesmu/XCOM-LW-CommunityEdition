class UIBaseFinances extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var private int m_iView;


simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGFinanceUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
final function UpdateData(){}
final simulated function AS_SetTitle(string displayString){}
final simulated function AS_SetNet(string displayString){}
final simulated function AS_SetSection(int Index, string subtitle, string subtitleLabel, string Label, string Value){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function UnlockItems(array<TItemUnlock> arrUnlocks){}
function UnlockItem(TItemUnlock kUnlock){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnCancelClick(){}
simulated function bool OnCancel(optional string Str){}
simulated function Remove(){}

DefaultProperties
{
}
