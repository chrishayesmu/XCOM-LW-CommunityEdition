class XComUIBroadcastMessage extends XComUIBroadcastMessageBase
    abstract
    notplaceable
    hidecategories(Navigation);
//complete stub

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

simulated event ReplicatedEvent(name VarName){}
function Init(string sMsg, UIMessageMgrBase.EUIIcon iIcon, UIMessageMgr.EUIPulse iPulse, float fTime, string Id, ETeam eBroadcastToTeams){}
