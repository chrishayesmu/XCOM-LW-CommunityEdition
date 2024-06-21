class LWCECountryTemplate extends LWCEDataTemplate
    dependson(LWCETypes)
    config(LWCEWorld);

struct LWCE_TNameListConfig
{
    var name nmGender;
    var name nmRace;
    var name nmNameList;
    var int iWeight;

    structdefaultproperties
    {
        iWeight=1
    }
};

var config int iStartingCash;                // How much cash the player will have if choosing this country as their starting location.
var config int iEngineersPerMonth;           // How many engineers this country gives each month if it has satellite coverage.
var config int iScientistsPerMonth;          // How many scientists this country gives each month if it has satellite coverage.
var config int iCashPerMonth;                // How much this country gives each month if it has satellite coverage; a percentage is given without coverage.
var config bool bIsCouncilMember;            // Whether this country is ever in the XCOM council. If not, the configuration above is unused, and
                                             // this country essentially only exists as a place for missions to occur.
var config string strFlagIconPath;           // Path to an image containing the icon of this country's flag. Must contain the "img:///" prefix.
var config string strSatelliteNarrativePath; // Path to an XComNarrativeMoment to be played when satellite coverage is established over this country.
var config Vector2D v2SatNodeLoc;            // The location on the Geoscape to display a satellite graphic if this country has a satellite.
var config array<config TRect> arrBounds;    // Bounding boxes which together define the area of this country.
var config int iSortIndex;                   // Where to sort this country within its continent in the satellite room UI, with lower values appearing first.
var config array<name> arrCities;            // The names of the cities which are in this country.
var config array<name> arrStartingBonuses;   // Which bonuses are available when choosing this country as the starting country.
var config array<name> arrSatelliteBonuses;  // Which bonuses are available via satellite coverage. If multiple are specified, one is chosen randomly
                                             // at the start of the campaign.
var config array<name> arrAdjacentCountries; // Which countries should be considered to be adjacent to this one. The enemy strategy AI uses this to decide
                                             // how to expand away from countries in which they already have bases. Adjacency should be a symmetric relationship,
                                             // where [A adj B] implies [B adj A], but this is not enforced currently.
var config int iSoldierOriginWeight;         // The weighting which assigns the relative likelihood of soldiers to be from this country.
var config array<LWCE_TNameListConfig> arrFirstNameLists;
var config array<LWCE_TNameListConfig> arrLastNameLists;
var config array<LWCE_NameIntKVP> arrSoldierRaceWeights;
var config array<LWCE_NameIntKVP> arrSpokenLanguageWeights;

var const localized string strName;
var const localized string strNameWithArticle;
var const localized string strNameWithArticleLower;
var const localized string strNamePossessive;
var const localized string strNameAdjective;
var const localized array<localized string> TickerPanicLow;
var const localized array<localized string> TickerPanicMedium;
var const localized array<localized string> TickerPanicHigh;
var const localized array<localized string> TickerPanicMax;

function name GetCountryName()
{
    return DataName;
}

function TRect GetBounds()
{
    local int iBounds;
    local TRect kRect;

    kRect = arrBounds[0];

    for (iBounds = 1; iBounds < arrBounds.Length; iBounds++)
    {
        if (arrBounds[iBounds].fLeft < kRect.fLeft)
        {
            kRect.fLeft = arrBounds[iBounds].fLeft;
        }

        if (arrBounds[iBounds].fTop < kRect.fTop)
        {
            kRect.fTop = arrBounds[iBounds].fTop;
        }

        if (arrBounds[iBounds].fRight > kRect.fRight)
        {
            kRect.fRight = arrBounds[iBounds].fRight;
        }

        if (arrBounds[iBounds].fBottom > kRect.fBottom)
        {
            kRect.fBottom = arrBounds[iBounds].fBottom;
        }
    }

    return kRect;
}

