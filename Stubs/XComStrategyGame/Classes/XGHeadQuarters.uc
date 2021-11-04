class XGHeadQuarters extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

const m_iSpeechLength = 14;

struct CheckpointRecord
{
    var string m_strName;
    var array<TSatellite> m_arrSatellites;
    var array<XGOutpost> m_arrOutposts;
    var array<XGFacility> m_arrFacilities;
    var XGFacility_MissionControl m_kMC;
    var XGFacility_Engineering m_kEngineering;
    var XGFacility_Labs m_kLabs;
    var XGFacility_Hangar m_kHangar;
    var XGFacility_Barracks m_kBarracks;
    var XGFacility_GollopChamber m_kGollop;
    var XGFacility_SituationRoom m_kSitRoom;
    var array<int> m_arrBaseFacilities;
    var array<TStaffOrder> m_arrHiringOrders;
    var array<TShipOrder> m_akInterceptorOrders;
    var array<TShipTransfer> m_arrShipTransfers;
    var int m_iCash;
    var int m_iContinent;
    var int m_iCountry;
    var XGBase m_kBase;
    var bool m_bWarning;
    var TMissionReward m_kLastReward;
    var TMissionResult m_kLastResult;
    var array<int> m_arrLastCargo;
    var array<EItemType> m_arrLastCaptives;
    var TFCMission m_kLastFCM;
    var XGObjectiveManager m_kObjectiveManager;
    var int m_iMoneyMadeThisMonth;
    var bool m_bCashPositive;
    var XGEntity m_kEntity;
    var array<int> m_arrFacilityBinks;
    var bool m_bHyperwaveActivated;
    var bool m_bUrgedEWFacility;
};

var string m_strName;
var array<TSatellite> m_arrSatellites;
var array<XGOutpost> m_arrOutposts;
var array<XGFacility> m_arrFacilities;
var XGFacility_MissionControl m_kMC;
var XGFacility_Engineering m_kEngineering;
var XGFacility_Labs m_kLabs;
var XGFacility_Hangar m_kHangar;
var XGFacility_Barracks m_kBarracks;
var XGFacility_GollopChamber m_kGollop;
var XGFacility_SituationRoom m_kSitRoom;
var array<int> m_arrBaseFacilities;
var array<TStaffOrder> m_arrHiringOrders;
var array<TShipOrder> m_akInterceptorOrders;
var array<TShipTransfer> m_arrShipTransfers;
var int m_iCash;
var int m_iContinent;
var int m_iCountry;
var XGFacility m_kActiveFacility;
var XGBase m_kBase;
var bool m_bWarning;
var bool m_bCashPositive;
var bool m_bHyperwaveActivated;
var bool m_bUrgedEWFacility;
var bool m_bInFacilityTransition;
var TMissionReward m_kLastReward;
var TMissionResult m_kLastResult;
var array<int> m_arrLastCargo;
var array<EItemType> m_arrLastCaptives;
var TFCMission m_kLastFCM;
var XGObjectiveManager m_kObjectiveManager;
var int m_iMoneyMadeThisMonth;
var array<int> m_arrFacilityBinks;
var array<TItemProject> m_akFirestormOrders;
var float m_fAnnounceTimer;
var float m_fCentralTimer;
var const localized string m_strSpeakSatOpRegion;
var const localized string m_strSpeakCommanderReportFacility;
var const localized string m_arrSpeech[14];
var const localized string m_strScienceLab;
var const localized string m_strEngineering;
var const localized string m_strBarracks;
var const localized string m_strMissionControl;
var const localized string m_strHangar;
var const localized string m_strSituationRoom;
var const localized string m_strDebtWarningTitle;
var const localized string m_strDebtWarningBody;
var const localized string m_strDebtWarningOK;
var const localized string m_strDebtWarningCancel;

