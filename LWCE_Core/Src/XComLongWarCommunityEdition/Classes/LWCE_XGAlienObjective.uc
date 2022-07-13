class LWCE_XGAlienObjective extends XGAlienObjective;

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