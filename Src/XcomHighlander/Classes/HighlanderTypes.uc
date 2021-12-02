class HighlanderTypes extends Object;

struct HL_TRange
{
    var int MinInclusive;
    var int MaxInclusive;
};

struct HL_TItemQuantity
{
    var int iItemId;
    var int iQuantity;
};

/// <summary>
/// Represents a cost paid by the player for building items, researching techs, beginning Foundry projects, etc.
/// </summary>
struct HL_TCost
{
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iMeld;
    var int iWeaponFragments;
    var array<HL_TItemQuantity> arrItems;

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
struct HL_TPrereqs
{
    var array<int> arrFacilityReqs; // A list of facility IDs that must be built. For non-unique facilities, only one needs to be built.
    var array<int> arrFoundryReqs;  // A list of foundry project IDs that must be complete.
    var array<int> arrItemReqs;     // A list of item IDs. The player must have possessed these at one time, but doesn't necessarily need to still have them now.
    var array<int> arrTechReqs;     // A list of research tech IDs that must be complete.
    var array<int> arrUfoReqs;      // A list of UFO types that must be encountered. A UFO type is considered encountered after a successful assault on a crashed or landed UFO.

    var int iRequiredSoldierRank;   // If set, XCOM must have at least one soldier of this rank or higher.
    var int iTotalSoldierRanks;     // If set, the sum of soldier ranks across XCOM's roster must be at least this value.

    var bool bRequiresAutopsy;       // If true, any autopsy research must be completed.
    var bool bRequiresInterrogation; // If true, any interrogation research must be completed.
};

struct HL_TItem
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

    // How many of this item XCOM HQ starts the game with. If bIsInfinite is set at the start of the game, this value is ignored.
    var int iStartingQuantity;

    // Whether XCOM's stores of this item are unlimited, such as starting weapons and armor, or Alien Grenades after their Foundry project
    // is complete. If this changes based on the state of the campaign (such as Alien Grenades do), then your mod should use the strategy hook
    // Override_HL_GetItem to set this value dynamically.
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
    var HL_TCost kCost;

    // Prerequisites for this item to appear in Engineering to be built. The iHours field must also be greater than or equal to zero.
    var HL_TPrereqs kPrereqs;

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
/// Struct representing a Foundry project.
/// </summary>
struct HL_TFoundryTech
{
    var int iTechId;            // The integer ID of the project. See README if you don't know how to choose IDs.
    var string strName;         // The friendly name of the Foundry project.
    var string strSummary;      // Friendly text describing the project to the player.

    var int iHours;             // The total number of engineer-hours required to complete this project. For example, if your project requires 15
                                // engineers and should take 48 hours to complete when at 15 engineers, this would be 15 * 48 = 720 hours.
    var int iEngineers;         // The number of engineers required to make progress at normal speed on this project.

    var array<int> arrCredits;  // A list of research credit IDs that can apply to speed up this project.

    var string ImagePath;       // Path to an image to show in the Foundry UI for this project. Must include the "img:///" prefix.
                                // Typical Foundry images are 256x128.

    var HL_TCost kCost;         // The base cost (unmodified by any continent bonuses or other situational modifiers) to start this project.
    var HL_TPrereqs kPrereqs;   // The prerequisites that must be met before this project will be visible in the Foundry.

    var bool bForceUnavailable; // If true, this project will never be shown in the list of available Foundry projects. This is the recommended
                                // way to deprecate Foundry projects from a mod, rather than deleting them (which may break existing game saves).
                                // If the player has already completed the project, it will still be visible in the Foundry.

    structdefaultproperties
    {
        iTechId=0
        strName=""
        strSummary=""
        iHours=0
        iEngineers=0
        kCost=(iCash=0, iAlloys=0, iElerium=0, iMeld=0, arrItems=())
        arrCredits=()
        ImagePath=""
        bForceUnavailable=false
    }
};

/// <summary>
/// Struct representing a research technology.
/// </summary>
struct HL_TTech
{
    var int iTechId;
    var string strName;     // The research name, as it will be seen when selecting research, browsing the archives, etc.
    var string strSummary;  // The summary text when selecting a new research in the Labs.
    var string strReport;   // The full text seen when the research is completed, or when viewing the research in the archives.
    var string strCustom;   // Extra text which is shown in yellow during the research results. Can be left blank if not needed.
    var string strCodename; // The codename which is seen during the research report.

