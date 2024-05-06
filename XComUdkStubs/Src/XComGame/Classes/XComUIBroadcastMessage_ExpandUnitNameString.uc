class XComUIBroadcastMessage_ExpandUnitNameString extends XComUIBroadcastMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastMessageData_ExpandUnitNameString extends XComUIBroadcastMessageData
{
    var EExpandedLocalizedStrings m_eExpandedLocalizedStringIndex;
    var XGUnit m_kUnit;
};

var private repnotify XComUIBroadcastMessageData_ExpandUnitNameString m_kMessageData_ExpandUnitNameString;
var private bool m_bMessageDisplayed_ExpandUnitNameString;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}