class XGMission extends XGStrategyActor
    hidecategories(Navigation)
    config(GameData)
    abstract
    notplaceable;
//complete stub

struct CheckpointRecord
{
    var bool m_bScripted;
    var string m_strTitle;
    var Vector2D m_v2Coords;
    var int m_iCity;
    var int m_iCountry;
    var int m_iContinent;
    var int m_iMissionType;
    var int m_iID;
    var int m_iDuration;
    var array<int> m_arrArtifacts;
    var XGBattleDesc m_kDesc;
    var int m_iDetectedBy;
    var EMissionTime m_eTimeOfDay;
    var XGAlienObjective m_kAlienObjective;
    var TMissionReward m_kReward;
    var XGStrategyActorNativeBase.EMissionDifficulty m_eDifficulty;
    var XGEntity m_kEntity;
    var string m_strTip;
};

var bool m_bScripted;
var bool m_bCheated;
var Vector2D m_v2Coords;
var int m_iCity;
var int m_iCountry;
var int m_iContinent;
var int m_iMissionType;
var int m_iID;
var int m_iDuration;
var array<int> m_arrArtifacts;
var XGBattleDesc m_kDesc;
var int m_iDetectedBy;
var ETimeOfDay m_eTimeOfDay;
var EMissionDifficulty m_eDifficulty;
var XGAlienObjective m_kAlienObjective;
var TMissionReward m_kReward;
var string m_strHelp;
var float fAnimationTimer;
var const localized string m_aFirstOpName[53];
var const localized string m_aSecondOpName[76];
var const localized string m_strOpAvenger;
var const localized string m_strOpAshes;
var const localized string m_strOpRandom;
var string m_strTitle;
var string m_strSituation;
var string m_strObjective;
var string m_strOpenExclamationMark;
var string m_strTip;

function OnLoadGame(){};
function bool IsDetected(){}
simulated function string GetTitle(){}
simulated function string GetHelp(){}
function Vector2D GetCoords(){}
function XGCity GetCity(){}
function int GetCountry(){}
function XGContinent GetContinent(){}
function EMissionRegion GetRegion(){}
function string GetLocationString(){}
function XGShip_Dropship GetAssignedSkyranger(){}
function GenerateBattleDescription(){}
function TBriefingInfo GetBriefingInfo(){}
function string CalcTime(){}
protected function string GenerateOpName(optional bool bTutorial){}
function int GetEnemyCount(){}
function string GetSpeciesList(){}
