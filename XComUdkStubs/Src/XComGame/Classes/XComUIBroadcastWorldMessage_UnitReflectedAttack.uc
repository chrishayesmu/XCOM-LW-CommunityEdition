class XComUIBroadcastWorldMessage_UnitReflectedAttack extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_UnitReflectedAttack extends XComUIBroadcastWorldMessageData
{
    var XGUnit m_kUnit;
};

var private repnotify XComUIBroadcastWorldMessageData_UnitReflectedAttack m_kMessageData_UnitReflectedAttack;
var private bool m_bMessageDisplayed_UnitReflectedAttack;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}