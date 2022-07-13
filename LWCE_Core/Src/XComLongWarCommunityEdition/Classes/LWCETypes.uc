class LWCETypes extends Object;

enum EDataType
{
    eDT_Bool,
    eDT_Int,
    eDT_Name,
    eDT_String
};

/// <summary>A three-dimensional vector of integers.</summary>
struct LWCE_Vector3Int
{
    var int X, Y, Z;
};

/// <summary>A simple key-value pair where both are integers.</summary>
struct LWCE_IntKVP
{
    var int Key;
    var int Value;
};

struct LWCE_TRange
{
    var int MinInclusive;
    var int MaxInclusive;
};

/// <summary>
/// A very generic structure meant to capture the idea of referencing both an object, and that object's source.
/// The exact meaning is context-specific. For example, in an LWCE_TCharacter, this struct is used to identify a perk
/// (the Id field), its source type (class, equipped item, Foundry, etc), and its source's ID (such as item or class ID).
/// Check the documentation where this struct is used to understand its meaning in context, and valid values for the
/// SourceType field.
/// </summary>
struct LWCE_TIDWithSource
{
    var int Id;
    var int SourceId;
    var int SourceType;
};

struct LWCE_TCharacter
{
    var string strName;
    var int iCharacterType; // As in the ECharacter enum
    var TInventory kInventory;

    var array<LWCE_TIDWithSource> arrAbilities;

    // Perks this character has, and where they came from. For the SourceType field, valid values are:
    //     0 - Innate perk (e.g. from promotions, the Foundry, or starting perk for hero units like Zhang)
    //     1 - Perk from an equipped item
    var array<LWCE_TIDWithSource> arrPerks;

    var array<LWCE_TIDWithSource> arrProperties;
    var array<LWCE_TIDWithSource> arrTraversals;

    var int aStats[ECharacterStat];
    var int iBaseClassId; // The first non-rookie class this character had; resets if the character becomes a MEC
    var int iClassId;     // The character's current class
    var bool bHasPsiGift;
    var float fBioElectricParticleScale;
};

struct LWCE_TClassDefinition
{
    var string strName;           // Friendly name for this class to show the player.
    var bool bIsAugmented;        // Whether this class is augmented (i.e. a MEC class).
    var bool bIsBaseClass;        // Whether this is a base class. If so, rookies can be promoted directly into this class. If not, soldiers
                                  // must be assigned this class based on selecting a perk. (Ex: Scout-Sniper is a base class, and soldiers
                                  // are assigned the non-base class Scout when they select the Lightning Reflexes perk.)
    var bool bCanDoCovertOps;     // Whether units of this class are eligible for covert ops duty. MEC soldiers are never eligible, regardless of this
                                  // field. This field is ignored for psionic classes.
    var bool bIsPsionic;          // Whether this is a psionic class or not (a new concept in LWCE).
    var int iSoldierClassId;      // The class ID.
    var int iWeaponType;          // The type of weapon usable by this class.
    var int iAugmentsIntoClassId; // The ID of the MEC class that this class turns into if augmented. If not set, this class cannot be augmented.
                                  // Setting this and bIsAugmented within the same class definition will break things.

    var string IconBase; // Icon without gene mods or psi training.
    var string IconGeneModded;
    var string IconGeneModdedAndPsionic;
    var string IconPsionic;

    var array<string> NicknamesFemale; // Nicknames that can be randomly assigned to female soldiers of this class.
    var array<string> NicknamesMale;   // Nicknames that can be randomly assigned to male soldiers of this class.
};

/// <summary>
/// A single piece of data which can be used in situations where the type and/or quantity of data is not known in
/// advance, such as Geoscape alerts. The ID field can be used to communicate what the data represents, but this is
/// optional, and generally only needed for mod-to-mod communication.
/// </summary>
struct LWCE_TData
{
    var name ID;
    var EDataType eType;
    var bool bData;
    var int iData;
    var name nmData;
    var string strData;
};

struct LWCE_TSoldier
{
    var int iID;
    var string strFirstName;
    var string strLastName;
    var string strNickName;
    var int iRank;
    var int iPsiRank;
    var int iCountry;
    var int iXP;
    var int iPsiXP;
    var int iNumKills;
    var TAppearance kAppearance;
    var int iSoldierClassId;
    var bool bBlueshirt;

