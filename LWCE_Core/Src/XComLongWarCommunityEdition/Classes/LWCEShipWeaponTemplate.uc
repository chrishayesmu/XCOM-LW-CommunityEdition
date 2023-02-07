class LWCEShipWeaponTemplate extends LWCEItemTemplate;

enum EEngagementRange
{
    eER_Short,
    eER_Long
};

// IMPORTANT: the projectile type is used by the UIInterceptionEngagement Flash movie to know what
// image to display. These values are just a renamed version of EShipWeapon. Reordering or modifying
// them will break the interception UI!
enum EProjectileType
{
    ePT_None,
    ePT_Cannon,
    ePT_Stingray,
    ePT_Avalanche,
    ePT_Laser,
    ePT_Plasma,
    ePT_EMP,
    ePT_Fusion,
    ePT_UFOPlasmaI,
    ePT_UFOPlasmaII,
    ePT_UFOFusionI
};

var config int iDamage; // Base damage of the weapon.

var config int iArmorPen; // Amount of armor penetrated by this weapon.

var config int iHitChance; // Base hit chance for this weapon in a Balanced engagement.

var config int iRange; // TODO: usage unclear

var config float fFiringTime; // Time in seconds required between shots.

var config EEngagementRange eEngagementDistance; // The distance this weapon can be fired at. Short range weapons cause the ship to
                                                 // close distance with the opponent. This is purely visual and has no effect on the
                                                 // outcome of the interception.

var config int iFirestormArmingTimeHours; // Time in hours to arm a Firestorm with this weapon.

var config int iInterceptorArmingTimeHours; // Time in hours to arm an Interceptor with this weapon.

var config bool bCanEquipOnFirestorm; // Whether this weapon can be armed on a Firestorm.

var config bool bCanEquipOnInterceptor; // Whether this weapon can be armed on an Interceptor.

var config float fArtifactRecoveryBonus; // How much of a boost in recovered artifacts is granted when a UFO is shot down using this
                                         // weapon. This is a flat additive percentage; for example, if the base recovery percentage
                                         // is 30% and this value is 20, the final recovery percentage is 50%. Total recovery percentage
                                         // is capped at 100%.

var config EProjectileType eProjectile; // What projectile to display during an interception when this weapon fires. Also determines the
                                        // accompanying sound effect.

var array< delegate<ArmorPenModifierDel> > arrArmorPenModifiers;
var array< delegate<DamageModifierDel> > arrDamageModifiers;
var array< delegate<FiringTimeModifierDel> > arrFiringTimeModifiers;
var array< delegate<HitChanceModifierDel> > arrHitChanceModifiers;

delegate int ArmorPenModifierDel(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue);
delegate int DamageModifierDel(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue);
delegate float FiringTimeModifierDel(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, float iCurrentValue);
delegate int HitChanceModifierDel(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue);

// TODO: add more hooks to allow for dynamically adjusting the remaining stats

function int GetArmorPen(XGShip kShip, bool bShipIsXCom)
{
    local int iResult;
    local delegate<ArmorPenModifierDel> delModifier;

    iResult = iArmorPen;

    foreach arrArmorPenModifiers(delModifier)
    {
        iResult += delModifier(self, kShip, bShipIsXCom, iResult);
    }

    return iResult;
}

function int GetDamage(XGShip kShip, bool bShipIsXCom)
{
    local int iResult;
    local delegate<DamageModifierDel> delModifier;

    iResult = iDamage;

    foreach arrDamageModifiers(delModifier)
    {
        iResult += delModifier(self, kShip, bShipIsXCom, iResult);
    }

    return iResult;
}

function float GetFiringTime(XGShip kShip, bool bShipIsXCom)
{
    local float fResult;
    local delegate<FiringTimeModifierDel> delModifier;

    fResult = fFiringTime;

    foreach arrFiringTimeModifiers(delModifier)
    {
        fResult += delModifier(self, kShip, bShipIsXCom, fResult);
    }

    return fResult;
}

function int GetHitChance(XGShip kShip, bool bShipIsXCom)
{
    local int iResult;
    local delegate<HitChanceModifierDel> delModifier;

    iResult = iHitChance;

    foreach arrHitChanceModifiers(delModifier)
    {
        iResult += delModifier(self, kShip, bShipIsXCom, iResult);
    }

    return iResult;
}

function bool IsShipWeapon()
{
    return true;
}