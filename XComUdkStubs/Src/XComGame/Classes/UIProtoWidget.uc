class UIProtoWidget extends UI_FxsPanel
    abstract
    notplaceable
    hidecategories(Navigation);

var protected string m_strGroup;
var protected bool m_bIdSet;
var protected bool m_bCenterHorizontal;
var protected bool m_bCenterVertical;
var protected bool m_bImmediateUpdate;
var protected float m_x;
var protected float m_y;
var protected Color m_kColor;

defaultproperties
{
    m_bImmediateUpdate=true
    m_kColor=(R=255,G=255,B=255,A=255)
    s_name="<UIProtoWidget name NOT SET>"
}