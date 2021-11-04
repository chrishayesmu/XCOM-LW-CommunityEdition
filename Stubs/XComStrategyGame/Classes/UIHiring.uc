class UIHiring extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var UIWidgetHelper m_hWidgetHelper;
var UINavigationHelp m_kNavBar;
var const localized string m_strHelpHire;
var const localized string m_strHelpOrder;
var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnMouseAccept(){}
simulated function OnMouseCancel(){}
simulated function bool OnAccept(optional string selectedOption){}
simulated function bool OnCancel(optional string selectedOption){}
simulated function UpdateData();
simulated function GoToView(int iView);
simulated function RefreshDisplay(){}
simulated function UpdateButtonHelp(){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_UpdateInfo(string infoText, string descText){}
simulated function AS_SetIcon(string Icon){}
simulated function AS_SetMouseConfirmText(string displayString){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
