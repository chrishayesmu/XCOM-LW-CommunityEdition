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

function XGShip_UFO LaunchUFO(EShipType eShip, array<int> arrFlightPlan, Vector2D v2Target, float fDuration)
{
    local XGShip_UFO kUFO;

    if (eShip == eShip_UFOEthereal && m_kTObjective.eType == eObjective_Flyby)
    {
        v2Target = m_v2Target;
    }

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

    kUFO = Spawn(class'LWCE_XGShip_UFO');
    kUFO.Init(ITEMTREE().GetShip(eShip));
    kUFO.SetObjective(self);
    kUFO.SetFlightPlan(arrFlightPlan, v2Target, ECountry(m_iCountryTarget), fDuration);

    AI().AIAddNewUFO(kUFO);

    return kUFO;
}