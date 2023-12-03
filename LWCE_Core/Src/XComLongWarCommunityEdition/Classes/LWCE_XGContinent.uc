class LWCE_XGContinent extends XGContinent;

struct CheckpointRecord_LWCE_XGContinent extends XGContinent.CheckpointRecord
{
    var name m_nmBonus;
    var name m_nmContinent;
    var array<LWCE_TShipRecord> m_arrCEShipRecord;
};

var name m_nmBonus; // Which bonus is awarded for completing satellite coverage on this continent
var name m_nmContinent;
var array<LWCE_TShipRecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions targeting this continent.

var protectedwrite LWCEContinentTemplate m_kTemplate;

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_CONTINENT(m_nmContinent);
}

function InitNewGame()
{
    m_kTemplate = `LWCE_CONTINENT(m_nmContinent);

    // Pick a bonus at random if there's multiple; if not, this picks the only one
    m_nmBonus = m_kTemplate.arrContinentBonuses[Rand(m_kTemplate.arrContinentBonuses.Length)];
}

function bool ContainsCountry(name nmCountry)
{
    return m_kTemplate.arrCountries.Find(nmCountry) != INDEX_NONE;
}

function TContinentBonus GetBonus()
{
    local TContinentBonus kBonus;

    `LWCE_LOG_DEPRECATED_CLS(GetBonus);

    return kBonus;
}

function name LWCE_GetBonus()
{
    return m_nmBonus;
}

function string GetName()
{
    return m_kTemplate.strName;
}

function int GetID()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetID);

    return -1;
}

/// <summary>
/// Retrieves the country which contains this continent's headquarters (which would typically be either XCOM HQ,
/// if this is the starting continent, or an air base if not). This is done by comparing the continent template's
/// v2HQLocation to the bounds of each country in the continent.
///
/// If the continent is misconfigured such that the HQ location doesn't fall in the bounds of any country, this will
/// simply return the first country belonging to this continent.
/// </summary>
function name GetHQCountry()
{
    local TRect kRect;
    local name nmCountry;
    local LWCECountryTemplate kCountry;
    local LWCECountryTemplateManager kCountryTemplateMgr;

    kCountryTemplateMgr = `LWCE_COUNTRY_TEMPLATE_MGR;

    foreach m_kTemplate.arrCountries(nmCountry)
    {
        kCountry = kCountryTemplateMgr.FindCountryTemplate(nmCountry);

        foreach kCountry.arrBounds(kRect)
        {
            if (`LWCE_UTILS.RectContainsPoint(kRect, m_kTemplate.v2HQLocation))
            {
                return nmCountry;
            }
        }
    }

    `LWCE_LOG_WARN("Continent " $ m_nmContinent $ " couldn't find any country containing its HQ location of " $ `V2DTOSTR(m_kTemplate.v2HQLocation));
    return m_kTemplate.arrCountries[0];
}

function Vector2D GetHQLocation()
{
    return m_kTemplate.v2HQLocation;
}

function RecordCountryHelped(ECountry eHelpedCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordCountryHelped);
}

function LWCE_RecordCountryHelped(name nmHelpedCountry)
{
    `LWCE_LOG_NOT_IMPLEMENTED(LWCE_RecordCountryHelped);

    // TODO: add LWCE version of m_kMonthly
    // m_kMonthly.arrCountriesNotHelped.RemoveItem(nmHelpedCountry);
}

function RecordCountryNotHelped(ECountry eNotHelpedCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordCountryNotHelped);
}

function LWCE_RecordCountryNotHelped(name nmNotHelpedCountry)
{
    `LWCE_LOG_NOT_IMPLEMENTED(LWCE_RecordCountryNotHelped);

    // TODO: add LWCE version of m_kMonthly
    // if (m_kMonthly.arrCountriesNotHelped.Find(nmNotHelpedCountry) == INDEX_NONE)
    // {
    //     m_kMonthly.arrCountriesNotHelped.AddItem(nmNotHelpedCountry);
    // }
}

function SetSatelliteCoverage(int iCountry, bool bCoverage)
{
    `LWCE_LOG_DEPRECATED_CLS(SetSatelliteCoverage);
}

function LWCE_SetSatelliteCoverage(name nmCountry, bool bCoverage)
{
    local bool bHadContinentBonus;

    if (bCoverage)
    {
        m_iNumSatellites += 1;
        AddPanic(class'XGTacticalGameCore'.default.PANIC_SAT_ADDED_CONTINENT);
        LWCE_RecordCountryHelped(nmCountry);

        if (STAT_GetStat(eRecap_FirstContinent) == 0 && m_iNumSatellites == m_arrCountries.Length)
        {
            STAT_SetStat(eRecap_FirstContinent, Game().GetDays());
        }

        if (CheckForAllTogetherNow())
        {
            Achieve(AT_AllTogehterNow);
        }

        // In LW 1.0, this retains the EW logic of "HQ continent always has its bonuses", so the corresponding
        // stat is never set. Since this isn't actually true in LW, we change it in LWCE to remove that check.
        // (Although it's not clear whether these values are ever read.)
        if (m_iNumSatellites == m_arrCountries.Length)
        {
            LWCE_XGHeadquarters(HQ()).AdjustBonusLevel(m_nmBonus, class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT);

            switch (m_eContinent)
            {
                case eContinent_NorthAmerica:
                    STAT_SetStat(eRecap_NorthAmericaBonuses, 1);
                    break;
                case eContinent_SouthAmerica:
                    STAT_SetStat(eRecap_SouthAmericaBonuses, 1);
                    break;
                case eContinent_Europe:
                    STAT_SetStat(eRecap_EuropeBonuses, 1);
                    break;
                case eContinent_Asia:
                    STAT_SetStat(eRecap_AsiaBonuses, 1);
                    break;
                case eContinent_Africa:
                    STAT_SetStat(eRecap_AfricaBonuses, 1);
                    break;
            }
        }
    }
    else
    {
        bHadContinentBonus = m_iNumSatellites == m_arrCountries.Length;

        LWCE_RecordCountryNotHelped(nmCountry);
        m_iNumSatellites -= 1;

        if (bHadContinentBonus)
        {
            LWCE_XGHeadquarters(HQ()).AdjustBonusLevel(m_nmBonus, -1 * class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT);
        }
    }
}