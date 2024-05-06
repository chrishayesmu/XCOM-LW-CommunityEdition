class UIProtoWidget_BarGraph extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);

var protected float m_fWidth;
var protected float m_fHeight;
var protected float m_fPercentage;
var UIProtoWidget_Panel m_kBGBar;
var UIProtoWidget_Panel m_kValueBar;
var UIProtoWidget_Text m_txtLabel;
var UIProtoWidget_Text m_txtValue;
var protected string m_strLabel;
var protected string m_strValue;

defaultproperties
{
    m_fWidth=0.20
    m_fHeight=0.0250
    m_kColor=(R=0,G=255,B=255,A=150)
}