class UIWidget_List extends UIWidget;

//complete stub

var array<string> arrLabels;
var array<int> arrValues;
var int iCurrentSelection;
var bool m_bHasFocus;
var bool m_bWrap;

delegate del_OnSelectionChanged(int iSelected)
{
}