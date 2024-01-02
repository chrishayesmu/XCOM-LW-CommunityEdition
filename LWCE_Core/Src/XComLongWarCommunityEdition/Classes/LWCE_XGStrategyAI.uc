class LWCE_XGStrategyAI extends XGStrategyAI
    config(LWCEBaseStrategyAI);

struct CheckpointRecord_LWCE_XGStrategyAI extends XGStrategyAI.CheckpointRecord
{
    var array<LWCE_XGShip> m_arrCEShips;
    var array<LWCE_TShipRecord> m_arrCEShipRecord;
    var array<name> m_arrCEShipsShotDown;
};

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

var array<LWCE_XGShip> m_arrCEShips;
var array<LWCE_TShipRecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions.
var array<name> m_arrCEShipsShotDown; // Tracks ship types that have been shot down by XCOM.

function InitNewGame()
{
    m_kStartDate = Spawn(class'LWCE_XGDateTime');
    m_kStartDate.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);

    m_iTerrorCounter = 2;

    AIAddNewObjectives();
}

function Update()
{
    AIUpdateMissions();
    UpdateObjectives();

    if (IsOptionEnabled(9)) // Dynamic War
    {
        m_iTerrorCounter = TallySquadCost();
    }
}

function AddAirBaseDefenseMission()
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGWorld kWorld;
    local array<LWCE_XGContinent> arrContinents;
    local array<name> arrPossibleTargets;
    local name nmTargetCountry, nmTargetContinent;

    kHQ = LWCE_XGHeadquarters(HQ());
    kWorld = LWCE_XGWorld(WORLD());

    arrContinents = kWorld.LWCE_GetContinents();

    // Map each continent to the country containing its air base
    foreach arrContinents(kContinent)
    {
        if (kContinent.m_nmContinent == kHQ.LWCE_GetContinent())
        {
            continue;
        }

        if (IsFirestormOnContinent(kContinent.m_nmContinent))
        {
            arrPossibleTargets.AddItem(kContinent.GetHQCountry());
        }
    }

    if (arrPossibleTargets.Length == 0)
    {
        return;
    }

    nmTargetCountry = arrPossibleTargets[Rand(arrPossibleTargets.Length)];
    nmTargetContinent = kWorld.LWCE_GetCountry(nmTargetCountry).LWCE_GetContinent();

    if (!IsOptionEnabled(9)) // if not Dynamic War
    {
        LWCE_AIAddNewObjective('AssaultXComAirBase', 0, `LWCE_XGCONTINENT(nmTargetContinent).GetHQLocation(), nmTargetCountry);
    }
    else
    {
        LWCE_AIAddNewObjective('AssaultXComAirBase', 1 + Rand(26), `LWCE_XGCONTINENT(nmTargetContinent).GetHQLocation(), nmTargetCountry);
    }
}

function AddHuntTarget(ECountry eTargetCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(AddHuntTarget);
}

/// <summary>
/// Adds a Hunt objective targeting the given country.
/// </summary>
function LWCE_AddHuntTarget(name nmTargetCountry)
{
    local LWCE_XGHeadquarters kHQ;

    kHQ = LWCE_XGHeadquarters(HQ());

    LWCE_AIAddNewObjective('Hunt', Rand(5), kHQ.m_arrCESatellites[kHQ.LWCE_GetSatellite(nmTargetCountry)].v2Loc, nmTargetCountry);
}

/// <summary>
/// In Long War, this function was repurposed to add an air base defense mission. For LWCE, we've made
/// a separate function for that and we simply delegate to it for now.
///
/// TODO: once LWCE supports Dynamic War mission scheduling, we won't need to delegate and can simply
/// deprecate this function completely.
/// </summary>
function AddLateMission()
{
    AddAirBaseDefenseMission();
}

function int AddNewOverseers()
{
    local XGCountry kCountry;
    local LWCE_XGWorld kWorld;

    kWorld = LWCE_XGWorld(WORLD());

    if (!LWCE_XGStorage(STORAGE()).LWCE_EverHadItem('Item_EtherealDevice'))
    {
        LWCE_ScheduleNewObjectives('CommandOverwatch', 3);
    }

    foreach kWorld.m_arrCountries(kCountry)
    {
        if (kCountry.LeftXCom())
        {
            LWCE_AIAddNewObjective('CommandOverwatch', 5 + Rand(20), kCountry.GetCoords(), LWCE_XGCountry(kCountry).m_nmCountry);

        }
    }

    // Return value is unused, so we just return 0 for simplicity
    return 0;
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

function AddUFOMission(EAlienObjective eObjective, int iStartDate, EShipType eUFO, EUFOMission eMission, int iMissionRadius, int iRandomDays)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(AddUFOMission);
}

function XGMission AIAddNewMission(EMissionType eType, XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateGrenades);

    return none;
}

/// <summary>
/// Creates a mission of the given type and adds it to the Geoscape.
/// </summary>
/// <param name="eType">The type of mission to create. Only some types are supported.</param>
/// <param name="kShip">The ship responsible for the mission, if any.</param>
function XGMission LWCE_AIAddNewMission(EMissionType eType, optional LWCE_XGShip kShip)
{
    local XGMission kMission;

    if (eType == eMission_Final)
    {
        kMission = CreateTempleMission();
    }
    else if (eType == eMission_TerrorSite)
    {
        kMission = LWCE_CreateTerrorMission(kShip);
    }
    else if (eType == eMission_LandedUFO)
    {
        kMission = LWCE_CreateLandedShipMission(kShip);
    }
    else if (eType == eMission_Crash)
    {
        kMission = LWCE_CreateCrashMission(kShip);
    }
    else if (eType == eMission_HQAssault)
    {
        kMission = CreateHQAssaultMission();
    }
    else if (eType == 14) // Air base defense
    {
        kMission = LWCE_CreateAirBaseDefenseMission(kShip);
    }
    else
    {
        `LWCE_LOG_ERROR("AI was asked to create a mission of an unsupported type: " $ eType);
        ScriptTrace();
    }

    GEOSCAPE().AddMission(kMission);

    return kMission;
}

function XGAlienObjective AIAddNewObjective(EAlienObjective eObjective, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity = -1, optional EShipType eUFO = eShip_None)
{
    `LWCE_LOG_DEPRECATED_CLS(AIAddNewObjective);

    return none;
}

function LWCE_XGAlienObjective LWCE_AIAddNewObjective(name nmObjective, int iStartDate, Vector2D v2Target, name nmCountry, optional name nmCity = '', optional name nmShipType = '')
{
    local LWCE_XGAlienObjective kAlienObjective;

    kAlienObjective = Spawn(class'LWCE_XGAlienObjective');
    kAlienObjective.LWCE_Init(nmObjective, iStartDate, v2Target, nmCountry, nmCity, nmShipType);
    m_arrObjectives.AddItem(kAlienObjective);

    return kAlienObjective;
}

function AIAddNewObjectives()
{
    local bool bSpawnedHQAssault;
    local int iObjectiveIndex, iNumObjectives, iStartOfMonthResources, iStartOfMonthThreat;
    local name nmStartingContinent;
    local LWCEMissionPlanTemplate kMissionPlanTemplate;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;

    kWorld = LWCE_XGWorld(WORLD());

    `LWCE_LOG_CLS("AIAddNewObjectives start");

    // Use the default logic for Dynamic War; make sure to do this before modifying
    // any state or else it will be modified twice
    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        `LWCE_LOG("Dynamic War not currently supported. Falling back to base LW logic for adding missions.");
        super.AIAddNewObjectives();

        return;
    }

    // Calculate what our resources will be without updating them, in case we need to fall back to the
    // superclass method, which will also update them
    iStartOfMonthResources = `ALIEN_RESOURCES + MonthlyResourcesPerBase * World().GetNumDefectors();
    iStartOfMonthResources = Clamp(iStartOfMonthResources, ResourceFloorPerMonthPassed * GetMonth(), MaximumResources);
    iStartOfMonthThreat = `XCOM_THREAT;

    kMissionPlanTemplate = PickMissionPlan(GetMonth(), iStartOfMonthResources, iStartOfMonthThreat);

    if (kMissionPlanTemplate == none)
    {
        `LWCE_LOG("Unable to select a mission plan! Falling back to base LW logic for adding missions.");
        super.AIAddNewObjectives();

        return;
    }

    STAT_SetStat(19, iStartOfMonthResources);

    for (iObjectiveIndex = 0; iObjectiveIndex < kMissionPlanTemplate.arrObjectives.Length; iObjectiveIndex++)
    {
        iNumObjectives = `LWCE_UTILS.RandInRange(kMissionPlanTemplate.arrObjectives[iObjectiveIndex].kAmount);

        LWCE_ScheduleNewObjectives(kMissionPlanTemplate.arrObjectives[iObjectiveIndex].nmObjective, iNumObjectives);
    }

    // Reduce and clamp threat at the start of each month
    STAT_SetStat(21, Clamp(STAT_GetStat(21) - ThreatDecreasePerMonth, 0, MaxThreatCarriedOverEachMonth));

    // Force an infiltration mission in the first month, if configured
    if (bForceFirstMonthInfiltration && GetMonth() == 0)
    {
        nmStartingContinent = LWCE_XGHeadquarters(HQ()).LWCE_GetHomeContinent();
        kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());

        // Don't infiltrate on the starting continent, too disruptive
        while (kCountry.LWCE_GetContinent() == nmStartingContinent)
        {
            kCountry = LWCE_XGCountry(World().GetRandomCouncilCountry());
        }

        LWCE_AIAddNewObjective('Infiltrate', 5 + Rand(5), kCountry.GetCoords(), kCountry.m_nmCountry);
    }

    // If not at max HQ assaults yet, increment the counter if currently valid
    if (MaxNumHQAssaultMissions < 0 || MaxNumHQAssaultMissions > Game().GetNumMissionsTaken(eMission_HQAssault))
    {
        if (iStartOfMonthResources >= MinResourcesForHQAssaultCounter && iStartOfMonthThreat >= MinThreatForHQAssaultCounter)
        {
            `LWCE_LOG("Requirements met: incrementing HQ assault counter (stat 22)");
            STAT_AddStat(22, 1);

            if (STAT_GetStat(22) == CounterValueToSpawnHQAssault)
            {
                `LWCE_LOG("HQ assault counter has reached required value " $ CounterValueToSpawnHQAssault $ ". Spawning HQ assault and resetting counter.");
                bSpawnedHQAssault = true;
                AddHQAssaultMission();
                STAT_SetStat(22, 0);
            }
        }
    }

    // Force spawn an HQ assault if configured to do so, and if we've gone long enough without one
    if (!bSpawnedHQAssault && MonthToForceSpawnHQAssault >= 0 && GetMonth() >= MonthToForceSpawnHQAssault && Game().GetNumMissionsTaken(eMission_HQAssault) == 0)
    {
        `LWCE_LOG("Force-spawning HQ assault mission");
        AddHQAssaultMission();
        STAT_SetStat(22, 0);
    }

    AddNewOverseers();
    AddCouncilMission();

    // This is at the end of the original function, so it's at the end here too
    STAT_AddStat(2, MonthlyResearchPerBase * World().GetNumDefectors());

    // Not sure what this does, but it's in the original
    m_iCounter = 0;

    `LWCE_LOG_CLS("AIAddNewObjectives complete");
}

