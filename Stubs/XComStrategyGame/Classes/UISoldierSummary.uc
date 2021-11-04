class UISoldierSummary extends UI_FxsScreen
	implements(IScreenMgrInterface);
//complete
var XGSoldierUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var int m_iCurrentSelection;
var XGStrategySoldier m_kSoldier;
var UIStrategyComponent_SoldierInfo m_kSoldierHeader;
var UIStrategyComponent_SoldierStats m_kSoldierStats;
var UIStrategyComponent_SoldierAbilityList m_kAbilityList;
var const localized string m_sChangeCovertOperativeLabel;
var const localized string m_sLaunchCovertOperativeMisison;
var const localized string m_sOnMissionLabel;
var const localized string m_sCovertOpsInfoHelpTitle;
var const localized string m_sCovertOpsInfoHelpDescription;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView, optional bool bCovertOperativeMode){}
simulated function XGSoldierUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function UpdatePanels(){}
final simulated function UpdateButtonHelp(){}
final simulated function RealizeSelected(){}
simulated function OnMousePrevSoldier(){}
simulated function bool PrevSoldier(optional bool includeSHIV, optional bool SkipSpecial, optional bool includeMEC){}
simulated function OnMouseNextSoldier(){}
simulated function bool NextSoldier(optional bool includeSHIV, optional bool SkipSpecial, optional bool includeMEC){}
simulated function OnMouseCancel(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function bool OnCancel(optional string Str){}
simulated function OnSoldierList(){}
simulated function SetSoldier(XGStrategySoldier kSoldier){}
simulated function OnLaunchMission(){}
simulated function ShowCovertOpsInfoHelp(){}
final simulated function AS_SetDescription(string _description){}
final simulated function AS_SetInDropship(optional string _label){}
simulated function AS_AddMenuOption(int _index, string _label, bool _promote, bool _psiPromote, bool _isDisabled){}
simulated function Remove(){}
function OnDeactivate(){}
event Destroyed(){}
simulated function Show(){}
simulated function Hide(){}
