class XComUIBroadcastWorldMessage extends XComUIBroadcastMessageBase;
//complete stub

struct XComUIBroadcastWorldMessageData
{
    var Vector m_vLocation;
    var string m_strMessage;
    var UI_FxsPanel.EWidgetColor m_eColor;
    var int m_eBehavior;
    var bool m_bUseScreenLocationParam;
    var Vector2D m_vScreenLocationParam;
    var float m_fDisplayTime;
};
var private repnotify XComUIBroadcastWorldMessageData m_kMessageData;
var private bool m_bMessageDisplayed;
var bool m_bReplicateBaseMessageData;

replication
{
    if((m_bReplicateBaseMessageData && bNetInitial) && Role == ROLE_Authority)
        m_kMessageData;
}

simulated event ReplicatedEvent(name VarName){}
function Init(Vector vLocation, string strMessage, EWidgetColor eColor, int EBehavior, bool bUseScreenLocationParam, Vector2D vScreenLocationParam, float fDisplayTime, ETeam eBroadcastToTeams){}
