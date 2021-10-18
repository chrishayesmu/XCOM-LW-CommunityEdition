class Highlander_XGStrategyAI extends XGStrategyAI
    config(HighlanderStrategyAI);

struct HL_AIMissionPlan
{
    var int FirstValidMonth;
    var int LastValidMonth;
    var int MinResources;
    var int MaxResources;
    var int MinThreat;
    var int MaxThreat;

    var float NumAbductions;
    var float NumAirBaseDefenses;
    var float NumBombings;
    var float NumHarvests;
    var float NumHunts;
    var float NumInfiltrations;
    var float NumResearches;
    var float NumScouts;
    var float NumTerrors;

    structdefaultproperties
    {
        FirstValidMonth=-1
        LastValidMonth=-1
        MinResources=-1
        MaxResources=-1
        MinThreat=-1
        MaxThreat=-1

        NumAbductions=0
        NumAirBaseDefenses=0
        NumBombings=0
        NumHarvests=0
        NumHunts=0
        NumInfiltrations=0
        NumResearches=0
        NumScouts=0
        NumTerrors=0
    }
};

var config array<HL_AIMissionPlan> PossibleMissionPlans;
var config bool bForceFirstMonthInfiltration;

var config int MaxThreatCarriedOverEachMonth;
var config int ThreatDecreasePerMonth;

var config int MaxTargetedTerrorsPerMonth;
var config int IndiscriminateTerrorResourceThreshold;
var config int CiviliansLostPanicIncreaseThreshold;
var config int CiviliansSavedPanicDecreaseThreshold;
var config int ContinentPanicIncreasePerLostCivilian;
var config int CountryPanicIncreasePerLostCivilian;
var config int ContinentPanicDecreasePerSavedCivilian;
var config int CountryPanicDecreasePerSavedCivilian;
var config int NumCiviliansSavedToPreventCountryLeaving;

// Config related to alien gains per month
var config int MaximumResources;
var config int MonthlyResearchPerBase;
var config int MonthlyResourcesPerBase;
var config int ResourceFloorPerMonthPassed;

// Config related to XCOM HQ assault (base defense mission)
var config int MaxNumHQAssaultMissions;
var config int MinResourcesForHQAssaultCounter;
var config int MinThreatForHQAssaultCounter;
var config int CounterValueToSpawnHQAssault;
var config int MonthToForceSpawnHQAssault;

