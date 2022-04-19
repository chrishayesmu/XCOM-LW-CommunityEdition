class XComUIBroadcastWorldMessage_UnitReflectedAttack extends XComUIBroadcastWorldMessage;

struct XComUIBroadcastWorldMessageData_UnitReflectedAttack extends XComUIBroadcastWorldMessageData
{
    var XGUnit m_kUnit;
};

var repnotify XComUIBroadcastWorldMessageData_UnitReflectedAttack m_kMessageData_UnitReflectedAttack;
var bool m_bMessageDisplayed_UnitReflectedAttack;

simulated event ReplicatedEvent(name VarName){}
function Init_UnitReflectedAttack(XGUnit kUnit, Vector vLocation, EWidgetColor eColor, ETeam eBroadcastToTeams){}