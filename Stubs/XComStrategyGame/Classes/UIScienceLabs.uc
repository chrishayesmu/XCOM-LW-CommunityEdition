class UIScienceLabs extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

struct UIOption
{
    var int iIndex;
    var string strLabel;
    var int iState;
    var string strHelp;
};

var const localized string m_strScienceLabsArchiveTitle;
var const localized string m_strScienceLabsReportTitle;
var string m_strCameraTag;
var name DisplayTag;
var int m_iCurrentSelection;
var array<UIOption> m_arrUIOptions;
var int m_iView;
var const localized string m_strScienceTechSelectTitle;
var const localized string m_strCreditArchiveTitle;
var const localized string m_strScienceTechSelectTime;
var const localized string m_strScienceTechSelectPrerequisites;
var const localized string m_strTopSecret;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGResearchUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function bool OnOption(optional string Str){}
simulated function OnLoseFocus(){}
simulated function RealizeArchiveList(){}
simulated function RealizeReport(){}
simulated function SetTitle(string displayString){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function AS_EnableArchives(bool IsEnabled){}
simulated function AS_ClearArchives(){}
simulated function AS_SetArchiveTitle(string Title){}
simulated function AS_AddOption(int I, string Desc, bool IsDisabled){}
simulated function AS_SetListSelection(int I){}
simulated function AS_ClearResults(){}
simulated function AS_SetReportTitles(string TitleText, string subTitleText){}
simulated function AS_SetReportItem(string subject, string Notes, string imagePath){}
simulated function AS_AddResults(string Results){}
simulated function AS_SetTopSecretText(string localizedTopSecretText){}
simulated function AS_ScrollResearchUp(){}
simulated function AS_ScrollResearchDown(){}