function AIAddNewObjectives()
{
    local array<ECountry> arrVisibleTargets;
    local bool bSpawnedHQAssault;
    local int CountryID;
    local int Index;
    local int iNumAbductions, iNumAirBaseDefenses, iNumBombings, iNumHarvests, iNumHunts, iNumInfiltrations, iNumResearches, iNumScouts, iNumTerrors;
    local int StartOfMonthResources, StartOfMonthThreat;
    local HL_AIMissionPlan MissionPlan;

    `HL_LOG(string(Class) $ ": AIAddNewObjectives start");

    // Use the default logic for Dynamic War; make sure to do this before modifying
    // any state or else it will be modified twice
    if (IsOptionEnabled(9))
    {
        `HL_LOG("Dynamic War not currently supported. Falling back to base LW logic for adding missions.");
        super.AIAddNewObjectives();

        return;
    }

    // Calculate what our resources will be without updating them, in case we need to fall back to the
    // superclass method, which will also update them
    StartOfMonthResources = STAT_GetStat(19) + MonthlyResourcesPerBase * World().GetNumDefectors();
    StartOfMonthResources = Clamp(StartOfMonthResources, ResourceFloorPerMonthPassed * GetMonth(), MaximumResources);
    StartOfMonthThreat = STAT_GetStat(21);

    if (!PickMissionPlan(GetMonth(), StartOfMonthResources, StartOfMonthThreat, MissionPlan))
    {
        `HL_LOG("Unable to select a mission plan! Falling back to base LW logic for adding missions.");
        super.AIAddNewObjectives();

        return;
    }

    STAT_SetStat(19, StartOfMonthResources);

    iNumAbductions      = RollMissionCount(MissionPlan.NumAbductions);
    iNumAirBaseDefenses = RollMissionCount(MissionPlan.NumAirBaseDefenses);
    iNumBombings        = RollMissionCount(MissionPlan.NumBombings);
    iNumHarvests        = RollMissionCount(MissionPlan.NumHarvests);
    iNumHunts           = RollMissionCount(MissionPlan.NumHunts);
    iNumInfiltrations   = RollMissionCount(MissionPlan.NumInfiltrations);
    iNumResearches      = RollMissionCount(MissionPlan.NumResearches);
    iNumScouts          = RollMissionCount(MissionPlan.NumScouts);
    iNumTerrors         = RollMissionCount(MissionPlan.NumTerrors);

    `HL_LOG("AIAddNewObjectives: iNumAbductions = " $ iNumAbductions);
    `HL_LOG("AIAddNewObjectives: iNumAirBaseDefenses = " $ iNumAirBaseDefenses);
    `HL_LOG("AIAddNewObjectives: iNumBombings = " $ iNumBombings);
    `HL_LOG("AIAddNewObjectives: iNumHarvests = " $ iNumHarvests);
    `HL_LOG("AIAddNewObjectives: iNumHunts = " $ iNumHunts);
    `HL_LOG("AIAddNewObjectives: iNumInfiltrations = " $ iNumInfiltrations);
    `HL_LOG("AIAddNewObjectives: iNumResearches = " $ iNumResearches);
    `HL_LOG("AIAddNewObjectives: iNumScouts = " $ iNumScouts);
    `HL_LOG("AIAddNewObjectives: iNumTerrors = " $ iNumTerrors);

    AddNewAbductions(iNumAbductions, false);
    AddNewTerrors(iNumTerrors, StartOfMonthResources);

    for (Index = 0; Index < iNumAirBaseDefenses; Index++) {
        AddLateMission();
    }

    for (Index = 0; Index < iNumBombings; Index++) {
        AddUFOs(8, arrVisibleTargets);
    }

    for (Index = 0; Index < iNumHarvests; Index++) {
        AddUFOs(eObjective_Harvest, arrVisibleTargets);
    }

    for (Index = 0; Index < iNumHunts; Index++) {
        AddUFOs(eObjective_Hunt, arrVisibleTargets);
    }

    for (Index = 0; Index < iNumInfiltrations; Index++) {
        AddUFOs(eObjective_Infiltrate, arrVisibleTargets);
    }

    for (Index = 0; Index < iNumResearches; Index++) {
        AddUFOs(eObjective_Recon, arrVisibleTargets);
    }

    for (Index = 0; Index < iNumScouts; Index++) {
        AddUFOs(eObjective_Scout, arrVisibleTargets);
    }

    // Reduce and clamp threat at the start of each month
    STAT_SetStat(21, Clamp(STAT_GetStat(21) - ThreatDecreasePerMonth, 0, MaxThreatCarriedOverEachMonth));

    // Force an infiltration mission in the first month
    if (bForceFirstMonthInfiltration && GetMonth() == 0)
    {
        CountryID = World().GetRandomCouncilCountry().GetID();

        // Don't infiltrate on the starting continent, too disruptive
        while (Country(CountryID).GetContinent() == Country(HQ().GetHomeCountry()).GetContinent())
        {
            CountryID = World().GetRandomCouncilCountry().GetID();
        }

        AIAddNewObjective(eObjective_Infiltrate, 5 + Rand(5), Country(CountryID).GetCoords(), CountryID);
    }

    // If not at max HQ assaults yet, increment the counter if currently valid
    if (MaxNumHQAssaultMissions < 0 || MaxNumHQAssaultMissions > Game().GetNumMissionsTaken(eMission_HQAssault))
    {
        if (StartOfMonthResources >= MinResourcesForHQAssaultCounter && StartOfMonthThreat >= MinThreatForHQAssaultCounter)
        {
            `HL_LOG("Requirements met: incrementing HQ assault counter (stat 22)");
            STAT_AddStat(22, 1);

            if (STAT_GetStat(22) == CounterValueToSpawnHQAssault)
            {
                `HL_LOG("HQ assault counter has reached required value " $ CounterValueToSpawnHQAssault $ ". Spawning HQ assault and resetting counter.");
                bSpawnedHQAssault = true;
                AddHQAssaultMission();
                STAT_SetStat(22, 0);
            }
        }
    }

    // Force spawn an HQ assault if configured to do so, and if we've gone long enough without one
    if (!bSpawnedHQAssault && MonthToForceSpawnHQAssault >= 0 && GetMonth() >= MonthToForceSpawnHQAssault && Game().GetNumMissionsTaken(eMission_HQAssault) == 0)
    {
        `HL_LOG("Force-spawning HQ assault mission");
        AddHQAssaultMission();
        STAT_SetStat(22, 0);
    }

    AddNewOverseers();
    AddCouncilMission();

    // This is at the end of the original function, so it's at the end here too
    STAT_AddStat(2, MonthlyResearchPerBase * World().GetNumDefectors());

    // Not sure what this does, but it's in the original
    m_iCounter = 0;

    `HL_LOG(string(Class) $ ": AIAddNewObjectives complete");
}

