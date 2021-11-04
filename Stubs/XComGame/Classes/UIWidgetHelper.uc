class UIWidgetHelper extends Actor
    notplaceable
    hidecategories(Navigation);
//complete stub

const INCREASE_VALUE = -1;
const DECREASE_VALUE = -2;

enum EUINavDirection
{
    eNavDir_None,
    eNavDir_Down,
    eNavDir_Up,
    eNavDir_MAX
};

var array<UIWidget> m_arrWidgets;
var int m_iCurrentWidget;
var string s_widgetName;
var string s_name;
var EUINavDirection m_eDirection;

simulated function bool OnUnrealCommand(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_Combobox(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_Button(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_Spinner(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_Slider(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_Checkbox(int Cmd, int Arg){}
final simulated function bool OnUnrealCommand_List(int Cmd, int Arg){}
function SelectNextAvailableWidget(){}
function SelectPrevAvailableWidget(){}
simulated function ProcessMouseEvent(int iTargetBox, optional int iTargetOption=-1){}
final simulated function ProcessMouseEvent_Combobox(int iTargetOption){}
final simulated function ProcessMouseEvent_Button(int iTargetBox){}
final simulated function ProcessMouseEvent_Checkbox(int iTargetOption){}
final simulated function ProcessMouseEvent_List(int iTargetOption){}
final simulated function ProcessMouseEvent_Spinner(int iTargetBox){}
final simulated function ProcessMouseEvent_Slider(int iValue){}
simulated function bool SafetyCheckForActiveWidgets(){}
simulated function RealizeSelected(){}
simulated function Deselect(){}
simulated function int GetCurrentSelection(){}
simulated function int GetCurrentValue(int Index){}
simulated function string GetCurrentValueString(int Index){}
simulated function string GetCurrentLabel(int Index){}
simulated function Clear(){}
simulated function ClearWidget(int Index){}
simulated function int GetNumWidgets(){}
simulated function UIWidget GetCurrentWidget(){}
simulated function SetSelected(int Index){}
simulated function ClearSelection(){}
simulated function UIWidget GetWidget(int Index){}
simulated function SetActive(int Index, bool bIsActive){}
simulated function DisableButton(int Index){}
simulated function EnableButton(int Index){}
simulated function SetReadOnly(int Index, bool bReadOnly){}
simulated function RefreshWidget(int Index){}
simulated function RefreshAllWidgets(){}
simulated function SelectInitialAvailable(){}
simulated function UIWidget_Combobox NewCombobox(){}
final simulated function RefreshComboBox(int Index){}
final simulated function SetComboboxLabel(int Index, string strText){}
final simulated function SetComboboxText(int Index, string strText){}
simulated function SetDropdownOptions(int Index, array<string> arrLabels){}
simulated function SetDropdownSelection(int Index, int iSelection){}
simulated function SetComboboxValue(int Index, int iSelectionIndex){}
simulated function OpenCombobox(int Index){}
simulated function CloseCombobox(int Index){}
simulated function CloseAllComboboxes(){}
simulated function UIWidget_Button NewButton(){}
final simulated function RefreshButton(int Index){}
final simulated function SetButtonLabel(int Index, string strText){}
simulated function UIWidget_Checkbox NewCheckbox(optional int textStyle){}
simulated function ToggleCheckbox(int Index){}
simulated function SetCheckboxValue(int Index, bool bChecked){}
final simulated function RefreshCheckbox(int Index){}
final simulated function AS_SetCheckboxLabel(int Index, string strText){}
final simulated function AS_SetCheckboxValue(int Index, bool bChecked){}
final simulated function AS_SetCheckboxStyle(int Index, int style){}
simulated function UIWidget_List NewList(){}
simulated function SetListOptions(int Index, array<string> arrLabels){}
simulated function SetListSelection(int Index, int iSelection){}
final simulated function RefreshList(int Index){}
simulated function SetListItemText(int iWidgetIndex, int iItemIndex, string displayString){}
simulated function UIWidget_Spinner NewSpinner(){}
simulated function RefreshSpinner(int Index){}
simulated function SetSpinnerLabel(int Index, string strText){}
simulated function SetSpinnerValue(int Index, string StrValue){}
final simulated function SetSpinnerArrows(int Index, bool bCanSpin){}
simulated function UIWidget_Slider NewSlider(){}
simulated function RefreshSlider(int Index){}
final simulated function SetSliderLabel(int Index, string strText){}
final simulated function SetSliderValue(int Index, int iValue){}
final simulated function SetSliderMouseWheelStep(int Index, int iValue){}
simulated function string GetASFuncPath(string func){}


