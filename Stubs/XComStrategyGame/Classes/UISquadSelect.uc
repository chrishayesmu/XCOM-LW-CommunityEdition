class UISquadSelect extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var bool m_bExiting;
var string m_sMouseNavigation;
var int m_iCurrentSelection;
var int m_iView;
var UISquadSelect_SquadList m_kSquadList;
var UINavigationHelp m_kHelpBar;
var const localized string m_strBackToBriefing;
var const localized string m_strSimMission;
var const localized string m_strTitleConfirmLaunchWithoutPromotion;
var const localized string m_strLaunchWithoutPromoting;
var const localized string m_strTitleMecsInCivvies;
var const localized string m_strTextMecsInCivvies;
var const localized string m_strComfirmLaunch;
var const localized string m_strCancelLaunch;
var const localized string m_strStripGearLabel;
var const localized string m_strStripGearConfirmDesc;
var string m_strLaunch;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGMission kMission, bool _bCanNavigate){}
simulated function XGChooseSquadUI GetMgr(){}
simulated function UpdateButtonHelp(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function GoToView(int iView){}
simulated function OnLaunchMission(){}
simulated function OnSimMission(){}
simulated function bool OnAccept(optional string strOption){}
function ConfirmDialogue(){}
function MecsStillInCivviesDialog(){}
simulated function ConfirmDialogueCallback(EUIAction eAction){}
simulated function OnStripGear(){}
simulated function OnConfirmStripGear(EUIAction eAction){}
simulated function OnMouseCancel(){}
simulated function OnMouseLaunch(){}
simulated function OnMouseSimMission(){}
simulated function bool OnCancel(optional string strOption){}
simulated function bool OnOption(optional string Str){}
simulated function RealizeSelected(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function Show(){}
simulated function Remove(){}
simulated function UpdateObjective(){}
simulated function AS_UpdateObjective(string Title, string Body){}
simulated function AS_SetStripGearButton(string Label, string Icon){}