function AddNewTerrors(int iNumTerrors, int StartOfMonthResources)
{
    local int Index;
    local ECountry TargetCountry;

    for (Index = 0; Index < iNumTerrors; Index++) {
        if ( (MaxTargetedTerrorsPerMonth < 0 || Index < MaxTargetedTerrorsPerMonth) &&
             (IndiscriminateTerrorResourceThreshold < 0 || StartOfMonthResources < IndiscriminateTerrorResourceThreshold) )
        {
            TargetCountry = DetermineBestTerrorTarget();
        }
        else
        {
            TargetCountry = ECountry(World().GetRandomCouncilCountry().GetID());
        }

        AddNewTerrorMission(TargetCountry, 1 + Rand(23));
    }
}

/**
 * Calculates the change in panic after a terror mission for both the country and continent.
 * Returns true if the country should leave the XCOM Project after this mission, false if not.
 */
function bool CalcTerrorMissionPanicResult(out int iCountryPanicChange, out int iContinentPanicChange)
{
    local int CiviliansLost, CiviliansSaved, CiviliansTotal;
    local int ExtraCivilians;
    local XGHeadQuarters kHQ;

    kHQ = HQ();

    // Some mods (i.e. LOS indicator's invisible sectoid/chryssalid) cause there to be more civilians than there should be,
    // so those extra units are showing up in either saved or lost. They're more likely to be saved, because it's rare for
    // the AI to shoot them, so if they exist, we remove them from the civilians saved.
    // TODO: ideally we would hook into the battle itself and check whether each unit on the civilian team is actually a
    // civilian unit or not, then transfer that info back to strategy.

    CiviliansTotal = class'XGBattleDesc'.default.m_iNumTerrorCivilians;
    ExtraCivilians = Max(kHQ.m_kLastResult.iCiviliansTotal - CiviliansTotal, 0);
    CiviliansLost = kHQ.m_kLastResult.iCiviliansTotal - kHQ.m_kLastResult.iCiviliansSaved;
    CiviliansSaved = kHQ.m_kLastResult.iCiviliansSaved;

    if (ExtraCivilians != 0) {
        `HL_LOG("WARNING: there are " $ ExtraCivilians $ " more civilian units than there should be. Likely this is due to a mod. "
              $ "These units will be removed from the count of civilians saved under the assumption that they did not die.");

        CiviliansSaved -= ExtraCivilians;
    }

    CiviliansLost = Clamp(CiviliansLost, 0, CiviliansTotal);
    CiviliansSaved = Clamp(CiviliansSaved, 0, CiviliansTotal);

    `HL_LOG("CiviliansTotal = " $ CiviliansTotal $ "; ExtraCivilians = " $ ExtraCivilians $ "; CiviliansLost = " $ CiviliansLost $ "; CiviliansSaved = " $ CiviliansSaved);

    // If we saved more than the threshold limit of civilians, then we should decrease panic as a reward
    if (CiviliansSavedPanicDecreaseThreshold >= 0 && CiviliansSaved > CiviliansSavedPanicDecreaseThreshold)
    {
        `HL_LOG(CiviliansSaved $ " civilians were saved, surpassing the threshold of " $ CiviliansSavedPanicDecreaseThreshold $ ". Panic will be decreased.");
        CiviliansSaved -= CiviliansSavedPanicDecreaseThreshold;

        iContinentPanicChange = CiviliansSaved * ContinentPanicDecreasePerSavedCivilian;
        iCountryPanicChange = CiviliansSaved * CountryPanicDecreasePerSavedCivilian;
    }
    else
    {
        if (CiviliansLostPanicIncreaseThreshold > 0) {
            `HL_LOG("Adjusting civilians lost from " $ CiviliansLost $ " to " $ (CiviliansLost - CiviliansLostPanicIncreaseThreshold));
            CiviliansLost = Max(0, CiviliansLost - CiviliansLostPanicIncreaseThreshold);
        }

        iContinentPanicChange = CiviliansLost * ContinentPanicIncreasePerLostCivilian;
        iCountryPanicChange = CiviliansLost * CountryPanicIncreasePerLostCivilian;
    }

    `HL_LOG("iContinentPanicChange = " $ iContinentPanicChange $ " and iCountryPanicChange = " $ iCountryPanicChange);

    // If not enough civilians were saved, the country will leave immediately
    if (CiviliansSaved < NumCiviliansSavedToPreventCountryLeaving)
    {
        `HL_LOG(CiviliansSaved $ " civilians were saved, failing to meet threshold of " $ NumCiviliansSavedToPreventCountryLeaving $ "; country will leave XCOM");
        return true;
    }

    return false;
}

