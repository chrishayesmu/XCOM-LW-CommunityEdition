class LWCEEnemyObjectiveTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyAI);

// What algorithm to use when picking a target country (and possibly city) for this objective.
// Base game values can be `SatelliteCovered`, `ProtectAlienBases`, `Terrorize`,
var config name nmTargetSelectionAlgorithm;

// The individual ship missions which make up this objective. Each entry in this array must
// correspond to an LWCEShipMissionTemplate instance.
var config array<name> arrMissions;

var array< delegate<OnObjectiveSuccessful> > arrOnSuccessDelegates;

// The objective's name, which is shown to the player if they have the Hyperwave Relay.
var const localized string strName;

delegate OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip);

/// <summary>
/// Called when an objective using this template has succeeded (i.e. the last ship configured in the objective
/// has completed its mission).
/// </summary>
function ObjectiveSucceeded(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local delegate<OnObjectiveSuccessful> SuccessDel;

    foreach arrOnSuccessDelegates(SuccessDel)
    {
        SuccessDel(kObj, kLastShip);
    }
}

/// <summary>
/// Selects a country for this objective, following the configured target selection algorithm.
/// Note that this function is NOT idempotent; aside from having random elements, the algorithm
/// is also allowed to have side effects (e.g. the AvoidSatellites algorithm can sometimes deduct
/// from alien resources).
/// </summary>
function name SelectTargetCountry()
{
    // We can eventually add an event to allow extending these algorithms, whenever somebody asks for it

    switch (nmTargetSelectionAlgorithm)
    {
        case 'AvoidSatellites':
            return SelectTargetCountry_AvoidSatellites();
        case 'ProtectAlienBases':
            return SelectTargetCountry_ProtectAlienBases();
        case 'SatelliteCovered':
            return SelectTargetCountry_SatelliteCovered();
        case 'SpreadPanic':
            return SelectTargetCountry_SpreadPanic();
        case 'Terrorize':
            return SelectTargetCountry_Terrorize();
        case 'XComAdvancedAirBase':
            return SelectTargetCountry_XComAdvancedAirBase();
        case 'XComHQ':
            return SelectTargetCountry_XComHQ();
        case 'XComMember':
            return SelectTargetCountry_XComMember();
    }

    return '';
}

function bool ValidateTemplate(out string strError)
{
    if (arrMissions.Length == 0)
    {
        strError = "No missions configured for objective";
        return false;
    }

	return super.ValidateTemplate(strError);
}
