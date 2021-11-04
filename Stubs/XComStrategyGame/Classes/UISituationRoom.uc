class UISituationRoom extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface)
	dependson(UISituationRoomHUD);
//complete stub

var const localized string m_strTickerTitle;
var const localized string m_strNone;
var const localized string m_strAvailable;
var const localized string m_strUplinks;
var const localized string m_strInOrbit;
var const localized string m_strSweepDesc;
var const localized string m_strSweepDisabled;
var const localized string m_strSweepCantAfford;
var const localized string m_strSweepButton;
var const localized string m_strSweepFailed;
var XGSituationRoomUI m_kLocalSitRoomMgr;
var XGSatelliteSitRoomUI m_kLocalSatelliteMgr;
var XGInfiltratorSitRoomUI m_kLocalInfiltratorMgr;
var string m_strCameraTag;
var name DisplayTag;
var int m_iViewSitRoom;
var int m_iViewSatellite;
var int m_iViewInfiltrator;
var int m_iCurrentCountry;
var int m_iCols;
var int m_iRows;
var UISituationRoomHUD m_kSitRoomHUD;
var UIObjectivesScreen m_kObjectivesScreen;
var bool m_bAcceptsInput;
var bool m_bSweepFailed;
var int m_iTickerStartingIndex;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function OnInit(){}
simulated function OnInitComplete(){}
simulated function XGSituationRoomUI GetSitRoomMgr(optional IScreenMgrInterface kInterface){}
simulated function XGSatelliteSitRoomUI GetSatelliteMgr(){}
simulated function XGInfiltratorSitRoomUI GetInfiltratorMgr(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function OnUCancel();
simulated function UpdateData(){}
simulated function UpdateCountries(){}
simulated function UpdateTicker(){}
simulated function RealizeMap(){}
simulated function RealizeObjectives(){}
simulated function HideObjectives(){}
simulated function ShowObjectives(){}
simulated function UpdateHUD();
simulated function UpdateFailResults(){}
simulated function UpdateSuccessResults(){}
simulated function GoToView(int iView){}
simulated function RefreshHUDButtonHelp();
simulated function bool OnUp(optional string Str){}
simulated function bool OnDown(optional string Str){}
simulated function bool OnLeft(optional string Str){}
simulated function bool OnRight(optional string Str){}
simulated function RealizeSelected();
simulated function bool OnAccuse(){}
function ConfirmSatelliteDialogue(){}
simulated function ConfirmSatelliteDialogueCallback(EUIAction eAction){}
function HelpSatelliteDialogue(){}
simulated function HelpSatelliteDialogueCallback(EUIAction eAction){}
function HelpInfiltratorDialogue(){}
simulated function HelpInfiltratorDialogueCallback(EUIAction eAction){}
function BonusDialogue(){}
simulated function BonusDialogueCallback(EUIAction eAction){}
function AlertDialogue(){}
simulated function AlertDialogueCallback(EUIAction eAction){}
function OnSweepDialogue(){}
simulated function SweepDialogueCallback(EUIAction eAction){}
simulated function bool WasSweepSuccessful(){}
simulated function AS_SetTickerText(string tickerTitle, string txt){}
simulated function AS_HideTicker(){}
simulated function AS_ShowTicker(){}
simulated function AS_SetCountryInfo(int iIndex, string countryName, string cash, int panicLevel, bool bIsActive){}
simulated function AS_SetCountryInfoInfiltrator(int iIndex, string countryName, int panicLevel, bool bIsActive, bool bHasCell, XGSituationRoomUI.EUICellState cellState, bool bClearedByClues, bool bShowExaltBase){}
simulated function AS_ClearMap(){}
simulated function AS_AddMapItem(string movieclipLabelName, float X, float Y){}
simulated function AS_AddGroundedPlanes(float X, float Y, float Amount, float amountDisabled){}
simulated function AS_SetObjectivesTitle(string Title){}
simulated function AS_AddObjective(string Text){}
simulated function AS_HideUplinks(){}
simulated function AS_ShowUplinks(){}
simulated function AS_SetSatellites(int NumAvailable, string availLabel, int amtUsed, int amtMax, string inOrbitLabel){}
simulated function AS_SetDoomLevel(int Level){}
simulated function AS_SetDisplayMode(UISituationRoomHUD.UISitRoomMode Mode){}
simulated function AS_SetIntel(string txt, string buttonLabel, string Icon){}
simulated function AS_SweepAnimation(int EContinent){}
simulated function Remove(){}

state MainSituationViewState{
    simulated event PushedState(){}
    simulated event ContinuedState(){}
    simulated event PoppedState(){}
    simulated function GoToView(int iView){}
    simulated function bool OnAccept(optional string Str){}
    simulated function bool OnUp(optional string Str){}
    simulated function bool OnDown(optional string Str){}
    simulated function bool OnLeft(optional string Str){}
    simulated function bool OnRight(optional string Str){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}

}

state BaseSelectingCountriesState{
    simulated function bool OnUp(optional string Str){}
    simulated function bool OnDown(optional string Str){}
    simulated function bool OnLeft(optional string Str){}
    simulated function bool OnRight(optional string Str){}
    simulated function HideHUD(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}
}

state SatelliteState extends BaseSelectingCountriesState{
    simulated event PushedState(){}
    simulated event PoppedState(){}
    simulated function GoToView(int iView){}
    simulated function RealizeSelected(){}
    simulated function bool OnAccept(optional string Str){}
    simulated function OnUCancel(){}
    simulated function UpdateHUD(){}

}

state ObjectivesState{
    simulated event PushedState(){}
    simulated event PoppedState(){}
    simulated function OnUCancel(){}

}

state InfiltratorState extends BaseSelectingCountriesState{
    simulated event PushedState(){}
    simulated event PoppedState(){}
    simulated function ContinuedState(){}
    simulated function GoToView(int iView){}
    simulated function RealizeSelected(){}
    simulated function bool OnAccept(optional string Str){}
    simulated function bool OnAccuse(){}
    function OnAccuseCallback(EUIAction eAction){}
    simulated function OnUCancel(){}
    simulated function UpdateHUD(){}
    simulated function UpdateCountries(){}
    simulated function SelectDefaultCountry(){}
    simulated function RefreshHUDButtonHelp(){}
    simulated function OnLoseFocus(){}
    simulated function OnReceiveFocus(){}

}

state TransitionState{
    simulated event PushedState(){}
    simulated function bool OnAccept(optional string Str){}
    simulated function GoToView(int iView){}
    simulated function UpdateCountries(){}
	simulated event PoppedState(){};
}
