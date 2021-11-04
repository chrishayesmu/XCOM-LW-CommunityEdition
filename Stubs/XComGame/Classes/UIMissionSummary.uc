class UIMissionSummary extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGTacticalScreenMgr m_kTacMgr;
var string m_sMouseNavigation;
var UIMissionSummary_Factors m_kFactors;
var UIMissionSummary_Artifacts m_kArtifacts;
var UIMissionSummary_Promotions m_kPromotions;
var UIMissionSummary_Ticker m_kTicker;
var UI_FxsPanel m_kFocus;
var const localized string m_strContinue;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
function InitMgr(class<Actor> kMgrClass, optional int iView){}
function XGSummaryUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int ucmd, int Arg){}
simulated function bool OnMouseEvent(int ucmd, array<string> parsedArgs){}
simulated function NextScreen(){}
simulated function PreviousScreen(){}
simulated function ShowFactors(){}
simulated function ShowArtifacts(){}
simulated function ShowPromotions(){}
simulated function DismissScreen(){}
simulated function AS_SetButtonHelp(string Label, string Icon){}
simulated function AS_SetMissionStatus(string Status){}

