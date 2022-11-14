class LWCEItemTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyGame);

var config name nmCategory;            // The item's category. Base LWCE categories are 'Armor', 'Weapon', 'Vehicle', 'AlienArtifact', 'Corpse', and 'Captive'.
                                       // The category affects several things, primarily whether the item appears in the Engineering build UI, and if so,
                                       // where in that UI it is listed.

var config name nmTechTier;            // The tech tier of the item. Not applicable to all items. Base game weapon tiers are 'weapon_ballistic', 'weapon_laser', 'weapon_gauss',
                                       // 'weapon_pulse' and 'weapon_plasma'. Base game armor tiers are 'armor_basic', 'armor_improved', 'armor_advanced', 'armor_power1', and
                                       // 'armor_power2'.

var config int iStartingQuantity;      // How many of this item XCOM HQ starts the game with. If bIsInfinite is true, this value is ignored.

var config bool bIsInfinite;           // Whether XCOM's stores of this item are unlimited, such as starting weapons and armor, or Alien Grenades after their Foundry project
                                       // is complete. If this changes based on the state of the campaign (such as Alien Grenades do), then set the delegate IsInfiniteFn.
                                       // Note that items which are marked as infinite cannot be built in engineering, nor can they be sold in the Grey Market.

var delegate<IsInfiniteDel> IsInfiniteFn; // Delegate to determine if an item is infinite. If set, bIsInfinite will be ignored. If this delegate returns true, it should
                                          // return true for the remainder of the campaign; switching from true to false may break things.

var config bool bIsPriority;              // Whether this item is a build priority for the player. If IsPriorityFn is set, this field is ignored.

var delegate<IsPriorityDel> IsPriorityFn; // Delegate to determine if an item is a build priority for the player (eg main storyline items).

var config bool bIsBuildable;          // Whether this is ever a buildable item. Being set to true does not imply it is buildable right now; the item's
                                       // prerequisites will indicate that.

var config bool bIsSellable;           // Whether this item can be sold on the grey market. Setting this to true is not enough by itself; the item's kCost.iCash field
                                       // must also be greater than 0. Items which are infinite cannot be sold.

var config int iPointsToComplete;      // If > 0, this is the number of engineer-hours needed to build this item. If <= 0, this item is built instantly.
var config int iEngineers;             // The number of engineers required to make progress at normal speed when building this item.

var config name nmReplacementItem;     // If set, when this item is granted, then the replacement item ID is added to XCOM's stores instead of the actual
                                       // item ID. This can be used to make items buildable in different ways, such as how SHIVs can be built directly,
                                       // or they can be rebuilt using a damaged SHIV chassis. If you're using this field, then you can set strName to
                                       // the name you want to appear in Engineering instead of the replacement item's name. This replacement effect can occur
                                       // multiple times if the specified replacement also has nmReplacementItem set. Take care not to introduce any loops in
                                       // replacement using this, as that will cause the game to hang and crash.

var config name nmCaptiveToCorpseId;   // If this item is a captive and the captive is killed, this is the item ID of the corpse to add to the player's storage.
var config int iCorpseToCharacterId;   // If this item is a corpse, this is the ID of the character type that this is the corpse of.

var config LWCE_TCost kCost;           // If bIsBuildable is true, kCost is the cost to build this item in Engineering, and the item can be sold for a percentage of its cash cost.
                                       // Otherwise, kCost.iCash is the selling price of the item, if greater than zero. If kCost.iCash <= 0, the item cannot be sold.

var config LWCE_TPrereqs kPrereqs;     // If bIsBuildable is true, these are the prerequisites for this item to appear in Engineering to be built. For equipment, these prereqs
                                       // must be met in order to equip the item to a soldier; otherwise they will be visible but locked out.

var config string ItemBuiltNarrative;                 // A narrative to play when this item is built.
var config EFacilityType eItemBuiltNarrativeFacility; // Which facility the ItemBuiltNarrative should be played in.

var config string ImagePath;            // Path to an image to show in the UI for this item. Must include the "img:///" prefix.
                                        // Typical item images are 256x128.

var const localized string strName;           // The player-viewable name of the item (singular).
var const localized string strNamePlural;     // The player-viewable name of the item (plural).
var const localized string strBriefSummary;   // A summary of the item to show in the Engineering UI.
var const localized string strTacticalText;   // Text shown in the detailed view of items. Should be formatted as bullet points to match other
                                              // items. See examples in XComGame.int, in the array m_aItemTacticalText, for the HTML to use.


