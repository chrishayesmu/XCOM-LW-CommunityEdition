class UIShipSummary extends UI_FxsScreen
	    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strKillsLabel;
var const localized string m_strWeaponLabel;
var const localized string m_strShipInfoBtnHelp;
var const localized string m_strWeaponInfoBtnHelp;
var const localized string m_strEditLoadoutBtnHelp;
var const localized string m_strDismissShipBtnHelp;
var const localized string m_strDismissShipConfirmDialogTitle;
var const localized string m_strDismissShipConfirmDialogText;
var const localized string m_strDismissShipConfirmDialogAcceptText;
var XGHangarUI m_kLocalMgr;
var string m_strCameraTag;
var int m_iSelectedOption;
var bool m_bUpdateDataOnReceiveFocus;
var XGShip_Interceptor m_kShip;
var UINavigationHelp m_kNavBar;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, XGShip_Interceptor kShip){}
simulated function XGHangarUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
function UpdateButtonHelp(){}
protected simulated function RealizeSelected(int newSelection){}
simulated function OnMouseShipInfo(){}
simulated function OnMouseWeaponInfo(){}
simulated function OnMouseCancel(){}
simulated function OnEditLoadout(){}
simulated function OnDismissShip(){}
simulated function OnDismissDialogConfirm(EUIAction eAction){}
simulated function OnWeaponItemCard(){}
simulated function OnShipItemCard(){}
simulated function GoToView(int iView){}
simulated function OnReceiveFocus(){}
simulated function AS_SetShipName(string txt){}
simulated function AS_SetShipStatus(string htmlTxt, int Status){}
simulated function AS_SetKills(string txt){}
simulated function AS_SetWeaponLabel(string txt){}
simulated function AS_SetWeaponName(string txt){}
simulated function AS_SetWeaponImage(string imgPath){}
simulated function AS_SetWeaponHelp(int btnIndex, string btnHelp, string btnIcon, bool IsDisabled){}
simulated function AS_SetWeaponButtonFocus(int btnIndex, bool IsFocused){}
function OnDeactivate(){}
event Destroyed(){}
