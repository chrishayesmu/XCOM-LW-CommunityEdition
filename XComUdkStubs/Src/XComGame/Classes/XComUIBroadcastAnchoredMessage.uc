class XComUIBroadcastAnchoredMessage extends XComUIBroadcastMessageBase
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastAnchoredMessageData
{
    var string m_sMsg;
    var float m_xLoc;
    var float m_yLoc;
    var UIAnchoredMessageMgr.EUIAnchor m_eAnchor;
    var float m_fDisplayTime;
    var string m_sId;
    var UIMessageMgrBase.EUIIcon m_eIcon;
};

var private repnotify XComUIBroadcastAnchoredMessageData m_kMessageData;
var private bool m_bMessageDisplayed;