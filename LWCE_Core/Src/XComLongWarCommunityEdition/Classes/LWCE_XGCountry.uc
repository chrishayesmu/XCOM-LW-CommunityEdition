class LWCE_XGCountry extends XGCountry;

struct CheckpointRecord_LWCE_XGCountry extends XGCountry.CheckpointRecord
{
    var name m_nmCountry;
    var name m_nmContinent;
    var name m_nmBonus;
    var array<LWCE_TShipRecord> m_arrCEShipRecord;
    var array<name> m_arrCECities;
    var int m_iShields;
    var bool m_bIsGrantingBonus;
};

var name m_nmCountry;
var name m_nmContinent;
var name m_nmBonus;
var array<LWCE_TShipRecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions targeting this country.
var array<name> m_arrCECities; // Separate from the template in case the template changes mid-campaign due to mod changes/updates
var int m_iShields; // Country's defense level; replaces m_kTCountry.iScience in LW
var bool m_bIsGrantingBonus; // Whether this country is currently granting its bonus

var LWCECountryTemplate m_kTemplate;

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_COUNTRY(m_nmCountry);
}

function AddPanic(int iPanic, optional bool bSuppressHeadline)
{
    local int iPrevPanic;

    iPrevPanic = m_iPanic;

    if (m_iPanic == -1)
    {
        return;
    }

    if (!IsCouncilMember())
    {
        return;
    }

    if (m_iPanic >= 99 && iPanic > 0)
    {
        return;
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        // Don't apply dynamic war scaling to the panic which is applied at the start of the game
        if (STAT_GetStat(1) > 0)
        {
            iPanic /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    if (iPanic > 0)
    {
        if (Roll(m_iShields))
        {
            iPanic = Max(1, iPanic / 2);
        }
    }

    iPanic += LWCE_XGExaltSimulation(EXALT()).LWCE_GetPanicMod(m_nmCountry, iPanic);
    m_iPanic = Clamp(m_iPanic + iPanic, 0, 99);
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_ColorCountry(m_nmCountry, GetPanicColor());

    if (m_iPanic >= GetPanicWarningThreshhold() && m_iPanic - iPanic < GetPanicWarningThreshhold() && iPanic > 0)
    {
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('CountryPanic').AddName(m_nmCountry).Build());
    }

    if (iPrevPanic != m_iPanic)
    {
        if (!bSuppressHeadline)
        {
            LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushPanicHeadline(m_nmCountry, m_iPanic / 20);
        }
    }
}

/// <summary>
/// Checks whether this country has been targeted by a satellite-hunting mission since the last
/// time its satellite coverage changed.
/// </summary>
function bool BeenHunted()
{
    local int iRecord;

    for (iRecord = 0; iRecord < m_arrCEShipRecord.Length; iRecord++)
    {
        if (m_arrCEShipRecord[iRecord].nmObjective == 'Hunt')
        {
            return true;
        }
    }

    return false;
}

/// <summary>
/// Causes the country to recalculate its funding, taking its current state into account. This function is slightly
/// misnamed, as if the country isn't in the XCOM project, it won't be paying anything.
/// </summary>
function BeginPaying()
{
    m_iFunding = LWCE_CalcFunding();
}

function int CalcFunding(optional int iAdditionalPanic)
{
    `LWCE_LOG_DEPRECATED_CLS(CalcFunding);

    return -100;
}

/// <summary>
/// Retrieves the monthly funding for this country. Takes into account whether the country has a satellite,
/// whether the country has left the XCOM project, and any relevant bonuses or Second Wave options.
/// </summary>
/// <param name="bPretendHasSatellite">If true, the funding calculated will assume the country has a satellite,
/// regardless of whether one is actually present.</param>
/// <param name="bPretendHasNoSatellite">If true, the funding calculated will assume the country does not have
/// a satellite, regardless of whether one is actually present. Overridden by bPretendHasSatellite.</param>
function int LWCE_CalcFunding(optional bool bPretendHasSatellite = false, optional bool bPretendHasNoSatellite = false)
{
    local int iFunding;
    local float fPenaltyPct;

    if (LeftXCom())
    {
        return 0;
    }

    iFunding = m_kTemplate.iCashPerMonth;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(WarWeariness)))
    {
        fPenaltyPct = AI().GetMonth() * 0.050;
        fPenaltyPct = FClamp(fPenaltyPct, 0.0, 0.90);
        iFunding *= (1.0 - fPenaltyPct);
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(ResultsDriven)))
    {
        iFunding *= (float(100 - m_iPanic) / 100.0);
    }

    // TODO: Wealth of Nations should be applied here too, so the sit room shows the right numbers

    if (!bPretendHasSatellite && (!m_bSatellite || bPretendHasNoSatellite))
    {
        iFunding *= class'XGTacticalGameCore'.default.BASE_FUNDING[Game().GetDifficulty()] / 100.0f;
    }

    return iFunding;
}

function EContinent GetContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);

    return EContinent(-100);
}

function name LWCE_GetContinent()
{
    return m_nmContinent;
}

function int GetID()
{
    `LWCE_LOG_DEPRECATED_BY(GetID, LWCE_XGCountry.m_nmCountry);

    return -1;
}

function string GetName(optional bool bPossessive)
{
    if (bPossessive)
    {
        return m_kTemplate.strNamePossessive;
    }
    else
    {
        return m_kTemplate.strName;
    }
}

function string GetNameAdjective()
{
    return m_kTemplate.strNameAdjective;
}

function string GetNameWithArticle(optional bool bLowerCase)
{
    if (bLowerCase)
    {
        return m_kTemplate.strNameWithArticleLower;
    }
    else
    {
        return m_kTemplate.strNameWithArticle;
    }
}

function int GetRandomCity()
{
    `LWCE_LOG_DEPRECATED_CLS(GetRandomCity);

    return -1;
}

/// <summary>
/// Gets the name of a random city which belongs to this country.
/// </summary>
function name LWCE_GetRandomCity()
{
    return m_arrCECities[Rand(m_arrCECities.Length)];
}

function InitNewGame(TCountry kCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(InitNewGame);
}

function LWCE_InitNewGame(name nmCountry, name nmContinent)
{
    m_kTemplate = `LWCE_COUNTRY(nmCountry);

    m_nmCountry = nmCountry;
    m_nmContinent = nmContinent;

    m_arrBounds = m_kTemplate.arrBounds;

    // If this is the starting country, our bonus is already decided for us by the player
    if (IsStartingCountry())
    {
        m_nmBonus = LWCE_XGHeadquarters(HQ()).m_nmStartingBonus;
        m_bIsGrantingBonus = true;
    }
    else if (m_kTemplate.arrSatelliteBonuses.Length > 0)
    {
        // Otherwise, randomly choose a possible bonus for this country to have
        // TODO: it would be better to do this at a higher level and avoid the same bonus appearing in multiple countries
        // (unless some config setting indicates that we want that)
        m_nmBonus = m_kTemplate.arrSatelliteBonuses[Rand(m_kTemplate.arrSatelliteBonuses.Length)];
    }
}

function bool IsCouncilMember()
{
    return m_kTemplate.bIsCouncilMember;
}

/// <summary>
/// Checks whether this country is currently granting its bonus (in m_nmBonus) to the player. Usually this requires satellite
/// coverage, but the starting country always grants its starting bonus regardless. Note that granting the bonus doesn't imply
/// granting engineers/scientists per month, which requires satellite coverage.
/// </summary>
function bool IsGrantingBonus()
{
    return m_bIsGrantingBonus;
}

function bool IsStartingCountry()
{
    return LWCE_XGHeadquarters(HQ()).m_nmCountry == m_nmCountry;
}

function LeaveXComProject()
{
    LWCE_XGStrategyAI(AI()).LWCE_ClearCountryObjectives(m_nmCountry);

    m_iFunding = 0;
    m_iPanic = -1;

    if (LeftXCom())
    {
        return;
    }

    if (HasSatelliteCoverage())
    {
        LWCE_XGHeadquarters(HQ()).LWCE_RemoveSatellite(m_nmCountry);
    }

    m_bSecretPact = true;
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_ColorCountry(m_nmCountry, GetPanicColor());
    Game().CheckForLoseGame();
    LWCE_XGFundingCouncil(World().m_kFundingCouncil).LWCE_OnCountryLeft(m_nmCountry);
    World().m_iNumCountriesLost += 1;

    STAT_AddStat(eRecap_CountriesLost, 1);
    SetEntity(Spawn(class'LWCE_XGEntity'), GetStormEntity());

    // Taking a country and building a base costs the aliens 50 resources (except in the first month,
    // when it's the result of a guaranteed infiltration mission)
    if (AI().GetMonth() != 0)
    {
        STAT_AddStat(19, -50);
    }
}

/// <summary>
/// Brings this country back into the XCom project. In LW 1.0, this occurs after successfully assaulting an alien base.
/// </summary>
function RejoinXComProject()
{
    if (!LeftXCom())
    {
        return;
    }

    m_bSecretPact = false;

    if (HasSatelliteCoverage())
    {
        if (!m_bIsGrantingBonus)
        {
            m_bIsGrantingBonus = true;
            `LWCE_HQ.AdjustBonusLevel(m_nmBonus, class'LWCE_XGHeadquarters'.const.COUNTRY_SATELLITE_BONUS_LEVEL_AMOUNT);
        }

        `LWCE_XGCONTINENT(m_nmContinent).LWCE_SetSatelliteCoverage(m_nmCountry, true);
    }

    BeginPaying();

    // Destroy the alien base Geoscape entity
    if (GetEntity() != none)
    {
        HideEntity(true);
        GetEntity().Destroy();
    }
}

function SetSatelliteCoverage(bool bCoverage)
{
    if (m_bSatellite == bCoverage)
    {
        return;
    }

    m_bSatellite = bCoverage;

    // Only inform the continent of coverage changes if this country is still in the council; otherwise
    // it messes with logic for continent bonuses and panic
    if (!LeftXCom())
    {
        `LWCE_XGCONTINENT(m_nmContinent).LWCE_SetSatelliteCoverage(m_nmCountry, bCoverage);

        if (bCoverage)
        {
            AddPanic(class'XGTacticalGameCore'.default.PANIC_SAT_ADDED_COUNTRY);
        }
    }

    // Countries erase their records whenever satellite coverage changes, presumably because the history
    // is only used when checking if a country has been hunted
    m_arrCEShipRecord.Length = 0;

    // Check if we need to gain or lose a bonus due to this coverage change
    if (bCoverage && !LeftXCom() && !m_bIsGrantingBonus)
    {
        m_bIsGrantingBonus = true;
        `LWCE_HQ.AdjustBonusLevel(m_nmBonus, class'LWCE_XGHeadquarters'.const.COUNTRY_SATELLITE_BONUS_LEVEL_AMOUNT);
    }
    else if (!bCoverage && m_bIsGrantingBonus && !IsStartingCountry())
    {
        m_bIsGrantingBonus = false;
        `LWCE_HQ.AdjustBonusLevel(m_nmBonus, -1 * class'LWCE_XGHeadquarters'.const.COUNTRY_SATELLITE_BONUS_LEVEL_AMOUNT);
    }

    BeginPaying();
}