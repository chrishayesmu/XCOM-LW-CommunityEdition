class UIStrategyComponent_SoldierAbilityList extends UI_FxsPanel;
//complete stub

var const localized string m_strAbilitiesTitle;
var XGSoldierUI m_kLocalMgr;
var private int m_iAddedAbilities;


simulated function Init(XGSoldierUI kMgr, XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
function ClearAbilityList(){}
event Destroyed(){}
final simulated function AS_SetTitle(string Title){}
simulated function AS_AddAbility(string _label, string _perkIconLabel, bool _psionic){}
