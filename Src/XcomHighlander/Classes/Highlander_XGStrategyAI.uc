class Highlander_XGStrategyAI extends XGStrategyAI
    config(HighlanderBaseStrategyGame);

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

    `HL_LOG_CLS("AIAddNewObjectives start");

    // Use the default logic for Dynamic War; make sure to do this before modifying
    // any state or else it will be modified twice
    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
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

    `HL_LOG_CLS("AIAddNewObjectives complete");
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

function XGMission CreateTempleMission()
{
    local XGMission_TempleShip kMission;

    kMission = Spawn(class'XGMission_TempleShip');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCity = -1;
    kMission.m_iContinent = -1;
    kMission.m_iDuration = -1;
    kMission.m_v2Coords = vect2d(0.4150, 0.5570);
    kMission.m_iMissionType = eMission_Final;

    return kMission;
}

function XGMission CheatTerrorMission()
{
    local XGMission_Terror kMission;

    kMission = Spawn(class'XGMission_Terror');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCity = 4;
    kMission.m_iCountry = 0;
    kMission.m_iContinent = 0;
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_Terror);
    kMission.m_v2Coords = CITY(4).m_v2Coords;
    kMission.m_kDesc.m_kAlienSquad = DetermineTerrorSquad();

    return kMission;
}

function XGMission CreateTerrorMission(XGShip_UFO kUFO)
{
    local XGMission_Terror kMission;

    kMission = Spawn(class'XGMission_Terror');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCity = kUFO.m_kObjective.m_iCityTarget;
    kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
    kMission.m_iContinent = kUFO.GetContinent();
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_Terror);
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_kDesc.m_kAlienSquad = DetermineTerrorSquad();

    return kMission;
}

function XGMission CreateHQAssaultMission()
{
    local XGMission_HQAssault kMission;

    kMission = Spawn(class'XGMission_HQAssault');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iContinent = HQ().GetContinent();
    kMission.m_v2Coords = HQ().GetCoords();
    kMission.m_kDesc.m_kAlienSquad = DetermineHQAssaultSquad();

    return kMission;
}

function XGMission CreateExaltRaidMission(ECountry ExaltCountry)
{
    local XGMission_ExaltRaid kMission;

    kMission = Spawn(class'XGMission_ExaltRaid');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCity = Country(ExaltCountry).GetRandomCity();
    kMission.m_iCountry = ExaltCountry;
    kMission.m_iContinent = Country(ExaltCountry).GetContinent();
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_kDesc.m_kAlienSquad = DetermineExaltRaidSquad();

    return kMission;
}

/**
 * This function has been rewritten to create an air base defense mission.
 */
function XGMission CheatCrash(XGShip_UFO strMapName)
{
    local XGMission_UFOLanded kMission;

    kMission = Spawn(class'XGMission_UFOLanded');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_bScripted = true;
    kMission.m_kDesc.m_bScripted = true;
    kMission.m_iCity = -1;
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_AirBaseDefense);
    kMission.m_kDesc.m_kAlienSquad = DetermineAbductionSquad(9);
    kMission.m_kDesc.m_iMissionType = 14;
    kMission.m_strTitle = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strLabelViewAbductionSitesFlying);
    kMission.m_strSituation = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strPanicRemedy);
    kMission.m_strObjective = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strLabelMessageFromFoundry);
    kMission.m_kDesc.m_strMapName = "EWI_HQAssault_MP (Airbase Defense)";
    kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
    kMission.m_v2Coords = strMapName.GetCoords();
    kMission.m_iContinent = strMapName.GetContinent();

    return kMission;
}

