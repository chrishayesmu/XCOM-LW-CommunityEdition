class UIOTS extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

struct UIOption
{
    var int iIndex;
    var string strTacticLabel;
    var string strRequirementLabel;
    var int iState;
    var string strHelp;
    var string strImagePath;
    var string strSummaryDescription;
};

var const localized string m_strTactic;
var const localized string m_strCost;
var const localized string m_strPurchaseButtonText_PC;
var const localized string m_strConfirmUpgradeTitle;
var const localized string m_strConfirmUpgradeBody;
var array<UIOption> m_arrUIOptions;
var int m_iCurrentSelection;
var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGOTSUI GetMgr(){}
simulated function OnInit(){}
simulated function DrawHeader(){}
simulated function DrawTable(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string strOption){}
function DisplayConfirmUpgradeDialog(){}
function OnDisplayConfirmUpgradeDialogAction(EUIAction eAction){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function bool OnOption(optional string Str){}
simulated function RealizeSelected(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Remove(){}
simulated function AS_SetTitles(string displayString, string tacticColumnHeader, string requirementItemHeader){}
simulated function AS_SetHelp(string helpText){}
simulated function AS_UpdateInfo(string imagePath, string DescriptionText){}
simulated function AS_SetPurchaseButtonText(string btnText, bool IsDisabled){}
simulated function AS_Clear(){}
simulated function AS_AddOption(int iIndex, string sLabel, string sRequirement, bool IsDisabled){}
simulated function AS_SetListSelection(string Id){}
event Destroyed(){}
