class LWCE_XGAlienObjective extends XGAlienObjective;

struct CheckpointRecord_LWCE_XGAlienObjective extends XGAlienObjective.CheckpointRecord
{
    var LWCE_TObjective m_kCETObjective;
    var LWCE_XGShip m_kLastShip;
    var name m_nmCityTarget;
    var name m_nmCountryTarget;
    var name m_nmShipTeam;
};

var LWCE_TObjective m_kCETObjective;
var LWCE_XGShip m_kLastShip;
var name m_nmCityTarget;
var name m_nmCountryTarget;
var name m_nmShipTeam;

var LWCEEnemyObjectiveTemplate m_kTemplate;

function Init(TObjective kObj, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity, optional EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmObjective, int iStartDate, Vector2D v2Target, name nmShipTeam, name nmCountry, optional name nmCity, optional name nmShipType)
{
    local LWCEShipMissionTemplate kShipMission;
    local LWCEShipMissionTemplateManager kShipMissionMgr;
    local int Index, iAlienResearch, iAlienResources;

    m_kCETObjective.nmType = nmObjective;
    m_nmCountryTarget = nmCountry;
    m_nmCityTarget = nmCity;
    m_nmShipTeam = nmShipTeam;
    m_v2Target = v2Target;

    kShipMissionMgr = `LWCE_SHIP_MISSION_TEMPLATE_MGR;
    m_kTemplate = `LWCE_ENEMY_OBJECTIVE(m_kCETObjective.nmType);

    iAlienResearch = `ALIEN_RESEARCH;
    iAlienResources = `ALIEN_RESOURCES;

    // Populate our objective data from the ship mission templates; after this, those templates aren't used again
    // except to retrieve their flight plans
    for (Index = 0; Index < m_kTemplate.arrMissions.Length; Index++)
    {
        kShipMission = kShipMissionMgr.FindShipMissionTemplate(m_kTemplate.arrMissions[Index]);

        m_kCETObjective.arrMissions.AddItem(kShipMission.GetMissionName());
        m_kCETObjective.arrRadii.AddItem(kShipMission.iFlightRadius);
        m_kCETObjective.arrRandDays.AddItem(kShipMission.iRandomDays);
        m_kCETObjective.arrShips.AddItem(kShipMission.RollForShip(iAlienResearch, iAlienResources));
        m_kCETObjective.arrStartDates.AddItem(kShipMission.iStartDays);
    }

    // Override the ship type, if one is provided
    if (nmShipType != '')
    {
        for (Index = 0; Index < m_kCETObjective.arrShips.Length; Index++)
        {
            m_kCETObjective.arrShips[Index] = nmShipType;
        }
    }

    // Offset all start dates by the incoming start date
    for (Index = 0; Index < m_kCETObjective.arrStartDates.Length; Index++)
    {
        m_kCETObjective.arrStartDates[Index] += iStartDate;
    }

    m_iNextMissionTimer = ConvertDaysToTimeslices(m_kCETObjective.arrStartDates[0], m_kCETObjective.arrRandDays[0]);
}

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_ENEMY_OBJECTIVE(m_kCETObjective.nmType);
}

function CheckIsComplete(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(CheckIsComplete);
}

/// <summary>
/// Checks if this objective is complete, meaning there are no more missions scheduled.
/// If so, and if the last mission succeeded, notifies the enemy strategy AI of mission success.
/// </summary>
function LWCE_CheckIsComplete(LWCE_XGShip kShip)
{
    if (m_iNextMissionTimer == -1 && !m_bComplete)
    {
        m_bComplete = true;

        if (m_bLastMissionSuccessful)
        {
            LWCE_XGStrategyAI(AI()).LWCE_OnObjectiveEnded(self, kShip);
        }
    }
}

/// <summary>
/// Removes all pending missions and their associated ships, schedules, etc, effectively rendering
/// this objective inactive.
/// </summary>
function ClearMissions()
{
    m_kCETObjective.arrMissions.Length = 0;
    m_kCETObjective.arrRadii.Length = 0;
    m_kCETObjective.arrRandDays.Length = 0;
    m_kCETObjective.arrShips.Length = 0;
    m_kCETObjective.arrStartDates.Length = 0;

    m_iNextMissionTimer = -1;
}