/// <summary>
/// Schedules new alien objectives, using the objective's template to fill in any unprovided parameters.
/// </summary>
function LWCE_ScheduleNewObjectives(name nmObjective, int iNumObjectives, optional int iStartDate = -1, optional name nmCountry = '', optional name nmCity = '', optional name nmShipType = '', optional Vector2D v2Target)
{
    local int Index, iActualStartDate;
    local name nmActualCountry, nmActualCity;
    local Vector2D v2ActualTarget;
    local LWCEEnemyObjectiveTemplate kObjectiveTemplate;
    local array<name> arrCountryTargets;

    kObjectiveTemplate = `LWCE_ENEMY_OBJECTIVE(nmObjective);

    // If we aren't given a specific country to target, we need to select our own, keeping in mind that it's possible to
    // roll less targets than requested depending on the target selection algorithm in use.
    if (nmCountry == '')
    {
        nmCity = '';

        arrCountryTargets = SelectTargetCountries(kObjectiveTemplate.nmTargetSelectionAlgorithm, iNumObjectives);
    }
    else
    {
        for (Index = 0; Index < iNumObjectives; Index++)
        {
            arrCountryTargets.AddItem(nmCountry);
        }
    }

    for (Index = 0; Index < arrCountryTargets.Length; Index++)
    {
        iActualStartDate = iStartDate;
        nmActualCountry = arrCountryTargets[Index];
        nmActualCity = nmCity;
        v2ActualTarget = v2Target;

        if (iActualStartDate == -1)
        {
            if (kObjectiveTemplate.bSpreadThroughoutMonth)
            {
                iActualStartDate = (1 + (Index * (30 / arrCountryTargets.Length))) + Rand((30 / arrCountryTargets.Length) - 1);
            }
            else
            {
                iActualStartDate = kObjectiveTemplate.iStartDays + Rand(kObjectiveTemplate.iRandDays);
            }
        }

        if (v2ActualTarget.X == 0.0f && v2ActualTarget.Y == 0.0f)
        {
            switch (kObjectiveTemplate.nmFineGrainedTarget)
            {
                case 'ContinentHQ':
                    v2ActualTarget = `LWCE_XGCONTINENT(`LWCE_XGCOUNTRY(nmActualCountry).LWCE_GetContinent()).GetHQLocation();
                    break;
                case 'Country':
                    v2ActualTarget = `LWCE_XGCOUNTRY(nmActualCountry).GetCoords();
                    break;
                case 'RandomCity':
                    nmActualCity = `LWCE_XGCOUNTRY(nmActualCountry).LWCE_GetRandomCity();
                    v2ActualTarget = `LWCE_XGCITY(nmActualCity).GetCoords();
                    break;
                case 'XComHQ':
                    v2ActualTarget = HQ().GetCoords();
                    break;
            }
        }

        LWCE_AIAddNewObjective(nmObjective, iActualStartDate, v2ActualTarget, nmActualCountry, nmActualCity, nmShipType);
    }
}

function AIAddNewUFO(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(AIAddNewUFO, LWCE_AIAddNewShip);
}

/// <summary>
/// Adds the given ship to the strategy AI's tracking. The AI is then responsible for handling when it is
/// shot down, flies away, or otherwise exits the geoscape.
/// </summary>
function LWCE_AIAddNewShip(LWCE_XGShip kShip)
{
    m_arrCEShips.AddItem(kShip);
}

function ApplyMissionPanic(XGMission kMission, bool bXComSuccess, optional bool bExpired, optional bool bDontApplyToContinent)
{
    local XGCountry kCountry;
    local XGContinent kContinent;
    local TContinentResult kResultContinent;
    local TCountryResult kResultCountry;
    local int iCountryPanic, iContPanic;

    switch (Game().GetDifficulty())
    {
        case 0:
            iCountryPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_COUNTRY_EASY;
            iContPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_CONTINENT_EASY;
            break;
        case 1:
            iCountryPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_COUNTRY_NORMAL;
            iContPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_CONTINENT_NORMAL;
            break;
        case 2:
            iCountryPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_COUNTRY_HARD;
            iContPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_CONTINENT_HARD;
            break;
        case 3:
            iCountryPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_COUNTRY_CLASSIC;
            iContPanic = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_CONTINENT_CLASSIC;
            break;
    }

    if (kMission.GetCountry() != -1)
    {
        kCountry = Country(kMission.GetCountry());
    }

    kContinent = kMission.GetContinent();

    switch (kMission.m_iMissionType)
    {
        case eMission_Abduction:
            kContinent.m_kMonthly.iAbductions += 1;
            kResultContinent.eContinentAffected = EContinent(kContinent.GetID());
            kResultCountry.eCountryAffected = ECountry(kCountry.GetID());

            if (bXComSuccess)
            {
                kResultContinent.iPanicChange = class'XGTacticalGameCore'.default.PANIC_ABDUCTION_THWARTED_CONTINENT;
                kResultCountry.iPanicChange = Max(-kCountry.m_iPanic, class'XGTacticalGameCore'.default.PANIC_ABDUCTION_THWARTED_COUNTRY);
                kContinent.m_kMonthly.iAbductionsThwarted += 1;
            }
            else
            {
                kResultContinent.iPanicChange = iContPanic;
                kResultCountry.iPanicChange = iCountryPanic;
                kContinent.RecordCountryNotHelped(ECountry(kMission.GetCountry()));
            }

            if (kResultContinent.iPanicChange != 0 && !bDontApplyToContinent)
            {
                kContinent.AddPanic(kResultContinent.iPanicChange);
                HQ().m_kLastResult.arrContinentResults.AddItem(kResultContinent);
            }

            if (kResultCountry.iPanicChange != 0)
            {
                HQ().m_kLastResult.arrCountryResults.AddItem(kResultCountry);
                kCountry.AddPanic(kResultCountry.iPanicChange);
            }

            break;
        case eMission_TerrorSite:
            kContinent.m_kMonthly.iTerror += 1;
            kResultContinent.eContinentAffected = EContinent(kContinent.GetID());
            kResultCountry.eCountryAffected = ECountry(kCountry.GetID());

            if (kCountry.m_bSecretPact) // Country is not part of XCOM
            {
                if (!bXComSuccess)
                {
                    kResultContinent.iPanicChange = class'XGTacticalGameCore'.default.PANIC_TERROR_CONTINENT;
                }
                else
                {
                    kResultContinent.iPanicChange = class'XGTacticalGameCore'.default.UFO_LIMIT * (HQ().m_kLastResult.iCiviliansTotal - HQ().m_kLastResult.iCiviliansSaved);
                }
            }
            else
            {
                if (bXComSuccess)
                {
                    kResultCountry.bLeftXCom = CalcTerrorMissionPanicResult(kResultCountry.iPanicChange, kResultContinent.iPanicChange);
                    kResultCountry.iPanicChange = Max(-kCountry.m_iPanic, kResultCountry.iPanicChange);

                    if (!kResultCountry.bLeftXCom)
                    {
                        kContinent.m_kMonthly.iTerrorThwarted += 1;
                    }
                }
                else if (!kResultCountry.bLeftXCom)
                {
                    kResultContinent.iPanicChange = class'XGTacticalGameCore'.default.PANIC_TERROR_CONTINENT;
                    kResultCountry.iPanicChange = class'XGTacticalGameCore'.default.PANIC_TERROR_COUNTRY;
                    kResultCountry.bLeftXCom = true;
                    kContinent.RecordCountryNotHelped(ECountry(kMission.GetCountry()));
                }

                if (kResultCountry.iPanicChange != 0)
                {
                    HQ().m_kLastResult.arrCountryResults.AddItem(kResultCountry);

                    if (!kResultCountry.bLeftXCom)
                    {
                        kCountry.AddPanic(kResultCountry.iPanicChange);
                    }
                }

                if (kResultCountry.bLeftXCom)
                {
                    kCountry.LeaveXComProject();
                    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('SecretPact').AddInt(kMission.GetCountry()).Build());
                }
            }

            if (kResultContinent.iPanicChange != 0)
            {
                kContinent.AddPanic(kResultContinent.iPanicChange);
                HQ().m_kLastResult.arrContinentResults.AddItem(kResultContinent);
            }

            break;
        case eMission_AlienBase:
            if (bXComSuccess)
            {
                RestoreCountryToXCom(LWCE_XGCountry(kCountry).m_nmCountry);
                kCountry.m_iPanic = 98;
                kCountry.AddPanic(class'XGTacticalGameCore'.default.PANIC_ALIENBASE_CONQUERED_CLASSIC_AND_IMPOSSIBLE);

                if (HQ().HasBonus(`LW_HQ_BONUS_ID(IndependenceDay)) > 0)
                {
                    kCountry.AddPanic(-1 * HQ().HasBonus(`LW_HQ_BONUS_ID(IndependenceDay)));
                }

                Continent(kCountry.GetContinent()).AddPanic(class'XGTacticalGameCore'.default.PANIC_ALIENBASE_CONQUERED);
            }

            break;
        case eMission_ExaltRaid:
            if (Game().GetDifficulty() == 2 || Game().GetDifficulty() == 3)
            {
                HQ().m_kLastResult.iWorldPanicChange = class'XGTacticalGameCore'.default.PANIC_EXALT_RAIDED_CLASSIC_AND_IMPOSSIBLE;
            }
            else
            {
                HQ().m_kLastResult.iWorldPanicChange = class'XGTacticalGameCore'.default.PANIC_EXALT_RAIDED;
            }

            World().AddPanic(HQ().m_kLastResult.iWorldPanicChange);
            break;
        case 4:
            if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
            {
                if (!bXComSuccess || bExpired)
                {
                    STAT_SetStat(103, kContinent.GetID()); // Hacked way to pass the continent ID to ChooseUFOMissionType
                    iCountryPanic = ChooseUFOMissionType(0);
                    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('AirBaseDefenseFailed').AddInt(kContinent.GetID()).Build());
                }
            }

            break;
    }
}

