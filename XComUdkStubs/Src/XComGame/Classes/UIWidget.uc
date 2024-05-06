class UIWidget extends Object
    native(UI);

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

delegate del_OnValueChanged()
{
}

defaultproperties
{
    strTitle="Unset Widget Name"
    bIsActive=true
}