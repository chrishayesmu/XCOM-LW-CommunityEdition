/// <summary>
/// Simple data container class specific to the costs of working on projects. This class mirrors
/// the LWCE_TCost struct for ease-of-use in event handlers, and for extension by mods which may
/// add a new resource type. The struct should generally be used for config variables, as it is
/// far easier to write the struct values inline.
/// </summary>
class LWCECost extends Object;

var int iCash;
var int iAlloys;
var int iElerium;
var int iMeld;
var int iWeaponFragments;
var array<LWCE_TItemQuantity> arrItems;

static function LWCECost FromTCost(const out LWCE_TCost kCost)
{
    local LWCECost kProjectCost;

    kProjectCost = new class'LWCECost';

    kProjectCost.iCash = kCost.iCash;
    kProjectCost.iAlloys = kCost.iAlloys;
    kProjectCost.iElerium = kCost.iElerium;
    kProjectCost.iMeld = kCost.iMeld;
    kProjectCost.iWeaponFragments = kCost.iWeaponFragments;
    kProjectCost.arrItems = kCost.arrItems;

    return kProjectCost;
}

function LWCE_TCost ToTCost()
{
    local LWCE_TCost kCost;

    kCost.iCash = iCash;
    kCost.iAlloys = iAlloys;
    kCost.iElerium = iElerium;
    kCost.iMeld = iMeld;
    kCost.iWeaponFragments = iWeaponFragments;
    kCost.arrItems = arrItems;

    return kCost;
}