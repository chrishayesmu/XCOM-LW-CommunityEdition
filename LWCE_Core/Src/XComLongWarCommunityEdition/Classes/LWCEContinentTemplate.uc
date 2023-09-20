class LWCEContinentTemplate extends LWCEDataTemplate
    config(LWCEWorld);

var config Vector2D v2HQLocation;           // Where on the Geoscape this continent is located.
var config array<config TRect> arrBounds;   // Bounding boxes which together define the area of this continent.
var config array<name> arrCountries;        // The names of the countries which are in this continent.
var config array<name> arrContinentBonuses; // Which bonuses are available via complete satellite coverage. If multiple are specified, one is chosen randomly
                                            // at the start of the campaign.

var config string ImagePath;                // TODO

var const localized string strName;
var const localized string strNameWithArticle;
var const localized string strNameWithArticleLower;
var const localized string strNamePossessive;
var const localized string strNameAdjective;

function name GetContinentName()
{
    return DataName;
}