class UIEndOfMonthReport extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var int m_iView;
var UIWorldReport m_kWorldReportUI;
var const localized string m_strLabelCarryOn;
var const localized string m_strMonthlyReward;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGWorldReportUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
final simulated function AS_UpdateHeader(string Title, string Desc, string rewards, string gradeLabel, string grade){}
final simulated function AS_UpdateBar(int contIndex, string continentName, string rewards, string bonus, int continentNum, bool bIsWithdrawn){}
final simulated function AS_UpdateCountry(int contIndex, int countryIndex, string countryName, int panicLevel, string satelliteinfo){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function GoToView(int iView){}
simulated function Remove(){}
