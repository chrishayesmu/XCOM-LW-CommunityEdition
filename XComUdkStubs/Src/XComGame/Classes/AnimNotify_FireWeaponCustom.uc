class AnimNotify_FireWeaponCustom extends AnimNotify_FireWeapon
    native(Animation)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() bool bDoDamage;
var() int TemplateIndex;
var() int WeaponIndex;
var() name WeaponSocketName;
var() int PerkIndex;

defaultproperties
{
    WeaponSocketName=gun_fire
}