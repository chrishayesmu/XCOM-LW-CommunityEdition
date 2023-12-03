class LWCEShipMissionTemplate extends LWCEDataTemplate
    config(LWCEBaseShipMissions);

/// <summary>
/// Configuration struct for defining which ships are eligible for missions.
/// See ini file for a detailed breakdown.
/// </summary>
struct LWCE_AIShipMissionConfig
{
    var int iMinResearch;  // Minimum alien research to use this config.
    var int iMaxResearch;  // Maximum alien research to use this config; -1 indicates no maximum.
    var int iMinResources; // Minimum alien resources to use this config.
    var int iMaxResources; // Maximum alien resources to use this config; -1 indicates no maximum.
    var int iRepeatPerExcessResources; // If set, adds extra entries for this config for every N resources the aliens possess beyond iMinResources.
    var name nmShipType;   // The name of an LWCEShipTemplate which will be used for the mission.

    structdefaultproperties
    {
        iMaxResearch=-1
        iMaxResources=-1
        iRepeatPerExcessResources=-1
    }
};

var config int iStartDays;
var config int iRandomDays;
var config int iFlightRadius;
var config name nmFlightPlan;
var config array<LWCE_AIShipMissionConfig> arrPossibleShips;

function name GetMissionName()
{
    return DataName;
}

/// <summary>
/// Breaks down this mission's flight plan into its individual steps, and for flight plans which
/// involve spending some time in the target area, gets the duration to remain. (TODO: units of duration?)
/// </summary>
function array<name> GetFlightPlanSteps(out float fDuration)
{
    local array<name> arrFlightPlan;

    switch (nmFlightPlan)
    {
        case 'Direct':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('Land');

            break;
        case 'Dropoff':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('FlyOver');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');

            break;
        case 'QuickSpecimen':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 4.0;

            break;
        case 'LongSpecimen':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('SpendTime');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 4.0;

            break;
        case 'QuickScout':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('SpendTime');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 4.0;

            break;
        case 'LongScout':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('SpendTime');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 6.0;

            break;
        case 'Flyby':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('SpendTime');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 4.0;

            break;
        case 'Seek':
            arrFlightPlan.AddItem('Arrive');
            arrFlightPlan.AddItem('SpendTime');
            arrFlightPlan.AddItem('Land');
            arrFlightPlan.AddItem('Depart');
            arrFlightPlan.AddItem('LiftOff');
            fDuration = 6.0;

            break;
    }

    return arrFlightPlan;
}

/// <summary>
/// Determines the ships which can potentially be used for this mission, based on the current
/// alien research and resources. Entries in the returned array may contain duplicates.
/// </summary>
function array<name> GetPossibleShips(int iAlienResearch, int iAlienResources)
{
    local LWCE_AIShipMissionConfig kConfig;
    local array<name> arrShips;
    local int iNumRepeats;

    iAlienResearch = Max(0, iAlienResearch);
    iAlienResources = Max(0, iAlienResources);

    foreach arrPossibleShips(kConfig)
    {
        if (iAlienResearch < kConfig.iMinResearch)
        {
            continue;
        }

        if (iAlienResearch > kConfig.iMaxResearch && kConfig.iMaxResearch > 0)
        {
            continue;
        }

        if (iAlienResources < kConfig.iMinResources)
        {
            continue;
        }

        if (iAlienResources > kConfig.iMaxResources && kConfig.iMaxResources > 0)
        {
            continue;
        }

        arrShips.AddItem(kConfig.nmShipType);

        // Repeats: config can be set so that, for every N resources above the threshold needed to trigger
        // this entry, the same ship type is added into the results again. This emulates the way that the most
        // resource-intensive UFO would become increasingly likely in Long War's UFO selection logic.
        if (kConfig.iRepeatPerExcessResources > 0)
        {
            iNumRepeats = (iAlienResources - kConfig.iMinResources) / kConfig.iRepeatPerExcessResources;

            while (iNumRepeats > 0)
            {
                arrShips.AddItem(kConfig.nmShipType);
                iNumRepeats--;
            }
        }
    }

    return arrShips;
}

/// <summary>
/// Rolls for what ship should be used to conduct a mission of this type. If more than one ship type
/// is possible, the outcome is random.
/// </summary>
function name RollForShip(int iAlienResearch, int iAlienResources)
{
    local array<name> arrShips;

    arrShips = GetPossibleShips(iAlienResearch, iAlienResources);

    if (arrShips.Length == 0)
    {
        return '';
    }

    return arrShips[Rand(arrShips.Length)];
}