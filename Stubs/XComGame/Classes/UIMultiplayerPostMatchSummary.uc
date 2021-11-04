class UIMultiplayerPostMatchSummary extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var const localized string m_strMatchSummary;
var const localized string m_strGame;
var const localized string m_strPoints;
var const localized string m_strMap;
var const localized string m_strTurns;
var const localized string m_strTime;
var const localized string m_strWin;
var const localized string m_strLose;
var const localized string m_strReadyForRematch;
var const localized string m_strContinue;
var const localized string m_strRematch;
var int m_iSelectedIndex;
var XComMultiplayerTacticalUI m_kMPInterface;
var UniqueNetId m_TopPlayerUniqueId;
var UniqueNetId m_BottomPlayerUniqueId;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated event OnCleanupWorld(){}
simulated function OnSystemMessageAdd(string sMessage, string sTitle){}
final simulated function string FormatTime(int Seconds){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnAccept(optional string strOption){}
simulated function bool OnAltYSelect(){}
simulated function bool OnAltXSelect(){}
simulated function bool OnUp(){}
simulated function bool OnDown(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
final simulated function RealizeSelection(){}
final simulated function AS_SetLabels(string Title, string Game, string Points, string Map, string turnslabel, string Time, string iconCard, string viewGamerCard, string iconStats, string playerStats){}
final simulated function AS_SetValues(string Game, string Points, string Map, string turnslabel, string Time){}
final simulated function AS_SetNavigationLabels(string continueButton, string rematchButton){}
final simulated function AS_SetGamerTags(string nameTop, string nameBottom){}
final simulated function AS_SetOutcomes(string outcomeTop, string outcomeBottom){}
final simulated function AS_SetSelected(int Index){}
