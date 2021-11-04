class XComUIBroadcastWorldMessage_DamageDisplay extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EUIBWMDamageDisplayType
{
    eUIBWMDamageDisplayType_Miss,
    eUIBWMDamageDisplayType_Hit,
    eUIBWMDamageDisplayType_CriticalHit,
    eUIBWMDamageDisplayType_MAX
};

struct XComUIBroadcastWorldMessageData_DamageDisplay extends XComUIBroadcastWorldMessageData
{
    var EUIBWMDamageDisplayType m_eDamageType;
    var int m_iActualDamage;
};

var repnotify XComUIBroadcastWorldMessageData_DamageDisplay m_kMessageData_DamageDisplay;
var bool m_bMessageDisplayed_DamageDisplay;

replication
{
	if(bNetInitial && Role == ROLE_Authority)
		m_kMessageData_DamageDisplay;
}

simulated event ReplicatedEvent(name VarName){}
function Init_DisplayDamage(EUIBWMDamageDisplayType eDamageType, Vector vLocation, int iActualDamage, ETeam eBroadcastToTeams){}

