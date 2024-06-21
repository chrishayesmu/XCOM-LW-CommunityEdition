class XComTacticalSoundInfo_Names extends Object
    dependson(XComTacticalSoundManager)
    hidecategories(Object);

struct RegionAmbiences
{
    var() EContinent Continent;
    var() string AmbienceToUse;
};

struct RainAmbience
{
    var() ERainIntensity Intensity;
    var() string AmbienceToUse;
};

var(Normal) array<string> BackgroundAmbiences;
var(Terror) array<string> TerrorAmbiences;
var(EXALT) array<string> ExaltAmbiences;
var(Rain) array<RainAmbience> RainAmbiences;