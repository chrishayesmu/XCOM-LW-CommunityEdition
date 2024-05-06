class XComUIBroadcastWorldMessage_WeaponOverheated extends XComUIBroadcastWorldMessage
    notplaceable
    hidecategories(Navigation);

struct XComUIBroadcastWorldMessageData_WeaponOverheated extends XComUIBroadcastWorldMessageData
{
    var XGWeapon m_kWeapon;
};

var private repnotify XComUIBroadcastWorldMessageData_WeaponOverheated m_kMessageData_WeaponOverheated;
var private bool m_bMessageDisplayed_WeaponOverheated;

defaultproperties
{
    m_bReplicateBaseMessageData=false
}