delegate bool IsInfiniteDel();
delegate bool IsPriorityDel();

/// <summary>
/// Whether this item can be built. Does not include whether the item's cost can be afforded,
/// only whether the item is available to the player in the engineering UI.
/// </summary>
function bool CanBeBuilt()
{
    if (!bIsBuildable)
    {
        return false;
    }

    if (IsInfinite())
    {
        return false;
    }

    return `LWCE_HQ.ArePrereqsFulfilled(kPrereqs);
}

function bool CanBeSold()
{
    if (!bIsSellable)
    {
        return false;
    }

    if (IsInfinite())
    {
        return false;
    }

    return kCost.iCash > 0;
}

function LWCE_TCost GetCost(bool bRush)
{
    // TODO
    return kCost;
}

function name GetItemName()
{
    return DataName;
}

function int GetQuestPrice()
{
    local int iQuestPrice;
    local name MyName;
    local float fPerPointValue;

    iQuestPrice = 0;
    fPerPointValue = 0.0650; // TODO move to config

    iQuestPrice += kCost.iCash;
    iQuestPrice += int(fPerPointValue * iPointsToComplete);

    if (kCost.iAlloys > 0)
    {
        iQuestPrice += kCost.iAlloys * `LWCE_ITEM('Item_AlienAlloy').GetSalePrice();
    }

    if (kCost.iElerium > 0)
    {
        iQuestPrice += kCost.iElerium * `LWCE_ITEM('Item_Elerium').GetSalePrice();
    }

    if (`LWCE_HQ.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        MyName = GetItemName();

        if (MyName != 'Item_AlienAlloy' && MyName != 'Item_Elerium' && MyName != 'Item_Meld' && MyName != 'Item_WeaponFragment')
        {
            iQuestPrice /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    return iQuestPrice;
}

function int GetSalePrice()
{
    local LWCE_XGHeadquarters kHQ;
    local LWCE_TCost kCurrentCost;
    local int iSalePrice;
    local name MyName;

    kHQ = `LWCE_HQ;
    kCurrentCost = GetCost(/* bRush */ false);
    iSalePrice = kCurrentCost.iCash;
    MyName = GetItemName();

    if (bIsBuildable)
    {
        iSalePrice *= 0.4;
    }
    else if (kHQ.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        // TODO make a flag in template instead
        if (MyName != 'Item_AlienAlloy' && MyName != 'Item_Elerium' && MyName != 'Item_Meld' && MyName != 'Item_WeaponFragment')
        {
            iSalePrice /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    if (IsCorpse() && kHQ.HasBonus(`LW_HQ_BONUS_ID(XenologicalRemedies)) > 0)
    {
        iSalePrice *= (1.0f + (float(kHQ.HasBonus(`LW_HQ_BONUS_ID(XenologicalRemedies))) / 100.0f));
    }

    return iSalePrice;
}

function bool IsAlienArtifact()
{
    return nmCategory == 'AlienArtifact';
}

function bool IsArmor()
{
    return false;
}

function bool IsCaptive()
{
    return nmCategory == 'Captive';
}

function bool IsCorpse()
{
    return nmCategory == 'Corpse';
}

function bool IsEquipment()
{
    return false;
}

function bool IsInfinite()
{
    if (IsInfiniteFn != none)
    {
        return IsInfiniteFn();
    }

    return bIsInfinite;
}

function bool IsMecArmor()
{
    return false;
}

/// <summary>
/// Whether this item is a priority for the player to build in Engineering. Items which can't be built
/// will always return false.
/// </summary>
function bool IsPriority()
{
    if (!CanBeBuilt())
    {
        return false;
    }

    if (IsPriorityFn != none)
    {
        return IsPriorityFn();
    }

    return bIsPriority;
}

function bool IsShipWeapon()
{
    return false;
}

function bool IsWeapon()
{
    return false;
}

function bool ValidateTemplate(out string strError)
{
    // Normally we would fail for missing localization, but until we test how that works for non-INT locales
    // (e.g. will it fallback to INT properly), that would cause base game templates to not exist.

    /*
    if (strName == "")
    {
        strError = "Missing localization string 'strName'";
        return false;
    }
     */

    return super.ValidateTemplate(strError);
}