function BuildObjective(EAlienObjective eObjective, bool bAbandonMission)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BuildObjective);
}

function BuildObjectives()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BuildObjectives);
}

/// <summary>
/// Calculates the change in panic after a terror mission for both the country and continent.
/// Returns true if the country should leave the XCOM Project after this mission, false if not.
/// </summary>
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
        `LWCE_LOG("WARNING: there are " $ ExtraCivilians $ " more civilian units than there should be. Likely this is due to a mod. "
              $ "These units will be removed from the count of civilians saved under the assumption that they did not die.");

        CiviliansSaved -= ExtraCivilians;
    }

    CiviliansLost = Clamp(CiviliansLost, 0, CiviliansTotal);
    CiviliansSaved = Clamp(CiviliansSaved, 0, CiviliansTotal);

    `LWCE_LOG("CiviliansTotal = " $ CiviliansTotal $ "; ExtraCivilians = " $ ExtraCivilians $ "; CiviliansLost = " $ CiviliansLost $ "; CiviliansSaved = " $ CiviliansSaved);

    // If we saved more than the threshold limit of civilians, then we should decrease panic as a reward
    if (CiviliansSavedPanicDecreaseThreshold >= 0 && CiviliansSaved > CiviliansSavedPanicDecreaseThreshold)
    {
        `LWCE_LOG(CiviliansSaved $ " civilians were saved, surpassing the threshold of " $ CiviliansSavedPanicDecreaseThreshold $ ". Panic will be decreased.");
        CiviliansSaved -= CiviliansSavedPanicDecreaseThreshold;

        iContinentPanicChange = CiviliansSaved * ContinentPanicDecreasePerSavedCivilian;
        iCountryPanicChange = CiviliansSaved * CountryPanicDecreasePerSavedCivilian;
    }
    else
    {
        if (CiviliansLostPanicIncreaseThreshold > 0) {
            `LWCE_LOG("Adjusting civilians lost from " $ CiviliansLost $ " to " $ (CiviliansLost - CiviliansLostPanicIncreaseThreshold));
            CiviliansLost = Max(0, CiviliansLost - CiviliansLostPanicIncreaseThreshold);
        }

        iContinentPanicChange = CiviliansLost * ContinentPanicIncreasePerLostCivilian;
        iCountryPanicChange = CiviliansLost * CountryPanicIncreasePerLostCivilian;
    }

    `LWCE_LOG("iContinentPanicChange = " $ iContinentPanicChange $ " and iCountryPanicChange = " $ iCountryPanicChange);

    // If not enough civilians were saved, the country will leave immediately
    if (CiviliansSaved < NumCiviliansSavedToPreventCountryLeaving)
    {
        `LWCE_LOG(CiviliansSaved $ " civilians were saved, failing to meet threshold of " $ NumCiviliansSavedToPreventCountryLeaving $ "; country will leave XCOM");
        return true;
    }

    return false;
}

function XGMission CheatCrash(XGShip_UFO strMapName)
{
    `LWCE_LOG_DEPRECATED_CLS(CheatCrash, LWCE_CreateAirBaseDefenseMission);

    return none;
}

/// <summary>
/// Creates a new mission for defending one of XCOM's air bases.
/// </summary>
function XGMission LWCE_CreateAirBaseDefenseMission(LWCE_XGShip kShip)
{
    local XGMission_UFOLanded kMission;

    kMission = Spawn(class'LWCE_XGMission_UFOLanded');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_bScripted = true;
    kMission.m_kDesc.m_bScripted = true;
    kMission.m_iCity = -1;
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_AirBaseDefense);
    kMission.m_kDesc.m_kAlienSquad = DetermineAbductionSquad(9);
    kMission.m_kDesc.m_iMissionType = 14;
    kMission.m_strTitle = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strLabelViewAbductionSitesFlying);
    kMission.m_strSituation = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strPanicRemedy);
    kMission.m_strObjective = class'XComLocalizer'.static.ExpandString(class'XGMissionControlUI'.default.m_strLabelMessageFromFoundry);
    kMission.m_kDesc.m_strMapName = "EWI_HQAssault_MP (Airbase Defense)";
    kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
    kMission.m_v2Coords = kShip.GetCoords();

    `LWCE_LOG_ERROR("Continent names are not supported for LWCE_CreateAirBaseDefenseMission yet!");
    ScriptTrace();
    // kMission.m_iContinent = kShip.GetContinent();

    return kMission;
}

function bool CheckForHunterKiller()
{
    // LWCE issue #87: Hunter Killer in LW 1.0 is still based on vanilla UFOs. Here, we've changed
    // the list to include all 11 of the UFO types found in LW.
    return m_arrCEShipsShotDown.Find('UFOAbductor') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOAssaultCarrier') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOBattleship') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFODestroyer') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOFighter') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOHarvester') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOOverseer') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFORaider') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOScout') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOTerrorShip') != INDEX_NONE
        && m_arrCEShipsShotDown.Find('UFOTransport') != INDEX_NONE;
}

function bool ClearFromAbductionList(ECountry eTarget)
{
    `LWCE_LOG_DEPRECATED_BY(ClearFromAbductionList, LWCE_ClearCountryObjectives);

    return false;
}

/// <summary>
/// Removes some alien objectives related to the given country - only Abductions, Terror missions,
/// and Infiltrations. Other objectives, such as bombing runs, will remain.
/// </summary>
function bool LWCE_ClearCountryObjectives(name nmTargetCountry)
{
    local XGAlienObjective kObjective, kSimulObj;
    local LWCE_XGAlienObjective kCEObjective;
    local array<LWCE_XGAlienObjective> arrRemove;
    local array<LWCE_XGShip> arrRemoveShips;
    local LWCE_XGShip kShip;
    local bool bFound;

    foreach m_arrObjectives(kObjective)
    {
        kCEObjective = LWCE_XGAlienObjective(kObjective);

        if (kCEObjective.m_nmCountryTarget != nmTargetCountry)
        {
            continue;
        }

        // TODO let the template dictate whether the objective can continue or not; update function docs at that time
        if (kCEObjective.m_kCETObjective.nmType == 'Abduct')
        {
            if (!kCEObjective.m_bAbductionLaunched)
            {
                bFound = true;
                arrRemove.AddItem(kCEObjective);
            }
        }
        else if (kCEObjective.m_kCETObjective.nmType == 'Terrorize')
        {
            bFound = true;
            arrRemove.AddItem(kCEObjective);
        }
        else if (kCEObjective.m_kCETObjective.nmType == 'Infiltrate')
        {
            bFound = true;
            arrRemove.AddItem(kCEObjective);
        }
    }

    foreach arrRemove(kCEObjective)
    {
        foreach kCEObjective.m_arrSimultaneousObjs(kSimulObj)
        {
            kSimulObj.m_arrSimultaneousObjs.RemoveItem(kCEObjective);
        }

        CheckForAbductionBlitz(kCEObjective.m_arrSimultaneousObjs);

        foreach m_arrCEShips(kShip)
        {
            if (kShip.m_kObjective == kCEObjective)
            {
                arrRemoveShips.AddItem(kShip);
            }
        }

        foreach arrRemoveShips(kShip)
        {
            LWCE_RemoveShip(kShip);
        }
    }

    return bFound;
}

function CostTest()
{
    `LWCE_LOG_DEPRECATED_BY(CostTest, RestoreCountryToXCom);
}

function XGMission CreateTempleMission()
{
    local XGMission_TempleShip kMission;

    kMission = Spawn(class'LWCE_XGMission_TempleShip');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
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

    kMission = Spawn(class'LWCE_XGMission_Terror');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iCity = 4;
    kMission.m_iCountry = 0;
    kMission.m_iContinent = 0;
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Terror);
    kMission.m_v2Coords = CITY(4).m_v2Coords;
    kMission.m_kDesc.m_kAlienSquad = DetermineTerrorSquad();

    return kMission;
}

function XGMission CreateTerrorMission(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateTerrorMission);

    return none;
}

function XGMission LWCE_CreateTerrorMission(LWCE_XGShip kShip)
{
    local XGMission_Terror kMission;

    kMission = Spawn(class'LWCE_XGMission_Terror');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Terror);
    kMission.m_kDesc.m_kAlienSquad = DetermineTerrorSquad();

    `LWCE_LOG_ERROR("City/country/continent names are not supported for LWCE_XGMission_Terror yet!");
    ScriptTrace();
    // kMission.m_iCity = kShip.m_kObjective.m_iCityTarget;
    // kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    // kMission.m_iContinent = kShip.GetContinent();
    // kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();

    return kMission;
}

function XGMission CreateHQAssaultMission()
{
    local XGMission_HQAssault kMission;

    kMission = Spawn(class'LWCE_XGMission_HQAssault');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iContinent = HQ().GetContinent();
    kMission.m_v2Coords = HQ().GetCoords();
    kMission.m_kDesc.m_kAlienSquad = DetermineHQAssaultSquad();

    return kMission;
}

function XGMission CreateExaltRaidMission(ECountry ExaltCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateExaltRaidMission);

    return none;
}

function XGMission LWCE_CreateExaltRaidMission(name nmCountry)
{
    local XGMission_ExaltRaid kMission;

    kMission = Spawn(class'LWCE_XGMission_ExaltRaid');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_kDesc.m_kAlienSquad = DetermineExaltRaidSquad();

    `LWCE_LOG_ERROR("Country/continent names are not supported for LWCE_CreateExaltRaidMission yet!");
    ScriptTrace();
    // kMission.m_iCity = Country(nmCountry).GetRandomCity();
    // kMission.m_iCountry = nmCountry;
    // kMission.m_iContinent = Country(nmCountry).GetContinent();
    // kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;

    return kMission;
}

function CheatLandedUFO(string strMapName)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(CheatLandedUFO);
}

