class UIStrategyComponent_SoldierStats extends UI_FxsPanel
    hidecategories(Navigation);
//complete stub

var const localized string m_strStatHealth;
var const localized string m_strStatWill;
var const localized string m_strStatDefense;
var const localized string m_strStatOffense;
var XGSoldierUI m_kLocalMgr;

simulated function Init(XGSoldierUI kMgr, XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
function UpdateData(){}
event Destroyed(){}
final simulated function AS_SetSoldierStats(string _health, string _will, string _defense, string _offense){}
