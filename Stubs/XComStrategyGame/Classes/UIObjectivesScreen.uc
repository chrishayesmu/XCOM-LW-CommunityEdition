class UIObjectivesScreen extends UI_FxsScreen
    hidecategories(Navigation);
//complete stub

var const localized string m_strBack;
var const localized string m_strMoreInfo;
var const localized string m_strObjectives;
var bool m_isLarge;
var private UISituationRoom m_kSitRoom;
var private string m_strBriefText;
var private string m_strLargeText;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UISituationRoom kSitRoom){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnCancel(optional string Str){}
simulated function ShowLarge(){}
simulated function ShowSmall(){}
simulated function SetBriefText(string strText){}
simulated function SetLargeText(string strText){}
simulated function bool CanBeShown(){}
simulated function RefreshContents(){}
simulated function AS_SetTitle(string Text){}
simulated function AS_SetSmallBody(string Text){}
simulated function AS_SetLargeBody(string Text){}
simulated function AS_ShowLarge(bool isShowing){}
simulated function AS_SetLabels(string back, string moreInfo){}
simulated function AS_ScrollLargeObjectivesDown(){}
simulated function AS_ScrollLargeObjectivesUp(){}
