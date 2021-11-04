class UIWidget extends Object
    native(UI);
//complete  stub
enum UIWidgetType
{
    eWidget_Invalid,
    eWidget_Combobox,
    eWidget_Button,
    eWidget_List,
    eWidget_Spinner,
    eWidget_Slider,
    eWidget_Checkbox,
    eWidget_MAX
};

var string strTitle;
var int eType;
var bool bIsActive;
var bool bIsDisabled;
var bool bReadOnly;
//var delegate<del_OnValueChanged> __del_OnValueChanged__Delegate; COPIED TO CHILD CLASSES CAUSE HANGS THE COMPILER
//delegate del_OnSelectionChanged(int iSelected);
delegate del_OnValueChanged();

