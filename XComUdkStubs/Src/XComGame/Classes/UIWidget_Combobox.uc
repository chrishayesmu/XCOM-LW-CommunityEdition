class UIWidget_Combobox extends UIWidget
    native(UI);

var array<string> arrLabels;
var array<int> arrValues;
var int iCurrentSelection;
var int iBoxSelection;
var bool m_bComboBoxHasFocus;

defaultproperties
{
    iCurrentSelection=-1
    iBoxSelection=-1
    eType=1
}