    structdefaultproperties
    {
        kAppearance=(iHead=-1,iHaircut=-1,iBody=-1,iBodyMaterial=-1,iSkinColor=-1,iEyeColor=-1,iFlag=-1,iArmorSkin=-1,iVoice=-1,iArmorDeco=-1,iArmorTint=-1)
    }
};

/// <summary>
/// Encapsulates all of the stats which characters have, to make it easier to reuse methods which operate on stats.
/// </summary>
struct LWCE_TCharacterStats
{
    var int iAim;
    var int iBleedoutTurns;
    var int iCriticalChance;
    var int iDamage;
    var float fDamageReduction;
    var int iDefense;
    var int iFlightFuel;
    var int iHP;
    var int iMobility;
    var int iRegen;
    var int iWill;
};

struct LWCE_TItemQuantity
{
    var int iItemId;
    var int iQuantity;
};

/// <summary>
/// Represents a cost paid by the player for building items, researching techs, beginning Foundry projects, etc.
/// </summary>
struct LWCE_TCost
{
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iMeld;
    var int iWeaponFragments;
    var array<LWCE_TItemQuantity> arrItems;

    structdefaultproperties
    {
        iCash=0
        iAlloys=0
        iElerium=0
        iMeld=0
        iWeaponFragments=0
        arrItems=()
    }
};

/// <summary>
/// Represents prerequisites that must be met by the player. Depending on the context of how this struct is used, failing to
/// meet prerequisites might make something completely unknown to the player (such as research techs) or visible but inaccessible.
/// </summary>
struct LWCE_TPrereqs
{
    var array<int> arrFacilityReqs; // A list of facility IDs that must be built. For non-unique facilities, only one needs to be built.
    var array<name> arrFoundryReqs; // A list of foundry project names that must be complete.
    var array<int> arrItemReqs;     // A list of item IDs. The player must have possessed these at one time, but doesn't necessarily need to still have them now.
    var array<name> arrTechReqs;    // A list of research tech names that must be complete.
    var array<int> arrUfoReqs;      // A list of UFO types that must be encountered. A UFO type is considered encountered after a successful assault on a crashed or landed UFO.

    var int iRequiredSoldierRank;   // If set, XCOM must have at least one soldier of this rank or higher.
    var int iTotalSoldierRanks;     // If set, the sum of soldier ranks across XCOM's roster must be at least this value.

    var bool bRequiresAutopsy;       // If true, any autopsy research must be completed.
    var bool bRequiresInterrogation; // If true, any interrogation research must be completed.
};

struct LWCE_TItem
{
    var string strName;           // The player-viewable name of the item (singular).
    var string strNamePlural;     // The player-viewable name of the item (plural).
    var string strBriefSummary;   // A summary of the item to show in the Engineering UI.
    var string strTacticalText;   // Text shown in the detailed view of equipment items. Should be formatted as bullet points to match
                                  // other items. See examples in XComGame.int, in the array m_aItemTacticalText, for the HTML to use.
    var string ImagePath;         // Path to an image to show in the UI for this item. Must include the "img:///" prefix.
                                  // Typical item images are 256x128.

    var int iItemId;              // The integer ID of the item. See README if you don't know how to choose IDs.
    var int iCategory;            // The item's category, corresponding to the enum type EItemCategory.

    var int iHours;               // If >= 0, this is the number of engineer-hours needed to build this item. If < 0, this item cannot be built.
    var int iMaxEngineers;        // The number of engineers required to make progress at normal speed on this project.

    var int iReplacementItemId;  // If > 0, when this item is granted, then the replacement item ID is added to XCOM's stores instead of the actual
                                 // item ID. This can be used to make items buildable in different ways, such as how SHIVs can be built directly,
                                 // or they can be rebuilt using a damaged SHIV chassis. If you're using this field, then you can set strName to
                                 // the name you want to appear in Engineering instead of the replacement item's name.

    // How many of this item XCOM HQ starts the game with. If bIsInfinite is set at the start of the game, this value is ignored.
    var int iStartingQuantity;

