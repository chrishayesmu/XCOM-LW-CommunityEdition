class UIProtoWidget_Text extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);
//complete stub

var string m_strValue;
var int m_iSize;
var Color m_kBGColor;
var float m_fWrapWidth;
var float m_fWidth;
var float m_fHeight;

simulated function OnInit(){}
function Update(){}
function SetValue(string strNewValue){}
function UpdateTextInWidget(string strNewValue){}
function string GetValue(){}
function SetSize(int iNewSize){}
function int GetSize(){}
function SetBGColor(Color kNewBGColor){}
function SetBGColorFromEnum(UI_FxsPanel.EWidgetColor eColor, optional UI_FxsPanel.EColorShade eShade, optional int Alpha){}
function SetBGAlpha(int Alpha){}
function Color GetBGColor(){}
function SetWrapWidth(float fWrapWidth){}
function float GetWrapWidth(){}
function SetWidth(float fNewWidth){}
function float GetWidth(){}
function SetHeight(float fNewHeight){}
function float GetHeight(){}
