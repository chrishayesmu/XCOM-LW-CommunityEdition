class UIShipList extends UI_FxsScreen
	implements(IScreenMgrInterface);
//complete stub

const EMPTY_STATE_ID = -1;
const ICON_UP_DOWN = "Icon_DPAD_VERTICAL";

var const localized string m_strScreenTitle;
var const localized string m_strEmptySlotLabel;
var const localized string m_strFullContinentLabel;
var const localized string m_strMoreInfoHotlinkLabel;
var const localized string m_strViewShipButtonHelp;
var const localized string m_strTransferShipButtonHelp;
var const localized string m_strTransferShipHereButtonHelp;
var const localized string m_strTransferShipUpDownNavigationHelp;
var const localized string m_strBeginTransferShip;
var const localized string m_strHireShipButtonHelp;
var const localized string m_strCancelHireButtonHelp;
var const localized string m_strCancelTransferButtonHelp;
var const localized string m_strPendingInterceptorInfo;
var const localized string m_strPendingFirestormInfo;
var const localized string m_strPendingOrderRemainingDays;
var const localized string m_strConfirmTransferDialogTitle;
var const localized string m_strConfirmTransferDialogAcceptText;
var const localized string m_strConfirmTransferDialogText;
var const localized string m_strConfirmTransferDialogTextNoSattelitesOverContinent;
var const localized string m_strHangarsFullDialogTitle;
var const localized string m_strHangarsFullDialogText;
var const localized string m_strColumnShipName;
var const localized string m_strColumnShipWeapon;
var const localized string m_strColumnShipStatus;
var XGHangarUI m_kLocalMgr;
var int m_iView;
var int m_iSelectedShip;
var int m_iSelectedContinent;
var int m_iContinentTransferingFrom;
var int m_iContinentTransferingTo;
var XGShip_Interceptor m_kSelectedShip;
var bool m_bTransferingShip;
var bool m_bUpdateDataOnReceiveFocus;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGHangarUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
function XGFacility_Engineering ENGINEERING(){}
simulated function AlterSelection(int Direction){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function int GetNumPendingFirestormsForSelectedContinent(){}
simulated function OnCommand(string Cmd, string Arg){}
protected simulated function UpdateData(){}
simulated function RealizeSelected(optional int iContinentOverride, optional int iShipOverride){}
simulated function UpdateButtonHelpOnSelectedItem(){}
simulated function bool HangarSlotAvailable(){}
simulated function bool OnAccept(optional string selectedOption){}
simulated function TransferShip(){}
simulated function OnTransferDialogConfirm(EUIAction eAction){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string selectedOption){}
simulated function OnTransferInterceptor(){}
simulated function OnReceiveFocus(){}
simulated function GoToView(int iView){}
simulated function AS_SetTitle(string Title){}
simulated function AS_SetColumnLabels(string shipName, string SHIPWEAPON, string shipStatus){}
simulated function AS_SetContinentTitle(int Index, string Title){}
simulated function AS_SetMoreInfoHotlink(optional string Label, optional string Icon){}
simulated function AS_SetSelection(int continentIndex, int shipIndex){}
simulated function AS_AddShip(int continentIndex, string shipName, string WeaponType, string Status, optional string Help, optional int State){}
simulated function AS_AddPendingShip(int continentIndex, string infoTxt, string statusTxt, optional string Help, optional int ShipType){}
simulated function AS_UpdateShipData(int shipIndex, string shipName, string WeaponType, string Status, optional string Help, optional int State){}
simulated function AS_UpdateShipHelp(int continentIndex, int shipIndex, string Help){}
simulated function AS_UpdateShipStatusHelp(int continentIndex, int shipIndex, string statusHelp){}
simulated function AS_InitializeShipTransfer(optional string transferringShipTextOverride, optional string emptySlotTextOverride){}
simulated function AS_ClearContinent(int continentIndex){}
function OnDeactivate(){}
event Destroyed(){}
