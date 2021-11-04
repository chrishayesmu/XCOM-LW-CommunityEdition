class XComUIBroadcastWorldMessage_UnexpandedLocalizedString extends XComUIBroadcastWorldMessage;
//complete stub

struct XComUIBroadcastWorldMessageData_UnexpandedLocalizedString extends XComUIBroadcastWorldMessageData
{
    var EUnexpandedLocalizedStrings m_eUnexpandedLocalizedStringIndex;
};

var private repnotify XComUIBroadcastWorldMessageData_UnexpandedLocalizedString m_kMessageData_UnexpandedLocalizedString;
var private bool m_bMessageDisplayed_UnexpandedLocalizedString;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kMessageData_UnexpandedLocalizedString;
}

simulated event ReplicatedEvent(name VarName){}

function Init_UnexpandedLocalizedString(int eUnexpandedLocalizedStringIndex, Vector vLocation, UI_FxsPanel.EWidgetColor eColor, Object.ETeam eBroadcastToTeams) {}

DefaultProperties
{
}
