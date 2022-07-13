class XComHQPresentationLayer extends XComPresentationLayerBase
	DependsOn(XGStrategyActorNativeBase);
//complete stub

var XGHQCamera m_kCamera;
var XComHQSoundCollection m_kSounds;
var XGSoundMgr m_kSoundMgr;
var XComDropshipAudioMgr m_kMissionAudioMgr;
var UIAlert m_kUIAlert;
var UIBaseFinances m_kFinances;
var UIBriefing m_kBriefing;
var UIDropshipHUD m_kPCDropshipHUD;
var UIBuildFacilities m_kBuildFacilities;
var UIBuildItem m_kBuildItem;
var UIContinentSelect m_kContinentSelect;
var UIChooseFacility m_kChooseFacility;
var UIChooseTech m_kChooseTech;
var UIDebrief m_kDebriefUI;
var UIDisplayMovie m_kDisplayMovie;
var UIEndOfMonthReport m_kEoMReport;
var UIFoundry m_kFoundryUI;
var UIGeneLab m_kGeneLab;
var UICyberneticsLab m_kCyberneticsLab;
var UISoldierAugmentation m_kAugmentSoldier;
var UIGollop m_kGollopUI;
var UIGreyMarket m_kGreyMarket;
var UIHiring_Barracks m_kBarracksHiring;
var UIHiring_Hangar m_kHangarHiring;
var UIInterceptionEngagement m_kInterceptionEngagement;
var SwfMovie m_kInterceptionMovie;
var UIInfiltratorMission m_kInfiltratorMission;
var UIManufacturing m_kManufacturing;
var UIMECInventory m_kMECInventory;
var UIMECUpgrade m_kMECUpgrade;
var UIMedals m_kMedals;
var UIMemorial m_kMemorial;
var UIObjectivesPopup m_kObjectivePopupUI;
var UIOTS m_kOTS;
var UIPendingRequests m_kPendingRequestsUI;
var UIPsiLabs m_kPsiLabsUI;
var UIShipList m_kShipList;
var UIShipLoadout m_kShipLoadout;
var UIShipSummary m_kShipSummary;
var UIShellStrategy m_kShellStrategy;
var UISituationRoom m_kSituationRoom;
var UIFundingCouncilRequest m_kFundingCouncilRequest;
var UIFundingCouncilMission m_kFundingCouncilMission;
var UISquadSelect m_kSquadSelect;
var UIStrategyHUD m_kStrategyHUD;
var UIStrategyHUD_FacilitySubMenu m_kSubMenu;
var UIRecap m_kRecapUI;
var UIScienceLabs m_kScienceLabs;
var UISoldierCustomize m_kSoldierCustomize;
var UISoldierListBase m_kSoldierList;
var UISoldierLoadout m_kSoldierLoadout;
var UISoldierPromotion m_kSoldierPromote;
var UISoldierGeneMods m_kSoldierGeneMods;
var UISoldierGeneModsHUD m_kSoldierGeneModsHUD;
var UISoldierSummary m_kSoldierSummary;
var UISpecialUnlockDialogue m_kSpecialUnlockDialogue;
var UITellMeMore m_kTellMeMore;
var array<XGScreenMgr> m_arrScreenMgrs;
var array<EMedalType> m_arrMedalUnlocks;
var array<EMedalType> m_arrMedalAwards;
var UIMissionControl m_kUIMissionControl;
var int m_iFacilityView;
var int m_iFirstTickerMsgIndex;
var transient bool m_bRecentlyPlayedPromotions;
var bool bShouldUpdateSituationRoomMenu;
var bool bShowMissionCounter;
var bool bShouldPause;
var bool m_bHasRequestedInterceptionLoad;
var bool m_bIsShuttling;
var XGInterception m_kXGInterception;

