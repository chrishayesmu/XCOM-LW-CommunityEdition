class UIStrategyHUD_BuildQueue extends UI_FxsPanel
    hidecategories(Navigation);
//complete stub

struct UIEngineeringQueueItem
{
    var int iIndex;
    var string strEngineers;
    var string strQty;
    var string strItemName;
    var string strETA;
    var int iState;
};

var int m_iCurrentSelection;
var bool m_bIsEditing;
var bool m_bHideEditString;
var array<UIEngineeringQueueItem> m_arrUIOptions;
var const localized string m_strQueue_Locked;
var const localized string m_strQueue_ClickToEdit;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function XGEngineeringUI GetMgr(optional IScreenMgrInterface kInterface){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function RealizeNavigation(){}
simulated function bool OnAccept(optional string strOption){}
simulated function bool OnCancel(optional string strOption){}
simulated function bool OnOption(optional string Str){}
simulated function RealizeSelected(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function Show(){}
simulated function ActivateEditing(){}
simulated function DeactivateEditing(){}
simulated function GoToView(int iView){}
simulated function bool hasItems(){}
protected simulated function AS_SetQueueTitle(string Title, string etaLabel, string projectLabel, string engineersLabel, string qtyLabel){}
final simulated function AS_AddProjectToQueue(string Desc, string engineers, string qty, string eta, int uistate){}
final simulated function AS_SetHelp(string displayString, string buttonIcon){}
simulated function DeactivateMouseBlocker(){}
simulated function ActivateMouseBlocker(){}
