class XComTacticalSoundInfo_Names extends Object
    hidecategories(Object)
	dependson(XComContentManager);
//complete stub

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

function string GetAmbienceByContinent(const out array<RegionAmbiences> Ambiences, EContinent Continent){}
function string GetBackgroundAmbience(){}
function string GetTerrorMissionAmbience(){}
function string GetExaltMissionAmbience(){}
function LoadSoundsFor(XComTacticalSoundInfo SoundInfoTemplate, Object ObjectRequestingLoad, delegate<XComContentManager.OnObjectLoaded> BackgroundCallback, delegate<XComContentManager.OnObjectLoaded> OverlayCallback){}
function SoundCue FindKismetOverlayAmbience(){}
