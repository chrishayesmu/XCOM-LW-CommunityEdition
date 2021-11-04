class UIGameplayToggles extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var const localized string m_strTitle;
var const localized string m_strWarning;
var const localized string m_arrGameplayToggleTitle[EGameplayOption];
var const localized string m_arrGameplayToggleDesc[EGameplayOption];
var const localized string m_strCanNotChangeInGame;
var UIWidgetHelper m_hWidgetHelper;
var UINavigationHelp m_kHelpBar;
var bool m_bViewOnly;
var array<int> CheckboxIndexToGameplayOptionMap;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, optional bool bViewOnly=FALSE){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function OnUCancel(){}
simulated function UpdateToggle(){}
simulated function RefreshDescInfo(){}
simulated function AS_SetTitle(string Title){}
simulated function AS_SetDesc(string Desc){}
function UpdateButtonHelp(){}
