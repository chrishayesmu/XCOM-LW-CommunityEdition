class LWCETypes extends Object;

enum EDataType
{
    eDT_Bool,
    eDT_Int,
    eDT_Name,
    eDT_String
};

/// <summary>A two-dimensional vector of integers.</summary>
struct LWCE_Vector2Int
{
    var int X, Y;
};

/// <summary>A three-dimensional vector of integers.</summary>
struct LWCE_Vector3Int
{
    var int X, Y, Z;
};

/// <summary>A simple key-value pair where the key is a name and the value is an integer.</summary>
struct LWCE_NameIntKVP
{
    var name Key;
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
    var name SourceId;
    var name SourceType;
};

struct LWCE_TInventory
{
    var name nmArmor;
    var name nmPistol;

    var array<name> arrLargeItems;
    var array<name> arrSmallItems;
    var array<name> arrCustomItems;
};

struct LWCE_TLoadout
{
    var name Items[ELocation.EnumCount];
    var array<name> Backpack;
};

struct LWCE_TAppearance
{
    var name nmHead;
    var name nmRace;
    var name nmHaircut;
    var name nmFacialHair;
    var name nmBody;
    var name nmLanguage;
    var name nmVoice;
    var name nmArmorKit;
    var name nmGender;
    var string strFlagPath;
    var int iBodyMaterial;

    // TODO: deprecate using templates for colors
    var name nmArmorColor;
    var name nmHairColor;
    var name nmSkinColor;
};

struct LWCE_TCharacter
{
    var string strName;
    var int iCharacterType; // As in the ECharacter enum
    var LWCE_TInventory kInventory;

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
    var bool bIsAugmented; // TODO: not being populated yet
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
/// High level stats of the events of a month. Note that *which* month isn't part of this struct, and should be
/// determined from context.
/// </summary>
struct LWCE_TMonthlySummary
{
    var int iPanicChange;
    var int iUFOsSeen;
    var int iUFOsDetected;
    var int iUFOsShotdown;
    var int iUFOsEscaped;
    var int iInterceptionRating;
    var int iAbductions;
    var int iAbductionsThwarted;
    var int iTerror;
    var int iTerrorThwarted;
    var int iUFORaids;
    var int iTechsResearched;
    var int iSatellitesLaunched;
    var int iSatellitesLost;
    var int iMismanagedFunds;
    var int iAbductionsIgnored;
    var int iAbductionsFailed;
    var int iTerrorIgnored;
    var int iTerrorFailed;
    var int iAlienBasesAssaulted;
    var int iCouncilMissionsCompleted;
    var int iFunding;
    var int iScientists;
    var int iEngineers;
    var array<name> arrCountriesNotHelped;
    var array<name> arrCountriesLeaving;
};

/// <summary>
/// The results of the monthly council meeting, used to display the council report UI.
/// </summary>
struct LWCE_TCouncilMeeting
{
    var string strSummary;
    var array<LWCE_TMonthlySummary> arrContinentSummaries;
    var int iFunding;
    var int iScientists;
    var int iEngineers;
    var LWCE_TMonthlySummary kSummary;
    var EMonthlyGrade eGrade;

    // Countries which are leaving during the council report (as opposed to kResult.arrCountriesLeaving, which is countries that left in the month leading up to the report).
    var array<name> arrLeavingCountries;
};

struct LWCE_TSoldier
{
    var int iID;
    var string strFirstName;
    var string strLastName;
    var string strNickName;
    var string strClassIcon;
    var int iRank;
    var int iPsiRank;
    var int iXP;
    var int iPsiXP;
    var int iNumKills;
    var name nmCountry;
    var LWCE_TAppearance kAppearance;
    var int iSoldierClassId;
    var bool bBlueshirt;
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
    var float fDamageReductionPenetration;
    var int iDefense;
    var int iFlightFuel;
    var int iHP;
    var int iMobility;
    var int iRegen;
    var int iWill;
    var int iShieldHP;
    var int iSightRadius;
};

struct LWCE_TItemQuantity
{
    var name ItemName;
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
    var array<name> arrFacilityReqs; // A list of facility names that must be built. For non-unique facilities, only one needs to be built.
    var array<name> arrFoundryReqs;  // A list of foundry project names that must be complete.
    var array<name> arrItemReqs;     // A list of item names. The player must have possessed these at one time, but doesn't necessarily need to still have them now.
    var array<name> arrTechReqs;     // A list of research tech names that must be complete.
    var array<name> arrShipReqs;     // A list of enemy ship types that must be encountered. A ship type is considered encountered after a successful assault on a crashed or landed ship.

