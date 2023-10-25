class LWCE_XGAlienObjective extends XGAlienObjective;

struct CheckpointRecord_LWCE_XGAlienObjective extends XGAlienObjective.CheckpointRecord
{
    var LWCE_TObjective m_kCETObjective;
    var name m_nmCityTarget;
    var name m_nmCountryTarget;
    var LWCE_XGShip m_kLastShip;
};

var LWCE_TObjective m_kCETObjective;
var name m_nmCityTarget;
var name m_nmCountryTarget;
var name m_nmShipTeam;
var LWCE_XGShip m_kLastShip;

function Init(TObjective kObj, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity, optional EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(LWCE_TObjective kObj, int iStartDate, Vector2D v2Target, name nmShipTeam, name nmCountry, optional name nmCity, optional name nmShipType)
{
    local int iShip, iDate;

    m_kCETObjective = kObj;
    m_nmCountryTarget = nmCountry;
    m_nmCityTarget = nmCity;
    m_nmShipTeam = nmShipTeam;
    m_v2Target = v2Target;

    if (nmShipType != '')
    {
        for (iShip = 0; iShip < m_kCETObjective.arrShips.Length; iShip++)
        {
            m_kCETObjective.arrShips[iShip] = nmShipType;
        }
    }

    for (iDate = 0; iDate < m_kCETObjective.arrStartDates.Length; iDate++)
    {
        m_kCETObjective.arrStartDates[iDate] += iStartDate;
    }

    m_iNextMissionTimer = ConvertDaysToTimeslices(m_kCETObjective.arrStartDates[0], m_kCETObjective.arrRandDays[0]);
}

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

    `LWCE_LOG_DEPRECATED_CLS(GetFlightPlan);

    arrFlightPlan.Length = 0;
    return arrFlightPlan;
}

function array<name> LWCE_GetFlightPlan(name nmShipMission, out float fDuration)
{
    local array<name> arrFlightPlan;

    switch (nmShipMission)
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

function EAlienObjective GetType()
{
    `LWCE_LOG_DEPRECATED_CLS(GetType);

    return EAlienObjective(0);
}

function name LWCE_GetType()
{
    return m_kCETObjective.nmType;
}

function LaunchNextMission()
{
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;
    local int iSatIndex;
    local array<name> arrFlightPlan;
    local float fDuration;

    arrFlightPlan = LWCE_GetFlightPlan(m_kCETObjective.arrMissions[0], fDuration);
    kShip = LWCE_LaunchUFO(m_kCETObjective.arrShips[0], arrFlightPlan, DetermineMissionTarget(m_kCETObjective.arrRadii[0]), fDuration);
    m_iSightings += 1;

    `LWCE_XGCONTINENT(LWCE_GetContinent()).m_kMonthly.iUFOsSeen += 1;
    PopFrontMission();
    SetNextMissionTimer();

    if (m_iNextMissionTimer == -1)
    {
        m_kLastShip = kShip;
    }

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
    `LWCE_LOG_DEPRECATED_CLS(LaunchUFO);

    return none;
}

function LWCE_XGShip LWCE_LaunchUFO(name nmShipType, array<name> arrFlightPlan, Vector2D v2Target, float fDuration)
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