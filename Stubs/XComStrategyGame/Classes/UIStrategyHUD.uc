class UIStrategyHUD extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strBackLabel;
var const localized string m_strAcceptLabel;
var const localized string m_strZoomLabel;
var const localized string m_strMoveCameraLabel;

var UIStrategyHUD_FacilityMenu m_kMenu;
var UIStrategyComponent_Clock m_kClock;
var UIStrategyComponent_EventList m_kEventList;
var UINavigationHelp m_kHelpBar;
var XGHeadquartersUI m_kMgr;
var UIStrategyHUD_BuildQueue m_kBuildQueue;
var UIStrategyTutorialBox m_kTutorialHelpBox;
var bool m_bIsFocused;
var bool m_bPostOnInitFocusCached;
var delegate<OnMouseClickDel> m_MouseAcceptDelegate;
var delegate<OnMouseClickDel> m_MouseBackDelegate;
var delegate<OnMouseClickDel> OnMouseClickDel__Delegate;
var delegate<onButtonClickedDelegate> onButtonClickedDelegate__Delegate;

delegate bool OnMouseClickDel();
delegate onButtonClickedDelegate();

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateDefaultResources(){}
simulated function UpdateFunds(){}
simulated function UpdateMeld(){}
simulated function ClearResources(){}
simulated function AddResource(string Data){}
simulated function UpdateTickerText(){}
function UpdateHotlink(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function UpdateTopLevelButtonHelp(){}
simulated function ClearButtonHelp(){}
simulated function Touch_ShowPauseButtonHelp(){}
simulated function OnPause(){}
simulated function ShowZoomButtonHelp(){}
simulated function ShowBackButton(delegate<onButtonClickedDelegate> mouseCallback, optional string customLabel, optional bool hideEverythingElse){}
simulated function SetBackButtonMouseClickDelegate(delegate<onButtonClickedDelegate> mouseCallback){}
simulated function Show(){}
simulated function Hide(){}
simulated function ShowTutorialHelp(string strHelpText){}
simulated function HideTutorialHelp(){}
simulated function ClearFacilityPanels(){}
simulated function AS_SetHumanResources(optional string resourceName, optional string Amount){}
simulated function AS_SetHotlink(optional string missionControlString, optional string missionControlIcon, optional bool bShowMCAlert, optional string gollopString, optional string gollopIcon, optional bool bShowGollopAlert){}
simulated function AS_SetCurrentResearch(optional string Title, optional string Description, optional string eta, optional float percentComplete, optional string iconLabel){}
final simulated function AS_ShowTicker(){}
final simulated function AS_HideTicker(){}
final simulated function AS_HideHotlink(){}
simulated function AS_HideResourcesPanel(){}
simulated function AS_ShowResourcesPanel(){}
final simulated function AS_SetObjectives(optional string Title, optional string Description){}
final simulated function AS_AddResource(string displayString){}
function GoToView(int iView);
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
