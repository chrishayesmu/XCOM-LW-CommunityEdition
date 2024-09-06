class XComUIBroadcastWorldMessage_UnexpandedLocalizedString extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_UnexpandedLocalizedString extends XComUIBroadcastWorldMessageData
{
    var XGTacticalGameCore.EUnexpandedLocalizedStrings m_eUnexpandedLocalizedStringIndex;
};

var private repnotify XComUIBroadcastWorldMessageData_UnexpandedLocalizedString m_kMessageData_UnexpandedLocalizedString;
var private bool m_bMessageDisplayed_UnexpandedLocalizedString;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}