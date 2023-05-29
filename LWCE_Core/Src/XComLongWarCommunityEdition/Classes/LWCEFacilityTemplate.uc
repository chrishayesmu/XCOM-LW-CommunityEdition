class LWCEFacilityTemplate extends LWCEDataTemplate
    config(LWCEFacilities)
    dependson(LWCETypes);

var config bool bCanDestroy;           // Whether this facility can be torn down after construction.
var config bool bIsBuildable;          // Whether this facility can ever be built by the player, or if it's always created automatically. Do not use this
                                       // field to indicate when a facility is conditionally buildable; that's what prereqs are for.
var config bool bIsPriority;           // Whether this facility is a priority for the player once available, such as Alien Containment or Hyperwave Relay.
var config bool bIsTopLevel;           // Whether this is a top level facility, meaning it has an entry in the strategy layer
                                       // HUD along the top of the screen once built. If this is true, then the FacilityClass
                                       // field must be populated as well.
var config int iBuildTimeInHours;      // The base build time of the facility in hours.
var config int iMaxInstances;          // The maximum number of this facility that can be built in XCOM HQ.
var config int iMonthlyCost;           // How much money is spent at the end of each month to maintain this facility. If negative,
                                       // this facility produces money.
var config int iPowerConsumed;         // How much power this facility needs to operate. If negative, this facility
                                       // produces power.
var config int iSatelliteCapacity;     // How much satellite capacity this facility provides.
var config name nmRequiredTerrainType; // If set, the facility can only be built in terrain of this type (e.g. steam for Thermo Generators).
var config array<name> arrAdjacencies; // What type of adjacency bonuses this facility can have. Unlike the vanilla game, in LWCE,
                                       // a facility can have multiple adjacency types. This value is also used for determining a facility's
                                       // type, for bonuses such as reduced maintenance cost of power facilities.
var config LWCE_TCost kCost;
var config LWCE_TPrereqs kPrereqs;
var config array<LWCE_TStaffRequirement> arrStaffRequirements; // A static list of staff requirements to build this facility. If requirements
                                                               // are dynamic, such as increasing engineer requirements for Workshops, then the
                                                               // template must express that using StaffRequirementsFn.
var delegate<StaffRequirementsDel> StaffRequirementsFn;

var config string ImageLabel; // The image to display for this facility in the build UI; hardcoded in Flash.
var config string ImagePath;  // The image to display for this facility.

var config string FacilityClass;   // The full class name of the XGFacility subclass that should be instantiated when this
                                   // facility is built. Not all facilities have one of these.

var config string MapName;               // The name of the map to stream in that represents the facility.
var config string strBinkReveal;         // The name of the bink to play when this facility is constructed.
var config string strPostBuildNarrative; // The narrative to play after this facility is constructed.

var const localized string strName;       // The player-viewable name of the facility (singular).
var const localized string strNameInMenu; // The player-viewable name of the facility when it's in the menu at the top of the strategy HUD.
var const localized string strBriefSummary;

delegate array<LWCE_TStaffRequirement> StaffRequirementsDel();

function name GetFacilityName()
{
    return DataName;
}

/// <summary>
/// Determines whether this facility can be removed from the given base. It may not be able to for a number
/// of reasons, such as if it is providing power the base needs, or if the facility has active projects which
/// the player hasn't canceled.
/// /<summary>
function bool CanBeRemoved(const LWCE_XGBase kBase, int X, int Y, out string strError)
{
    local bool bCanRemove;
    local int iPower;

    bCanRemove = true;

    if (!bCanDestroy)
    {
        strError = "<< ERROR: not-removeable facility should have been caught before this point >>";
        return false;
    }

    iPower = GetPower();

    // Don't allow removing the facility if it's providing power we need for other facilities
    if (iPower < 0)
    {
        if (arrAdjacencies.Find('Power') != INDEX_NONE)
        {
            iPower += kBase.LWCE_GetSurroundingAdjacencies(X, Y, 'Power') * class'XGTacticalGameCore'.default.POWER_ADJACENCY_BONUS;
        }

        if (kBase.GetPowerAvailable() < iPower)
        {
            strError = "TODO not enough power"; // class'XGBuildUI'.const.m_strPowerCantRemoveBody;
            bCanRemove = false;
        }
    }

    // TODO introduce a delegate or event handler for this
    if (DataName == 'Facility_AlienContainment')
    {
    }

    return bCanRemove;
}

/// <summary>
/// Calculates how long it will take to build this facility, in hours.
/// </summary>
function int GetBuildTimeInHours(bool bRush)
{
    local LWCEDataContainer kDataContainer;
    local int iTimeInHours;

    iTimeInHours = iBuildTimeInHours;

    // EVENT: LWCEFacilityTemplate_GetBuildTimeInHours
    //
    // SUMMARY: Emitted when calculating how long a facility will take to build. Can be used to modify the build time.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - Out parameter. Current expected time to build the facility, in hours.
    //       Data[1]: bool - Whether the facility is being rushed. If so, the rush bonus has NOT been applied yet.
    //
    // SOURCE: LWCEFacilityTemplate
    kDataContainer = class'LWCEDataContainer'.static.New('LWCEFacilityTemplate_GetBuildTimeInHours');
    kDataContainer.AddInt(iTimeInHours);
    kDataContainer.AddBool(bRush);

    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetBuildTimeInHours', kDataContainer, self);

    iTimeInHours = kDataContainer.Data[0].I;

    if (bRush)
    {
        iTimeInHours /= 2; // TODO config this bonus
    }

    return iTimeInHours;
}

