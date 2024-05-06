class XComUIBroadcastWorldMessage extends XComUIBroadcastMessageBase
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData
{
    var Vector m_vLocation;
    var string m_strMessage;
    var EWidgetColor m_eColor;
    var int m_eBehavior;
    var bool m_bUseScreenLocationParam;
    var Vector2D m_vScreenLocationParam;
    var float m_fDisplayTime;
};

var private repnotify XComUIBroadcastWorldMessageData m_kMessageData;
var private bool m_bMessageDisplayed;
var bool m_bReplicateBaseMessageData;

defaultproperties
{
    m_bReplicateBaseMessageData=true
}