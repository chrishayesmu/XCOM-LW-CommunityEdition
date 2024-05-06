class UIProtoWidget_Text extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);

var protected string m_strValue;
var protected int m_iSize;
var protected Color m_kBGColor;
var protected float m_fWrapWidth;
var protected float m_fWidth;
var protected float m_fHeight;

defaultproperties
{
    m_iSize=12
    m_fWrapWidth=1.0
    m_fWidth=-1.0
    m_fHeight=-1.0
}