function CheatLandedUFO(string strMapName)
{
    local XGMission_UFOLanded kMission;
    local XComMapMetaData kMapMeta;

    if (XComEngine(class'Engine'.static.GetEngine()).MapManager.GetMapInfoFromDisplayName(strMapName, kMapMeta))
    {
        kMission = Spawn(class'XGMission_UFOLanded');
        kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
        kMission.m_iContinent = 0;
        kMission.m_iCountry = 0;
        kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_LandedScout); // just pick a random entry for cheats
        kMission.m_v2Coords = CITY(8).m_v2Coords;
        kMission.m_kDesc.m_kAlienSquad = DetermineUFOSquad(none, true, kMapMeta.ShipType);

        if (Country(0).HasSatelliteCoverage())
        {
            kMission.m_iDetectedBy = HQ().GetSatellite(0);
        }
        else
        {
            kMission.m_iDetectedBy = -1;
        }

        kMission.m_bCheated = true;
        kMission.m_kDesc.m_strMapName = strMapName;
        GEOSCAPE().AddMission(kMission);
    }
}

function CreateAlienBase()
{
    local XGCountry kCountry;
    local XGMission_AlienBase kMission;

    kCountry = Country(m_iAlienMonth);

    if (kCountry == none)
    {
        return;
    }

    if (!kCountry.IsCouncilMember())
    {
        return;
    }

    if (!kCountry.LeftXCom())
    {
        return;
    }

    kMission = Spawn(class'XGMission_AlienBase');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCountry = kCountry.GetID();
    kMission.m_v2Coords = CITY(kCountry.GetRandomCity()).m_v2Coords;
    kMission.m_strTitle = kMission.m_strTitle $ kCountry.GetName();
    kMission.m_kDesc.m_kAlienSquad = DetermineAlienBaseSquad();

    PopulateMissionRewards(kMission, `HL_STRATCFG(AlienBaseAssaultRewards));

    kMission.m_arrArtifacts[`LW_ITEM_ID(Elerium)] += int(class'XGTacticalGameCore'.default.UFO_ELERIUM_PER_POWER_SOURCE[Game().GetDifficulty()] * float(kMission.m_arrArtifacts[`LW_ITEM_ID(UFOPowerSource)]));

    if (OBJECTIVES().m_eObjective == eObj_AssaultAlienBase)
    {
        kMission.m_arrArtifacts[`LW_ITEM_ID(HyperwaveBeacon)] = 1;
    }
    else
    {
        kMission.m_arrArtifacts[`LW_ITEM_ID(HyperwaveBeacon)] = 0;
    }

    kMission.m_iDetectedBy = 0;

    GEOSCAPE().AddMission(kMission);
}

function XGMission CreateFirstMission()
{
    local XGMission_Abduction kMission;
    local XGMission_FundingCouncil kMeldMission;
    local TFCMission kMeldData;
    local ECountry MeldCountry;

    if (ISCONTROLLED())
    {
        return CreateFirstMission_Controlled();
    }

    if (`HQGAME.GetGameCore().m_bMeldTutorial)
    {
        MeldCountry = ECountry(Continent(HQ().GetContinent()).GetRandomCouncilCountry());
        kMeldData = World().m_kFundingCouncil.BuildMission(30, MeldCountry);
        kMeldMission = World().m_kFundingCouncil.CreateMission(kMeldData);
        kMeldMission.m_iCity = Country(MeldCountry).GetRandomCity();
        kMeldMission.m_iCountry = MeldCountry;
        kMeldMission.m_iContinent = Country(MeldCountry).GetContinent();

        return kMeldMission;
    }
    else
    {
        kMission = Spawn(class'XGMission_Abduction');
        kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
        kMission.m_iCity = Continent(HQ().GetContinent()).GetRandomCity();
        kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
        kMission.m_iContinent = HQ().GetContinent();
        kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_Abduction);
        kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
        kMission.m_eTimeOfDay = 7;
        kMission.m_kDesc.m_kAlienSquad = DetermineFirstMissionSquad();

        return kMission;
    }
}

function XGMission CreateFirstMission_Controlled()
{
    local XGMission_Abduction kMission;

    kMission = Spawn(class'XGMission_Abduction');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_bScripted = true;
    kMission.m_kDesc.m_bScripted = true;
    kMission.m_iCity = Continent(HQ().GetContinent()).GetRandomCity();
    kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
    kMission.m_iContinent = HQ().GetContinent();
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_Abduction);
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_kDesc.m_strMapName = "Tutorial 2 (Abduction)";
    kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
    kMission.m_kDesc.m_iMissionType = eMission_Special;
    return kMission;
}