simulated function Init(){}
simulated function OnZoomIn();
simulated function OnZoomOut();
simulated function OnSoundCollectionLoaded(Object LoadedObject){}
simulated function InitUIScreens(){}
simulated function PollForUIScreensComplete(){}
simulated function InitUIScreensComplete(){}
simulated function UIPsiLabs GetPsiLabsUI(){}
simulated function UIStrategyHUD GetStrategyHUD(){}
simulated function UIDisplayMovie Get3DMovie(){}
simulated function bool IsBusy(){}
simulated function bool IsSquadBeingSelected(){}
simulated function ClearAllUIScreens(){}
simulated function HideUIForCinematics(){}
simulated function ShowUIForCinematics(){}
simulated function XComHeadquartersCamera GetCamera(){}
simulated function bool CAMIsBusy(){}
reliable client simulated function CAMLookAtEarth(Vector2D v2Location, optional float fZoom, optional float fInterpTime){}
reliable client simulated function CAMLookAt(Vector vLocation, optional bool bCut){};
reliable client simulated function CAMZoom(float fZoom){}
reliable client simulated function CAMLookAtHorizon(Vector2D v2LookAt){}
reliable client simulated function CAMLookAtFacility(XGFacility kFacility, optional float fInterpTime){}
reliable client simulated function CAMLookAtNamedLocation(string strLocation, optional float fInterpTime){}
reliable client simulated function CAMCenterNamedLocation(string strLocation, optional float fInterpTime){}
reliable client simulated function CAMLookAtHQTile(int X, int Y, optional float fInterpTime){}
reliable client simulated function UIKeyboard_ScreenManaged(XGScreenMgr kScreenMgr){}
function UIWinGame(){}
function UILoseGame(){}
reliable client simulated function UIAlertBox(string _titleMsg, string _bodyMsg, string _dialogueMsg, optional EUIAlertType _type, optional float _x, optional float _y, optional bool _isCentered){}
reliable client simulated function UIFacilityMenu(XGFacility kFacility, optional int iView){}
simulated function UIMissionControlMenu(){}
simulated function UILabsMenu(){}
simulated function UIBarracksMenu(){}
simulated function UIEngineeringMenu(){}
simulated function UIHangarMenu(){}
simulated function bool IsInAnFSM(){}
simulated function UIChooseTech(optional int iView){}
simulated function UIArchives(){}
simulated function UIGeneLabScreen(optional XGStrategySoldier kSoldier, optional int iSelectedRow, optional int iSelectedCol){}
simulated function ShuttleToGeneLabEditing(XGStrategySoldier kSoldier, int iSelectedRow, int iSelectedCol){}
simulated function UICyberneticsLab(){}
simulated function UIMECInventoryScreen(){}
simulated function UIMECUpgradeScreen(){}
simulated function UISoldierAugmentation(XGStrategySoldier kSoldier){}
simulated function UIBuildItem(){}
simulated function UIDropshipBriefing(XGMission Mission){}
simulated function UIDropshipBriefingOnMapLoaded(){}
simulated function RemoveUIDropshipBriefingHUD(){}
reliable client simulated function UIHangarShipList(){}
reliable client simulated function UIHangarShipSummary(XGShip_Interceptor kShip){}
reliable client simulated function UIHangarShipLoadout(XGShip_Interceptor kShip){}
reliable client simulated function UIGollopMenu(){}
reliable client simulated function UIFundingCouncilRequest(IFCRequestInterface kDataInterface){}
reliable client simulated function UIFundingCouncilRequestComplete(IFCRequestInterface kDataInterface){}
reliable client simulated function UIFundingCouncilMission(){}
reliable client simulated function TransitionToFCMissionState(){}
reliable client simulated function UIInfiltratorMission(){}
reliable client simulated function TransitionToInfiltratorMissionState(){}
reliable client simulated function UISitRoom(optional int iStartView){}
reliable client simulated function UIMemorial(){}
reliable client simulated function UIMedals(){}
simulated function NotifyMedalUnlocked(EMedalType Type){}
simulated function NotifyMedalAwarded(EMedalType Type){}
simulated function ClearMedal(EMedalType Type){}
simulated function UISoldierList(class<Actor> soldierListClass){}
reliable client simulated function UISoldier(XGStrategySoldier kSoldier, optional int iView, optional bool bReturnToDebriefUI, optional bool bPreventSoldierCycling, optional bool bCovertOperativeMode){}
reliable client simulated function UICustomize(XGStrategySoldier kSoldier){}
simulated function UISpecialUnlockDialogue(TItemUnlock kData){}
reliable client simulated function UIBuildBase(){}
reliable client simulated function UIBuildBaseChooseFacility(){}
function Notify(XGStrategyActorNativeBase.EGeoscapeAlert eAlert, optional int iData1, optional int iData2, optional int iData3){}
function MissionNotify(){}
function UINotifySkyReturn(){}
reliable client simulated function UIMissionControl(){}
function ToggleMissionCounter(){}
reliable client simulated function UIIntercept(XGShip_UFO kUFO){}
simulated function LoadInterceptionScreen(){}
simulated function OnInterceptionLoaded(Object LoadedObject){}
reliable client simulated function StartInterceptionEngagement(XGInterception kXGInterception){}
reliable client simulated function UIHangarHiring(){}
reliable client simulated function UIBarracksHiring(){}
reliable client simulated function UIWorldReport(){}
reliable client simulated function UISoldierPromotionMEC(XGStrategySoldier kSoldier){}
reliable client simulated function UISoldierPromotion(XGStrategySoldier kSoldier, bool psiPromote){}
reliable client simulated function UISoldierGeneMods(XGStrategySoldier kSoldier, bool bViewGenesOnly, optional int iSelectedRow, optional int iSelectedCol){}
reliable client simulated function UISoldierLoadout(XGStrategySoldier kSoldier){}
reliable client simulated function UIContinent(){}
reliable client simulated function UIHQMenu(){}
simulated function ClearUIToHUD(){}
function XGSoundMgr Sound(){}
function ShouldPause(bool k_ShouldPause){}
simulated function bool AllowSaving(){}
simulated function bool ISCONTROLLED(){}
simulated function UIHQMenuZoom(){}
simulated event ContinuedState(){}
reliable client simulated function UIStrategyShell(){}
simulated function UIEndGame(){}
reliable client simulated function UIFoundry(){}
reliable client simulated function UIGreyMarket(){}
reliable client simulated function UIPendingRequests(){}
reliable client simulated function UIOTS(){}
reliable client simulated function UIManufactureFacility(EFacilityType eFacility, int X, int Y){}
reliable client simulated function UIManufactureItem(EItemType eItem, optional int iQueueIndex){}
reliable client simulated function UIManufactureFoundry(int iTech, optional int iProjectIndex){}
reliable client simulated function UIDebrief(XGShip_Dropship kSkyranger){}
reliable client simulated function UIChooseSquad(XGMission kMission){}
reliable client simulated function UISatelliteSitRoom(){}
reliable client simulated function UIInfiltratorSitRoom(){}
reliable client simulated function UIObjectivesSitRoom(){}
reliable client simulated function UIFinances(){}
reliable client simulated function UIPsiLabs(){}
reliable client simulated function UITellMeMore(){}
reliable client simulated function UIObjectiveDisplay(optional EGameObjective eNewObjective){}
static simulated function string GetObjectiveImagePath(int eObjectiveImageType){}
function PlayCinematic(ECinematicMoment eCinematic, optional int iData, optional bool bWait){}
simulated function bool IsGameplayOptionEnabled(EGameplayOption Option){}
function XGScreenMgr GetMgr(class<Actor> kMgrClass, optional IScreenMgrInterface kInterface, optional int iView, optional bool bIgnoreIfDoesNotExist){}
function bool AddPreformedMgr(XGScreenMgr kMgr){}
function bool RemoveMgr(class<Actor> kMgrClass){}
function bool IsMgrRegistered(class<Actor> kMgrClass){}
simulated function ChangeDifficutly(int difficutlyLevel){}
simulated function int GetDifficulty(){}
function PostFadeForBeginCombat(){}
simulated function ToggleUIWhenPaused(bool bShow){}
function ClearPlayedPromotions(){}
simulated function bool ShouldAnchorTipsToRight(){}
function bool PlayerCanSave(){}


