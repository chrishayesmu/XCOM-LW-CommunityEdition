class LWCE_XGContinent extends XGContinent;

struct CheckpointRecord_LWCE_XGContinent extends XGContinent.CheckpointRecord
{
    var name m_nmBonus;
    var name m_nmContinent;
    var array<name> m_arrCECountries;
    var array<LWCE_TShipRecord> m_arrCEShipRecord;
};

var name m_nmBonus; // Which bonus is awarded for completing satellite coverage on this continent
var name m_nmContinent;
var array<name> m_arrCECountries;
var LWCE_TMonthlySummary m_kCEMonthly;
var array<LWCE_TShipRecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions targeting this continent.

var protectedwrite LWCEContinentTemplate m_kTemplate;

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_CONTINENT(m_nmContinent);
}

function InitNewGame()
{
    m_kTemplate = `LWCE_CONTINENT(m_nmContinent);

    m_arrBounds = m_kTemplate.arrBounds;
    m_arrCECountries = m_kTemplate.arrCountries;

    // Pick a bonus at random if there's multiple; if not, this picks the only one
    m_nmBonus = m_kTemplate.arrContinentBonuses[Rand(m_kTemplate.arrContinentBonuses.Length)];
}

function CalcRewards()
{
    local LWCE_XGCountry kCountry;
    local int iCountry;

    for (iCountry = 0; iCountry < m_arrCECountries.Length; iCountry++)
    {
        kCountry = `LWCE_XGCOUNTRY(m_arrCECountries[iCountry]);

        if (kCountry.LeftXCom() || !kCountry.IsCouncilMember())
        {
            continue;
        }

        m_kMonthly.iFunding += kCountry.GetCurrentFunding();
    }

    m_kMonthly.iScientists = GetScientists();
    m_kMonthly.iEngineers = GetEngineers();
}

function bool ContainsCountry(name nmCountry)
{
    return m_arrCECountries.Find(nmCountry) != INDEX_NONE;
}

function EndOfMonth(out TCouncilMeeting kCouncil)
{
    `LWCE_LOG_DEPRECATED_CLS(EndOfMonth);
}

function LWCE_EndOfMonth(out LWCE_TCouncilMeeting kCouncil)
{
    local LWCE_TMonthlySummary kClear;

    LWCE_WhoIsLeaving(kCouncil);
    CalcRewards();
    kCouncil.arrContinentSummaries.AddItem(m_kCEMonthly);
    m_kCEMonthly = kClear;
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

function int GetNumRemainingCountries()
{
    local LWCE_XGCountry kCountry;
    local int iCountry, iNumRemaining;

    for (iCountry = 0; iCountry < m_arrCECountries.Length; iCountry++)
    {
        kCountry = `LWCE_XGCOUNTRY(m_arrCECountries[iCountry]);

        if (kCountry.LeftXCom() || !kCountry.IsCouncilMember())
        {
            continue;
        }

        iNumRemaining++;
    }

    return iNumRemaining;
}

function int GetNumSatNodes()
{
    // Every country has a corresponding satellite node
    return m_arrCECountries.Length;
}

function int GetID()
{
    `LWCE_LOG_DEPRECATED_BY(GetID, LWCE_XGContinent.m_nmContinent);

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

    foreach m_arrCECountries(nmCountry)
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
    return m_arrCECountries[0];
}

function Vector2D GetHQLocation()
{
    return m_kTemplate.v2HQLocation;
}

function int GetRandomCity()
{
    `LWCE_LOG_DEPRECATED_CLS(GetRandomCity);

    return -1;
}

/// <summary>
/// Returns a random city in this continent. The city will belong to a country which is still a member of the XCom project.
/// </summary>
function name LWCE_GetRandomCity()
{
    return `LWCE_XGCOUNTRY(LWCE_GetRandomCouncilCountry()).LWCE_GetRandomCity();
}

function int GetRandomCouncilCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetRandomCouncilCountry);

    return -1;
}

/// <summary>
/// Returns a random country in this continent which is still a member of the XCom project.
/// </summary>
function name LWCE_GetRandomCouncilCountry()
{
    local LWCE_XGCountry kCountry;
    local array<name> arrCouncilCountries;
    local int iCountry;

    for (iCountry = 0; iCountry < m_arrCECountries.Length; iCountry++)
    {
        kCountry = `LWCE_XGCOUNTRY(m_arrCECountries[iCountry]);

        if (kCountry.IsCouncilMember() && !kCountry.m_bSecretPact)
        {
            arrCouncilCountries.AddItem(m_arrCECountries[iCountry]);
        }
    }

    return arrCouncilCountries[Rand(arrCouncilCountries.Length)];
}

/// <summary>
/// Checks whether this continent's bonus has been earned (i.e. it has complete satellite coverage over every country).
/// </summary>
function bool HasBonus()
{
    return m_iNumSatellites == m_arrCECountries.Length;
}

function RecordCountryHelped(ECountry eHelpedCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordCountryHelped);
}

function LWCE_RecordCountryHelped(name nmHelpedCountry)
{
    m_kCEMonthly.arrCountriesNotHelped.RemoveItem(nmHelpedCountry);
}

function RecordCountryNotHelped(ECountry eNotHelpedCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordCountryNotHelped);
}

