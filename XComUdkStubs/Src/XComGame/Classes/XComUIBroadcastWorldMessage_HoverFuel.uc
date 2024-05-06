class XComUIBroadcastWorldMessage_HoverFuel extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_HoverFuel extends XComUIBroadcastWorldMessageData
{
    var int m_iCurrentFuel;
    var int m_iMaxFuel;
    var XGTacticalGameCore.EExpandedLocalizedStrings m_eHoverFuelString;
};

var private repnotify XComUIBroadcastWorldMessageData_HoverFuel m_kMessageData_HoverFuel;
var private bool m_bMessageDisplayed_HoverFuel;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}