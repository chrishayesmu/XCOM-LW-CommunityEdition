class UIProtoWidget_Menu extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);

var protected float m_fMenuItemOffset;
var protected array<UIProtoWidget_Text> m_arrItems;
var protected array<UIProtoScreen.EMenuStates> m_arrItemStates;
var protected bool m_bUniformWidth;
var protected bool m_bCanScroll;
var private bool m_bUpdatePending;
var protected int m_iFontSize;
var protected float m_fOptionWidth;
var protected int m_iCurrentSelection;
var protected int m_iNumVisibleOptions;
var protected int m_iScrollIndex;
var protected Color m_clrText;
var protected UIProtoWidget_Image m_kImage_ArrowUp;
var protected UIProtoWidget_Image m_kImage_ArrowDown;

defaultproperties
{
    m_fMenuItemOffset=0.0750
    m_bUniformWidth=true
    m_iFontSize=16
    m_fOptionWidth=0.20
    m_clrText=(R=255,G=255,B=255,A=255)
    m_x=0.250
    m_y=0.250
    m_kColor=(R=0,G=255,B=255,A=175)
    s_name="MenuDefault"
}