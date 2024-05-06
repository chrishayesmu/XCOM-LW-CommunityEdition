class UIProtoWidget_Rect extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);

var UIProtoWidget_Line m_kTopBorder;
var UIProtoWidget_Line m_kBottomBorder;
var UIProtoWidget_Line m_kLeftBorder;
var UIProtoWidget_Line m_kRightBorder;
var protected float m_fTop;
var protected float m_fBottom;
var protected float m_fLeft;
var protected float m_fRight;

defaultproperties
{
    m_kColor=(R=0,G=255,B=255,A=255)
}