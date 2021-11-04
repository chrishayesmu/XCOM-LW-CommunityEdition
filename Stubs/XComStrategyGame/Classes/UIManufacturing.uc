class UIManufacturing extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var string m_strCameraTag;
var name DisplayTag;
var private UIWidgetHelper m_hWidgetHelper;
var protected int m_iView;
var const localized string m_strBack;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function InitFacility(XComPlayerController _controllerRef, UIFxsMovie _manager, EFacilityType eFacility, int X, int Y, optional int iIndex){}
simulated function InitItem(XComPlayerController _controllerRef, UIFxsMovie _manager, EItemType eItem, int iIndex){}
simulated function InitFoundry(XComPlayerController _controllerRef, UIFxsMovie _manager, int iTech, int iIndex){}
simulated function XGManufacturingUI GetMgr(){}
simulated function OnInit(){}
simulated function InitWidgets(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function RefreshDisplay(){}
simulated function OnIncreaseEngineers(){}
simulated function OnDecreaseEngineers(){}
simulated function OnIncreaseQuantity(){}
simulated function OnDecreaseQuantity(){}
simulated function OnToggleNotify(){}
simulated function OnToggleRush(){}
simulated function GoToView(int iView){}
simulated function DrawItemProject(){}
simulated function DrawFacilityProject(){}
simulated function DrawFoundryProject(){}
simulated function string GetCost(){}
simulated function string GetDuration(){}
simulated function string GetNotes(){}
simulated function string GetImage(){}
simulated function OnSubmit(){}
simulated function OnSubmitTop(){}
simulated function OnDeleteOrder(){}
simulated function OnCancelScreen(){}
simulated function Remove(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_UpdateInfo(string infoText, string descText, string imgPath){}
simulated function AS_SetEngineerLine(string Label, string Value){}
simulated function AS_SetQuantityLine(string Label, string Value, bool isReadOnly){}