function Vector2D DetermineMissionTarget(int iRadius)
{
    local Vector2D v2Target;

    if (iRadius == 0)
    {
        return m_v2Target;
    }
    else if (iRadius == -1)
    {
        return `LWCE_XGCOUNTRY(m_nmCountryTarget).GetRandomLocation();
    }
    else
    {
        v2Target.X = m_v2Target.X + (MilesToXMapCoords(Rand(iRadius * 2) - iRadius));
        v2Target.Y = m_v2Target.Y + (MilesToYMapCoords(Rand(iRadius * 2) - iRadius));
        v2Target = RectClamp(v2Target, `LWCE_XGCOUNTRY(m_nmCountryTarget).GetBounds());
    }

    return v2Target;
}

/// <summary>
/// Rolls to see if the last ship launched was able to find a satellite over m_nmCountryTarget.
/// </summary>
function bool FoundSatellite()
{
    local LWCE_XGCountry kCountry;
    local int iSatelliteFoundChance;

    kCountry = `LWCE_XGCOUNTRY(m_nmCountryTarget);

    if (LWCE_XGHeadquarters(HQ()).LWCE_GetSatellite(m_nmCountryTarget) == INDEX_NONE)
    {
        return false;
    }

    if (!kCountry.HasSatelliteCoverage())
    {
        return false;
    }

    // Chance to detect satellite scales based on ship's HP percentage, linearly from 100% at max
    // health to 0% at 0 health
    iSatelliteFoundChance = 100 * m_kLastShip.GetHPPercentage();

    if (iSatelliteFoundChance <= 0)
    {
        return false;
    }

    if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_StealthSatellites'))
    {
        if (kCountry.BeenHunted())
        {
            iSatelliteFoundChance *= class'XGTacticalGameCore'.default.UFO_SECOND_PASS_FIND_STEALTH_SAT;
        }
        else
        {
            iSatelliteFoundChance *= class'XGTacticalGameCore'.default.UFO_FIND_STEALTH_SAT;
        }
    }
    else
    {
        if (kCountry.BeenHunted())
        {
            iSatelliteFoundChance *= class'XGTacticalGameCore'.default.UFO_SECOND_PASS_FIND_SAT;
        }
        else
        {
            iSatelliteFoundChance *= class'XGTacticalGameCore'.default.UFO_FIND_SAT;
        }
    }

    return Roll(iSatelliteFoundChance);
}

function EContinent GetContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);

    return EContinent(-100);
}

function name LWCE_GetContinent()
{
    return `LWCE_XGCOUNTRY(m_nmCountryTarget).LWCE_GetContinent();
}

function array<int> GetFlightPlan(EUFOMission eMission, out float fDuration)
{
    local array<int> arrFlightPlan;

    `LWCE_LOG_DEPRECATED_BY(GetFlightPlan, LWCEShipMissionTemplate.GetFlightPlanSteps);

    arrFlightPlan.Length = 0;
    return arrFlightPlan;
}

function EAlienObjective GetType()
{
    `LWCE_LOG_DEPRECATED_CLS(GetType);

    return EAlienObjective(0);
}

function name LWCE_GetType()
{
    return m_kCETObjective.nmType;
}

/// <summary>
/// Launches a new ship on the next scheduled mission, and schedules another mission following this one,
/// if any remain for this objective.
/// </summary>
function LaunchNextMission()
{
    local LWCEShipMissionTemplate kShipMission;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;
    local int iSatIndex;
    local array<name> arrFlightPlan;
    local float fDuration;

    // This shouldn't be necessary, but just in case a mod does something funny
    if (m_kCETObjective.arrMissions.Length == 0)
    {
        return;
    }

    kShipMission = `LWCE_SHIP_MISSION(m_kCETObjective.arrMissions[0]);
    arrFlightPlan = kShipMission.GetFlightPlanSteps(fDuration);
    kShip = LWCE_LaunchShip(m_kCETObjective.arrShips[0], arrFlightPlan, DetermineMissionTarget(m_kCETObjective.arrRadii[0]), fDuration);
    m_iSightings += 1;

    `LWCE_XGCONTINENT(LWCE_GetContinent()).m_kMonthly.iUFOsSeen += 1;
    PopFrontMission();
    SetNextMissionTimer();

    if (m_iNextMissionTimer == -1)
    {
        m_kLastShip = kShip;
    }

    // TODO: move this logic into some event listener or template delegate
    if (m_kCETObjective.nmType == 'Hunt')
    {
        kHQ = LWCE_XGHeadquarters(HQ());
        iSatIndex = kHQ.LWCE_GetSatellite(m_nmCountryTarget);

        if (iSatIndex != INDEX_NONE)
        {
            kHQ.m_arrCESatellites[iSatIndex].kSatEntity.SetHidden(false);
        }
    }
}

