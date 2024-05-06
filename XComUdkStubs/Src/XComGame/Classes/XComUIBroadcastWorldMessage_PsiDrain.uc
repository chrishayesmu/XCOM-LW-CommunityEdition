class XComUIBroadcastWorldMessage_PsiDrain extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_PsiDrain extends XComUIBroadcastWorldMessageData
{
    var int m_iHealthDrained;
    var XGTacticalGameCore.EExpandedLocalizedStrings m_ePsiDrainString;
};

var private repnotify XComUIBroadcastWorldMessageData_PsiDrain m_kMessageData_PsiDrain;
var private bool m_bMessageDisplayed_PsiDrain;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}