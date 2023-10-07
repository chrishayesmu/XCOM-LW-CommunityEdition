class LWCE_XGAlienObjective extends XGAlienObjective;

struct CheckpointRecord_LWCE_XGAlienObjective extends CheckpointRecord
{
    var name m_nmCityTarget;
    var name m_nmCountryTarget;
};

var name m_nmCityTarget;
var name m_nmCountryTarget;

function Init(TObjective kObj, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity, optional EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(TObjective kObj, int iStartDate, Vector2D v2Target, name nmCountry, optional name nmCity, optional EShipType eShip)
{
    local int iShip, iDate;

    m_kTObjective = kObj;
    m_nmCountryTarget = nmCountry;
    m_nmCityTarget = nmCity;
    m_v2Target = v2Target;

    if (eShip != eShip_None)
    {
        for (iShip = 0; iShip < m_kTObjective.arrUFOs.Length; iShip++)
        {
            m_kTObjective.arrUFOs[iShip] = eShip;
        }
    }

    for (iDate = 0; iDate < m_kTObjective.arrStartDates.Length; iDate++)
    {
        m_kTObjective.arrStartDates[iDate] += iStartDate;
    }

    m_iNextMissionTimer = ConvertDaysToTimeslices(m_kTObjective.arrStartDates[0], m_kTObjective.arrRandDays[0]);
}

function bool FoundSatellite()
{
    if (HQ().GetSatellite(ECountry(m_iCountryTarget)) == -1)
    {
        return false;
    }

    if (!Country(m_iCountryTarget).HasSatelliteCoverage())
    {
        return false;
    }

    m_iCityTarget = Max(0, ((200 * m_kLastUFO.GetHP()) / m_kLastUFO.GetHullStrength()) - 100);

    if (m_iCityTarget > 0)
    {
        if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_StealthSatellites'))
        {
            if (Country(m_iCountryTarget).BeenHunted())
            {
                m_iCityTarget *= class'XGTacticalGameCore'.default.UFO_SECOND_PASS_FIND_STEALTH_SAT;
            }
            else
            {
                m_iCityTarget *= class'XGTacticalGameCore'.default.UFO_FIND_STEALTH_SAT;
            }
        }
        else
        {
            if (Country(m_iCountryTarget).BeenHunted())
            {
                m_iCityTarget *= class'XGTacticalGameCore'.default.UFO_SECOND_PASS_FIND_SAT;
            }
            else
            {
                m_iCityTarget *= class'XGTacticalGameCore'.default.UFO_FIND_SAT;
            }
        }

        return Roll(m_iCityTarget);
    }

    return false;
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

function XGShip_UFO LaunchUFO(EShipType eShip, array<int> arrFlightPlan, Vector2D v2Target, float fDuration)
{
    `LWCE_LOG_DEPRECATED_CLS(LaunchUFO);

    return none;
}

function LWCE_XGShip LWCE_LaunchUFO(name nmShipType, array<int> arrFlightPlan, Vector2D v2Target, float fDuration)
{
    local LWCE_XGShip kUFO;

    if (nmShipType == 'UFOOverseer' && m_kTObjective.eType == eObjective_Flyby)
    {
        v2Target = m_v2Target;
    }

    // TODO: this is rolling ship type; we probably need multiple functions to do all this
    if (eShip < eShip_UFOSmallScout || eShip > /* Assault Carrier */ 14)
    {
        switch (m_kTObjective.eType)
        {
            case 0: // Research
            case 1: // Scout
            case 2: // Harvest
            case 4: // Hunt
            case 8: // Bombing
                STAT_SetStat(103, m_kTObjective.eType);
                eShip = EShipType(AI().GetNumOutsiders());
                break;
            case 3: // Command Overwatch (Ethereal fly-by)
            case 7: // Infiltrate
                eShip = eShip_UFOEthereal;
                break;
            case 5: // Abductions
                eShip = eShip_UFOAbductor;
                break;
            case 6: // Terrorize
            case 9: // HQ assault
                eShip = 14; // Assault Carrier
                break;
            default:
                eShip = eShip_UFOSmallScout;
                break;
            }
    }

    kUFO = Spawn(class'LWCE_XGShip');
    kUFO.Init(ITEMTREE().GetShip(eShip));
    kUFO.SetObjective(self);
    kUFO.SetFlightPlan(arrFlightPlan, v2Target, ECountry(m_iCountryTarget), fDuration);

    AI().AIAddNewUFO(kUFO);

    return kUFO;
}