function LWCE_RecordCountryNotHelped(name nmNotHelpedCountry)
{
    if (m_kCEMonthly.arrCountriesNotHelped.Find(nmNotHelpedCountry) == INDEX_NONE)
    {
        m_kCEMonthly.arrCountriesNotHelped.AddItem(nmNotHelpedCountry);
    }
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

        if (STAT_GetStat(eRecap_FirstContinent) == 0 && m_iNumSatellites == m_arrCECountries.Length)
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
        if (m_iNumSatellites == m_arrCECountries.Length)
        {
            LWCE_XGHeadquarters(HQ()).AdjustBonusLevel(m_nmBonus, class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT);

            switch (m_nmContinent)
            {
                case 'NorthAmerica':
                    STAT_SetStat(eRecap_NorthAmericaBonuses, 1);
                    break;
                case 'SouthAmerica':
                    STAT_SetStat(eRecap_SouthAmericaBonuses, 1);
                    break;
                case 'Europe':
                    STAT_SetStat(eRecap_EuropeBonuses, 1);
                    break;
                case 'Asia':
                    STAT_SetStat(eRecap_AsiaBonuses, 1);
                    break;
                case 'Africa':
                    STAT_SetStat(eRecap_AfricaBonuses, 1);
                    break;
            }
        }
    }
    else
    {
        bHadContinentBonus = m_iNumSatellites == m_arrCECountries.Length;

        LWCE_RecordCountryNotHelped(nmCountry);
        m_iNumSatellites -= 1;

        if (bHadContinentBonus)
        {
            LWCE_XGHeadquarters(HQ()).AdjustBonusLevel(m_nmBonus, -1 * class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT);
        }
    }
}

function WhoIsAdding()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(WhoIsAdding);
}

function WhoIsJoining()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(WhoIsJoining);
}

function WhoIsLeaving(out TCouncilMeeting kCouncil)
{
    `LWCE_LOG_DEPRECATED_CLS(WhoIsLeaving);
}

function LWCE_WhoIsLeaving(out LWCE_TCouncilMeeting kCouncil)
{
    local LWCE_XGCountry kCountry;
    local LWCE_XGExaltSimulation kExalt;
    local int iLeaveChance, iDefectThreshold, iNotHelpedThreshold, iChancePerPanic;
    local name nmCountry;
    local float fSatHelp, fSatNearbyHelp;

    kExalt = LWCE_XGExaltSimulation(EXALT());

    switch (Game().GetDifficulty())
    {
        case 0:
            iDefectThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_EASY;
            iNotHelpedThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_NOT_HELPED_EASY;
            iChancePerPanic = class'XGTacticalGameCore'.default.PANIC_DEFECT_CHANCE_PER_BLOCK_EASY;
            break;
        case 1:
            iDefectThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_NORMAL;
            iNotHelpedThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_NOT_HELPED_NORMAL;
            iChancePerPanic = class'XGTacticalGameCore'.default.PANIC_DEFECT_CHANCE_PER_BLOCK_NORMAL;
            break;
        case 2:
            iDefectThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_HARD;
            iNotHelpedThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_NOT_HELPED_HARD;
            iChancePerPanic = class'XGTacticalGameCore'.default.PANIC_DEFECT_CHANCE_PER_BLOCK_HARD;
            break;
        case 3:
            iDefectThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_CLASSIC;
            iNotHelpedThreshold = class'XGTacticalGameCore'.default.PANIC_DEFECT_THRESHHOLD_NOT_HELPED_CLASSIC;
            iChancePerPanic = class'XGTacticalGameCore'.default.PANIC_DEFECT_CHANCE_PER_BLOCK_CLASSIC;
            break;
    }

    fSatHelp = class'XGTacticalGameCore'.default.SAT_HELP_DEFECT[Game().GetDifficulty()];
    fSatNearbyHelp = class'XGTacticalGameCore'.default.SAT_NEARBY_HELP_DEFECT[Game().GetDifficulty()];

    foreach m_arrCECountries(nmCountry)
    {
        kCountry = `LWCE_XGCOUNTRY(nmCountry);

        if (!kCountry.IsCouncilMember() || kCountry.LeftXCom())
        {
            continue;
        }

        if (kExalt.LWCE_IsOperativeInCountry(nmCountry))
        {
            continue;
        }

        if (m_kCEMonthly.arrCountriesNotHelped.Find(nmCountry) != INDEX_NONE && kCountry.GetPanicBlocks() >= iNotHelpedThreshold)
        {
            iLeaveChance = int((float(kCountry.GetPanicBlocks() * kCountry.GetPanicBlocks()) / 10000.0) * 100.0f);
        }
        else if (kCountry.GetPanicBlocks() >= iDefectThreshold)
        {
            iLeaveChance = kCountry.GetPanicBlocks() * iChancePerPanic;
        }
        else
        {
            continue;
        }

        if (kCountry.HasSatelliteCoverage())
        {
            iLeaveChance *= fSatHelp;
        }
        else if (HasSatelliteCoverage())
        {
            iLeaveChance *= fSatNearbyHelp;
        }

        if (Roll(iLeaveChance))
        {
            LWCE_XGWorld(World()).LWCE_AddToDefectorsList(kCouncil, nmCountry);
        }
    }
}