function bool PickMissionPlan(int Month, int Resources, int Threat, out HL_AIMissionPlan MissionPlan)
{
    local int Index;
    local HL_AIMissionPlan Candidate;
    local array<HL_AIMissionPlan> ValidCandidates;

    `HL_LOG("Selecting a mission plan out of" @ PossibleMissionPlans.Length @ "configured");

    if (PossibleMissionPlans.Length == 0) {
        `HL_LOG("No mission plans are configured!");
        return false;
    }

    foreach PossibleMissionPlans(Candidate) {
        if (Candidate.FirstValidMonth >= 0 && Month < Candidate.FirstValidMonth) {
            continue;
        }

        if (Candidate.LastValidMonth >= 0 && Month > Candidate.LastValidMonth) {
            continue;
        }

        if (Candidate.MinResources >= 0 && Resources < Candidate.MinResources) {
            continue;
        }

        if (Candidate.MaxResources >= 0 && Resources > Candidate.MaxResources) {
            continue;
        }

        if (Candidate.MinThreat >= 0 && Threat < Candidate.MinThreat) {
            continue;
        }

        if (Candidate.MaxThreat >= 0 && Threat > Candidate.MaxThreat) {
            continue;
        }

        ValidCandidates.AddItem(Candidate);
    }

    `HL_LOG("Found " $ ValidCandidates.Length $ " possible mission plan(s) to choose from");

    if (ValidCandidates.Length == 0) {
        return false;
    }

    Index = Rand(ValidCandidates.Length);
    MissionPlan = ValidCandidates[Index];

    `HL_LOG("Selected mission plan at index " $ Index);
    return true;
}

function int RollMissionCount(float Count)
{
    local int iCount;

    if (Count <= 0) {
        return 0;
    }

    iCount = FFloor(Count);

    // If we roll under the fractional part, add a mission
    if (FRand() < (Count - iCount)) {
        return iCount + 1;
    }

    return iCount;
}