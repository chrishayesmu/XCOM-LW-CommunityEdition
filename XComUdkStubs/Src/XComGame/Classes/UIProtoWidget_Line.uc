class UIProtoWidget_Line extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);

var protected float m_fx1;
var protected float m_fy1;
var protected float m_fx2;
var protected float m_fy2;
var protected int m_iLineWidth;

defaultproperties
{
    m_fx1=0.10
    m_fy1=0.10
    m_fx2=0.10
    m_fy2=0.10
    m_iLineWidth=3
    m_kColor=(R=0,G=255,B=255,A=255)
}