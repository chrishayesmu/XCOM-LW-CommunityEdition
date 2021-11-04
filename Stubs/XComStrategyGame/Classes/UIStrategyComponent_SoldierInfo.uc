class UIStrategyComponent_SoldierInfo extends UI_FxsPanel;
//complete stub

var const localized string m_strStatusLabel;
var const localized string m_strMissionsLabel;
var const localized string m_strKillsLabel;
var XGStrategySoldier m_kSoldier;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, XGStrategySoldier kSoldier){}
simulated function OnInit(){}
function UpdateData(){}
event Destroyed(){}
final simulated function AS_SetMedals(string medalData){}
final simulated function AS_SetSoldierInformation(string _name, string _nickname, string _status, string _flagIcon, string _classLabel, string _classText, string _rankLabel, string _rankText, bool _showPromoteIcon, string _missions, string _kills){}
