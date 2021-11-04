class XGSetupPhaseManager extends XGSetupPhaseManagerBase
    hidecategories(Navigation);

var const float m_HelpTextWait;
var array<name> TutorialRooms;
var const localized string m_TellMeMoreText;
var const localized string m_BarracksNavHelpText;
var const localized string m_BarracksNavHelpTextPC;
var const localized string m_ScienceLabNavHelpText;
var const localized string m_ScienceLabNavHelpTextPC;
var const localized string m_MissionControlNavHelpText;
var const localized string m_MissionControlNavHelpTextPC;
var const localized string m_MissionControlSelectMissionNavHelpText;
var const localized string m_MissionControlSelectMissionNavHelpTextPC;
var const localized string m_MissionControlScanNavHelpText;
var const localized string m_MissionControlScanNavHelpTextPC;
var const localized string m_SituationRoomNavHelpText;
var const localized string m_SituationRoomNavHelpTextPC;
var const localized string m_EngineeringNavHelpText;
var const localized string m_EngineeringNavHelpTextPC;
var const localized string m_EngineeringBuildItemNanoFiberNavHelpText;
var const localized string m_EngineeringBuildItemNanoFiberNavHelpTextPC;
var const localized string m_EngineeringBuildItemSCOPENavHelpText;
var const localized string m_EngineeringBuildItemSCOPENavHelpTextPC;
var const localized string m_SoldierListNavHelpText;
var const localized string m_SoldierListNavHelpTextPC;
var const localized string m_SelectSoldierHelpText;
var const localized string m_SelectSoldierHelpTextPC;
var const localized string m_EquipSoldierHelpText;
var const localized string m_EquipSoldierHelpTextPC;
var const localized string m_EquipNanoVestNavHelpText;
var const localized string m_EquipNanoVestNavHelpTextPC;
var const localized string m_EquipSCOPENavHelpText;
var const localized string m_EquipSCOPENavHelpTextPC;
var const localized string m_SoldierPromotionHelpText;
var const localized string m_SoldierPromotionHelpTextPC;
var const localized string m_SoldierPromotionHelpText2;
var const localized string m_SoldierPromotionHelpText2PC;
var const localized string m_MovingTimeForwardTitle;
var const localized string m_MovingTimeForwardMessage;
var const localized string m_SelectBuildFacilityNavHelpText;
var const localized string m_SelectBuildFacilityNavHelpTextPC;
var const localized string m_SelectBuildFacilityMenuNavHelpText;
var const localized string m_SelectBuildFacilityMenuNavHelpTextPC;
var const localized string m_SelectAlienContainmentNavHelpText;
var const localized string m_SelectAlienContainmentNavHelpTextPC;
var const localized string m_SelectFirstResearchNavHelpText;
var const localized string m_SelectFirstResearchNavHelpTextPC;
var const localized string m_SelectXenoBiologyNavHelpText;
var const localized string m_SelectXenoBiologyNavHelpTextPC;
var const localized string m_SelectArcThrowerNavHelpText;
var const localized string m_SelectArcThrowerNavHelpTextPC;
var const localized string m_SelectLaunchSatNavHelpText;
var const localized string m_SelectLaunchSatNavHelpTextPC;
var const localized string m_SelectCountryForSatNavHelpText;
var const localized string m_SelectCountryForSatNavHelpTextPC;
var const localized string m_AddNewItemToSoldierHelpText;
var const localized string m_AddNewItemToSoldierHelpTextPC;
var const localized string m_EquipMediKitNavHelpText;
var const localized string m_EquipMediKitNavHelpTextPC;
var WatchVariableMgr WatchVarMgr;
var XComHQPresentationLayer HQPRES;
var XGHeadQuarters HQ;
var XComHeadquartersInput HQINPUT;
var bool bUsingDebugStart;
var bool bAllowedToSave;
var transient bool bDoomTrackerComplete;
var transient bool bPerkGiven;
var transient bool bVisitedScienceLab;
var transient bool bVisitedSituationRoom;
var transient bool bVisitedEngineering;
var transient bool bVisitedBarracks;
var transient bool bPlayedArcThrowerTentPole;
var transient bool bVisitedMissionControl;
var transient bool bSoldierEquipped;
var transient bool bLoadedFromSave;
var transient bool bWasHangarUnlocked;
var transient bool bReadyToPlayMovieInDropship;
var transient XGBarracksUI BarracksUI;
var transient XGSoldierUI SoldierSummaryUI;
var transient XGResearchUI ResearchUI;
var transient int iSubMenuWatchVar;
var transient int iBarracskViewWatchVar;
var transient int iSoldierSummaryWatchVar;
var transient int iSoldierSummaryViewWatchVar;
var transient int iSoldierGivenPerkWatchVar;
var transient int iSoldierEquippedWatchVar;
var transient int iResearchMenuWatchVar;
var transient int iMissionControlWatchVar;
var transient int iScanWatchVar;
var transient int iViewSoldierWatchVar;
var transient int iLaunchMissionWatchVar;
var transient int iDebriefWatchVar;
var transient int iFabricationMenuWatchVar;
var transient int iItemBuildWatchVar;
var transient int iLaunchSatWatchVar;
var transient int iBuildAlienContainmentWatchVar;
var transient int iEngineeringViewWatchVar;
var transient int iOpenBuildFacilityMenuWatchVar;
var transient int iBuildFacilitiesWatchVar;
var transient int iSubMenuFocusWatchVar;
var transient XGGameData.EItemType eItemBuilding;
var transient float fTransientMasterVolume;

function StartNewGame(){}
function DebugStart(name StateName){}
function ApplyCheckpointRecord(){}
function NextState(){}
function TutorialBase(int BaseNum){}
function bool IsBarracksSectionEnabled(XGSoldierUI.EBaseView eSection){}
simulated function bool AllowedToSave(){}
function OnSoldierEquipped(){}
function AssignHQGlobals(){}
function ShowEngineeringNavHelp(){}
function ShowAddNewItemToSoldierNavHelp(){}
function ShowSelectSoldierNavHelp(TSoldier Soldier){}
function ShowBarracksNavHelp(){}
function ShowSituationRoomNavHelp(){}
function ShowScienceLabNavHelp(){}
function ShowMissionControlNavHelp(){}
function TSoldier FindVeteran(){}
function DisableFacilities(){}
function UIStrategyHUD GetHUD(){}
function WatchVariableMgr GetWatchVariableMgr(){}
function bool UsingGamepad(){}

