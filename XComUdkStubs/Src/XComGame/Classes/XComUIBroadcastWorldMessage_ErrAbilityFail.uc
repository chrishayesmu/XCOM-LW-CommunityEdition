class XComUIBroadcastWorldMessage_ErrAbilityFail extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_ErrAbilityFail extends XComUIBroadcastWorldMessageData
{
    var XGAbility m_kAbility;
};

var private repnotify XComUIBroadcastWorldMessageData_ErrAbilityFail m_kMessageData_ErrAbilityFail;
var private bool m_bMessageDisplayed_ErrAbilityFail;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}