class UIGreyMarket extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var int m_iView;
var int m_iNumUIItems;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGGreyMarketUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function UpdateData(){}
function RealizeSelected(){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_AddItem(int Index, string STORAGE, string DisplayName, string price, string sell, string total, int iState, bool bEnableSpinnerArrows){}
simulated function AS_SetHeader(int Index, string displayString){}
simulated function AS_SetListSelection(int Index){}
simulated function AS_UpdateInfo(string Desc, string imagePath){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function GoToView(int iView){}
simulated function OnAcceptClick(){}
simulated function bool OnAccept(optional string Str){}
simulated function OnCancelClick(){}
simulated function bool OnCancel(optional string Str){}
simulated function Remove(){}
simulated function ShowButtonHelp(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