/// <summary>
/// Determines the cost to build this facility, based on the current campaign.
/// Should not be called outside of a campaign's strategy layer.
/// </summary>
function LWCE_TCost GetCost(bool bRush)
{
    local LWCEDataContainer kData;
    local LWCECost kProjectCost;
    local LWCE_TCost kAdjustedCost;

    kAdjustedCost = kCost;

    // EVENT: LWCEFacilityTemplate_GetCost
    //
    // SUMMARY: Triggered whenever LWCEFacilityTemplate.GetCost is called, to provide a hook which can dynamically adjust
    //          the cost of facilities.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCECost - The current cost of the project, adjusted by any event listeners which have already run.
    //                                  Note that any additional cost due to the project being rushed is applied after this event fires,
    //                                  so it is not reflected here.
    //       Data[1]: boolean - Whether this project is being rushed. Changing this will not affect whether the project is actually rushed
    //                          or not, but it will change whether the cost increasing due to rushing is assessed or not. Use this if your
    //                          mod is accounting for the rush costs on its own, and you want to prevent base game logic from running.
    //
    // SOURCE: LWCEFacilityTemplate - The template which is having its cost evaluated.
    kProjectCost = class'LWCECost'.static.FromTCost(kAdjustedCost);

    kData = class'LWCEDataContainer'.static.New('LWCEFacilityTemplate_GetCost');
    kData.AddObject(kProjectCost);
    kData.AddBool(bRush);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetCost', kData, self);

    kProjectCost = LWCECost(kData.Data[0].Obj);
    kAdjustedCost = kProjectCost.ToTCost();

    bRush = kData.Data[1].B;

    if (bRush)
    {
        // TODO move to config
        kAdjustedCost.iCash *= 1.5;
        kAdjustedCost.iAlloys *= 1.5;
        kAdjustedCost.iElerium *= 1.5;
        kAdjustedCost.iMeld += 20;
    }

    return kAdjustedCost;
}

/// <summary>
/// Determines how much money is spent per month to maintain this facility. If the returned
/// value is negative, this facility actually produces money.
/// </summary>
function int GetMonthlyCost()
{
    local LWCEDataContainer kDataContainer;

    // EVENT: LWCEFacilityTemplate_GetMonthlyCost
    //
    // SUMMARY: Emitted when calculating how much a facility costs at the end of each month.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - The monthly cost of this facility. Initially set to the template's iMonthlyCost field.
    //                      If the final value is negative, this facility will produce money rather than cost it.
    //
    // SOURCE: LWCEFacilityTemplate
    kDataContainer = class'LWCEDataContainer'.static.NewInt('LWCEFacilityTemplate_GetMonthlyCost', iMonthlyCost);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetMonthlyCost', kDataContainer, self);

    return kDataContainer.Data[0].I;
}

/// <summary>
/// Determines how much power is either consumed or produced by this facility. A positive return value indicates
/// power is consumed; a negative value indicates power is produced.
/// </summary>
function int GetPower()
{
    local LWCEDataContainer kDataContainer;

    // EVENT: LWCEFacilityTemplate_GetPower
    //
    // SUMMARY: Emitted when calculating how much power a facility consumes or produces.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - The power usage of this facility. Initially set to the template's iPowerConsumed field.
    //                      If the final value is negative, this facility will produce power rather than consume it.
    //
    // SOURCE: LWCEFacilityTemplate
    kDataContainer = class'LWCEDataContainer'.static.NewInt('LWCEFacilityTemplate_GetPower', iPowerConsumed);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetPower', kDataContainer, self);

    return kDataContainer.Data[0].I;
}

/// <summary>
/// Determines how many satellites a single instance of this facility can support.
/// </summary>
function int GetSatelliteCapacity()
{
    local LWCEDataContainer kDataContainer;

    // EVENT: LWCEFacilityTemplate_GetSatelliteCapacity
    //
    // SUMMARY: Emitted when calculating how much satellite capacity a facility provides (by itself, not including adjacencies).
    //          Can be used to modify the capacity, such as following a Foundry project. Do not include adjacency bonuses in the output!
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - The satellite capacity of this facility. Initially set to the template's iSatelliteCapacity field.
    //
    // SOURCE: LWCEFacilityTemplate
    kDataContainer = class'LWCEDataContainer'.static.NewInt('LWCEFacilityTemplate_GetSatelliteCapacity', iSatelliteCapacity);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetSatelliteCapacity', kDataContainer, self);

    return Max(kDataContainer.Data[0].I, 0);
}

/// <summary>
/// Gets the required staff which must be present before this facility can be built.
/// </summary>
function array<LWCE_TStaffRequirement> GetStaffRequirements()
{
    if (StaffRequirementsFn != none)
    {
        return StaffRequirementsFn();
    }

    return arrStaffRequirements;
}

/// <summary>
/// Whether this facility is a priority for the player to build. Usually this is used for story-critical facilities,
/// such as Alien Containment or the Hyperwave Relay.
/// </summary>
function bool IsBuildPriority()
{
    local bool IsPriority;
    local LWCEDataContainer kDataContainer;

    IsPriority = bIsPriority;

    // EVENT: LWCEFacilityTemplate_IsBuildPriority
    //
    // SUMMARY: Emitted when determining whether a facility is currently a priority for XCOM to build. This only impacts
    //          its display in the UI.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: bool - Out parameter. Whether this facility is currently a build priority for XCOM.
    //
    // SOURCE: LWCEFacilityTemplate
    kDataContainer = class'LWCEDataContainer'.static.NewBool('LWCEFacilityTemplate_IsBuildPriority', IsPriority);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_IsBuildPriority', kDataContainer, self);

    IsPriority = kDataContainer.Data[0].B;

    return IsPriority;
}