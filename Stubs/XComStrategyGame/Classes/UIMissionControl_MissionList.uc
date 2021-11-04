class UIMissionControl_MissionList extends UI_FxsPanel
	   hidecategories(Navigation);

var const localized string m_strMissionListTitle;
var XGMissionControlUI m_kLocalMgr;
var int m_hMissionWatchHandle;
var int m_hHighlightWatchHandle;
var int m_hTimeScaleHandle;
var array<TMCMission> arrCurrDisplayedMissions;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function XGMissionControlUI GetMgr(optional int iStaringView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function OnFlashCommand(string Cmd, string Arg){}
simulated function TimeScaleChanged(){}
protected simulated function UpdateData(){}
simulated function RealizeSelected(){}
simulated function OnReceiveFocus(){}
simulated function Show(){}
simulated function Hide(){}
simulated function AS_SetTitle(string Title){}
simulated function AS_AddOption(int Index, string Text, int State, string Icon){}
simulated function Remove(){}