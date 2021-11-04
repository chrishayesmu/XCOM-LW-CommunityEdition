class UIFoundry extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var const localized string m_strConfirm;
var const localized string m_strNoProjectAvailable;
var string m_strCameraTag;
var name DisplayTag;
var array<UIOption> m_arrUIOptions;
var int m_iCurrentSelection;
var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGFoundryUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function RealizeAvailableProjects(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function bool OnOption(optional string Str){}
simulated function bool OnAlternateOption(){}
simulated function RealizeSelected(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Remove(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function AS_SetLabels(string displayString, string itemLabel, string quantityLabel){}
simulated function AS_UpdateInfo(string techName, string infoText, string descText, string imgPath){}
simulated function AS_ShowNoProjectMessage(string Text){}
simulated function AS_SetSelectedCategory(int iSelectedCategoryIndex){}
simulated function AS_SetTabState(int iIndex, int iState){}
simulated function AS_UpdateResources(string label0, string value0, string label1, string Value1, string label2, string Value2){}
simulated function AS_SetFocus(string Id){}
simulated function AS_AddOption(int iIndex, string sLabel, bool IsDisabled, int iQuantity){}
simulated function AS_SetConfirmButton(string Desc){}
event Destroyed(){}
