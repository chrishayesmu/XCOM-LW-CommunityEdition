class UIChooseFacility extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strNoReqLabel;
var const localized string m_strSuperSpreeLabel;
var int m_iCurrentSelection;
var array<UIOption> m_arrUIOptions;
var int m_iView;
var XComHQHUD myHUD;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGBuildUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateButtonHelp(){}
simulated function GoToView(int iView){}
protected simulated function UpdateData(){}
protected simulated function UpdateLayout(){}
final simulated function AS_AddOption(int iIndex, string sLabel, int iState){}
simulated function OnUAccept(){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Hide(){}
final simulated function UpdateInfoPanelData(int iMenuItem){}
final simulated function AS_UpdateInfo(string techName, string infoText, string descText, string imageLabel){}
final simulated function RealizeSelected(){}
function UnlockItems(array<TItemUnlock> arrUnlocks){};
function UnlockItem(TItemUnlock kUnlock){};
