class UIStrategyComponent_Clock extends UI_FxsPanel
    hidecategories(Navigation);
//complete stub

var XGMissionControlUI m_kLocalMgr;
var int m_hClockWatchHandle;
var bool m_bClockValueChanged;
var float m_fTimeSinceLastUpdate;
var float m_fUpdateRate;
var const localized string KOR_year_suffix;
var const localized string KOR_month_suffix;
var const localized string KOR_day_suffix;
var const localized string JPN_year_suffix;
var const localized string JPN_month_suffix;
var const localized string JPN_day_suffix;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function XGMissionControlUI GetMgr(optional int iStaringView){}
simulated function ClockValueChanged(){}
event Tick(float fDeltaT){}
simulated function UpdateData(){}
function int GetUIColorNumber(int State){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function AS_SetDateTime(string month_and_day, string Year, string hours, string Mins, bool am, int colorNumber, bool bIs24HourClock){}
simulated function Remove(){}

defaultproperties
{
    m_fUpdateRate=0.0330
    s_name=theClock
}