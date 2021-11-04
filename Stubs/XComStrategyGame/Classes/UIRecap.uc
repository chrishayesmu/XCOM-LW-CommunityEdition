class UIRecap extends UI_FxsScreen
    implements(IScreenMgrInterface);

//complete stub
var const localized string m_strNext;
var const localized string m_strPrevious;
var const localized string m_strStat;
var const localized string m_strYou;
var const localized string m_strWorld;
var private int m_iPage;
var private XGRecapUI m_kMgr;

function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function BuildRecapPages(){}
simulated function UpdateWorldvalues(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function bool OnScrollUp(){}
simulated function bool OnScrollDown(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function GoToView(int iView){}
simulated function bool IsVisible(){}
simulated function Hide(){}
simulated function Show(){}
simulated function AS_SetLabels(string winLoseText, string difficultyText, string nextText, string previousText, string statText, string youText, string worldText){}
simulated function AS_AddPage(string pageId, string Title){}
simulated function AS_AddLine(string pageId, string Description, string Value, string worldValue){}
simulated function AS_ShowFirstPage(){}
simulated function AS_NextPage(){}
simulated function AS_PreviousPage(){}
simulated function AS_ScrollDown(){}
simulated function AS_ScrollUp(){}
simulated function AS_UpdateWorldValue(string pageId, int Idx, string worldValue){}
event Destroyed(){}
