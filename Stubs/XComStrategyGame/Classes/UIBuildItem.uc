class UIBuildItem extends UI_FxsScreen
	dependsOn(XGStrategyActor)
    implements(IScreenMgrInterface);
//complete stub
struct UIOption
{
    var int iIndex;
    var string strLabel;
    var int iQuantity;
    var int iState;
    var string strHelp;
};

var const localized string m_strItemLabel;
var const localized string m_strQuantityLabel;
var const localized string m_strConfirm;
var const localized string m_strDetailLabel;
var string m_strCameraTag;
var name DisplayTag;
var int m_iCurrentSelection;
var array<UIOption> m_arrUIOptions;
var int m_iView;
var bool m_bSetCancelDisabled;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGEngineeringUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function UpdateLayout(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
final simulated function RealizeSelected(){}
final simulated function UpdateItemDesc(TObjectSummary kSummary){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function UnlockItems(array<TItemUnlock> arrUnlocks){};
function UnlockItem(TItemUnlock kUnlock);
simulated function OnMouseAccept(){}
simulated function AS_SetSelectedCategory(int iSelectedCategoryIndex){}
simulated function AS_SetTabState(int iIndex, int iState){}
simulated function AS_SetLabels(string displayString, string itemLabel, string quantityLabel){}
final simulated function AS_AddOption(int iIndex, string sLabel, bool IsDisabled, int iQuantity){}
final simulated function AS_UpdateInfo(string techName, string infoText, string descText, string imgPath){}
final simulated function AS_SetFocus(string Id){}
final simulated function AS_SetConfirmButton(string Desc){}
