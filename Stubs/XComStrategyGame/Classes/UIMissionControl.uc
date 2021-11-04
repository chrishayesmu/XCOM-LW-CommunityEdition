class UIMissionControl extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete  stub

var XGMissionControlUI m_kLocalMgr;
var int m_iView;
var UIMissionControl_MissionList m_kMissionList;
var UIStrategyComponent_EventList m_kEventList;
var UIStrategyComponent_Clock m_kClock;
var UIMissionControl_AlertBase m_kActiveAlert;
var UINavigationHelp m_kHelpBar;
var const localized string m_strHoloGlobeHelp;
var const localized string m_strRotateGlobeHelp;
var bool m_bHolowGlobeOnMouseToggle;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView){}
simulated function XGMissionControlUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function GoToView(int iView){}
function UFOContact_BeginShipSelection(XGShip_UFO kTarget){}
simulated function ShowBackButtonForAlert(){}
simulated function OnMouseCancelAlert(){}
simulated function OnMouseCancel(){}
simulated function OnMouseHologlobe(){}
simulated function UpdateButtonHelp(){}
simulated function UpdateNotices(){}
simulated function LoadFlashAlertPanel(){}
function bool IsEventListExpanded(){}
function ToggleMissionList(bool bVisible){}
simulated function HideNonAlertPanels(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Show(){}
simulated function Hide(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function ClearAlertReference(UIMissionControl_AlertBase referenceToBeCleared){}
simulated function Remove(){}
event Destroyed(){}