function XGMission CreateCrashMission(XGShip_UFO kUFO)
{
    local XGMission_UFOCrash kMission;

    kMission = Spawn(class'XGMission_UFOCrash');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iContinent = kUFO.GetContinent();
    kMission.m_iCountry = kUFO.GetCountry();
    kMission.m_iDuration = 2 * DetermineCrashedUFOMissionTimer(kUFO);
    kMission.m_v2Coords = kUFO.GetCoords();
    kMission.m_kDesc.m_kAlienSquad = DetermineUFOSquad(kUFO, false);
    kMission.m_arrArtifacts = kUFO.m_kTShip.arrSalvage;
    kMission.m_iUFOType = kUFO.GetType();
    kMission.m_kUFOObjective = kUFO.m_kObjective.m_kTObjective;
    kMission.m_iCounter = kUFO.m_iCounter;
    RemoveUFO(kUFO);

    return kMission;
}

function XGMission CreateLandedUFOMission(XGShip_UFO kUFO)
{
    local XGMission_UFOLanded kMission;

    kMission = Spawn(class'XGMission_UFOLanded');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iContinent = kUFO.GetContinent();
    kMission.m_iCountry = kUFO.GetCountry();
    kMission.m_iDuration = 2 * DetermineLandedUFOMissionTimer(kUFO);
    kMission.m_v2Coords = kUFO.GetCoords();
    kMission.m_kDesc.m_kAlienSquad = DetermineUFOSquad(kUFO, true);
    kMission.kUFO = kUFO;

    if (Country(kUFO.GetCountry()).HasSatelliteCoverage())
    {
        kMission.m_iDetectedBy = HQ().GetSatellite(ECountry(kUFO.GetCountry()));
        kUFO.m_bEverDetected = true;
    }
    else
    {
        kMission.m_iDetectedBy = -1;
    }

    kMission.m_arrArtifacts = kUFO.m_kTShip.arrSalvage;
    return kMission;
}

function XGMission CreateCovertOpsExtractionMission(ECountry eMissionCountry)
{
    local XGMission_CovertOpsExtraction kMission;
    local XGCountry kCountry;

    kCountry = Country(eMissionCountry);
    kMission = Spawn(class'XGMission_CovertOpsExtraction');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iContinent = kCountry.GetContinent();
    kMission.m_iCountry = eMissionCountry;
    m_iAlienMonth = eMission_CovertOpsExtraction; // Hacked-in way to pass mission type to DetermineCovertOpsSquad
    kMission.m_kDesc.m_kAlienSquad = DetermineCovertOpsSquad();
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_CovertExtraction);
    kMission.m_v2Coords = kCountry.GetCoords();
    return kMission;
}

function XGMission CreateCaptureAndHoldMission(ECountry eMissionCountry)
{
    local XGMission_CaptureAndHold kMission;
    local XGCountry kCountry;

    kCountry = Country(eMissionCountry);
    kMission = Spawn(class'XGMission_CaptureAndHold');
    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iContinent = kCountry.GetContinent();
    kMission.m_iCountry = eMissionCountry;
    m_iAlienMonth = eMission_CaptureAndHold; // Hacked-in way to pass mission type to DetermineCovertOpsSquad
    kMission.m_kDesc.m_kAlienSquad = DetermineCovertOpsSquad();
    kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_DataRecovery);
    kMission.m_v2Coords = kCountry.GetCoords();
    return kMission;
}

/**
 * Penalizes XCOM for losing a base defense mission.
 */
