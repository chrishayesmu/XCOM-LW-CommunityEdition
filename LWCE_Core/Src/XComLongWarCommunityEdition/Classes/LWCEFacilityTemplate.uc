class LWCEFacilityTemplate extends LWCEDataTemplate
    config(LWCEFacilities)
    dependson(LWCETypes);

var config bool bCanDestroy;           // Whether this facility can be torn down after construction.
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

var config string ImagePath; // The image to display for this facility.

var config string FacilityClass;   // The full class name of the XGFacility subclass that should be instantiated when this
                                   // facility is built. Not all facilities have one of these.

var config string MapName; // The name of the map to stream in that represents the facility.
var config string strBinkReveal; // The name of the bink to play when this facility is constructed.

var const localized string strName;       // The player-viewable name of the facility (singular).
var const localized string strNamePlural; // The player-viewable name of the facility (plural).
var const localized string strBriefSummary;       

delegate array<LWCE_TStaffRequirement> StaffRequirementsDel();

function name GetFacilityName()
{
    return DataName;
}

function int GetBuildTimeInHours()
{

}

/// <summary>
/// Determines the cost to build this facility, based on the current campaign.
/// Should not be called outside of a campaign's strategy layer.
/// </summary>
function LWCE_TCost GetCost(bool bRush)
{
    local LWCEDataContainer kData;
    local LWCEProjectCost kProjectCost;
    local LWCE_TCost kAdjustedCost;

    kAdjustedCost = kCost;

    // EVENT: LWCEFacilityTemplate_GetCost
    //
    // SUMMARY: Triggered whenever LWCEFacilityTemplate.GetCost is called, to provide a hook which can dynamically adjust
    //          the cost of facilities.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCEProjectCost - The current cost of the project, adjusted by any event listeners which have already run.
    //                                  Note that any additional cost due to the project being rushed is applied after this event fires,
    //                                  so it is not reflected here.
    //       Data[1]: boolean - Whether this project is being rushed. Changing this will not affect whether the project is actually rushed
    //                          or not, but it will change whether the cost increasing due to rushing is assessed or not. Use this if your
    //                          mod is accounting for the rush costs on its own, and you want to prevent base game logic from running.
    //
    // SOURCE: LWCEFacilityTemplate - The template which is having its cost evaluated.
    kProjectCost = class'LWCEProjectCost'.static.FromTCost(kAdjustedCost);
    
    kData = class'LWCEDataContainer'.static.New('LWCEFacilityTemplate_GetCost');
    kData.AddObject(kProjectCost);
    kData.AddBool(bRush);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetCost', kData, self);

    kProjectCost = LWCEProjectCost(kData.Data[0].Obj);
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