class XComUIBroadcastWorldMessage_HoverFuel extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);
//complete stub

struct XComUIBroadcastWorldMessageData_HoverFuel extends XComUIBroadcastWorldMessageData
{
    var int m_iCurrentFuel;
    var int m_iMaxFuel;
    var EExpandedLocalizedStrings m_eHoverFuelString;
};

var repnotify XComUIBroadcastWorldMessageData_HoverFuel m_kMessageData_HoverFuel;
var bool m_bMessageDisplayed_HoverFuel;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kMessageData_HoverFuel;
}

simulated event ReplicatedEvent(name VarName){}
function Init_HoverFuel(EExpandedLocalizedStrings eHoverFuelString, int iCurrentFuel, int iMaxFuel, Vector vLocation, EWidgetColor eColor, ETeam eBroadcastToTeams){}
static final function string GetHoverFuelText(EExpandedLocalizedStrings eHoverFuelString, int iCurrentFuel, int iMaxFuel){}
