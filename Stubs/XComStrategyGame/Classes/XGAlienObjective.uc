class XGAlienObjective extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord
{
    var array<XGAlienObjective> m_arrSimultaneousObjs;
    var TObjective m_kTObjective;
    var int m_iCountryTarget;
    var int m_iCityTarget;
    var Vector2D m_v2Target;
    var bool m_bAbandoned;
    var int m_iTimer;
    var int m_iNextMissionTimer;
    var bool m_bComplete;
    var bool m_bLastMissionSuccessful;
    var bool m_bMissionThwarted;
    var int m_iSightings;
    var int m_iDetected;
    var int m_iShotDown;
    var XGShip_UFO m_kLastUFO;
    var bool m_bFoundSat;
    var bool m_bAbductionLaunched;
};

var array<XGAlienObjective> m_arrSimultaneousObjs;
var TObjective m_kTObjective;
var int m_iCountryTarget;
var int m_iCityTarget;
var Vector2D m_v2Target;
var bool m_bAbandoned;
var bool m_bComplete;
var bool m_bLastMissionSuccessful;
var bool m_bMissionThwarted;
var bool m_bFoundSat;
var bool m_bAbductionLaunched;
var int m_iTimer;
var int m_iNextMissionTimer;
var int m_iSightings;
var int m_iDetected;
var int m_iShotDown;
var XGShip_UFO m_kLastUFO;


function Init(TObjective kObj, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity, optional EShipType eShip){}
function EContinent GetContinent(){}
function NotifyOfCrash(XGShip_UFO kUFO){}
function NotifyOfAssaulted(XGShip_UFO kUFO){}
function NotifyOfSuccess(XGShip_UFO kUFO){}
function CheckIsComplete(XGShip_UFO kUFO){}
function Update(optional int iNumUnits){}
function LaunchNextMission(){}
function Vector2D DetermineMissionTarget(int iRadius){}
function SetNextMissionTimer(){}
function PopFrontMission(){}
function ClearMissions(){}
function int ConvertDaysToTimeslices(int iStartDate, int iRandomDays){}
function OverseerUpdate(){}
function XGShip_UFO LaunchUFO(EShipType eShip, array<int> arrFlightPlan, Vector2D v2Target, float fDuration){}
function array<int> GetFlightPlan(EUFOMission eMission, out float fDuration){}
function bool FoundSatellite(){}
function EAlienObjective GetType(){}