    // Whether XCOM's stores of this item are unlimited, such as starting weapons and armor, or Alien Grenades after their Foundry project
    // is complete. If this changes based on the state of the campaign (such as Alien Grenades do), then your mod should use the strategy hook
    // Override_LWCE_GetItem to set this value dynamically. Note that items which are marked as infinite cannot be built in engineering, nor can
    // they be sold in the Grey Market.
    var bool bIsInfinite;

    var bool bIsCaptive;          // Whether this represents a captive unit.
    var int iCaptiveToCorpseId;   // If the captive is killed, this is the item ID of the corpse to add to the player's storage.

    var bool bIsCorpse;           // Whether this represents the corpse of a unit.
    var int iCorpseToCharacterId; // The ID of the character that this is the corpse of.

    var bool bIsUniqueEquip;      // If true, soldiers can only have one of this item equipped. This field is ignored for non-equipment items.

    // An array of item IDs that cannot be equipped at the same time as this item, such as how Drum Mags and Hi Cap Mags can't be equipped together.
    // This field is ignored for non-equipment items.
    var array<int> arrMutuallyExclusiveEquipment;

    // If this array is populated, then this item can only be equipped if one of the item IDs in this array is equipped in a large equipment slot.
    // This field is ignored for non-equipment items.
    var array<int> arrCompatibleLargeEquipment;

    // If this array is populated, then this item cannot be equipped if any of the item IDs in this array is equipped in a large equipment slot.
    // This field is ignored for non-equipment items.
    var array<int> arrIncompatibleLargeEquipment;

    // When equipped, this item grants its holder all of the perk IDs listed here.
    // This field is ignored for non-equipment items.
    var array<int> arrPerksGranted;

    // The base number of charges for this item. If something changes the number of charges globally, such as a Foundry project, the mod should use
    // Override_GetItem to reflect that dynamically. If the number of charges changes situationally, such as with soldier perks, that should be done
    // using Override_UpdateItemCharges instead. Items that are on a cooldown or are not limited usage should not set this field.
    // This field is ignored for non-equipment items.
    var int iBaseCharges;

    // If iHours >= 0, kCost is the cost to build this item in Engineering, and the item can be sold for 40% of its cash cost.
    // Otherwise, kCost.iCash is the selling price of the item, if greater than zero. If kCost.iCash <= 0, the item cannot be sold.
    var LWCE_TCost kCost;

    // Prerequisites for this item to appear in Engineering to be built. The iHours field must also be greater than or equal to zero.
    var LWCE_TPrereqs kPrereqs;

    structdefaultproperties
    {
        strName=""
        strNamePlural=""
        strBriefSummary=""
        ImagePath=""
        iItemId=0
        iCategory=0
        iHours=-1
        iMaxEngineers=-1
        iStartingQuantity=0
        bIsInfinite=false
        bIsCaptive=false
        iCaptiveToCorpseId=0
        bIsCorpse=false
        iCorpseToCharacterId=0
        bIsUniqueEquip=false
        arrPerksGranted=()
        iBaseCharges=0
        kCost=(iCash=-1)
        kPrereqs=()
    }
};

/// <summary>
/// Struct representing a perk, replacing XComPerkManager.TPerk. Note that unlike XCOM 2, the perk's raw data
/// does not contain anything about how the perk actually works. You must use mod hooks to interact appropriately
/// with the game based on what your perk should do.
/// </summary>
struct LWCE_TPerk
{
    var int iPerkId;

    // Text content for the perk. Bonus and penalty text are used on the F1 tactical info HUD when targeting
    // a unit with an ability; passive text is used when pressing F1 on a unit with no ability raised.
    var string strBonusTitle;
    var string strBonusDescription;
    var string strPassiveTitle;
    var string strPassiveDescription;
    var string strPenaltyTitle;
    var string strPenaltyDescription;

    // Which icon to use for this perk. Currently this is limited to the icons packaged with the game, e.g. "ClusterBomb".
    // For a full list, see LWCE_XComPerkManager.BuildPerkTables. Support for arbitrary images may be added in a future update.
    var string Icon;

    var int iCategory;    // 0 for passive perks, 1 for active perks.

    var bool bShowPerk; // Whether to show this perk's icon in the UI, specifically the tactical HUD's bottom left corner (UITacticalHUD_PerkContainer)
                        // and the perk list when looking at a soldier in the barracks (XGSoldierUI). Other locations, such as the F1 tactical menu, are
                        // not affected by this value.

