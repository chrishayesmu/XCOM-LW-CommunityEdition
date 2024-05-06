class UIAnchoredMessageMgr extends UIMessageMgrBase
    notplaceable
    hidecategories(Navigation);

enum EUIAnchor
{
    TOP_LEFT,
    TOP_CENTER,
    TOP_RIGHT,
    CENTER_LEFT,
    Center,
    CENTER_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_CENTER,
    BOTTOM_RIGHT,
    EUIAnchor_MAX
};

struct THUDAnchoredMsg
{
    var string m_sId;
    var string m_txtMsg;
    var float m_fX;
    var float m_fY;
    var bool m_bVisible;
    var UIAnchoredMessageMgr.EUIAnchor m_eAnchor;
    var UIMessageMgrBase.EUIIcon m_eIcon;
    var float m_fTime;

    structdefaultproperties
    {
        m_fX=0.10
        m_fY=0.10
        m_fTime=5.0
    }
};

var private int idCounter;
var UIMessageMgr_Container m_MessageContainer;
var array<THUDAnchoredMsg> m_arrMsgs;

defaultproperties
{
    s_package="/ package/gfxAnchoredMessageMgr/AnchoredMessageMgr"
    s_screenId="gfxAnchoredMessageMgr"
    s_name="theAnchoredMessageContainer"
}