function Vector2D GetCoords()
{
    return `LWCE_UTILS.RectCenter(GetBounds());
}

/// <summary>
/// Rolls for a name list to use when generating a character's first name.
/// </summary>
/// <param name="nmRace">Filters to name lists supporting this race; if blank, no filter is applied.</param>
/// <param name="nmGender">Filters to name lists supporting this gender; if blank, no filter is applied.</param>
function name RollForFirstNameList(name nmRace, name nmGender)
{
    return RollForNameList(nmRace, nmGender, arrFirstNameLists);
}

/// <summary>
/// Rolls for a name list to use when generating a character's last name.
/// </summary>
/// <param name="nmRace">Filters to name lists supporting this race; if blank, no filter is applied.</param>
/// <param name="nmGender">Filters to name lists supporting this gender; if blank, no filter is applied.</param>
function name RollForLastNameList(name nmRace, name nmGender)
{
    return RollForNameList(nmRace, nmGender, arrLastNameLists);
}

/// <summary>
/// Rolls for a race to assign to a new soldier, using arrSoldierRaceWeights.
/// </summary>
function name RollForRace()
{
    local int iRoll, iSum, iTotalWeight;
    local LWCE_NameIntKVP kWeightPair;

    if (arrSoldierRaceWeights.Length == 0)
    {
        return '';
    }

    foreach arrSoldierRaceWeights(kWeightPair)
    {
        iTotalWeight += kWeightPair.Value;
    }

    iRoll = Rand(iTotalWeight);

    foreach arrSoldierRaceWeights(kWeightPair)
    {
        iSum += kWeightPair.Value;

        if (iRoll < iSum)
        {
            return kWeightPair.Key;
        }
    }

    return arrSoldierRaceWeights[arrSoldierRaceWeights.Length - 1].Key;
}

/// <summary>
/// Rolls for a language to assign to a new soldier, using arrSpokenLanguageWeights. This function does
/// NOT respect the m_bForeignLanguages setting in XComOnlineProfileSettingsDataBlob; callers are responsible
/// for checking that themselves if applicable in their context.
/// </summary>
function name RollForSpokenLanguage()
{
    local int iRoll, iSum, iTotalWeight;
    local LWCE_NameIntKVP kWeightPair;

    if (arrSpokenLanguageWeights.Length == 0)
    {
        return '';
    }

    foreach arrSpokenLanguageWeights(kWeightPair)
    {
        iTotalWeight += kWeightPair.Value;
    }

    iRoll = Rand(iTotalWeight);

    foreach arrSpokenLanguageWeights(kWeightPair)
    {
        iSum += kWeightPair.Value;

        if (iRoll < iSum)
        {
            return kWeightPair.Key;
        }
    }

    return arrSpokenLanguageWeights[arrSpokenLanguageWeights.Length - 1].Key;
}

protected function name RollForNameList(name nmRace, name nmGender, const out array<LWCE_TNameListConfig> arrListConfigs)
{
    local int iRoll, iSum, iTotalWeight;
    local LWCE_TNameListConfig kListConfig;

    if (arrListConfigs.Length == 0)
    {
        return '';
    }

    foreach arrListConfigs(kListConfig)
    {
        if (kListConfig.nmRace != '' && nmRace != '' && kListConfig.nmRace != nmRace)
        {
            continue;
        }

        if (kListConfig.nmGender != '' && nmGender != '' && kListConfig.nmGender != nmGender)
        {
            continue;
        }

        iTotalWeight += kListConfig.iWeight;
    }

    iRoll = Rand(iTotalWeight);

    foreach arrListConfigs(kListConfig)
    {
        if (kListConfig.nmRace != '' && nmRace != '' && kListConfig.nmRace != nmRace)
        {
            continue;
        }

        if (kListConfig.nmGender != '' && nmGender != '' && kListConfig.nmGender != nmGender)
        {
            continue;
        }

        iSum += kListConfig.iWeight;

        if (iRoll < iSum)
        {
            return kListConfig.nmNameList;
        }
    }

    return arrListConfigs[arrListConfigs.Length - 1].nmNameList;
}