class UIMessageMgr extends UIMessageMgrBase
    native(UI)
    notplaceable
    hidecategories(Navigation);

enum EUIPulse
{
    ePulse_None,
    ePulse_Cyan,
    ePulse_Blue,
    ePulse_Red,
    ePulse_MAX
};

var UIMessageMgr_Container m_MessageContainer;
var private int defaultMessageID;
var UI_FxsMessageBox m_kEndTurnMessage;

defaultproperties
{
    s_package="/ package/gfxMessageMgr/MessageMgr"
    s_screenId="gfxMessageMgr"
    s_name="theMessageContainer"
}