class XComUIBroadcastMessage_UnitBleedingOut extends XComUIBroadcastMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastMessageData_UnitBleedingOut extends XComUIBroadcastMessageData
{
    var XGTacticalGameCore.EExpandedLocalizedStrings m_eExpandedLocalizedStringIndex;
    var XGUnit m_kUnit;
    var int m_iCriticalWoundCounter;
};

var private repnotify XComUIBroadcastMessageData_UnitBleedingOut m_kMessageData_UnitBleedingOut;
var private bool m_bMessageDisplayed_UnitBleedingOut;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}