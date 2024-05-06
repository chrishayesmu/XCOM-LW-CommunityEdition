class XComUIBroadcastMessage extends XComUIBroadcastMessageBase
    abstract
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastMessageData
{
    var string m_sMsg;
    var UIMessageMgrBase.EUIIcon m_iIcon;
    var UIMessageMgr.EUIPulse m_iPulse;
    var float m_fTime;
    var string m_id;
};

var private repnotify XComUIBroadcastMessageData m_kMessageData;
var private bool m_bMessageDisplayed;
var bool m_bReplicateBaseMessageData;

defaultproperties
{
    m_bReplicateBaseMessageData=true
}