class UIMemorial extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strMemorialTitle;
var const localized string m_strKillsTitle;
var const localized string m_strMissionsTitle;
var const localized string m_strLastOpTitle;
var const localized string m_strTimeOfDeathTitle;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGMemorialUI GetMgr(optional int iStaringView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Arg){}
simulated function UpdateHeaders(){}
simulated function UpdateButtonHelp(){}
simulated function UpdateData(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Hide(){}
simulated function Show(){}
function GoToView(int iNewView){};
simulated function AS_SetTitleLabels(string Title, string Kills, string Missions, string lastOp, string timeOfDeath){}
simulated function AS_AddSoldier(string _name, string Kills, string Missions, string lastOp, string timeOfDeath, string Medals, string causeOfDeath){}
simulated function AS_ScrollUp(){}
simulated function AS_ScrollDown(){}
event Destroyed(){}
function OnDeactivate(){}
