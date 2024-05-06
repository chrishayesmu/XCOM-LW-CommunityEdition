class XComUIBroadcastWorldMessage_DamageDisplay extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

enum EUIBWMDamageDisplayType
{
    eUIBWMDamageDisplayType_Miss,
    eUIBWMDamageDisplayType_Hit,
    eUIBWMDamageDisplayType_CriticalHit,
    eUIBWMDamageDisplayType_MAX
};

struct XComUIBroadcastWorldMessageData_DamageDisplay extends XComUIBroadcastWorldMessageData
{
    var XComUIBroadcastWorldMessage_DamageDisplay.EUIBWMDamageDisplayType m_eDamageType;
    var int m_iActualDamage;
};

var private repnotify XComUIBroadcastWorldMessageData_DamageDisplay m_kMessageData_DamageDisplay;
var private bool m_bMessageDisplayed_DamageDisplay;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}