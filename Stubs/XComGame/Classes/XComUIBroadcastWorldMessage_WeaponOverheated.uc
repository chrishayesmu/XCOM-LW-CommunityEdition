class XComUIBroadcastWorldMessage_WeaponOverheated extends XComUIBroadcastWorldMessage;
//complete stub

struct XComUIBroadcastWorldMessageData_WeaponOverheated extends XComUIBroadcastWorldMessageData
{
    var XGWeapon m_kWeapon;
};

var private repnotify XComUIBroadcastWorldMessageData_WeaponOverheated m_kMessageData_WeaponOverheated;
var private bool m_bMessageDisplayed_WeaponOverheated;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kMessageData_WeaponOverheated;
}

simulated event ReplicatedEvent(name VarName){}

function Init_WeaponOverheated(XGWeapon kWeapon, Vector vLocation, UI_FxsPanel.EWidgetColor eColor, Object.ETeam eBroadcastToTeams) {}