    var bool bIsGeneMod;
    var bool bIsPsionic;
};

/// <summary>
/// Represents a single option in the soldier promotion UI (or the psi training UI).
/// </summary>
struct LWCE_TPerkTreeChoice
{
    // The ID of the perk that will be gained when selecting this choice.
    var int iPerkId;

    // If not -1, then when this perk is selected, the soldier's class is set to this ID. May cause buggy
    // results if used in a situation where the soldier already has a class ID set. If the perk tree is
    // psionic, the soldier's psionic class is modified instead of their base class.
    var int iNewClassId;

    // The change to the character's stats which will be applied on choosing this perk. Some perks, such as
    // Sprinter, already add stats; those stat values should not be reflected in this field.
    var LWCE_TCharacterStats kStatChanges;

    // The prerequisites that must be met before this perk can be trained. Note that this is currently only
    // implemented for psi perk trees, and has no effect on soldier perk trees.
    var LWCE_TPrereqs kPrereqs;

    // The target will for training this perk; training time will depend on the soldier's will compared to
    // this value. This is only implemented for psi training, not soldier perks.
    var int iTargetWill;

    structdefaultproperties
    {
        iNewClassId=-1
    }
};

/// <summary>
/// Represents a full row of perk choices in the soldier promotion UI (or the psi training UI).
/// </summary>
struct LWCE_TPerkTreeRow
{
    // The choices available in this row of the tree. Currently, having more than 3 options in a row is not supported.
    var array<LWCE_TPerkTreeChoice> arrPerkChoices;
};

/// <summary>
/// Contains an entire tree of options for soldier perks or psionic training.
/// </summary>
struct LWCE_TPerkTree
{
    // Soldiers must have this class ID to access this perk tree.
    var int iClassId;

    // The rows of the perk tree. arrPerkRows[0] is available at the first rank up; arrPerkRows[1] at the second; and so on.
    // Do not add empty rows, they will not work properly.
    var array<LWCE_TPerkTreeRow> arrPerkRows;
};

/// <summary>
/// LWCE equivalent of TWeapon. The primary changes include a more flexible system for abilities/properties, and
/// support for affecting more stats (such as DR) without having to write code.
/// </summary>
struct LWCE_TWeapon
{
    // The (singular) name of the weapon to show the player.
    var string strName;

    // The ID of this weapon, which must match the ID of its equivalent LWCE_TItem entry.
    var int iItemId;

    // IDs of abilities granted to units with this item equipped.
    var array<int> arrAbilities;

    // IDs of this item's properties. See EWeaponProperty for base game properties, though mods can add their own.
    var array<int> arrProperties;

    // The size of the item, which dictates where it can be equipped and what role it fills. Valid values are
    // 0 (for small items) and 1 (for large). Generally speaking, large items are primary weapons, rocket launchers,
    // and MEC special weapons such as the flamethrower, and small items are everything else.
    var int iSize;

    // The base damage of the item. The exact damage range will depend on whether the item is an explosive or not,
    // as well as whether the player is using the Damage Roulette second wave option.
    var int iDamage;

    // The damage this item deals to the environment. For guns, environmental damage is dealt by projectiles that don't
    // connect with the target; for explosives, it is dealt to objects in the explosion radius.
    var int iEnvironmentDamage;

    // For items that are used against a specific target, this is the maximum distance away the target can be from the user.
    // This includes all guns, as well as usable items like Medikits and the Arc Thrower. The range of guns can be increased
    // if the shooter has height advantage over the target. Note that the shooter must still be able to see the target, either
    // naturally or via Squadsight, and a weapon range greater than visual range confers no bonus otherwise.
    // For thrown items like grenades, this is the base maximum distance that the item can be thrown.
    // This uses the same units as TWeapon.iRange, where 1.5 units is equal to the length of the side of an in-game tile.
    var int iRange;

    // This is the same as iRange, but only applying to shots taken while on overwatch. The unit will not fire at a target
    // using this item unless they are within this range. Range is measured in the same units as iRange.
    var int iReactionRange;

    // The radius of this item's area of effect, if it has one. This is measured in units such that 64 units
    // is equal to the length of the side of an in-game tile.
    // TODO: confirm this measurement
    var int iRadius;