function CreateAlienBase()
{
    local int iElerium;
    local XGCountry kCountry;
    local LWCE_XGMission_AlienBase kMission;
    local LWCE_TMissionReward kReward;

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

    kMission = Spawn(class'LWCE_XGMission_AlienBase');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iCountry = kCountry.GetID();
    kMission.m_v2Coords = CITY(kCountry.GetRandomCity()).m_v2Coords;
    kMission.m_strTitle = kMission.m_strTitle $ kCountry.GetName();
    kMission.m_kDesc.m_kAlienSquad = DetermineAlienBaseSquad();

    kReward = CreateMissionRewards(`LWCE_STRATCFG(AlienBaseAssaultRewards));
    iElerium = int(class'XGTacticalGameCore'.default.UFO_ELERIUM_PER_POWER_SOURCE[Game().GetDifficulty()] * `LWCE_UTILS.GetItemQuantity(kReward.arrItems, 'Item_UFOPowerSource').iQuantity);
    `LWCE_UTILS.AdjustItemQuantity(kReward.arrItems, 'Item_Elerium', iElerium);

    if (OBJECTIVES().m_eObjective == eObj_AssaultAlienBase)
    {
        `LWCE_UTILS.SetItemQuantity(kReward.arrItems, 'Item_HyperwaveBeacon', 1);
    }
    else
    {
        `LWCE_UTILS.SetItemQuantity(kReward.arrItems, 'Item_HyperwaveBeacon', 0);
    }

    class'LWCE_XGMission_Extensions'.static.SetMissionRewards(kMission, kReward);

    kMission.m_iDetectedBy = 0;

    GEOSCAPE().AddMission(kMission);
}

function XGMission CreateFirstMission()
{
    local XGMission_Abduction kMission;

    kMission = Spawn(class'LWCE_XGMission_Abduction');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Abduction);
    kMission.m_eTimeOfDay = eTOD_Night;
    kMission.m_kDesc.m_kAlienSquad = DetermineFirstMissionSquad();

    `LWCE_LOG_ERROR("Country/continent names are not supported for CreateFirstMission yet!");
    // kMission.m_iCity = Continent(HQ().GetContinent()).GetRandomCity();
    // kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
    // kMission.m_iContinent = HQ().GetContinent();
    // kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;

    return kMission;
}

function XGMission CreateFirstMission_Controlled()
{
    local XGMission_Abduction kMission;

    kMission = Spawn(class'LWCE_XGMission_Abduction');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_bScripted = true;
    kMission.m_kDesc.m_bScripted = true;
    kMission.m_iCity = Continent(HQ().GetContinent()).GetRandomCity();
    kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
    kMission.m_iContinent = HQ().GetContinent();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Abduction);
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_kDesc.m_strMapName = "Tutorial 2 (Abduction)";
    kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
    kMission.m_kDesc.m_iMissionType = eMission_Special;
    return kMission;
}

function XGMission CreateCrashMission(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateCrashMission);

    return none;
}

