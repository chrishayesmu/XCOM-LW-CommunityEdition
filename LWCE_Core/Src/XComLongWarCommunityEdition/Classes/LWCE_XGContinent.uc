class LWCE_XGContinent extends XGContinent;

struct CheckpointRecord_LWCE_XGContinent extends XGContinent.CheckpointRecord
{
    var name m_nmBonus;
    var name m_nmContinent;
    var array<LWCE_TUFORecord> m_arrCEShipRecord;
};

var name m_nmBonus; // Which bonus is awarded for completing satellite coverage on this continent
var name m_nmContinent;
var array<LWCE_TUFORecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions targeting this continent.

var LWCEContinentTemplate m_kTemplate;

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