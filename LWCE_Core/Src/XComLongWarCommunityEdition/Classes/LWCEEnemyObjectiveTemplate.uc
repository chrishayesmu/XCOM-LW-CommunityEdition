class LWCEEnemyObjectiveTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyAI);

// What algorithm to use when picking a target country (and possibly city) for this objective.
// Base game values can be `SatelliteCovered`, `ProtectAlienBases`, `Terrorize`,
var config name nmTargetSelectionAlgorithm;

// The individual ship missions which make up this objective. Each entry in this array must
// correspond to an LWCEShipMissionTemplate instance.
var config array<name> arrMissions;

// The objective's name, which is shown to the player if they have the Hyperwave Relay.
var const localized string strName;

function bool ValidateTemplate(out string strError)
{
    if (arrMissions.Length == 0)
    {
        strError = "No missions configured for objective";
        return false;
    }

	return super.ValidateTemplate(strError);
}