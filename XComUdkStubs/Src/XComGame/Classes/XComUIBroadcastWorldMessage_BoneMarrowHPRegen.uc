class XComUIBroadcastWorldMessage_BoneMarrowHPRegen extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_BoneMarrowHPRegen extends XComUIBroadcastWorldMessageData
{
    var int m_iHPRegen;
    var XGTacticalGameCore.EExpandedLocalizedStrings m_eHPRegenString;
};

var private repnotify XComUIBroadcastWorldMessageData_BoneMarrowHPRegen m_kMessageData_BoneMarrowHPRegen;
var private bool m_bMessageDisplayed_BoneMarrowHPRegen;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}