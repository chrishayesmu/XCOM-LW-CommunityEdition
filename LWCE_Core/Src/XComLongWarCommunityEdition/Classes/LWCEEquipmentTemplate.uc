/// <summary>
/// Template for an item which can be equipped to a soldier (including MECs and SHIVs). Should not be used for other types of
/// equipment, such as Interceptor weapons, which have their own type which doesn't derive from this one.
/// </summary>
class LWCEEquipmentTemplate extends LWCEItemTemplate
    abstract;

/** TODO decide on this
var config name nmEquipCategory;                      // The equipment category that this item falls into. Classes can define what weapons, armor, and small items
                                                      // they can use based on category. Base LWCE values include:
                                                      //   For armor - InfArmor, MecArmor, PsiArmor
                                                      //   For weapons - InfCarbine, InfRifle, InfRocketLauncher, InfSMG, MecWeapon, ShivWeapon
                                                      //   For small items -
 */

var config bool bIsUniqueEquip;                        // If true, soldiers can only have one of this item equipped.

var config array<name> arrMutuallyExclusiveEquipment;  // An array of items that cannot be equipped at the same time as this item,
                                                       // such as how Drum Mags and Hi Cap Mags can't be equipped together.

var config array<name> arrCompatibleEquipment;         // If this array is populated, then this item can only be equipped if one of
                                                       // the items in this array is equipped.

var config array<name> arrIncompatibleEquipment;       // If this array is populated, then this item cannot be equipped if any of
                                                       // the items in this array is equipped.

var config array<name> arrAbilities;                   // When equipped, this item grants its holder all of the abilities listed here.

var config array<name> arrPerks;                       // When equipped, this item grants its holder all of the perks listed here.

var config int iMaxChanceToBeDamaged;                  // The maximum chance for this item to be damaged if its wearer is injured. The max chance is applied if the wearer is reduced
                                                       // to 0 HP, and scales linearly for other HP values. If zero, or if the corresponding item is infinite, it cannot be damaged.
                                                       // This is a percentage, so it should be in the range 0 to 100, inclusive.

var config int iSize;                                  // An item's size determines where it can be equipped. Primary weapons, rocket launchers, and MEC secondary weapons are size 1.
                                                       // Sidearms (pistols, sawed-off shotgun, etc) and small items such as SCOPEs are size 0. Armor doesn't need to bother setting this.

var config LWCE_Vector3Int vModelScale;                // The scale to apply to the item's model, in each direction. Each value is specified as a percentage, so a value of 100 will
                                                       // not scale the model at all. The X direction is generally along the barrel of the weapon, but note that the orientation of
                                                       // the axes may depend on the specific model, so be sure to test accordingly.

var config LWCE_TCharacterStats kStatChanges;          // The change in the wielder's stats from equipping this item. For primary or secondary weapons, the stat changes only apply
                                                       // to shots taken with that weapon (for offensive stats). For small items, offensive stat changes do not apply to sidearms
                                                       // (but can apply to rocket launchers).

var delegate<ModifyStatChanges> ModifyStatChangesFn;   // If set, this function will be called when determining the stats applied by this equipment, allowing for dynamic stat values
                                                       // (e.g. for bonuses from Foundry projects, or bonuses that depend on the character's other stats).

var config int iClipSize;                              // Clip size for this item. For primary/secondary weapons, this is the amount of ammo that can be used before needing to
                                                       // reload. For small items and armor, this is the number of charges for abilities associated with the item. Ex: on a Medikit,
                                                       // this is the number of uses per medikit, shared across Heal/Revive/Stabilize.

var config bool bLoadoutScreenFanoutPerCharge;         // If true, when equipping this item in the lockers, the item image will "fan out" to however many charges the soldier has while
                                                       // using the item (e.g. how  HE Grenades will show 2 grenade images if the soldier has Grenadier). If false, always shows a single image.

var config int iWeaponFragmentsWhenDestroyed;          // How many weapon fragments this item is worth when an enemy who has it equipped is killed. This will be multiplied by the appropriate
                                                       // FragmentBalance value for the player's difficulty, and that value is then floored. Note that if you set this to a positive value, then
                                                       // the item will always be worth at least 1 fragment, even if the math above would otherwise make it worth 0.

var config name nmRecoveredItem;                       // If set, then when an enemy unit with this item equipped is stunned, the item specified in nmRecoveredItem will be recovered
                                                       // with the captive and returned to XCOM HQ. NOTE: you must set this even if the name is the same as the item itself! Items without
                                                       // this field set will not be recovered.

var config string Archetype;                           // The archetype to create new instances of when an actor is needed for this equipment.

var delegate<GetBonusWeaponAmmo> GetBonusWeaponAmmoFn; // If set, this function will be called when setting unit ammo/charges for this item. The return value is added to the base charges.

delegate int GetBonusWeaponAmmo(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kCharacter);

/// <summary>
/// Called to dynamically alter what stats are provided by this item. Note that kStatChanges will already include the item's baseline stats
/// when this is called, so be sure not to accidentally add them again.
/// </summary>
delegate ModifyStatChanges(const LWCEEquipmentTemplate kEquipment, out LWCE_TCharacterStats kStatChangesOut, const LWCE_TCharacter kCharacter);

function int GetClipSize(optional const LWCE_TCharacter kCharacter)
{
    local int iResult;

    iResult = iClipSize;

    if (GetBonusWeaponAmmoFn != none)
    {
        iResult += GetBonusWeaponAmmoFn(self, kCharacter);
    }

    return iResult;
}

function GetStatChanges(out LWCE_TCharacterStats kStatChangesOut, optional const LWCE_TCharacter kCharacter)
{
    kStatChangesOut = kStatChanges;

    if (ModifyStatChangesFn != none)
    {
        ModifyStatChangesFn(self, kStatChangesOut, kCharacter);
    }
}

function bool HasAbility(name AbilityName)
{
    return arrAbilities.Find(AbilityName) != INDEX_NONE;
}

function bool HasPerk(name PerkName)
{
    return arrPerks.Find(PerkName) != INDEX_NONE;
}

function bool IsEquipment()
{
    return true;
}