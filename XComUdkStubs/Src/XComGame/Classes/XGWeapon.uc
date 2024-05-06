class XGWeapon extends XGInventoryItem
    native(Weapon)
    notplaceable
    hidecategories(Navigation);

const NUM_WEAP_ABILITIES = 8;

struct CheckpointRecord_XGWeapon extends CheckpointRecord_XGInventoryItem
{
    var int iAmmo;
    var int m_iTurnFired;
};

var int iAmmo;
var int iOverheatChance;
var int m_iTurnFired;
var bool bIsFixedRange;
var int aAbilities[NUM_WEAP_ABILITIES];
var ECursorType iCursorType;
var const localized string m_strMedikitII;
var const localized string m_strArcThrowerII;
var private repnotify XComWeapon m_kReplicatedWeaponEntity;
var float fFiringRate;
var TWeapon m_kTWeapon;
var name GlamCamTag;

defaultproperties
{
    iAmmo=100
    m_iTurnFired=100
    GlamCamTag=Rifle
}