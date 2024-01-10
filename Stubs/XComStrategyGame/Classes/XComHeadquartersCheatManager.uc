class XComHeadquartersCheatManager extends XComCheatManager within XComHeadquartersController;

var bool bSeeAll;
var bool bDoGlobeView;
var bool bFreeCam;
var bool bDebugAIEvents;
var bool bAllowDeluge;
var bool bDumpSkelPoseUpdates;
var ECharacter iForceAlienType;
var XGEntity kEntity;

exec function GivePerk(string strName){}
function bool GetFreeFacilitySpot(out int iX, out int iY){}

function XGGeoscape GEOSCAPE(){}
function XGHeadQuarters HQ(){}
function XGStrategyAI AI(){}
function XComHQPresentationLayer PRES(){}