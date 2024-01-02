class LWCEMissionPlanTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyAI)
    dependson(LWCETypes);

struct LWCE_TMissionObjectivePlan
{
    var name nmObjective;
    var LWCE_TRange kAmount;
};

var config int iFirstMonthValid; // The first month this plan can be used, where 0 is the campaign's start month, 1 is the month after that, etc.
var config int iLastMonthValid;  // The last month this plan can be used.
var config int iMinResources;    // Aliens must have at least this many resources to consider this mission plan.
var config int iMaxResources;    // Aliens must have at most this many resources to consider this mission plan.
var config int iMinThreat;       // XCOM's threat level must be at least this high for the aliens to consider this mission plan.
var config int iMaxThreat;       // XCOM's threat level must be no higher than this for the aliens to consider this mission plan.

// If this plan is chosen, these are the objectives that the aliens will run for the month.
var config array<LWCE_TMissionObjectivePlan> arrObjectives;

function name GetMissionPlanName()
{
    return DataName;
}

/// <summary>
/// Checks if this plan is eligible to be used by the strategy AI, based on its configuration.
/// </summary>
function bool IsEligible(int Month, int Resources, int Threat)
{
    if (iFirstMonthValid >= 0 && Month < iFirstMonthValid)
    {
        return false;
    }

    if (iLastMonthValid >= 0 && Month > iLastMonthValid)
    {
        return false;
    }

    if (iMinResources >= 0 && Resources < iMinResources)
    {
        return false;
    }

    if (iMaxResources >= 0 && Resources > iMaxResources)
    {
        return false;
    }

    if (iMinThreat >= 0 && Threat < iMinThreat)
    {
        return false;
    }

    if (iMaxThreat >= 0 && Threat > iMaxThreat)
    {
        return false;
    }

    return true;
}