class UI_FxsMessageBox extends UI_FxsPanel
    dependson(UIMessageMgr, UIMessageMgrBase)
    notplaceable
    hidecategories(Navigation);

var protected string m_strTitle;
var protected EUIPulse m_ePulse;
var protected EUIIcon m_eIcon;
var protected float m_fTime;

defaultproperties
{
    m_strTitle="Generic Title"
    m_eIcon=eIcon_GenericCircle
    m_fTime=5.0
}