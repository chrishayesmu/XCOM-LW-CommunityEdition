class LWCE_XGCountry extends XGCountry;

struct CheckpointRecord_LWCE_XGCountry extends XGCountry.CheckpointRecord
{
    var name m_nmCountry;
    var name m_nmContinent;
    var array<LWCE_TUFORecord> m_arrCEShipRecord;
    var int m_iShields;
    var bool m_bIsCouncilMember;
};

var name m_nmCountry;
var name m_nmContinent;
var array<LWCE_TUFORecord> m_arrCEShipRecord; // History of all of the enemy ships that have been sent on missions targeting this country.
var int m_iShields; // Country's defense level; replaces m_kTCountry.iScience in LW
var bool m_bIsCouncilMember;

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

    if (!m_kTCountry.bCouncilMember)
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

    iPanic += EXALT().GetPanicMod(ECountry(m_kTCountry.iEnum), iPanic);
    m_iPanic = Clamp(m_iPanic + iPanic, 0, 99);
    GEOSCAPE().ColorCountry(ECountry(GetID()), GetPanicColor());

    if (m_iPanic >= GetPanicWarningThreshhold() && m_iPanic - iPanic < GetPanicWarningThreshhold() && iPanic > 0)
    {
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('CountryPanic').AddInt(m_kTCountry.iEnum).Build());
    }

    if (iPrevPanic != m_iPanic)
    {
        if (!bSuppressHeadline)
        {
            SITROOM().PushPanicHeadline(ECountry(GetID()), m_iPanic / 20);
        }
    }

    CalcFunding();
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

function InitNewGame(TCountry kCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(InitNewGame);
}

function LWCE_InitNewGame(name nmCountry, name nmContinent)
{
    m_nmCountry = nmCountry;
    m_nmContinent = nmContinent;

    m_kTemplate = `LWCE_COUNTRY(m_nmCountry);
}

function bool IsCouncilMember()
{
    return m_kTemplate.bIsCouncilMember;
}

function LeaveXComProject()
{
    LWCE_XGStrategyAI(AI()).LWCE_ClearFromAbductionList(m_nmCountry);

    m_iFunding = 0;
    m_iPanic = -1;

    if (LeftXCom())
    {
        return;
    }

    if (HasSatelliteCoverage())
    {
        HQ().RemoveSatellite(m_nmCountry);
    }

    m_bSecretPact = true;
    GEOSCAPE().ColorCountry(m_nmCountry, GetPanicColor());
    Game().CheckForLoseGame();
    World().m_kFundingCouncil.OnCountryLeft(m_nmCountry);
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

function SetSatelliteCoverage(bool bCoverage)
{
    if (m_bSatellite == bCoverage)
    {
        return;
    }

    m_bSatellite = bCoverage;

    if (!m_bSecretPact)
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

    BeginPaying();
}