function Init(bool bLoadingFromSave){}
function InitNewGame(){}
private final function CheckForSoldiersOrphanedOnMission(){}
function InitLoadGame(){}
function Update(){}
function CheckWarning(){}
function SetHQWarning(bool bWarningOn){}
function bool IsHQWarningOn(){}
function ECountry GetHomeCountry(){}
function UpdateSatellites(){}
function bool IsSatelliteInTransitTo(int iCountry){}
function bool CanLaunchSatelliteTo(int iCountry){}
function AddSatelliteNode(int iCountry, int iType, optional bool bInstant){}
function string RecordSatelliteLaunch(XGCountry LaunchedOverCountry){}
function UpdateSatCoverageGraphics(){}
function ActivateSatellite(int iSatellite, bool bVoice){}
function RemoveSatellite(int iCountry){}
function int GetSatellite(ECountry eSatCountry){}
function int HasBonus(EContinentBonus eBonus){}
function RemoveFacility(int iFacility){}
function AddFacility(int iFacility){}
function bool HasFacility(int iFacility){}
function int GetPowerUsed(){}
function int GetPowerCapacity(){}
function int GetSatelliteLimit(){}
function int GetAvailablePower(){}
function PayOverhead(){}
function int GetSalaryCost(){}
function PaySalaries(){}
function OrderStaff(int iType, int iQuantity){}
function string RecordHiredAdditionalSoldiers(int iQuantity){}
function int GetStaffOnOrder(EStaffType eStaff){}
function UpdateHiringOrders(){}
function OrderInterceptors(int iContinent, int iQuantity){}
function string RecordPurchasingInterceptor(int iQuantity){}
function UpdateFirestorms(TItemProject kOrder){}
function ReduceInterceptorOrder(int iOrder){}
function int GetInterceptorsOnOrder(optional int OrderIndex){}
function UpdateInterceptorOrders(){}
function GetEvents(out array<THQEvent> arrEvents){}
function int GetFacilityMaintenanceCost(){}
function int GetMaintenanceTotal(){}
function PayMaintenance(){}
function string RecordPayingMaintenance(){}
function int GetNumStaff(){}
function int GetNumFacilities(EFacilityType eFacility){}
function int GetCaptiveCapacity(){}
function int GetSoldierCapacity(){}
function int GetScientistCapacity(){}
function int GetEngineerCapacity(){}
function Vector2D GetCoords(){}
function int GetContinent(){}
function bool IsHyperwaveActive(){}
function CreateFacilities(){}
function SetActiveFacility(XGFacility kFacility, float fInterpTime){}
function EnterFacility(XGFacility kFacility, float fInterpTime, int iView, optional bool bAllowAutoSave){}
function LeaveFacility(XGFacility kFacility){};
function JumpToFacility(XGFacility kFacility, float fInterpTime, optional int iView, optional name NewState){}
function EnterMissionControlAutosave(){}
function array<XGFacility> GetFacilities(){}
function array<XGFacility> GetMainFacilities(){}
function NextFacility(){}
function PrevFacility(){}
function XGFacility_MissionControl GetMissionControl(){}
function XGFacility_Barracks GetBarracks(){}
function XGFacility_Hangar GetHangar(){}
function XGFacility_Labs GetLabs(){}
function XGFacility_Engineering GetEngineering(){}
function XGFacility_GollopChamber GetGollop(){}
function XGFacility_SituationRoom GetSitRoom(){}
function CentralChatter(){}
function RandomAnnouncement(){}
function bool FacilityAnnouncement(){}
function bool CheckForDebrief(){}
function bool CheckForAlerts(){};
function AddOutpost(int iContinent){}
function bool HasOutpostInContinent(int iContinent){}
function CheckForOperatingLoss(IScreenMgrInterface kScreen){}
function UIDebtWarning(IScreenMgrInterface kScreen){}
function DEBUGGivePsiGift(){}

state InBase{
    event BeginState(name PS){}
    event ContinuedState(){}
    function EnterFacility(XGFacility kFacility, float fInterpTime, int iView, optional bool bAllowAutoSave){}
    event Tick(float fDeltaT){}

}
state InFacility{
	event BeginState(name PS);
    function XGFacility CurrentFacility(){}
    function LeaveFacility(XGFacility kFacility){}
    event Tick(float fDeltaT){}
}