function XGMission LWCE_CreateCrashMission(LWCE_XGShip kShip)
{
    local LWCE_TMissionReward kReward;
    local LWCE_XGMission_UFOCrash kMission;

    kMission = Spawn(class'LWCE_XGMission_UFOCrash');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * DetermineCrashedUFOMissionTimer(kShip);
    kMission.m_v2Coords = kShip.GetCoords();
    kMission.m_kDesc.m_kAlienSquad = LWCE_DetermineUFOSquad(kShip, false);
    kMission.m_iCounter = kShip.m_iCounter;

    `LWCE_LOG_ERROR("LWCE_XGShip is not supported for LWCE_XGMission_UFOCrash yet!");
    ScriptTrace();
    // kMission.m_iContinent = kShip.GetContinent();
    // kMission.m_iCountry = kShip.GetCountry();
    // kMission.m_iUFOType = kShip.GetType();
    // kMission.m_kUFOObjective = kShip.m_kObjective.m_kTObjective;

    kReward = CreateMissionRewards(kShip.m_kTemplate.GetSalvage());
    class'LWCE_XGMission_Extensions'.static.SetMissionRewards(kMission, kReward);

    LWCE_RemoveShip(kShip);

    return kMission;
}

function XGMission CreateLandedUFOMission(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(CreateLandedUFOMission, LWCE_CreateLandedShipMission);

    return none;
}

function XGMission LWCE_CreateLandedShipMission(LWCE_XGShip kShip)
{
    local LWCE_TMissionReward kReward;
    local LWCE_XGMission_UFOLanded kMission;

    kMission = Spawn(class'LWCE_XGMission_UFOLanded');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * DetermineLandedUFOMissionTimer(kShip);
    kMission.m_v2Coords = kShip.GetCoords();
    kMission.m_kDesc.m_kAlienSquad = LWCE_DetermineUFOSquad(kShip, true);

    // TODO
    `LWCE_LOG_ERROR("LWCE_XGShip is not supported for LWCE_XGMission_UFOLanded yet!");
    ScriptTrace();
    // kMission.m_iContinent = kShip.GetContinent();
    // kMission.m_iCountry = kShip.GetCountry();
    // kMission.kUFO = kShip;

    if (`LWCE_XGCOUNTRY(kShip.GetCountry()).HasSatelliteCoverage())
    {
        kMission.m_iDetectedBy = LWCE_XGHeadquarters(HQ()).LWCE_GetSatellite(kShip.GetCountry());
        kShip.m_bEverDetected = true;
    }
    else
    {
        kMission.m_iDetectedBy = -1;
    }

    kReward = CreateMissionRewards(kShip.m_kTemplate.GetSalvage());
    class'LWCE_XGMission_Extensions'.static.SetMissionRewards(kMission, kReward);

    return kMission;
}

function XGMission CreateCovertOpsExtractionMission(ECountry eMissionCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateCovertOpsExtractionMission);

    return none;
}

function XGMission LWCE_CreateCovertOpsExtractionMission(name nmMissionCountry)
{
    local LWCE_XGMission_CovertOpsExtraction kMission;
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(nmMissionCountry);
    kMission = Spawn(class'LWCE_XGMission_CovertOpsExtraction');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_CovertExtraction);
    kMission.m_v2Coords = kCountry.GetCoords();

    m_iAlienMonth = eMission_CovertOpsExtraction; // Hacked-in way to pass mission type to DetermineCovertOpsSquad
    kMission.m_kDesc.m_kAlienSquad = DetermineCovertOpsSquad();

    `LWCE_LOG_ERROR("Country/continent names are not supported for LWCE_XGMission_CovertOpsExtraction yet!");
    ScriptTrace();
    // kMission.m_iContinent = kCountry.GetContinent();
    // kMission.m_iCountry = nmMissionCountry;

    return kMission;
}

function XGMission CreateCaptureAndHoldMission(ECountry eMissionCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(CreateCaptureAndHoldMission);

    return none;
}

function XGMission LWCE_CreateCaptureAndHoldMission(name nmMissionCountry)
{
    local LWCE_XGMission_CaptureAndHold kMission;
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(nmMissionCountry);

    kMission = Spawn(class'LWCE_XGMission_CaptureAndHold');
    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_DataRecovery);
    kMission.m_v2Coords = kCountry.GetCoords();

    m_iAlienMonth = eMission_CaptureAndHold; // Hacked-in way to pass mission type to DetermineCovertOpsSquad
    kMission.m_kDesc.m_kAlienSquad = DetermineCovertOpsSquad();

    `LWCE_LOG_ERROR("Country/continent names are not supported for LWCE_XGMission_CaptureAndHold yet!");
    ScriptTrace();
    // kMission.m_iContinent = kCountry.GetContinent();
    // kMission.m_iCountry = nmMissionCountry;

    return kMission;
}

function DetermineAbductionReward(out TMissionReward kReward, EMissionDifficulty eDiff, EMissionRewardType eRewardType)
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineAbductionReward);
}

function LWCE_DetermineAbductionReward(out LWCE_TMissionReward kReward, EMissionDifficulty eDiff, EMissionRewardType eRewardType)
{
    local LWCE_TRewardSoldier kRewardSoldier;

    if (eRewardType == eMissionReward_Cash)
    {
        kReward.iCash = int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_CASH);

        if (HQ().HasBonus(`LW_HQ_BONUS_ID(Bounties)) > 0)
        {
            kReward.iCash *= (1.0 + (float(HQ().HasBonus(`LW_HQ_BONUS_ID(Bounties))) / 100.0));
        }

        switch (eDiff)
        {
            case eMissionDiff_Easy:
                kReward.iCash *= 0.80;
                break;
            case eMissionDiff_Moderate:
                kReward.iCash *= 0.90;
                break;
            case eMissionDiff_Hard:
                kReward.iCash *= 1.0;
                break;
            case eMissionDiff_VeryHard:
                kReward.iCash *= 1.150;
                break;
        }

        if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            kReward.iCash /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    // Long War only has cash reward types so the rest of these don't matter
    if (eRewardType == eMissionReward_Scientist)
    {
        kReward.iScientists = 2;
    }

    if (eRewardType == eMissionReward_Engineer)
    {
        kReward.iEngineers = 2;
    }

    if (eRewardType == eMissionReward_Soldier)
    {
        // TODO: PickRewardSoldierClass needs an LWCE version
        kRewardSoldier.iClassId = BARRACKS().PickRewardSoldierClass();
        kRewardSoldier.iRank = Clamp(BARRACKS().m_iHighestRank - 1, 3, 5);

        kReward.arrSoldiers.AddItem(kRewardSoldier);
    }
}

/// <summary>
/// Ostensibly, picks hunt targets based on which countries have been failing to intercept ships recently.
/// Unused in LW 1.0, so deprecated in LWCE.
/// </summary>
function array<int> DetermineBestHuntTargets()
{
    local array<int> arrTargets;

    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(DetermineBestHuntTargets);

    arrTargets.Length = 0;
    return arrTargets;
}

function DetermineCrashLoot(XGShip_UFO kUFO, EShipWeapon eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineCrashLoot);
}

function LWCE_DetermineCrashLoot(LWCE_XGShip kShip, LWCE_XGShip kInterceptor)
{
    local array<LWCE_TItemQuantity> arrSalvage;
    local LWCEShipWeaponTemplate kShipWeapon;
    local int Index, iSurvived, iTotal, iSurvivalChance;
    local float fAlloySurvival;
    local name ItemName;

    kShipWeapon = LWCEShipWeaponTemplate(`LWCE_ITEM(kInterceptor.GetWeaponAtIndex(0)));
    arrSalvage = kShip.m_kTemplate.GetSalvage();

    // Copy salvage from the template to the ship itself, rolling survival chance for certain items
    // along the way
    for (Index = 0; Index < arrSalvage.Length; Index++)
    {
        ItemName = arrSalvage[Index].ItemName;
        iTotal = arrSalvage[Index].iQuantity;

        // TODO: using SetItemQuantity throughout the below block assumes that items will only appear once
        // in the template's salvage, which may be untrue with mods
        if (iTotal > 0)
        {
            switch (ItemName)
            {
                case 'Item_UFOPowerSource':
                    iSurvivalChance = int(class'XGTacticalGameCore'.default.UFO_PS_SURVIVE);
                    break;
                case 'Item_UFONavigation':
                    iSurvivalChance = int(class'XGTacticalGameCore'.default.UFO_NAV_SURVIVE);
                    break;
                case 'Item_AlienFood':
                    iSurvivalChance = int(class'XGTacticalGameCore'.default.UFO_FOOD_SURVIVE);
                    break;
                case 'Item_AlienStasisTank':
                    iSurvivalChance = int(class'XGTacticalGameCore'.default.UFO_STASIS_SURVIVE);
                    break;
                case 'Item_AlienSurgery':
                    iSurvivalChance = int(class'XGTacticalGameCore'.default.UFO_SURGERY_SURVIVE);
                    break;
                case 'Item_AlienAlloy':
                    fAlloySurvival = RandRange(class'XGTacticalGameCore'.default.MIN_WRECKED_ALLOYS, class'XGTacticalGameCore'.default.MAX_WRECKED_ALLOYS);
                    fAlloySurvival = FClamp(fAlloySurvival + (kShipWeapon.fArtifactRecoveryBonus / 100.0), 0.0f, 1.0f);

                    iSurvived = int(float(iTotal) * fAlloySurvival);
                    break;
                default:
                    iSurvivalChance = 100;
                    break;
            }

            // Alloys are already handled by a slightly different method above
            if (ItemName != 'Item_AlienAlloy')
            {
                iSurvivalChance = FClamp(iSurvivalChance + kShipWeapon.fArtifactRecoveryBonus, 0.0f, 1.0f);

                iSurvived = GetSurvivingCollectibles(iTotal, iSurvivalChance);
            }

            `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, ItemName, iSurvived);

            switch (ItemName)
            {
                case 'Item_UFOPowerSource':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_UFOPowerSourceDamaged', iTotal - iSurvived);
                    `LWCE_UTILS.AdjustItemQuantity(kShip.m_arrSalvage, 'Item_Elerium', -1 * int(RandRange(class'XGTacticalGameCore'.default.MIN_LOST_WRECKED_ELERIUM * class'XGTacticalGameCore'.default.UFO_ELERIUM_PER_POWER_SOURCE[Game().GetDifficulty()], class'XGTacticalGameCore'.default.MAX_LOST_WRECKED_ELERIUM * class'XGTacticalGameCore'.default.UFO_ELERIUM_PER_POWER_SOURCE[Game().GetDifficulty()]) * float(iTotal - iSurvived)));
                    break;
                case 'Item_UFONavigation':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_UFONavigationDamaged', iTotal - iSurvived);
                    break;
                case 'Item_AlienFood':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_AlienFoodDamaged', iTotal - iSurvived);
                    break;
                case 'Item_AlienEntertainment':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_AlienEntertainmentDamaged', iTotal - iSurvived);
                    break;
                case 'Item_AlienStasisTank':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_AlienStasisTankDamaged', iTotal - iSurvived);
                    break;
                case 'Item_AlienSurgery':
                    `LWCE_UTILS.SetItemQuantity(kShip.m_arrSalvage, 'Item_AlienSurgeryDamaged', iTotal - iSurvived);
                    break;
            }
        }
    }
}

function TAlienSquad DetermineUFOSquad(XGShip_UFO kUFO, bool bLanded, optional EShipType eShip = eShip_None)
{
    local TAlienSquad kSquad;

    `LWCE_LOG_DEPRECATED_CLS(DetermineUFOSquad);

    return kSquad;
}

function TAlienSquad LWCE_DetermineUFOSquad(LWCE_XGShip kShip, bool bLanded, optional name nmShip = '')
{
    local TAlienSquad kSquad;

    if (nmShip == '')
    {
        nmShip = kShip.m_nmShipTemplate;
    }

    // TODO replace everything about this function with proper squad determination via config
    m_bFirstMission = bLanded;

    `LWCE_LOG_ERROR("Ship names are not supported for LWCE_DetermineUFOSquad yet!");
    ScriptTrace();
    m_iAlienMonth = 4;
    // m_iAlienMonth = nmShip;

    switch (nmShip)
    {
        case 'UFOScout':
        case 'UFOFighter':
            return DetermineSmallScoutSquad(bLanded);
        case 'UFODestroyer':
        case 'UFORaider':
            return DetermineLargeScoutSquad(bLanded);
        case 'UFOAbductor':
        case 'UFOHarvester':
            return DetermineAbductorSquad(bLanded);
        case 'UFOTerrorShip':
        case 'UFOTransport':
            return DetermineSupplySquad(bLanded);
        case 'UFOAssaultCarrier':
        case 'UFOBattleship':
            return DetermineBattleshipSquad();
        case 'UFOOverseer':
            return DetermineOverseerSquad();
    }

    return kSquad;
}

function GetEvents(out array<THQEvent> arrEvents)
{
    local int iObjective, iLastMission;
    local EMissionType eMission;

    if (m_iCouncilCounter > 0)
    {
        AddAIEvent(eMission_Special, m_iCouncilCounter / 2, 0, arrEvents);
    }

    for (iObjective = 0; iObjective < m_arrObjectives.Length; iObjective++)
    {
        if (m_arrObjectives[iObjective].m_bComplete)
        {
            continue;
        }

        eMission = eMission_None;

        switch (m_arrObjectives[iObjective].m_kTObjective.eType)
        {
            case eObjective_Recon: // Research
            case eObjective_Harvest:
                eMission = eMission_LandedUFO;
                break;
            case eObjective_Flyby:
                if (!LWCE_XGHeadquarters(HQ()).LWCE_HasFacility('Facility_HyperwaveRelay'))
                {
                    eMission = eMission_None;
                }
                else
                {
                    eMission = 12;
                }

                break;
            case eObjective_Hunt:
                eMission = 7; // eMission_HQAssault??
                break;
            case eObjective_Scout:
                eMission = eMission_Crash;
                break;
            case eObjective_Abduct:
                eMission = eMission_Abduction;
                break;
            case eObjective_Terrorize:
                eMission = eMission_TerrorSite;
                break;
        }

        if (eMission != eMission_None)
        {
            iLastMission = m_arrObjectives[iObjective].m_kTObjective.arrMissions.Length - 1;

            if (iLastMission == -1)
            {
                AddAIEvent(eMission, 0, ECountry(m_arrObjectives[iObjective].m_iCountryTarget), arrEvents);
            }
            else
            {
                AddAIEvent(eMission, (m_arrObjectives[iObjective].m_iNextMissionTimer - m_iCounter) / 2, ECountry(m_arrObjectives[iObjective].m_iCountryTarget), arrEvents);
            }
        }
    }
}

function XGShip_UFO GetUFO(int iUFOindex)
{
    `LWCE_LOG_DEPRECATED_BY(GetUFO, LWCE_GetShip);

    return none;
}

/// <summary>
/// Retrieves the ship with the given index.
/// </summary>
function LWCE_XGShip LWCE_GetShip(int iShipIndex)
{
    return m_arrCEShips[iShipIndex];
}

/**
 * Penalizes XCOM for losing a base defense mission.
 */
function FillUFOPool()
{
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    // Lose the main resources (except weapon fragments)
    AddResource(eResource_Money,   -450 - Rand(100));
    AddResource(eResource_Elerium, -1 * Min(185 + Rand(30), GetResource(eResource_Elerium)));
    AddResource(eResource_Alloys,  -1 * Min(185 + Rand(30), GetResource(eResource_Alloys)));
    AddResource(eResource_Meld,    -1 * Min(185 + Rand(30), GetResource(eResource_Meld)));

    // Lose up to a third of staff
    AddResource(eResource_Engineers, -1 * Min(20 + Rand(10), GetResource(eResource_Engineers) / 3));
    AddResource(eResource_Scientists, -1 * Min(20 + Rand(10), GetResource(eResource_Scientists) / 3));

    // Free all captive aliens
    kStorage.LWCE_RemoveAllItem('Item_SectoidCaptive');
    kStorage.LWCE_RemoveAllItem('Item_SectoidCommanderCaptive');
    kStorage.LWCE_RemoveAllItem('Item_FloaterCaptive');
    kStorage.LWCE_RemoveAllItem('Item_HeavyFloaterCaptive');
    kStorage.LWCE_RemoveAllItem('Item_ThinManCaptive');
    kStorage.LWCE_RemoveAllItem('Item_MutonCaptive');
    kStorage.LWCE_RemoveAllItem('Item_MutonEliteCaptive');
    kStorage.LWCE_RemoveAllItem('Item_BerserkerCaptive');
    kStorage.LWCE_RemoveAllItem('Item_EtherealCaptive');

    // ChooseUFOMissionType damages/destroyers interceptors; Stat 103 is used to pass the target continent
    STAT_SetStat(103, HQ().GetContinent());
    ChooseUFOMissionType(0);

    STAT_AddStat(2, 20); // +20 bonus research
}


function int GetNumResistingContinents()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetNumResistingContinents);

    return -1000;
}

function bool IsGoodOverseerTarget(EContinent eTarget)
{
    `LWCE_LOG_DEPRECATED_BY(IsGoodOverseerTarget, IsFirestormOnContinent);

    return false;
}

function bool IsGoodUFOMissionChoice(TUFO kUFO)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsGoodUFOMissionChoice);

    return false;
}

function bool IsFirestormOnContinent(name nmContinent)
{
    local array<LWCE_XGShip> arrShips;
    local int iShip;

    arrShips = LWCE_XGFacility_Hangar(HANGAR()).LWCE_GetShipsByContinent(nmContinent);

    for (iShip = 0; iShip < arrShips.Length; iShip++)
    {
        if (arrShips[iShip] != none && arrShips[iShip].m_nmShipTemplate == 'Firestorm')
        {
            return true;
        }
    }

    return false;
}

function bool IsTerrorTarget(ECountry eTarget)
{
    `LWCE_LOG_DEPRECATED_CLS(IsTerrorTarget);

    return false;
}

function bool LWCE_IsTerrorTarget(name nmCountry)
{
    local XGAlienObjective kObjective;
    local LWCE_XGAlienObjective kCEObjective;

    foreach m_arrObjectives(kObjective)
    {
        kCEObjective = LWCE_XGAlienObjective(kObjective);

        if (kCEObjective.m_kCETObjective.nmType == 'Terrorize' && kCEObjective.m_nmCountryTarget == nmCountry)
        {
            return true;
        }
    }

    return false;
}

function LaunchBlitz(array<ECityType> arrTargetCities, optional bool bFirstBlitz)
{
    local XGMission_Abduction kMission;
    local XGCity kCity;
    local array<EMissionRewardType> arrRewards;
    local EMissionRewardType eReward;
    local EMissionDifficulty eDiff;
    local LWCEAlertBuilder kAlertBuilder;
    local LWCE_TMissionReward kBlankReward, kReward;
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
    kAlertBuilder = `LWCE_ALERT('Abduction');

    for (I = 0; I < arrTargetCities.Length; I++)
    {
        kReward = kBlankReward;

        kCity = CITY(arrTargetCities[I]);
        iIndex = Rand(arrRewards.Length);
        eReward = arrRewards[iIndex];
        arrRewards.Remove(iIndex, 1);
        eDiff = GetAbductionDifficulty(Country(kCity.GetCountry()));

        kMission = Spawn(class'LWCE_XGMission_Abduction');
        kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
        kMission.m_iCity = kCity.m_iID;
        kMission.m_iCountry = CITY(kMission.m_iCity).GetCountry();
        kMission.m_iContinent = kCity.GetContinent();
        kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Abduction);
        kMission.m_v2Coords = kCity.GetCoords();
        kMission.m_kDesc.m_kAlienSquad = DetermineAbductionSquad(eDiff);
        kMission.m_eDifficulty = eDiff;

        LWCE_DetermineAbductionReward(kReward, eDiff, eReward);
        class'LWCE_XGMission_Extensions'.static.SetMissionRewards(kMission, kReward);

        kMission.m_iDetectedBy = 0;

        GEOSCAPE().AddMission(kMission);

        if (kMission.m_iID >= 0)
        {
            bMissionAdded = true;

            kAlertBuilder.AddInt(kMission.m_iID);
        }
    }

    if (bMissionAdded)
    {
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(kAlertBuilder.Build());
    }
}

function LogResistance(int iCountry)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(LogResistance);
}

function LogNoResistance(int nmCountry)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(LogNoResistance);
}

function LogUFORecord(XGShip_UFO kShip, EUFOMissionResult eResult)
{
    `LWCE_LOG_DEPRECATED_BY(LogUFORecord, LWCE_LogShipRecord);
}

/// <summary>
/// Records the given ship's mission and its outcome, storing a copy of the record internally,
/// as well as copies with the target country and target continent of the mission. Also handles
/// some consequences of the mission, such as changes to alien research/resources, and panic.
/// </summary>
function LWCE_LogShipRecord(LWCE_XGShip kShip, EUFOMissionResult eResult)
{
    local LWCE_TShipRecord kRecord;
    local LWCE_XGCountry kCountry;
    local LWCE_XGContinent kContinent;
    local int iPanic, iResources;

    // TODO: rewrite tons of the below and maybe refactor into a few functions
    kRecord.nmShipType = kShip.m_nmShipTemplate;
    kRecord.nmObjective = kShip.m_kObjective.m_kCETObjective.nmType;
    kRecord.eResult = eResult;
    kRecord.nmCountry = kShip.GetCountry();
    kRecord.iMonth = GetMonth();

    kCountry = `LWCE_XGCOUNTRY(kRecord.nmCountry);
    kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

    m_arrCEShipRecord.AddItem(kRecord);

    if (kRecord.nmShipType != 'UFOOverseer')
    {
        if (kRecord.nmObjective != 'Hunt')
        {
            if (kRecord.eResult == eUMR_Detected)
            {
                if (Rand(6) == 0)
                {
                    // Just triggers Bradford to tell us to stop letting UFOs get away
                    GEOSCAPE().m_bUFOIgnored = true;
                }
            }

            if (kRecord.eResult == eUMR_Undetected || kRecord.eResult == eUMR_Detected || kRecord.eResult == eUMR_Intercepted)
            {
                // TODO: use some other method to decide whether to apply panic/bonus research here
                if (kRecord.nmObjective != 'Bomb')
                {
                    iPanic = class'XGTacticalGameCore'.default.PANIC_UFO_IGNORED;

                    if (kShip.GetHPPercentage() == 1.0f)
                    {
                        // If the UFO is undamaged, give 1 bonus research
                        STAT_AddStat(2, 1);
                    }
                    else if (kShip.GetHPPercentage() >= 0.50)
                    {
                        // If the UFO is damaged, but at 50% HP or higher, 50/50 chance to gain 1 bonus research
                        STAT_AddStat(2, Rand(2));
                    }
                }

                // Panic scales with the percentage of health remaining on the UFO
                iPanic *= kShip.GetHPPercentage();
                kCountry.AddPanic(iPanic);
            }

            if (kRecord.eResult == eUMR_AssaultedFailed) // Ground assault on landed UFO that failed
            {
                kCountry.AddPanic(class'XGTacticalGameCore'.default.PANIC_UFO_ESCAPED);
            }
        }
    }

    // Branch: UFO was intercepted in some form
    if (kRecord.eResult == eUMR_Intercepted || kRecord.eResult == eUMR_ShotDown || kRecord.eResult == eUMR_Assaulted)
    {
        // If the UFO was shot down or successfully assaulted, increase XCOM's threat level
        if (kRecord.eResult == eUMR_ShotDown || kRecord.eResult == eUMR_Assaulted)
        {
            kShip.m_iHP = 0;
            STAT_AddStat(21, kShip.m_kTemplate.GetThreatIncrement(kShip.m_nmTeam));
        }

        iResources = kShip.m_kTemplate.GetResourceCost(kShip.m_nmTeam);

        if (IsOptionEnabled(9)) // Dynamic War
        {
            iResources /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }

        // Reduce alien resources based on proportion of UFO HP remaining
        iResources = iResources * (1.0f - kShip.GetHPPercentage());
        STAT_AddStat(19, -1 * iResources);
    }

    if (kRecord.nmObjective != 'Terrorize' && kRecord.nmObjective != 'Abduct')
    {
        kContinent.m_arrCEShipRecord.AddItem(kRecord);
        kCountry.m_arrCEShipRecord.AddItem(kRecord);
    }

    // If the player tried a ground assault on the UFO but failed, remove it so you can't try again
    if (kRecord.eResult == eUMR_AssaultedFailed)
    {
        LWCE_RemoveShip(kShip);
    }
}

function OnObjectiveEnded(XGAlienObjective kObj, XGShip_UFO kLastUFO)
{
    `LWCE_LOG_DEPRECATED_BY(OnObjectiveEnded, LWCEEnemyObjectiveTemplate.arrOnSuccessDelegates);
}

function OnUFOAttacked(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(OnUFOAttacked, LWCE_OnShipAttacked);
}

/// <summary>
/// Notifies the AI that a ship was attacked in an interception, but not shot down.
/// The ship may decide to abandon its mission if sufficiently damaged.
/// </summary>
function LWCE_OnShipAttacked(LWCE_XGShip kShip)
{
    // Hunting ships won't abandon their mission; instead they get an increasing chance to
    // fail based on damage taken
    if (kShip.m_kObjective.LWCE_GetType() == 'Hunt')
    {
        return;
    }

    // At 50% HP, the UFO decides to leave
    if (kShip.GetHPPercentage() <= 0.50)
    {
        kShip.m_fTimeInCountry = 0.0;
    }
}

function OnSatelliteDestroyed(int nmCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(OnSatelliteDestroyed);
}

/// <summary>
/// Notifies the AI that a country's satellite has been destroyed.
/// </summary>
function LWCE_OnSatelliteDestroyed(name nmCountry)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGShip kShip;

    LWCE_XGHeadquarters(HQ()).LWCE_RemoveSatellite(nmCountry);
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('SatelliteDestroyed').AddName(nmCountry).Build());

    kCountry = `LWCE_XGCOUNTRY(nmCountry);
    kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

    kContinent.AddPanic(class'XGTacticalGameCore'.default.PANIC_SAT_DESTROYED_CONTINENT);
    kCountry.AddPanic(class'XGTacticalGameCore'.default.PANIC_SAT_DESTROYED_COUNTRY);

    kContinent.m_kMonthly.iSatellitesLost += 1;
    STAT_AddStat(eRecap_SatellitesLost, 1);

    // Clear detection status of all ships, then redo it based on current satellites
    foreach m_arrCEShips(kShip)
    {
        kShip.m_iDetectedBy = -1;
        kShip.SetDetection(LWCE_XGGeoscape(GEOSCAPE()).LWCE_DetectShip(kShip));
    }
}

function OnUFODestroyed(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(OnUFODestroyed, LWCE_OnShipDestroyed);
}

/// <summary>
/// Notifies the AI that one of its ships has been destroyed outright during an interception.
/// Awards XCOM a bounty, decreases country panic, and records the shootdown for the Hunter Killer
/// achievement.
/// </summary>
function LWCE_OnShipDestroyed(LWCE_XGShip kShip)
{
    local LWCE_XGStorage kStorage;
    local bool bHasAlienMetallurgy;
    local int iAlloysInBounty, iAlloysInSalvage, iAlloysDivisor;

    kStorage = LWCE_XGStorage(STORAGE());

    // Give a cash and alloys bounty based on what ship type was shot down; cash is configured directly,
    // while alloys are determined based on the alloys in the salvage
    if (kShip.m_kTemplate.iBounty > 0)
    {
        AddResource(eResource_Money, kShip.m_kTemplate.iBounty);
    }

    iAlloysInSalvage = `LWCE_UTILS.GetItemQuantity(kShip.m_kTemplate.arrSalvage, 'Item_AlienAlloy').iQuantity;

    if (iAlloysInSalvage > 0)
    {
        bHasAlienMetallurgy = LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_AlienMetallurgy');
        iAlloysDivisor = bHasAlienMetallurgy ? 3 : 5;
        iAlloysInBounty = 1 + Rand(iAlloysInSalvage / iAlloysDivisor);

        kStorage.LWCE_AddItem('Item_AlienAlloy', iAlloysInBounty);
    }

    `LWCE_XGCOUNTRY(kShip.GetCountry()).AddPanic(class'XGTacticalGameCore'.default.PANIC_UFO_SHOOTDOWN);
    `LWCE_XGCONTINENT(kShip.GetContinent()).LWCE_RecordCountryHelped(kShip.GetCountry());

    kShip.m_kObjective.LWCE_NotifyOfCrash(kShip);

    STAT_AddStat(eRecap_UFOsShotDown, 1);
    STAT_AddProfileStat(eProfile_UFOsShotDown, 1);

    if (STAT_GetProfileStat(eProfile_UFOsShotDown) >= 40)
    {
        Achieve(AT_ShootingStars);
    }

    SITROOM().PushNarrativeHeadline(eTickerNarrative_UFOShotDown);
    LWCE_RemoveShip(kShip);

    if (m_arrCEShipsShotDown.Find(kShip.m_nmShipTemplate) == INDEX_NONE)
    {
        m_arrCEShipsShotDown.AddItem(kShip.m_nmShipTemplate);
    }

    if (CheckForHunterKiller())
    {
        Achieve(AT_HunterKiller);
    }
}

function OnUFOShotDown(XGShip_Interceptor kJet, XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(OnUFOShotDown, LWCE_OnShipShotDown);
}

/// <summary>
/// Notifies the AI that one of its ships has been shot down, but not destroyed.
/// </summary>
function LWCE_OnShipShotDown(LWCE_XGShip kAttacker, LWCE_XGShip kVictim)
{
    kVictim.m_kObjective.LWCE_NotifyOfCrash(kVictim);
    LWCE_DetermineCrashLoot(kVictim, kAttacker);
    LWCE_AIAddNewMission(eMission_Crash, kVictim);

    STAT_AddStat(eRecap_UFOsShotDown, 1);
    STAT_AddProfileStat(eProfile_UFOsShotDown, 1);

    if (STAT_GetProfileStat(eProfile_UFOsShotDown) >= 40)
    {
        Achieve(AT_ShootingStars);
    }

    `LWCE_XGCOUNTRY(kVictim.GetCountry()).AddPanic(class'XGTacticalGameCore'.default.PANIC_UFO_SHOOTDOWN);
    `LWCE_XGCONTINENT(kVictim.GetContinent()).LWCE_RecordCountryHelped(kVictim.GetCountry());

    Achieve(AT_TablesTurned);
    SITROOM().PushNarrativeHeadline(eTickerNarrative_UFOShotDown);

    if (m_arrCEShipsShotDown.Find(kVictim.m_nmShipTemplate) == INDEX_NONE)
    {
        m_arrCEShipsShotDown.AddItem(kVictim.m_nmShipTemplate);
    }

    if (CheckForHunterKiller())
    {
        Achieve(AT_HunterKiller);
    }
}

function LWCEMissionPlanTemplate PickMissionPlan(int Month, int Resources, int Threat)
{
    local LWCEMissionPlanTemplate kMissionPlan;
    local array<LWCEMissionPlanTemplate> arrAllMissionPlans, arrEligiblePlans;

    arrAllMissionPlans = `LWCE_MISSION_PLAN_TEMPLATE_MGR.GetAllMissionPlanTemplates();

    `LWCE_LOG("Selecting a mission plan out of " $ arrAllMissionPlans.Length $ " templates");

    if (arrAllMissionPlans.Length == 0)
    {
        `LWCE_LOG("No mission plan templates exist!");
        return none;
    }

    foreach arrAllMissionPlans(kMissionPlan)
    {
        if (kMissionPlan.IsEligible(Month, Resources, Threat))
        {
            arrEligiblePlans.AddItem(kMissionPlan);
        }
    }

    `LWCE_LOG("Found " $ arrEligiblePlans.Length $ " possible mission plan template(s) to choose from");

    if (arrEligiblePlans.Length == 0)
    {
        return none;
    }

    return arrEligiblePlans[Rand(arrEligiblePlans.Length)];
}

function RemoveUFO(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(RemoveUFO, LWCE_RemoveShip);
}

/// <summary>
/// Removes the given ship completely from the Geoscape and from the strategy AI's tracking,
/// then destroys it.
/// </summary>
function LWCE_RemoveShip(LWCE_XGShip kShip)
{
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_RemoveShip(kShip);
    m_arrCEShips.RemoveItem(kShip);

    kShip.HideEntity(true);
    kShip.GetEntity().Destroy();
    kShip.Destroy();

    PRES().MissionNotify();
}

/// <summary>
/// Returns a country to the XCOM Project, as after a successful alien base assault.
/// </summary>
function RestoreCountryToXCom(name nmCountry)
{
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(nmCountry);

    World().m_iNumCountriesLost -= 1;
    STAT_AddStat(eRecap_CountriesLost, -1);

    kCountry.RejoinXComProject();

    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('CountryRejoinedXCom').AddName(nmCountry).Build());

    // Reduce alien bonus research by 15
    STAT_AddStat(2, -15);
}

/// <summary>
/// Selects one or more countries to target for a mission objective, following the given target selection algorithm.
/// Note that this function is NOT idempotent; aside from having random elements, the algorithm
/// is also allowed to have side effects (e.g. the AvoidSatellites algorithm can sometimes deduct
/// from alien resources).
///
/// Some algorithms behave differently when scheduling multiple missions at the same time; for example, when the
/// Terrorize algorithm is used for multiple missions, all targets past the first one will be completely random.
/// For this reason, countries are selected in batches by this function.
/// </summary>
/// <param name="nmTargetSelectionAlgorithm">Which algorithm to use to select target countries.</param>
/// <param name="iNumTargets">How many target countries should be selected in total.</param>
/// <returns>An array of countries to target. Depending on the algorithm used, this may contain duplicate entries.</returns>
function array<name> SelectTargetCountries(name nmTargetSelectionAlgorithm, int iNumTargets)
{
    local array<name> arrTargets;

    // We can eventually add an event to allow extending these algorithms, whenever somebody asks for it

    switch (nmTargetSelectionAlgorithm)
    {
        case 'AvoidSatellites':
            return SelectTargetCountries_AvoidSatellites(iNumTargets);
        case 'ProtectAlienBases':
            return SelectTargetCountries_ProtectAlienBases(iNumTargets);
        case 'SatelliteCovered':
            return SelectTargetCountries_SatelliteCovered(iNumTargets);
        case 'SpreadPanic':
            return SelectTargetCountries_SpreadPanic(iNumTargets);
        case 'Terrorize':
            return SelectTargetCountries_Terrorize(iNumTargets);
        case 'XComAdvancedAirBase':
            return SelectTargetCountries_XComAdvancedAirBase(iNumTargets);
        case 'XComHQ':
            return SelectTargetCountries_XComHQ(iNumTargets);
        case 'XComMember':
            return SelectTargetCountries_XComMember(iNumTargets);
    }

    arrTargets.Length = 0;
    return arrTargets;
}

function SignPact(XGShip_UFO kUFO, int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(SignPact);
}

function LWCE_SignPact(LWCE_XGShip kShip, name nmCountry)
{
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(nmCountry);

    if (!kCountry.m_bSecretPact)
    {
        kCountry.SignPact();
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('SecretPact').AddName(nmCountry).Build());
    }
}