function XGShip_UFO LaunchUFO(EShipType eShip, array<int> arrFlightPlan, Vector2D v2Target, float fDuration)
{
    `LWCE_LOG_DEPRECATED_BY(LaunchUFO, LWCE_LaunchShip);

    return none;
}

/// <summary>
/// Spawns a ship and immediately sets it to begin on the given flight plan.
/// </summary>
function LWCE_XGShip LWCE_LaunchShip(name nmShipType, array<name> arrFlightPlan, Vector2D v2Target, float fDuration)
{
    local LWCE_XGShip kShip;

    if (nmShipType == 'UFOOverseer' && m_kCETObjective.nmType == 'CommandOverwatch')
    {
        v2Target = m_v2Target;
    }

    kShip = Spawn(class'LWCE_XGShip');
    kShip.LWCE_Init(nmShipType, LWCE_GetContinent(), m_nmShipTeam);
    kShip.SetObjective(self);
    kShip.SetFlightPlan(arrFlightPlan, v2Target, m_nmCountryTarget, fDuration);

    LWCE_XGStrategyAI(AI()).LWCE_AIAddNewShip(kShip);

    return kShip;
}

function NotifyOfAssaulted(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(NotifyOfAssaulted);
}

/// <summary>
/// Informs the enemy strategic AI that this ship landed and was successfully assaulted by XCOM.
/// </summary>
function LWCE_NotifyOfAssaulted(LWCE_XGShip kShip)
{
    m_iDetected += 1;

    if (kShip == m_kLastShip)
    {
        LWCE_CheckIsComplete(kShip);
    }
}

function NotifyOfCrash(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(NotifyOfCrash);
}

/// <summary>
/// Informs the enemy strategic AI that this ship was shot down by XCOM. This could mean it was either
/// destroyed or resulted in a crash landing, spawning a mission.
/// </summary>
function LWCE_NotifyOfCrash(LWCE_XGShip kShip)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGStrategyAI kAI;

    kAI = LWCE_XGStrategyAI(AI());
    kContinent = `LWCE_XGCONTINENT(LWCE_GetContinent());

    m_iShotDown += 1;
    m_iDetected += 1;
    kContinent.m_kMonthly.iUFOsShotdown += 1;
    kContinent.m_kMonthly.iUFOsDetected += 1;

    kAI.LWCE_LogShipRecord(kShip, eUMR_ShotDown);

    if (kShip == m_kLastShip)
    {
        LWCE_CheckIsComplete(kShip);
    }
}

function NotifyOfSuccess(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(NotifyOfSuccess);
}

/// <summary>
/// Informs the enemy strategic AI that this ship has completed its mission successfully.
/// </summary>
function LWCE_NotifyOfSuccess(LWCE_XGShip kShip)
{
    local EUFOMissionResult eResult;

    if (kShip == m_kLastShip)
    {
        m_bLastMissionSuccessful = true;
    }

    if (kShip.m_bEverDetected)
    {
        m_iDetected += 1;
        `LWCE_XGCONTINENT(LWCE_GetContinent()).m_kMonthly.iUFOsDetected += 1;
        eResult = eUMR_Detected;
    }
    else
    {
        eResult = eUMR_Undetected;
    }

    if (kShip.m_bWasEngaged)
    {
        eResult = eUMR_Intercepted;
    }

    LWCE_XGStrategyAI(AI()).LWCE_LogShipRecord(kShip, eResult);

    if (kShip == m_kLastShip)
    {
        LWCE_CheckIsComplete(kShip);
    }

    LWCE_XGStrategyAI(AI()).LWCE_RemoveShip(kShip);
}

function OverseerUpdate()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OverseerUpdate);
}

function PopFrontMission()
{
    m_kCETObjective.arrStartDates.Remove(0, 1);
    m_kCETObjective.arrMissions.Remove(0, 1);
    m_kCETObjective.arrShips.Remove(0, 1);
    m_kCETObjective.arrRadii.Remove(0, 1);
    m_kCETObjective.arrRandDays.Remove(0, 1);
}

function SetNextMissionTimer()
{
    if (m_kCETObjective.arrMissions.Length > 0)
    {
        m_iNextMissionTimer = ConvertDaysToTimeslices(m_kCETObjective.arrStartDates[0], m_kCETObjective.arrRandDays[0]);
    }
    else
    {
        m_iNextMissionTimer = -1;
    }
}