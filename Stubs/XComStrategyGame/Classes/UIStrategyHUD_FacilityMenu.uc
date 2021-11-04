class UIStrategyHUD_FacilityMenu extends UI_FxsPanel
    hidecategories(Navigation);
//complete stub

struct UIFacilityMenuOption
{
    var int iIndex;
    var int iState;
    var string strLabel;
    var bool bNeedsAttention;
    var XGFacility kFacility;
};

var bool bItemsLoaded;
var bool bPumpDataPostItemLoad;
var int m_iCurrentSelection;
var array<UIFacilityMenuOption> m_arrUIFacilities;
var UIStrategyHUD_FacilitySubMenu m_kSubMenu;
var XGFacility m_kInitFacility;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
function OnFlashCommand(string Cmd, string Arg){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function bool EnterMissionControl(){}
function EnterGollopChamber(){}
simulated function UpdateData(optional bool bInitialUpdate){}
simulated function RealizeSelected(){}
simulated function bool DirectSelectFacility(int iFacility){}
simulated function bool DirectSelectFacilityByType(EFacilityType eType){}
simulated function OnAccept(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Show(){}
simulated function Hide(){}
simulated function XGFacility GetFacility(int iIndex){}
simulated function bool IsCurrentFacility(XGFacility kFacility){}
simulated function SetSelectedFacility(XGFacility kFacility){}
simulated function AS_SetFocus(string Id){}
simulated function AS_DimAllUnselectedMenuOptions(){}
simulated function AS_AddMenuOption(int Id, string displayTxt, bool ShowAlert){}