function FillUFOPool()
{
    local Highlander_XGStorage kStorage;

    kStorage = `HL_STORAGE;

    // Lose the main resources (except weapon fragments)
    AddResource(eResource_Money,   -450 - Rand(100));
    AddResource(eResource_Elerium, -1 * Min(185 + Rand(30), GetResource(eResource_Elerium)));
    AddResource(eResource_Alloys,  -1 * Min(185 + Rand(30), GetResource(eResource_Alloys)));
    AddResource(eResource_Meld,    -1 * Min(185 + Rand(30), GetResource(eResource_Meld)));

    // Lose up to a third of staff
    AddResource(eResource_Engineers, -1 * Min(20 + Rand(10), GetResource(eResource_Engineers) / 3));
    AddResource(eResource_Scientists, -1 * Min(20 + Rand(10), GetResource(eResource_Scientists) / 3));

    // Free all captive aliens
    kStorage.RemoveAllItem(`LW_ITEM_ID(SectoidCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(SectoidCommanderCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(FloaterCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(HeavyFloaterCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(ThinManCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(MutonCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(MutonEliteCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(BerserkerCaptive));
    kStorage.RemoveAllItem(`LW_ITEM_ID(EtherealCaptive));

    // ChooseUFOMissionType damages/destroyers interceptors; Stat 103 is used to pass the target continent
    STAT_SetStat(103, HQ().GetContinent());
    ChooseUFOMissionType(0);

    STAT_AddStat(2, 20); // +20 bonus research
}

function LaunchBlitz(array<ECityType> arrTargetCities, optional bool bFirstBlitz)
{
    local XGMission_Abduction kMission;
    local XGCity kCity;
    local array<EMissionRewardType> arrRewards;
    local EMissionRewardType eReward;
    local EMissionDifficulty eDiff;
    local TGeoscapeAlert kAlert;
    local bool bMissionAdded;
    local int I, iIndex;

    if (bFirstBlitz)
    {
        arrRewards.AddItem(eMissionReward_Cash);
        arrRewards.AddItem(eMissionReward_Cash);
        arrRewards.AddItem(eMissionReward_Cash);
    }
    else
    {
        arrRewards.AddItem(eMissionReward_Cash);
        arrRewards.AddItem(eMissionReward_Cash);
        arrRewards.AddItem(eMissionReward_Cash);
        arrRewards.AddItem(eMissionReward_Cash);
    }

    // This loop is written for the vanilla behavior where you pick from multiple abductions;
    // for Long War it can just be read as not being a loop.
    for (I = 0; I < arrTargetCities.Length; I++)
    {
        kCity = CITY(arrTargetCities[I]);
        iIndex = Rand(arrRewards.Length);
        eReward = arrRewards[iIndex];
        arrRewards.Remove(iIndex, 1);
        eDiff = GetAbductionDifficulty(Country(kCity.GetCountry()));

        kMission = Spawn(class'XGMission_Abduction');
        kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
        kMission.m_iCity = kCity.m_iID;
        kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
        kMission.m_iContinent = kCity.GetContinent();
        kMission.m_iDuration = 2 * `HL_STRATCFG(MissionGeoscapeDuration_Abduction);
        kMission.m_v2Coords = kCity.GetCoords();
        kMission.m_kDesc.m_kAlienSquad = DetermineAbductionSquad(eDiff);
        kMission.m_eDifficulty = eDiff;

        DetermineAbductionReward(kMission.m_kReward, eDiff, eReward);
        kMission.m_iDetectedBy = 0;

        if (ISCONTROLLED() && Game().GetNumMissionsTaken() == 1)
        {
            kMission.m_bScripted = true;
            kMission.m_kDesc.m_bScripted = true;
            kMission.m_kDesc.m_bIsTutorial = true;
            kMission.m_kDesc.m_bAllowedMissionAbort = false;

            if (kMission.m_iContinent == 0)
            {
                kMission.m_kReward.iEngineers = 0;
                kMission.m_kReward.iScientists = int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
                kMission.m_kReward.iCredits = 0;
                kMission.m_kDesc.m_strMapName = "URB_PierA_Rescue Tutorial 2 (Abduction) Pier";
                kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
            }
            else
            {
                kMission.m_kReward.iEngineers = 0;
                kMission.m_kReward.iScientists = 0;
                kMission.m_kReward.iCredits = int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_CASH);
                kMission.m_kDesc.m_strMapName = "URB_PierA_Rescue Tutorial 2 (Abduction) Pier Asia";
                kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
            }

            kMission.m_kDesc.m_iMissionType = eMission_Special;
        }

        GEOSCAPE().AddMission(kMission);

        if (kMission.m_iID >= 0)
        {
            bMissionAdded = true;
            kAlert.arrData.AddItem(kMission.m_iID);
        }
    }

    kAlert.eType = eGA_Abduction;

    if (bMissionAdded)
    {
        GEOSCAPE().Alert(kAlert);
    }
}

function bool PickMissionPlan(int Month, int Resources, int Threat, out HL_AIMissionPlan MissionPlan)
{
    local int Index;
    local HL_AIMissionPlan Candidate;
    local array<HL_AIMissionPlan> ValidCandidates;

    `HL_LOG("Selecting a mission plan out of" @ PossibleMissionPlans.Length @ "configured");

    if (PossibleMissionPlans.Length == 0)
    {
        `HL_LOG("No mission plans are configured!");
        return false;
    }

    foreach PossibleMissionPlans(Candidate) {
        if (Candidate.FirstValidMonth >= 0 && Month < Candidate.FirstValidMonth)
        {
            continue;
        }

        if (Candidate.LastValidMonth >= 0 && Month > Candidate.LastValidMonth)
        {
            continue;
        }

        if (Candidate.MinResources >= 0 && Resources < Candidate.MinResources)
        {
            continue;
        }

        if (Candidate.MaxResources >= 0 && Resources > Candidate.MaxResources)
        {
            continue;
        }

        if (Candidate.MinThreat >= 0 && Threat < Candidate.MinThreat)
        {
            continue;
        }

        if (Candidate.MaxThreat >= 0 && Threat > Candidate.MaxThreat)
        {
            continue;
        }

        ValidCandidates.AddItem(Candidate);
    }

    `HL_LOG("Found " $ ValidCandidates.Length $ " possible mission plan(s) to choose from");

    if (ValidCandidates.Length == 0)
    {
        return false;
    }

    Index = Rand(ValidCandidates.Length);
    MissionPlan = ValidCandidates[Index];

    `HL_LOG("Selected mission plan at index " $ Index);
    return true;
}

protected function int DetermineCrashedUFOMissionTimer(XGShip_UFO kUFO)
{
    switch (kUFO.m_kTShip.eType)
    {
        case eShip_UFOSmallScout:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedScout);
        case eShip_UFOLargeScout:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedDestroyer);
        case eShip_UFOAbductor:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedAbductor);
        case eShip_UFOSupply:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedTransport);
        case eShip_UFOBattle:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedBattleship);
        case eShip_UFOEthereal:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedOverseer);
        case 10:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedFighter);
        case 11:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedRaider);
        case 12:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedHarvester);
        case 13:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedTerrorShip);
        case 14:
            return `HL_STRATCFG(MissionGeoscapeDuration_CrashedAssaultCarrier);
        default:
            `HL_LOG_CLS("Unrecognized UFO type " $ kUFO.m_kTShip.eType $ ". Cannot determine mission timer.");
            return -1;
    }
}

protected function int DetermineLandedUFOMissionTimer(XGShip_UFO kUFO)
{
    switch (kUFO.m_kTShip.eType)
    {
        case eShip_UFOSmallScout:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedScout);
        case eShip_UFOAbductor:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedAbductor);
        case eShip_UFOSupply:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedTransport);
        case 11:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedRaider);
        case 12:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedHarvester);
        case 13:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedTerrorShip);
        case 14:
            return `HL_STRATCFG(MissionGeoscapeDuration_LandedAssaultCarrier);
        default:
            return -1;
    }
}

protected function int RollMissionCount(float Count)
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

protected function PopulateMissionRewards(XGMission kMission, const out array<HL_TItemQuantity> arrRewards)
{
    local HL_TItemQuantity kItemQuantity;

    foreach arrRewards(kItemQuantity)
    {
        if (kItemQuantity.iItemId > 255)
        {
            `HL_LOG_CLS("WARNING: arbitrary item IDs aren't yet supported for mission rewards. Ignoring reward " $ kItemQuantity.iItemId);
            continue;
        }

        kMission.m_arrArtifacts[kItemQuantity.iItemId] = kItemQuantity.iQuantity;
    }
}