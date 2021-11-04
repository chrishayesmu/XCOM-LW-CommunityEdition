class UISoldierSlots extends UI_FxsShellScreen;
//complete stub

enum UISlotOptionCategories
{
    eSOCat_Name,
    eSOCat_Status,
    eSOCat_ButtonLabel,
    eSOCat_MAX
};

struct UISlotOption
{
    var int iIndex;
    var string strName;
    var string strStatus;
    var string strButtonLabel;
    var bool IsDisabled;
};

var name DisplayTag;
var string m_strCameraTag;
var const localized string m_strSoldierSlotBaseStatusLabel;
var protected int m_iCurrentSelection;
var protected int m_iNumAvailableSlots;
var protected array<UISlotOption> m_arrUIOptions;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string SelectedIndex)
{}
simulated function bool OnCancel(optional string SelectedIndex){}
simulated function bool RealizeSelected(){}
simulated function ShowBackButton(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}

simulated function UpdateDataFromGame(TTableMenu kTable){}
final simulated function UpdateDisplay(){}
private final simulated function AS_ClearSoldiers(){}
private final simulated function AS_AddSlot(string _name, string _status, string _buttonLabel, bool IsDisabled){}
private final simulated function AS_AddEmptySlot(string _slotLabel, string _buttonLabel){}
protected simulated function AS_SetTitleLabels(string _titleLabel, string _statusLabel){}
simulated function AS_SetSelected(string Id){}
simulated function Hide(){}
simulated function Show(){}