function bool ShouldHunt(XGShip_UFO eUFO, ECountry eTarget, EUFOMissionResult eResult)
{
    `LWCE_LOG_DEPRECATED_CLS(ShouldHunt);

    return false;
}

/// <summary>
/// Determines whether a hunt should follow after a scouting mission.
/// </summary>
function bool LWCE_ShouldHunt(LWCE_XGShip kShip, name nmTargetCountry, EUFOMissionResult eResult)
{
    if (eResult == eUMR_Undetected)
    {
        return false;
    }

    if (int(eResult) >= 3) // eUMR_ShotDown, eUMR_Assaulted
    {
        return false;
    }

    // Up to 50% chance to fail based on the country's shields
    if (Roll(`LWCE_XGCOUNTRY(nmTargetCountry).m_iShields / 2))
    {
        return false;
    }

    // Chance to fail equal to the percentage of health lost
    if (!Roll(int(100.0f * kShip.GetHPPercentage())))
    {
        return false;
    }

    // Base success chance is 40%, +1% for every 15 alien research
    if (Roll(40 + (STAT_GetStat(1) / 15)))
    {
        return true;
    }

    return false;
}

protected function int DetermineCrashedUFOMissionTimer(LWCE_XGShip kShip)
{
    switch (kShip.m_kTShip.eType)
    {
        case eShip_UFOSmallScout:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedScout);
        case eShip_UFOLargeScout:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedDestroyer);
        case eShip_UFOAbductor:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedAbductor);
        case eShip_UFOSupply:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedTransport);
        case eShip_UFOBattle:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedBattleship);
        case eShip_UFOEthereal:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedOverseer);
        case 10:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedFighter);
        case 11:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedRaider);
        case 12:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedHarvester);
        case 13:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedTerrorShip);
        case 14:
            return `LWCE_STRATCFG(MissionGeoscapeDuration_CrashedAssaultCarrier);
        default:
            `LWCE_LOG_CLS("Unrecognized UFO type " $ kShip.m_kTShip.eType $ ". Cannot determine mission timer.");
            return -1;
    }
}

