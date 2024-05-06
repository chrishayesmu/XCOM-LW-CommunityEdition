class XComUIBroadcastWorldMessage_AbilityTargetMessage extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_AbilityTargetMessageData extends XComUIBroadcastWorldMessageData
{
    var XGAbility m_kAbility;
};

var private repnotify XComUIBroadcastWorldMessageData_AbilityTargetMessageData m_kMessageData_AbilityTargetMessage;
var private bool m_bMessageDisplayed_AbilityTargetMessage;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}