    var int iRequiredSoldierRank;   // If set, XCOM must have at least one soldier of this rank or higher.
    var int iTotalSoldierRanks;     // If set, the sum of soldier ranks across XCOM's roster must be at least this value.

    var bool bRequiresAutopsy;       // If true, any autopsy research must be completed.
    var bool bRequiresInterrogation; // If true, any interrogation research must be completed.
};

struct LWCE_TAbilityResult
{
    var bool bIsHit;
    var bool bIsCrit;
    var int iUnmitigatedDamage;
    var int iDamageReduction;
    var int iFinalDamage;
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

    // The ID of this weapon, which must match the ID of its equivalent LWCEItemTemplate entry.
    var name ItemName;

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
    // to 0 HP, and scales linearly for other HP values. If zero, or if the corresponding LWCEItemTemplate is infinite, it cannot be damaged.
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

/// <summary>
/// TODO
/// </summary>
struct LWCE_TAppliedEffect
{
    var name nmEffect;
    var int iTurnsRemaining;
    var LWCE_TCharacterStats kStatChanges;
};

/// <summary>
/// Used by the ability framework when determining eligible targets for abilities.
/// See LWCEAbilityTargetStyle and its children for the main usage of this struct.
/// </summary>
struct LWCE_TAvailableTarget
{
    var LWCE_XGUnit kPrimaryTarget;              // The ability's main target; may be none for purely AoE abilitiies like grenades/rockets.
    var array<LWCE_XGUnit> arrAdditionalTargets; // Extra targets, which may be hit by an AoE, or individually targeted (like Greater Mind Merge).
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
// Structs beyond this point are unlikely to be needed by most mod authors. You
// can skip past them to see some utility functions.
// ------------------------------------------------------------------------------

struct LWCE_THQEvent
{
    var name EventType;
    var int iHours;
    var LWCEDataContainer kData;
};

struct LWCE_TMCEvent
{
    var name EventType;
    var TImage imgOption;
    var TText txtOption;
    var TText txtDays;
    var int iPriority;
    var Color clrOption;
    var LWCEDataContainer kData;
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
    var string strImage;
    var name ItemName;
    var int shipWpnRange;
    var int shipWpnArmorPen;
    var int shipWpnHitChance;
    var float shipWpnFiringTime;
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
    var int iCharges;
    var array<int> arrPerkTypes;
    var array<int> arrAbilities;
    var array<TShivAbility> arrAbilitiesShiv;

    structdefaultproperties
    {
        strName="UNDEFINED"
    }
};

struct LWCE_TStaffRequirement
{
    var name StaffType;
    var int NumRequired;
};

struct LWCE_TProjectCost
{
    var LWCE_TCost kCost;
    var array<LWCE_TStaffRequirement> arrStaffRequirements; // The necessary staff to work on this project.
    var int iBarracksReq;  // How much open barracks space is required to complete this project.
};

struct LWCE_TItemProject
{
    var int iIndex;
    var name ItemName;
    var int iEngineers;
    var int iMaxEngineers;
    var int iQuantity;
    var int iQuantityLeft;
    var int iHoursLeft;
    var bool bAdjusted;
    var bool bNotify;
    var bool bRush;
    var LWCE_TProjectCost kRebate;
    var LWCE_TProjectCost kOriginalCost;

