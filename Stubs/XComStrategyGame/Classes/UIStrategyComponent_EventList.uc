class UIStrategyComponent_EventList extends UI_FxsPanel
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strEventListTitle;
var const localized string m_strSingleEventListTitle;
var const localized string m_strExpandEventList;
var const localized string m_strContractEventList;
var string m_strEventListLabel;
var XGMissionControlUI m_kLocalMgr;
var int m_hEventsWatchHandle;
var int m_hTimeScaleHandle;
var int m_iNumUpcomingEvents;
var int m_iMaxEventsPerRow;
var bool m_bExpandListVertically;
var bool m_bIsExpanded;
var delegate<onButtonClickedDelegate> onButtonClickedDelegate__Delegate;

delegate onButtonClickedDelegate(){};
simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function XGMissionControlUI GetMgr(optional int iStaringView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function TimeScaleChanged(){}
simulated function GoToView(int iView){};
simulated function UpdateData(){}
function bool IsExpanded(){}
simulated function ExpandEventList(){}
function ContractEventList(){}
function ResetList(){}
simulated function UpdateButtonHelp(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function string GetEventImageLabel(int EventType, int iContinentMakingRequest){}
simulated function Show(){}
simulated function Hide(){}
simulated function AS_AddEvent(string Description, string etaLabel, string eta, string iconLabel){}
simulated function AS_SetTitle(string Title, string Label){}
simulated function AS_OverrideMaxItemsPerColumn(int Num){}
simulated function AS_ExpandListVertically(bool Val){}
simulated function Remove(){}
