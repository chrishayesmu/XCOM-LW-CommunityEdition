class UIWidget_Slider extends UIWidget;

var int iValue;
var int iStepSize;

delegate del_OnIncrease()
{
}

delegate del_OnDecrease()
{
}

delegate del_OnValueChanged()
{
}

defaultproperties
{
    iValue=-1
    iStepSize=10
    eType=5
}