protected function int DetermineLandedUFOMissionTimer(LWCE_XGShip kShip)
{
    // TODO: genericize this and a bunch of other stuff about missions
    switch (kShip.m_nmShipTemplate)
    {
        case 'UFOScout':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedScout);
        case 'UFOAbductor':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedAbductor);
        case 'UFOTransport':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedTransport);
        case 'UFORaider':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedRaider);
        case 'UFOHarvester':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedHarvester);
        case 'UFOTerrorShip':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedTerrorShip);
        case 'UFOAssaultCarrier':
            return `LWCE_STRATCFG(MissionGeoscapeDuration_LandedAssaultCarrier);
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

protected function LWCE_TMissionReward CreateMissionRewards(const array<LWCE_TItemQuantity> arrRewards)
{
    local LWCE_TItemQuantity kItemQuantity;
    local LWCE_TMissionReward kReward;

    foreach arrRewards(kItemQuantity)
    {
        kReward.arrItems.AddItem(kItemQuantity);
    }

    return kReward;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'AvoidSatellites' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_AvoidSatellites(int iNumTargets)
{
    local array<name> arrTargets;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int iCounter;

    kWorld = `LWCE_WORLD;

    while (iNumTargets > 0)
    {
        kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());

        // Roll to see if we need to avoid this satellite-covered country
        if (kCountry.HasSatelliteCoverage() && Rand(10) < STAT_GetStat(21))
        {
            // Keep rerolling until we run out of tries or hit an uncovered country
            for (iCounter = 0; iCounter < 16; iCounter++)
            {
                kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());

                if (!kCountry.HasSatelliteCoverage())
                {
                    // The reroll costs 5 alien resources if successful
                    STAT_AddStat(19, -5);
                    break;
                }
            }
        }

        arrTargets.AddItem(kCountry.m_nmCountry);

        iNumTargets--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'ProtectAlienBases' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_ProtectAlienBases(int iNumTargets)
{
    local array<LWCE_XGCountry> arrCouncilCountries, arrPossibleCountries;
    local array<name> arrTargets, arrReplacementTargets;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int Index;

    kWorld = `LWCE_WORLD;
    arrCouncilCountries = kWorld.GetCouncilCountries(/* bRequireCurrentMember */ false);

    foreach arrCouncilCountries(kCountry)
    {
        if (kCountry.LeftXCom() && kCountry.HasSatelliteCoverage())
        {
            arrPossibleCountries.AddItem(kCountry);
        }
    }

    // If any countries exist matching our original criteria, then all targets are pulled from this pool (duplicates allowed)
    if (arrPossibleCountries.Length > 0)
    {
        while (iNumTargets > 0)
        {
            arrTargets.AddItem(arrPossibleCountries[Rand(arrPossibleCountries.Length)].m_nmCountry);

            iNumTargets--;
        }

        return arrTargets;
    }

    // If we fail to find any targets with the initial criteria, fall back to the SpreadPanic algorithm
    arrTargets = SelectTargetCountries_SpreadPanic(iNumTargets);

    // .. but if any of the targets selected don't have satellite coverage, replace them
    // with a random satellite-covered country, per the SatelliteCovered algorithm
    for (Index = 0; Index < arrTargets.Length; Index++)
    {
        if (!kWorld.LWCE_GetCountry(arrTargets[Index]).HasSatelliteCoverage())
        {
            arrReplacementTargets = SelectTargetCountries_SatelliteCovered(1);
            arrTargets[Index] = arrReplacementTargets[0];
        }
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'SatelliteCovered' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_SatelliteCovered(int iNumTargets)
{
    local array<LWCE_XGCountry> arrCouncilCountries;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local array<name> arrEligibleCountries, arrTargets;

    kWorld = `LWCE_WORLD;

    arrCouncilCountries = `LWCE_WORLD.GetCouncilCountries(/* bRequireCurrentMember */ false);

    foreach arrCouncilCountries(kCountry)
    {
        if (kCountry.HasSatelliteCoverage())
        {
            arrEligibleCountries.AddItem(kCountry.m_nmCountry);
        }
    }

    while (iNumTargets > 0)
    {
        if (arrEligibleCountries.Length > 0)
        {
            // If we have countries with satellite coverage, always pull from them, with duplicates allowed
            arrTargets.AddItem(arrEligibleCountries[Rand(arrEligibleCountries.Length)]);
        }
        else
        {
            // Otherwise, just use any random member of the XCOM project
            kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());
            arrTargets.AddItem(kCountry.m_nmCountry);
        }

        iNumTargets--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'SpreadPanic' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_SpreadPanic(int iNumTargets)
{
    local array<LWCE_XGCountry> arrCouncilCountries, arrPossibleCountries;
    local array<name> arrTargets;
    local LWCE_XGCountry kAdjacentCountry, kCountry;
    local LWCE_XGWorld kWorld;
    local name nmAdjacentCountry;

    kWorld = `LWCE_WORLD;
    arrCouncilCountries = kWorld.GetCouncilCountries(/* bRequireCurrentMember */ false);

    if (kWorld.GetNumDefectors() == 0)
    {
        // If all countries are still in the council, then they're all eligible
        arrPossibleCountries = arrCouncilCountries;
    }
    else
    {
        // Otherwise, for each defected country, add its "neighboring" countries that haven't defected yet
        foreach arrCouncilCountries(kCountry)
        {
            if (!kCountry.LeftXCom())
            {
                continue;
            }

            foreach kCountry.m_kTemplate.arrAdjacentCountries(nmAdjacentCountry)
            {
                // Just in case someone messes up their config
                if (nmAdjacentCountry == kCountry.m_nmCountry)
                {
                    continue;
                }

                kAdjacentCountry = kWorld.LWCE_GetCountry(nmAdjacentCountry);

                // It is possible to add the same country multiple times, if multiple of its adjacencies have defected;
                // this is expected and matches the LW 1.0 behavior
                if (!kAdjacentCountry.LeftXCom())
                {
                    arrPossibleCountries.AddItem(kAdjacentCountry);
                }
            }
        }
    }

    arrPossibleCountries.Sort(LWCE_SortTerrorTargets);

    while (iNumTargets > 0)
    {
        if (Roll(class'XGTacticalGameCore'.default.AI_TERRORIZE_MOST_PANICKED))
        {
            arrTargets.AddItem(arrPossibleCountries[0].m_nmCountry);
        }

        arrTargets.AddItem(arrPossibleCountries[Rand(Min(3, arrPossibleCountries.Length))].m_nmCountry);

        iNumTargets--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'Terrorize' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_Terrorize(int iNumTargets)
{
    local int iTargetedMissions, iUntargetedMissions;
    local array<name> arrTargets;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;

    kWorld = `LWCE_WORLD;

    // TODO rename these config vars not to be about "terrors" per se
    // TODO add handling for Dynamic War
    iTargetedMissions = MaxTargetedTerrorsPerMonth < 0 ? iNumTargets : Min(MaxTargetedTerrorsPerMonth, iNumTargets);

    // If alien resources are high enough, they don't bother targeting any terrors at all
    if (STAT_GetStat(19) >= IndiscriminateTerrorResourceThreshold)
    {
        iTargetedMissions = 0;
    }

    iUntargetedMissions = iNumTargets - iTargetedMissions;

    // Targeted missions used the SpreadPanic algorithm
    if (iTargetedMissions > 0)
    {
        arrTargets = SelectTargetCountries_SpreadPanic(iTargetedMissions);
    }

    // All remaining targets are just purely random
    while (iUntargetedMissions > 0)
    {
        kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());
        arrTargets.AddItem(kCountry.m_nmCountry);

        iUntargetedMissions--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'XComAdvancedAirBase' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_XComAdvancedAirBase(int iNumTargets)
{
    local array<name> arrEligibleCountries, arrTargets;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGWorld kWorld;
    local LWCE_XGContinent kCEContinent;
    local XGContinent kContinent;

    kHQ = `LWCE_HQ;
    kWorld = `LWCE_WORLD;

    foreach kWorld.m_arrContinents(kContinent)
    {
        kCEContinent = LWCE_XGContinent(kContinent);

        // Ignore the starting continent, it doesn't technically have an air base
        if (kCEContinent.m_nmContinent == kHQ.m_nmContinent)
        {
            continue;
        }

        // If a continent has at least one Firestorm, it's an eligible target
        if (IsFirestormOnContinent(kCEContinent.m_nmContinent))
        {
            arrEligibleCountries.AddItem(kCEContinent.m_kTemplate.nmHQCountry);
            break;
        }
    }

    // LW 1.0 has no situation where multiple air base defenses are added at once, so we're just
    // going to allow duplicates
    while (iNumTargets > 0 && arrEligibleCountries.Length > 0)
    {
        arrTargets.AddItem(arrEligibleCountries[Rand(arrEligibleCountries.Length)]);
        iNumTargets--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'XComHQ' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_XComHQ(int iNumTargets)
{
    local array<name> arrTargets;
    local name nmHQCountry;

    nmHQCountry = `LWCE_HQ.LWCE_GetHomeCountry();

    while (iNumTargets > 0)
    {
        arrTargets.AddItem(nmHQCountry);

        iNumTargets--;
    }

    return arrTargets;
}

/// <summary>
/// Selects one or more target countries for missions based on the 'XComMember' algorithm. For more details,
/// see SelectTargetCountries, as well as DefaultLWCEBaseStrategyAI.ini.
/// </summary>
protected function array<name> SelectTargetCountries_XComMember(int iNumTargets)
{
    local array<LWCE_XGCountry> arrCouncilCountries;
    local array<name> arrTargets;
    local int Index;

    arrCouncilCountries = `LWCE_WORLD.GetCouncilCountries(/* bRequireCurrentMember */ true);

    // Unlike most algorithms, XComMember doesn't allow duplicates, because it is potentially being used for abduction
    // blitzes in which every country needs to be unique
    while (iNumTargets > 0 && arrCouncilCountries.Length > 0)
    {
        Index = Rand(arrCouncilCountries.Length);
        arrTargets.AddItem(arrCouncilCountries[Index].m_nmCountry);
        arrCouncilCountries.Remove(Index, 1);

        iNumTargets--;
    }

    return arrTargets;
}

function int SortTerrorTargets(ECountry eTarget1, ECountry eTarget2)
{
    `LWCE_LOG_DEPRECATED_CLS(SortTerrorTargets);

    return 0;
}

protected function int LWCE_SortTerrorTargets(LWCE_XGCountry kTarget1, LWCE_XGCountry kTarget2)
{
    if (LWCE_IsTerrorTarget(kTarget1.m_nmCountry))
    {
        if (LWCE_IsTerrorTarget(kTarget2.m_nmCountry))
        {
            if (kTarget2.GetPanicBlocks() > kTarget1.GetPanicBlocks())
            {
                return -1; // Swap
            }
            else
            {
                return 0; // Don't swap
            }
        }
        else
        {
            return -1;
        }
    }
    else
    {
        if (LWCE_IsTerrorTarget(kTarget2.m_nmCountry))
        {
            return 0;
        }
        else
        {
            if (kTarget2.GetPanicBlocks() > kTarget1.GetPanicBlocks())
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }
    }
}