    // If this item is a gun, this is the ammo it has without any upgrades, e.g. Ammo Conservation, or small items like Drum Mags.
    // This only applies to reloadable weapons, not limited-use items such as grenades.
    var int iBaseAmmo;

    // The maximum chance for this item to be damaged if its wearer is injured. The max chance is applied if the wearer is reduced
    // to 0 HP, and scales linearly for other HP values. If zero, or if the corresponding LWCE_TItem is infinite, it cannot be damaged.
    // This is a percentage, so it should be in the range 0 to 100, inclusive.
    var int iMaxChanceToBeDamaged;

    // The scale to apply to the item's model, in each direction. Each value is specified as a percentage, so a value of 100 will
    // not scale the model at all. The X direction is generally along the barrel of the weapon, but note that the orientation of
    // the axes may depend on the specific model, so be sure to test accordingly.
    var LWCE_Vector3Int vModelScale;

    // The change in the wielder's stats from equipping this item. For primary or secondary weapons, the stat changes only apply
    // to shots taken with that weapon (for offensive stats). For small items, offensive stat changes do not apply to sidearms
    // (but can apply to rocket launchers).
    var LWCE_TCharacterStats kStatChanges;

    structdefaultproperties
    {
        vModelScale=(X=100, Y=100, Z=100)
    }
};

struct TModVersion
{
    var int Major;
    var int Minor;
    var int Revision;

    structdefaultproperties
    {
        Major=0
        Minor=0
        Revision=0
    }
};

// ------------------------------------------------------------------------------
// Delegate types used in various mod hooks
// ------------------------------------------------------------------------------



// ------------------------------------------------------------------------------
// Structs beyond this point are unlikely to be needed by most mod authors. You
// can skip past them to see some utility functions.
// ------------------------------------------------------------------------------

struct LWCE_THQEvent
{
    var name EventType;
    var int iHours;
    var array<LWCE_TData> arrData;
};

struct LWCE_TMCEvent
{
    var name EventType;
    var TImage imgOption;
    var TText txtOption;
    var TText txtDays;
    var int iPriority;
    var Color clrOption;
    var array<LWCE_TData> arrData;
};

struct LWCE_TMCEventMenu
{
    var TButtonText txtFFButton;
    var array<LWCE_THQEvent> arrEvents;
    var array<LWCE_TMCEvent> arrOptions;
    var TText txtEventsLabel;
    var int iHighlight;
};

struct LWCE_TItemCard
{
    var string strName;
    var string strFlavorText;
    var string strShivWeapon;
    var int shipWpnRange;
    var int shipWpnArmorPen;
    var int shipWpnHitChance;
    var int shipWpnFireRate;
    var int iCharacterId;
    var int iHealth;
    var int iWill;
    var int iAim;
    var int iDefense;
    var int iArmorHPBonus;
    var int iBaseCritChance;
    var int iBaseDamage;
    var int iBaseDamageMax;
    var int iCritDamage;
    var int iCritDamageMax;
    var float fireRate;
    var int iRangeCategory;
    var int iCardType;
    var int iItemId;
    var int iCharges;
    var array<int> arrPerkTypes;
    var array<int> arrAbilities;
    var array<TShivAbility> arrAbilitiesShiv;

    structdefaultproperties
    {
        strName="UNDEFINED"
        strFlavorText=""
        strShivWeapon=""
        shipWpnRange=0
        shipWpnArmorPen=0
        shipWpnHitChance=0
        shipWpnFireRate=0
        iCharacterId=0
        iHealth=0
        iWill=0
        iAim=0
        iDefense=0
        iArmorHPBonus=0
        iBaseCritChance=0
        iBaseDamage=0
        iBaseDamageMax=0
        iCritDamage=0
        iCritDamageMax=0
        fireRate=0.0
        iRangeCategory=0
        iCardType=0
        iItemId=0
        iCharges=0
        arrPerkTypes=()
        arrAbilities=()
        arrAbilitiesShiv=()
    }
};

struct LWCE_TItemProject
{
    var int iIndex;
    var int iItemId;
    var int iEngineers;
    var int iMaxEngineers;
    var int iQuantity;
    var int iQuantityLeft;
    var int iHoursLeft;
    var bool bAdjusted;
    var bool bNotify;
    var bool bRush;
    var TProjectCost kRebate;
    var TProjectCost kOriginalCost;

