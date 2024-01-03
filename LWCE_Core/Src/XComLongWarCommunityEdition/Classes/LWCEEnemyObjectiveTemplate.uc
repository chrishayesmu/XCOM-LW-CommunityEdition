class LWCEEnemyObjectiveTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyAI);

// What algorithm to use when picking a target country (and possibly city) for this objective.
// See ini file for possible values.
var config name nmTargetSelectionAlgorithm;

// How to select the exact coordinates that will be used when ships are flying to this objective.
var config name nmFineGrainedTarget;

var config int iStartDays;
var config int iRandomDays;
var config bool bSpreadThroughoutMonth;

// The individual ship missions which make up this objective. Each entry in this array must
// correspond to an LWCEShipMissionTemplate instance.
var config array<name> arrMissions;

var array< delegate<OnObjectiveSuccessful> > arrOnSuccessDelegates;

// The objective's name, which is shown to the player if they have the Hyperwave Relay.
var const localized string strName;

delegate OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip);

function name GetObjectiveName()
{
    return DataName;
}

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

function bool ValidateTemplate(out string strError)
{
    if (arrMissions.Length == 0)
    {
        strError = "No missions configured for objective";
        return false;
    }

	return super.ValidateTemplate(strError);
}
