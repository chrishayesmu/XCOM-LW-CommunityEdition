class XComHQCountryBorderToggles extends Actor;
//completet stub

enum ESatelliteCoverage
{
    eSat_None,
    eSat_Regular,
    eSat_Hyperwave,
    eSat_MAX
};

var() StaticMeshActor ActorToAffect;
var XComHQCountryBorderTogglesTexture CB_TogglesTexture;
var XComHQCountryBorderTogglesTexture CB_ColorTexture;
var XComHQCountryBorderTogglesTexture CB_BorderColorTexture;
var XComHQCountryBorderTogglesTexture CB_SatelliteCoverageTexture;
var int CountryToggled[255];
var Texture2D IndexTexture;
var const Color InitialColorOfAllCountries;
var XComColorWarper CountryColors[255];
var XComColorWarper BorderColors[255];
var XComColorWarper SatelliteColors[255];
var transient bool bRenderCountryColors;
var transient bool bRenderCountryToggles;
var transient bool bRenderCountryBorders;
var transient bool bRenderSatelliteCoverage;
var transient float CurrentPulseTime;
var transient float TotalPulseTime;
var Color Black;

function int GetCountryByTexCoord(float U, float V){}
function bool InWaterByTexCoord(float U, float V){}
function ToggleAllCountries(bool bShow){}
function ToggleCountry(int iCountry, bool bShow){}
function ToggleCountry_SpecificIndex(int Country, bool bShow){}
function bool IsCountryToggled(int iCountry){}
function ColorAllCountries(Color CountryColor){}
function ColorAllCountryBorders(Color CountryColor){}
function Color ChooseSatColor(ESatelliteCoverage SatCoverage){}
function ColorAllSatelliteCoverage(ESatelliteCoverage SatCoverage){}
function ColorCountry_SpecificIndex(int Country, Color CountryColor){}
function ColorCountry_PulseRepeatedly_SpecificIndex(int Country, Color CountryColor0, Color CountryColor1, float TotalDuration){}
function ColorSatellite_SpecificIndex(int Country, ESatelliteCoverage SatCoverage){}
simulated event PreBeginPlay(){}
simulated function UpdateMaterialsWithTextures(){}
simulated event Init(){}
function RenderTogglesTexture(Canvas C){}
function RenderColorTexture(Canvas C){}
function RenderBorderColorTexture(Canvas C){}
function RenderSatelliteCoverageTexture(Canvas C){}
