class LWCECountryTemplate extends LWCEDataTemplate
    config(LWCEWorld);

var config int iEngineersPerMonth;          // How many engineers this country gives each month if it has satellite coverage
var config int iScientistsPerMonth;         // How many scientists this country gives each month if it has satellite coverage
var config int iCashPerMonth;               // How much this country gives each month if it has satellite coverage; a percentage is given without coverage
var config bool bIsCouncilMember;           // Whether this country is ever in the XCOM council. If not, the configuration above is unused, and
                                            // this country essentially only exists as a place for missions to occur.
var config array<config TRect> arrBounds;   // Bounding boxes which together define the area of this country.
var config array<name> arrCities;           // The names of the cities which are in this country.
var config array<name> arrStartingBonuses;  // Which bonuses are available when choosing this country as the starting country.
var config array<name> arrSatelliteBonuses; // Which bonuses are available via satellite coverage. If multiple are specified, one is chosen randomly
                                            // at the start of the campaign.

var const localized string strName;
var const localized string strNameWithArticle;
var const localized string strNameWithArticleLower;
var const localized string strNamePossessive;
var const localized string strNameAdjective;