    structdefaultproperties
    {
        iIndex=-1
    }
};

struct LWCE_TTechState
{
    var name TechName;
    var ETechState eAvailabilityState;
};

struct LWCE_TTransferSoldier
{
    var LWCE_TCharacter kChar;
    var LWCE_TSoldier kSoldier;
    var int aStatModifiers[ECharacterStat];
    var int iHPAfterCombat;
    var int iCriticalWoundsTaken;
    var int iUnitLoadoutID;
    var bool bLeftBehind;
    var init string CauseOfDeathString;

    structdefaultproperties
    {
        iUnitLoadoutID=-1
    }
};

// ------------------------------------------------------------------------------
// Utility functions for mixing vanilla and LWCE types
// ------------------------------------------------------------------------------

delegate OnShowMenu(TMenu kMenu, optional object Data);

delegate OnSpinnerChanged(int Direction);

static function TProjectCost ConvertTCostToProjectCost(LWCE_TCost kInCost)
{
    local LWCE_TItemQuantity kItemQuantity;
    local TProjectCost kOutCost;

    kOutCost.iCash = kInCost.iCash;
    kOutCost.iAlloys = kInCost.iAlloys;
    kOutCost.iElerium = kInCost.iElerium;

    if (kInCost.iMeld > 0)
    {
        kOutCost.arrItems.AddItem(eItem_Meld);
        kOutCost.arrItemQuantities.AddItem(kInCost.iMeld);
    }

    if (kInCost.iWeaponFragments > 0)
    {
        kOutCost.arrItems.AddItem(eItem_WeaponFragment);
        kOutCost.arrItemQuantities.AddItem(kInCost.iWeaponFragments);
    }

    foreach kInCost.arrItems(kItemQuantity)
    {
        kOutCost.arrItems.AddItem(kItemQuantity.iItemId);
        kOutCost.arrItemQuantities.AddItem(kItemQuantity.iQuantity);
    }

    return kOutCost;
}

static function LWCE_TCost ConvertTResearchCostToTCost(TResearchCost kInCost)
{
    local int Index;
    local LWCE_TCost kOutCost;
    local LWCE_TItemQuantity kItemQuantity;

    kOutCost.iCash = kInCost.iCash;
    kOutCost.iAlloys = kInCost.iAlloys;
    kOutCost.iElerium = kInCost.iElerium;

    for (Index = 0; Index < kInCost.arrItems.Length; Index++)
    {
        if (kInCost.arrItems[Index] == eItem_Meld)
        {
            kOutCost.iMeld = kInCost.arrItemQuantities[Index];
        }
        else if (kInCost.arrItems[Index] == eItem_WeaponFragment)
        {
            kOutCost.iWeaponFragments = kInCost.arrItemQuantities[Index];
        }
        else
        {
            kItemQuantity.iItemId = kInCost.arrItems[Index];
            kItemQuantity.iQuantity = kInCost.arrItemQuantities[Index];

            kOutCost.arrItems.AddItem(kItemQuantity);
        }
    }

    return kOutCost;
}

static function TResearchCost ConvertTCostToTResearchCost(LWCE_TCost kInCost)
{
    local LWCE_TItemQuantity kItemQuantity;
    local TResearchCost kOutCost;

    kOutCost.iCash = kInCost.iCash;
    kOutCost.iAlloys = kInCost.iAlloys;
    kOutCost.iElerium = kInCost.iElerium;

    if (kInCost.iMeld > 0)
    {
        kOutCost.arrItems.AddItem(eItem_Meld);
        kOutCost.arrItemQuantities.AddItem(kInCost.iMeld);
    }

    if (kInCost.iWeaponFragments > 0)
    {
        kOutCost.arrItems.AddItem(eItem_WeaponFragment);
        kOutCost.arrItemQuantities.AddItem(kInCost.iWeaponFragments);
    }

    foreach kInCost.arrItems(kItemQuantity)
    {
        kOutCost.arrItems.AddItem(kItemQuantity.iItemId);
        kOutCost.arrItemQuantities.AddItem(kItemQuantity.iQuantity);
    }

    return kOutCost;
}