simulated state State_UI3DMovieMgr extends PROTOBaseScreenState
{
	simulated function Activate(){}
	simulated function Deactivate(){}
}
simulated state State_WinGame extends BaseScreenState
{
	simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}

}
simulated state State_LoseGame extends BaseScreenState
{
	simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}
}
simulated state State_UIAlert extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}}
simulated state State_MissionControlMenu extends PROTOBaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}}
simulated state State_LabsMenu extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_ChooseTech extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}

simulated state State_Archives extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_UIGeneLab extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
	simulated state State_UICyberneticsLab extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_UIMECInventory extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_UIMECUpgrade extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_UISoldierAugmentation extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_BarracksMenu extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_EngineeringMenu extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_BuildItem extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_DropshipBriefing extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_HangarMenu extends BaseScreenState
{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_HangarShipList extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_HangarShipSummary extends BaseScreenState
{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_HangarShipLoadout extends BaseScreenState{

    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}   }
simulated state State_Gollop extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_FundingCouncilRequest extends BaseScreenState{
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}   }
simulated state State_FundingCouncilMission extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}}
simulated state State_InfiltratorMission extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SitRoom extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_Memorial extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_MedalsScreen extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SoldierList extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Soldier extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Customize extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SpecialUnlockDialogue extends BaseScreenState{
    simulated function Deactivate(){}
    simulated function OnReceiveFocus(){}
    simulated function OnLoseFocus(){}   }
simulated state State_BaseBuild extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_BaseBuildChooseFacility extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_MC extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}simulated function OnZoomIn(){}}
simulated state State_InterceptionEngagement extends BaseScreenState{
    simulated function ActivatePrivate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_HangarHiring extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_BarracksHiring extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_WorldReport extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SoldierPromotion extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SoldierGeneMods extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_SoldierLoadout extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Continent extends PROTOBaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_StrategyHUD extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_StrategyShell extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}}
simulated state State_Foundry extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_GreyMarket extends PROTOBaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_PendingRequests extends BaseScreenState
{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_OTS extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Manufacture extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Debrief extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_ChooseSquad extends BaseScreenState{
    function DisplayChooseSquadLight(bool bEnable){}
    simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_Finances extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_PsiLabs extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
simulated state State_TellMeMore extends BaseScreenState{simulated function Activate(){}
	simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}}