    structdefaultproperties
    {
        iIndex=-1
    }
};

struct LWCE_TObjectSummary
{
    var TImage imgObject;
    var TText txtRequirementsLabel;
    var TText txtSummary;
    var TCostSummary kCost;
    var bool bCanAfford;
    var name ItemType;
};

/// <summary>
/// Represents an objective for the alien strategy layer AI.
/// </summary>
struct LWCE_TObjective
{
    // The overall goal of the objective. Base game values include `Scout`, `Hunt`, `Bomb`,
    // `Terrorize`, `AssaultXComAirBase`, `AssaultXComHQ`, `Infiltrate`, `Research`, `Harvest`,
    // `Abduct`, and `CommandOverwatch`. Must map to an LWCEEnemyObjectiveTemplate instance.
    var name nmType;

    // The name to display for this objective if the player has the Hyperwave Relay.
    var string strName;

    // A series of missions which ships will embark on as part of this objective. All of the arrays in
    // this struct should have the same length; they are implicitly tied together. Base game values for missions are
    // `Direct`, `Dropoff`, `Flyby`, `Seek`, `QuickSpecimen`, `LongSpecimen`, `QuickScout`, and `LongScout`.
    // They are largely just used for determining the flight plan of the ship.
    var array<name> arrMissions;

    // Used for picking exactly where a ship should go. If -1, the ship will pick a random point within the target country;
    // if 0, the ship will go exactly to its target, which is usually a city's coordinates or the country's center point. If
    // a positive value, represents a distance in miles. The ship will navigate to a random point which is less than that
    // distance away from its target.
    var array<int> arrRadii;

    // When scheduling a mission, it will be up to arrRandDays[] days earlier or later than the given start date.
    var array<int> arrRandDays;

    // Which type of ship will be sent on the mission. Should be the name of an LWCEShipTemplate.
    var array<name> arrShips;

    // When to schedule the mission. These dates are offsets from when the objective is created, which is typically the start
    // of the month; e.g. a date of 0 would be the first day of the month. However, some objectives are created mid-month, such as
    // satellite hunts which follow a successful scouting mission. Additionally, a start date could be extremely long, spanning more
    // than one month, and this would also be supported.
    var array<int> arrStartDates;
};

struct LWCE_TSatellite
{
    var name nmType; // The type of satellite; usually this will be 'Item_Satellite' but maybe some mod wants high-res or thermal sats, etc
    var Vector2D v2Loc;
    var LWCE_XGEntity kSatEntity;
    var name nmCountry; // Which country the satellite is monitoring
    var int iTravelTime; // How long until the satellite is in position; if <= 0, it's already arrived
};

struct LWCE_TSatNode
{
    var Vector2D v2Coords;
    var name nmCountry;
};

/// <summary>
/// An order which is placed for new ships. This is not used for ships which are built via
/// engineering; those are handled the same as other items, except that they reserve a hangar bay.
/// </summary>
struct LWCE_TShipOrder
{
    var int iNumShips;
    var name nmDestinationContinent;
    var name nmShipType; // Corresponds to an item template, not a ship template. TODO: that's really confusing
    var int iHours;
    var LWCE_TCost kUnitCostPaid; // In case the order is canceled and we want to refund. This is the cost per ship, not total.
};

/// <summary>
/// A record of an enemy ship's mission and its outcome.
/// </summary>
struct LWCE_TShipRecord
{
    var name nmShipType; // The type of ship which conducted the mission
    var name nmObjective; // The overall objective of the mission, as in LWCE_XGAlienObjective
    var name nmCountry; // The country which was targeted by this mission
    var EUFOMissionResult eResult; // The outcome of the mission
    var int iMonth; // The month the mission occurred in, with month 0 being the campaign's start month
};

/// <summary>
/// The stats of a ship during an interception or on the Geoscape.
/// </summary>
struct LWCE_TShipStats
{
    var int iAim;
    var int iArmor;
    var int iArmorPen;
    var int iHealth;
    var int iDamage;
    var int iDamageReduction;
    var int iDefense;
    var int iEngagementSpeed;
    var int iSpeed;
    var array<name> arrWeapons;
};

/// <summary>
/// Tracks a transfer of ships from one continent to another.
/// </summary>
struct LWCE_TShipTransfer
{
    var int iNumShips;
    var name nmShipType;
    var name nmDestinationContinent;
    var int iHours;
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

delegate OnSpinnerChanged(int Direction);