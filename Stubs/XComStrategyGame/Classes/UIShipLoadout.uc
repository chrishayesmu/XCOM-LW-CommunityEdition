class UIShipLoadout extends UI_FxsScreen
    implements(IScreenMgrInterface);
//complete stub
const WEAPON_IMAGE_SCALE = 0.9;

var const localized string m_strScreenTitle;
var const localized string m_strShipWeaponColumnLabel;
var const localized string m_strQuantityColumnLabel;
var const localized string m_strConfirmEquipDialogTitle;
var const localized string m_strConfirmEquipDialogAcceptText;
var const localized string m_strConfirmEquipDialogText;
var XGHangarUI m_kLocalMgr;
var XGShip_Interceptor m_kShip;
var int m_iCurrentSelection;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, XGShip_Interceptor kShip){}
simulated function XGHangarUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
function RealizeSelected(){}
simulated function bool OnAccept(optional string Arg){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Arg){}
simulated function OnConfirmDialogComplete(EUIAction eAction){}
simulated function OnItemCard(){}
simulated function GoToView(int iView){}
simulated function AS_SetTitle(string txt){}
simulated function AS_SetListLabels(string weaponlabel, string quantityLabel){}
simulated function AS_SetWeaponName(string txt){}
simulated function AS_SetWeaponDescription(string txt){}
simulated function AS_SetStatData(int statIndex, string statLabel, string statVal, optional string statDiff){}
simulated function AS_SetWeaponImage(string imgPath, float Scale){}
simulated function AS_AddWeapon(string weaponName, string Count, bool Disabled){}
simulated function AS_SetSelected(int Index){}
function OnDeactivate(){}
event Destroyed(){}
