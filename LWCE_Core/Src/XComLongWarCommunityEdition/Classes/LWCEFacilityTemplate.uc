class LWCEFacilityTemplate extends LWCEDataTemplate
    config(LWCEFacilities);

var config bool bCanDestroy; // Whether this facility can be torn down after construction.
var config int iBuildTimeInHours; // The base build time of the facility in hours.
var config int iMaxInstances; // The maximum number of this facility that can be built in XCOM HQ.
var config int iMaintenanceCost; // How much money is spent at the end of each month to maintain this facility.
var config int iPowerConsumed; // How much power this facility needs to operate. If negative, this facility
                               // produces power. 
var config LWCE_TCost kCost;
var config LWCE_TPrereqs kPrereqs;

var const localized string strName;       // The player-viewable name of the facility (singular).
var const localized string strNamePlural; // The player-viewable name of the facility (plural).
var const localized string strBriefSummary;       

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

    if (bRush)
    {
        // TODO move to config
        kAdjustedCost.iCash *= 1.5;
        kAdjustedCost.iAlloys *= 1.5;
        kAdjustedCost.iElerium *= 1.5;
        kAdjustedCost.iMeld += 20;
    }

    // EVENT: LWCEFacilityTemplate_GetCost
    //
    // SUMMARY: Triggered whenever LWCEFacilityTemplate.GetCost is called, to provide a hook which can dynamically adjust
    //          the cost of facilities.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCEProjectCost - The current cost of the project, adjusted by any event listeners which have already run,
    //                                  and with the cost adjustment due to rushing the project applied if applicable.
    //       Data[1]: boolean - Whether this project is being rushed.
    //
    // SOURCE: LWCEFacilityTemplate - The template which is having its cost evaluated.
    kProjectCost = class'LWCEProjectCost'.static.FromTCost(kAdjustedCost);
    
    kData = class'LWCEDataContainer'.static.New('LWCEFacilityTemplate_GetCost');
    kData.AddObject(kProjectCost);
    kData.AddBool(bRush);
    `LWCE_EVENT_MGR.TriggerEvent('LWCEFacilityTemplate_GetCost', kData, self);

    kProjectCost = LWCEProjectCost(kData.Data[0].Obj);
    kAdjustedCost = kProjectCost.ToTCost();

    return kAdjustedCost;
}