    // Whether this is an autopsy or interrogation, and which character ID is the subject.
    // This has the following effects:
    //
    //     1. Autopsies/interrogations can benefit from special research time reductions, such as We Have Ways.
    //     2. Starting an autopsy/interrogation plays the associated cutscene for the subject character ID.
    //     3. Autopsies are required to view enemy perks, and to see special enemy names for navigators/leaders.
    //     4. Autopsied enemy types grant a damage bonus from the Vital Point Targeting perk.
    //
    // In Long War 1.0, some enemies (Outsiders, zombies, EXALT) don't have autopsy research, and always count as being
    // autopsied. With the Highlander, this behavior is retained even if a mod adds an autopsy tech for those enemies.
    // If any mod author wants to add those autopsies and wants this changed, please contact the Highlander team.
    var bool bIsAutopsy;
    var bool bIsInterrogation;
    var int iSubjectCharacterId;

    var int iHours; // How many scientist-hours this research takes. Each scientist completes one scientist-hour per hour, multiplied by research
                    // bonuses from laboratories and adjacencies. This value will be multiplied by DefaultGameCore.ini's TECH_TIME_BALANCE.
                    // For example, if this value is 240 (10 * 24), then 1 scientist can complete the research in 10 days, or 10 scientists in 1
                    // day, or 20 in 0.5 days, etc. This value is also reduced multiplicatively by research credits (see arrCredits below), situational
                    // modifiers such as We Have Ways for autopsies/interrogations, and others.


    var int iCreditGranted; // The research credit ID granted by this tech, if any. See EResearchCredits for values.
    var array<int> arrCredits;  // A list of research credit IDs that can apply to speed up this research.

    var string ImagePath;

    var HL_TCost kCost;
    var HL_TPrereqs kPrereqs;   // The prerequisites that must be met before this research will be visible in the Labs.

    structdefaultproperties
    {
        iTechId=0
        strName=""
        strSummary=""
        strReport=""
        strCustom=""
        strCodename=""
        bIsAutopsy=false
        bIsInterrogation=false
        iHours=0
        iCreditGranted=0
        arrCredits=()
        ImagePath=""
        kCost=(iCash=0,iAlloys=0,iElerium=0,iMeld=0,iWeaponFragments=0,arrItems=())
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
// Structs beyond this point are unlikely to be needed by most mod authors. You
// can skip past them to see some utility functions.
// ------------------------------------------------------------------------------

struct HL_TItemCard
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

struct HL_TItemProject
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

struct HL_TLabArchivesUI
{
    var TMenu mnuArchives;
    var array<int> arrTechs;

    structdefaultproperties
    {
        mnuArchives=(strLabel="", arrOptions=(), bTakesNoInput=false)
        arrTechs=()
    }
};

struct HL_TResearchProgress
{
    var int iTechId;
    var int iHoursCompleted; // Scientist-hours of this research that have been completed
    var int iHoursSpent; // Number of clock hours the research has been worked on
    var XGDateTime kCompletionTime;
};

struct HL_TTechState
{
    var int iTechId;
    var ETechState eAvailabilityState;
};

// ------------------------------------------------------------------------------
// Utility functions for mixing vanilla and Highlander types
// ------------------------------------------------------------------------------

static function TProjectCost ConvertTCostToProjectCost(HL_TCost kInCost)
{
    local HL_TItemQuantity kItemQuantity;
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

static function HL_TCost ConvertTResearchCostToTCost(TResearchCost kInCost)
{
    local int Index;
    local HL_TCost kOutCost;
    local HL_TItemQuantity kItemQuantity;

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

static function TResearchCost ConvertTCostToTResearchCost(HL_TCost kInCost)
{
    local HL_TItemQuantity kItemQuantity;
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