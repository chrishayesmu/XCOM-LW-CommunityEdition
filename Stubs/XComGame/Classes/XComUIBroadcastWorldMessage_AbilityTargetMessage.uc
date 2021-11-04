class XComUIBroadcastWorldMessage_AbilityTargetMessage extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);
//complete stub

struct XComUIBroadcastWorldMessageData_AbilityTargetMessageData extends XComUIBroadcastWorldMessageData
{
    var XGAbility m_kAbility;
};

var repnotify XComUIBroadcastWorldMessageData_AbilityTargetMessageData m_kMessageData_AbilityTargetMessage;
var bool m_bMessageDisplayed_AbilityTargetMessage;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kMessageData_AbilityTargetMessage;
}

simulated event ReplicatedEvent(name VarName){}
function Init_AbilityTargetMessage(XGAbility kAbility, Vector vLocation, EWidgetColor eColor, ETeam eBroadcastToTeams){}
