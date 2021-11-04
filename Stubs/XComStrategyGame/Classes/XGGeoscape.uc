class XGGeoscape extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct TMCPin
{
    var Vector2D v2Loc;
    var TText txtTitle;
    var float fTimer;
};

struct CheckpointRecord
{
    var float m_fTimeScale;
    var float m_fAITimer;
    var float m_fGameTimer;
    var int m_iTicks;
    var int m_iDetectedUFOs;
    var bool m_bUFOIgnored;
    var array<XGMission> m_arrMissions;
    var int m_iNumMissions;
    var int m_iMissionCounter;
    var int m_iFunding;
    var int m_iFundingChange;
    var int m_iLastMonthPaid;
    var bool m_bFirstTime;
    var XGMission_ReturnToBase m_kReturnMission;
    var XGDateTime m_kDateTime;
    var array<XGInterception> m_arrInterceptions;
    var array<int> m_arrCraftEncounters;
    var bool m_bGlobeHidden;
    var bool m_bAchivementsEnabled;
    var bool m_bAchievementsDisabledXComHero;
    var XGEntity m_kTemple;
    var bool m_bDEMOPlayedTerror;
};

var float m_fTimeScale;
var float m_fAITimer;
var float m_fGameTimer;
var int m_iTicks;
var int m_iDetectedUFOs;
var bool m_bUFOIgnored;
var bool m_bGlobeHidden;
var bool m_bFirstTime;
var bool m_bInPauseMenu;
var bool m_bAchivementsEnabled;
var bool m_bAchievementsDisabledXComHero;
var bool m_bDEMOPlayedTerror;
var bool m_bSeeAll;
var bool m_bInFinalBriefing;
var bool m_bActiveFundingCouncilRequestPopup;
var array<XGMission> m_arrMissions;
var int m_iNumMissions;
var int m_iMissionCounter;
var int m_iLastMonthPaid;
var XGMission_ReturnToBase m_kReturnMission;
var XGDateTime m_kDateTime;
var array<TGeoscapeAlert> m_arrAlerts;
var array<XGInterception> m_arrInterceptions;
var array<int> m_arrCraftEncounters;
var export editinline AudioComponent m_sndUFOKlaxon;
var float m_fTimeForShips;
var XGEntity m_kTemple;
var XGGeoscapeUI UI;
var array<XGMission> m_arrRemove;
var float m_fTickTime;

	
function Init(){}
function InitNewGame(){}
function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
function InitLoadGame(){}
function XGRecapSaveData GetRecapSaveData(){}
function int AddMission(XGMission kMission, optional bool bFirst){}
function StartHQAssault(){}
function SpawnTempleEntity(){}
function ClearAllMissions(){}
function MissionAlert(int iMission){}
function RemoveMission(XGMission kMission, bool bXComSuccess, optional bool bExpired, optional bool bFirstMission, optional bool bDontApplyToContinent){}
function RemoveMissionByID(int Mid, optional bool bXComSuccess){}
function RemoveAllCovertOpsExtractionMissions(){}
function bool HasOverseerCrash(){}
function RemoveUFO(XGShip_UFO kUFO){}
function int GetSatTravelTime(int iCountry){}
function Vector2D GetShortestDist(Vector2D v2Start, Vector2D v2End){}
function float ShortestWrappedDistance(float fStart, float fEnd){}
function CancelInterception(XGShip_UFO kUFO){}
function XGMission GetMission(int iMissionID){}
function int GetNumMissions(){}
function int GetNumMissionsOfType(int iMissionType){}
function UpdateShips(float fDeltaT){}
function bool UpdateShip(XGShip ship, float fDeltaT) {}
function OnFundingCouncilRequestAdded(const TFCRequest kRequest){}
function int GetTurn(){}
function bool HasAlerts() {}
function bool HasRequests(){}
function Alert(TGeoscapeAlert kAlert){}
function TGeoscapeAlert GetTopAlert() {}
function ClearTopAlert(optional bool bDoNotResume) {}
function InitPlayer(){}
function TGeoscapeAlert MakeAlert(EGeoscapeAlert eAlert, optional int iData1, optional int iData2, optional int iData3, optional int iData4) {}
function SkyrangerArrival(XGShip_Dropship kSkyranger, optional bool bRequestOrders){}
function bool CanIdentifyCraft(EShipType eCraft){}
function SkyrangerReturnToBase(XGShip_Dropship kSkyranger, optional bool bMissionAborted){}
function bool SkyrangerTakeMission(XGShip_Dropship kSkyranger, XGMission kMission){}
function AddInterception(XGInterception kInterception) {}
function RemoveInterception(XGInterception kInterception){}
function DetermineMap(XGMission kMission, optional EMissionTime eTime){}
function AdjustTimeForCurrentMap(XGMission kMission){}
function bool CanExit(){}
function OnExitMissionControl(){}
function OnEnterMissionControl(){}
function XGMission GetFinalMission(){}
function bool MissionIsAvailable(XGMission kMission){}
function TakeFirstMission(){}
function int TrackUFO(XGShip_UFO kUFO){}
function int DetectUFO(XGShip_UFO kUFO) {}
function RadarUpdate(){}
function UpdateSound(){}
function StopSounds(){}
function SeeAll(bool bSeeAll){}
function OnUFODetected(int iUFO) {}
function OnUFOVanished(int iUFO){}
function OnAlienBaseDetected(XGMission_AlienBase kBase){}
function AIUpdate(){}
event Destroyed(){}
event Tick(float fDeltaT){}
function GameTick(float fGameTime){}
function int EncodePayDay(){}
function bool IsPayDay(){}
function bool IsBusy(){}
function GetEvents(out array<THQEvent> arrEvents){}
function bool IsPaused(){}
function Pause(){}
function Resume(){}
function bool DecreaseTimeScale(){}
function bool IncreaseTimeScale(){}
function ResetShipTimeScale(){}
function bool CanLaunchSatellites(){}
function bool IsScanning(){}
function bool CanScan(){}
function FastForward(){}
function RestoreNormalTimeFrame(){}
function Vector2D WrapCoords(Vector2D v2Coords){}
function ShowCouncil(){}
function HideCouncil(){}
function ShowHoloEarth(){}
function ShowRealEarth(){}
function HideEarth(){}
function bool CountryHasAbductionMission(ECountry eTargetCountry){}
function UpdateCountryColors(){}
function ColorCountry(ECountry eCntry, Color Col){}
function ClearCountryColor(ECountry eCntry, Color Col){}
function PulseCountry(ECountry eCntry, Color col1, Color col2, float fTime){}
function ClearCountryPulse(ECountry eCntry){}
function UpdateUI(float fDeltaT){}
function OnHQAssaultIntroComplete(){}
simulated function PreloadSquadIntoSkyranger(EGeoscapeAlert eAlertType, bool bUnload){}
simulated function UnloadPreloadedSquad(){}
simulated function PreloadSquad(){}

