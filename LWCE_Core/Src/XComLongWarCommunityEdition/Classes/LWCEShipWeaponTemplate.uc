class LWCEShipWeaponTemplate extends LWCEItemTemplate;

var config int iDamage; // Base damage of the weapon.

var config int iArmorPen; // Amount of armor penetrated by this weapon.

var config int iHitChance; // Base hit chance for this weapon in a Balanced engagement.

var config int iRange; // TODO: usage unclear

var config float fFiringTime; // Time in seconds required between shots.

var config int iFirestormArmingTimeHours; // Time in hours to arm a Firestorm with this weapon.

var config int iInterceptorArmingTimeHours; // Time in hours to arm an Interceptor with this weapon.

var config bool bCanEquipOnFirestorm; // Whether this weapon can be armed on a Firestorm.

var config bool bCanEquipOnInterceptor; // Whether this weapon can be armed on an Interceptor.

var config float fArtifactRecoveryBonus; // How much of a boost in recovered artifacts is granted when a UFO is shot down using this
                                         // weapon. This is a flat additive percentage; for example, if the base recovery percentage
                                         // is 30% and this value is 20, the final recovery percentage is 50%.

function bool IsShipWeapon()
{
    return true;
}