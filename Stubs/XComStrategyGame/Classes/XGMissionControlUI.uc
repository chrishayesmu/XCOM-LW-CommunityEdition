class XGMissionControlUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation)
    implements(IFCRequestInterface)
	dependsOn(XGFundingCouncil)
	dependson(XGSituationRoomUI);
//complete stub

enum EMCView
{
    eMCView_MainMenu,
    eMCView_Alert,
    eMCView_Abduction,
    eMCView_FCRequest,
    eMCView_ChooseShip,
    eMCView_MAX
};
struct TMCHeader
{
    var TText txtTitle;
};
struct TMCCounter
{
    var TText txtTitle;
    var TLabeledText txtTotal;
    var TLabeledText txtAbductions;
    var TLabeledText txtTerror;
    var TLabeledText txtUFOCrash;
    var TLabeledText txtUFOLanded;
    var TLabeledText txtAlienBase;
};
struct TMCClock
{
    var int iMinutes;
    var TText txtDateTime;
    var TText txtTimeScale;
};
struct TMCMission
{
    var TImage imgOption;
    var TButtonText txtOption;
    var Color clrOption;
};

struct TMCMenu
{
    var TButtonText txtChooseButton;
    var TText txtMissionsLabel;
    var array<TMCMission> arrMissions;
    var int iHighlight;
};

struct TMCEvent
{
    var TImage imgOption;
    var TText txtOption;
    var TText txtDays;
    var int iPriority;
    var int iEventType;
    var Color clrOption;
    var int iAdditionalData;
};

struct TMCEventMenu
{
    var TButtonText txtFFButton;
    var array<THQEvent> arrEvents;
    var array<TMCEvent> arrOptions;
    var TText txtEventsLabel;
    var int iHighlight;
};
struct TMCNotice
{
    var TImage imgNotice;
    var TText txtNotice;
    var float fTimer;
};
struct TMCSighting
{
    var TText txtLocation;
    var TText txtTimestamp;
    var TImage imgSighting;
};
struct TMCAbduct
{
    var TMenu mnuSites;
    var array<XGMission> arrAbductions;
    var TText txtCountryName;
    var TText txtPanicLabel;
    var int iPanicLevel;
    var int iMissionDiffLevel;
    var TLabeledText txtMissionDifficulty;
    var TLabeledText txtReward;
    var TLabeledText txtFundingIncrease;
    var TLabeledText txtCurrFunding;
    var TImage imgBG;
    var int iSelected;
    var int iPrevSelection;
};
struct TMCAlert
{
    var int iAlertType;
    var TText txtTitle;
    var array<TText> arrText;
    var array<TLabeledText> arrLabeledText;
	var TMenu mnuReplies;
    var TImage imgAlert;
    var TImage imgAlert2;
    var TImage imgAlert3;
    var int iNumber;
};

var TMCHeader m_kHeader;
var TMCClock m_kClock;
var TButtonBar m_kButtonBar;
var TMCCounter m_kCounter;
var TMCAlert m_kCurrentAlert;
var TMCMenu m_kMenu;
var TMCEventMenu m_kEvents;
var TMCAbduct m_kAbductInfo;
var array<int> m_arrMenuUFOs;
var array<int> m_arrMenuMissions;
var TButtonText m_btxtScan;
var TButtonText m_btxtSatellites;
var array<TMCNotice> m_arrNotices;
var array<TMCSighting> m_arrSightings;
var int m_iEvent;
var float m_fFirstTimeTimer;
var int m_iLastUpdateDay;
var bool m_bNarrFilteringAbduction;
var TSitRequest m_kRequest;
var int m_intMissionType;
var int m_eCountryFromExaltSelection;
var const localized string m_strLabelDays;
var const localized string m_strLabelHours;
var const localized string m_strLabelMissionCounter;
var const localized string m_strLabelScanUFO;
var const localized string m_strLabelStopScanUFO;
var const localized string m_strLabelUFOPrefix;
var const localized string m_strLabelAlienAbductions;
var const localized string m_strAvailableMissions;
var const localized string m_strLabelUpcomingEvents;
var const localized string m_strLabelNewInterceptors;
var const localized string m_strNewSoldierEvent;
var const localized string m_strLabelSatOperational;
var const localized string m_strLabelShipTransfer;
var const localized string m_strLabelPsiTesting;
var const localized string m_strLabelGeneModification;
var const localized string m_strLabelCyberneticModification;
var const localized string m_strLabelMecRepair;
var const localized string m_strLabelFCRequest;
var const localized string m_strLabelCouncilReport;
var const localized string m_strLabelCovertOperative;
var const localized string m_strLabelItemBuilt;
var const localized string m_strLabelExcavationComplete;
var const localized string m_strLabelFacilityRemoved;
var const localized string m_strLabelNewScientists;
var const localized string m_strLabelNewEngineers;
var const localized string m_strLabelNewSoldiers;
var const localized string m_strLabelNewInterceptorArrival;
var const localized string m_strLabelShipOnline;
var const localized string m_strLabelSatOnline;
var const localized string m_strLabelShipTransferArrival;
var const localized string m_strLabelExitToHQ;
var const localized string m_strLabelAbductionSites;
var const localized string m_strLabelPanicLevel;
var const localized string m_strLabelDifficulty;
var const localized string m_strLabelCurrentFunding;
var const localized string m_strLabelCashPerMonth;
var const localized string m_strLabelNone;
var const localized string m_strLabelNewHire;
var const localized string m_strLabelDoomTrackerTitle;
var const localized string m_strTagAbduction;
var const localized string m_strTagTerrorSite;
var const localized string m_strTagCrash;
var const localized string m_strTagAlienBase;
var const localized string m_strTagLandedUFO;
var const localized string m_strTagTotal;
var const localized string m_strSpeakSatDestroyed;
var const localized string m_strSpeakIncTransmission;
var const localized string m_strNumScientists;
var const localized string m_strNumEngineers;
var const localized string m_strLabelPriorityAlert;
var const localized string m_strLabelGoSituationRoom;
var const localized string m_strLabelNewRecruit;
var const localized string m_strLabelReward;
var const localized string m_strLabelRadarContact;
var const localized string m_strLabelContact;
var const localized string m_strLabelLocation;
var const localized string m_strLabelSize;
var const localized string m_strLabelSpeed;
var const localized string m_strLabelHeading;
var const localized string m_strLabelAltitude;
var const localized string m_strLabelUFOClass;
var const localized string m_strLabelSignatureIdentified;
var const localized string m_strLabelSignatureNotIdentified;
var const localized string m_strLabelUnidentified;
var const localized string m_strLabelNoInterceptors;
var const localized string m_strLabelNoInterceptorsInRange;
var const localized string m_strLabelInterceptorsUnavailable;
var const localized string m_strLabelScrambleInterceptors;
var const localized string m_strLabelIgnoreContact;
var const localized string m_strLabelWarningUFOOnGround;
var const localized string m_strLabelAlienSpecies;
var const localized string m_strLabelAlienCrewSize;
var const localized string m_strLabelAlienObjective;
var const localized string m_strLabelSendSkyranger;
var const localized string m_strLabelIgnore;
var const localized string m_strLabelUFOCrashSite;
var const localized string m_strLabelContactLost;
var const localized string m_strLabelUFOHasLanded;
var const localized string m_strLabelLostContactRequestOrder;
var const localized string m_strLabelWarningContactLost;
var const localized string m_strLabelRecallInterceptors;
var const localized string m_strLabelLostSatFundingSuspending;
var const localized string m_strLabelBonusLost;
var const localized string m_strPanicIncrease;
var const localized string m_strPanicRemedy;
var const localized string m_strLabelOk;
var const localized string m_strLabelStatCountryDestroyed;
var const localized string m_strLabelIncFCCom;
var const localized string m_strLabelFCPresenceRequest;
var const localized string m_strLabelFCFinishedJetTransfer;
var const localized string m_strLabelFCFinishedSatCountry;
var const localized string m_strLabelFCRequestExpired;
var const localized string m_strLabelFCRequestDelayed;
var const localized string m_strLabelCommanderUrgentNews;
var const localized string m_strLabelVisualContact;
var const localized string m_strSkyRangerArrivedSite;
var const localized string m_strLabelBeginAssault;
var const localized string m_strLabelReturnToBase;
var const localized string m_strLabelAbductionsReported;
var const localized string m_strLabelViewAbductionSites;
var const localized string m_strLabelViewAbductionSitesFlying;
var const localized string m_strLabelTerrorCity;
var const localized string m_strLabelFCMission;
var const localized string m_strLabelCountrySignedPactLabel;
var const localized string m_strLabelCountryCountLeave;
var const localized string m_strLabelPanicCountry;
var const localized string m_strLabelPanicCountryLeave;
var const localized string m_strLabelAssaultAlienBase;
var const localized string m_strLabelAssaultTempleShip;
var const localized string m_strLabelTempleShip;
var const localized string m_strLabelSkeletonKey;
var const localized string m_strLabelAssault;
var const localized string m_strlabelWait;
var const localized string m_strLabelMessageFromLabs;
var const localized string m_strLabelTechResearchComplete;
var const localized string m_strLabelAssignNewResearch;
var const localized string m_strLabelCarryOn;
var const localized string m_strLabelMessageFromEngineering;
var const localized string m_strLabelManufactureItemComplete;
var const localized string m_strLabelWorkshopRebate;
var const localized string m_strLabelAssignNewProjects;
var const localized string m_strLabelConstructItemFacilityComplete;
var const localized string m_strLabelAssignNewConstruction;
var const localized string m_strLabelMessageFromFoundry;
var const localized string m_strLabelFoundryItemComplete;
var const localized string m_strLabelMessageFromPsiLabs;
var const localized string m_strLabelPsionicTestingRoundComplete;
var const localized string m_strLabelViewResults;
var const localized string m_strLabelMessageFormBarracks;
var const localized string m_strLabelNumRookiesArrived;
var const localized string m_strLabelVisitBarracks;
var const localized string m_strLabelNumEngineersArrived;
var const localized string m_strLabelVisitEngineering;
var const localized string m_strLabelNumScientistsArrived;
var const localized string m_strLabelVisitLabs;
var const localized string m_strLabelShipRearmed;
var const localized string m_strLabelSoldierHealed;
var const localized string m_strLabelExaltActivityBody;
var const localized string m_strLabelExaltSelSendOperative;
var const localized string m_strLabelExaltSelSitRoom;
var const localized string m_strLabelExaltSelNotNow;
var const localized string m_strLabelExaltAlertSendSquad;
var const localized string m_strLabelExaltAlertNotNow;
var const localized string m_strLabelExaltAlertTitle;
var const localized string m_strLabelExaltAlertBody;
var const localized string m_strLabelExaltActivityTitle;
var const localized string m_strLabelResearchHackTimeLost;
var const localized string m_strLabelResearchHackNumLabs;
var const localized string m_strLabelResearchHackDataBackup;
var const localized string m_strLabelResearchHackTotalTimeLost;
var const localized string m_strCellHides;
var const localized string m_strLabelGeneModTitle;
var const localized string m_strLabelGeneModBody;
var const localized string m_strLabelAugmentTitle;
var const localized string m_strLabelAugmentBody;
var const localized string m_strLabelGotoBuildMec;
var const localized string m_strGeneModCompleteNotify;
var const localized string m_arrExaltReasons[EExaltCellExposeReason];
var const localized string m_strLabelExaltActivitySubtitles[EExaltCellExposeReason];
var const localized string m_strLabelItemsRequested;
var const localized string m_strLabelExaltRaidCountryFailSubtitle;
var const localized string m_strLabelExaltRaidCountryFailLeft;
var const localized string m_strLabelExaltRaidContinentFailTitle;
var const localized string m_strLabelExaltRaidContinentFailSubtitle;
var const localized string m_strLabelExaltRaidContinentFailDesc;
var const localized string m_strLabelExaltRaidContinentFailPanic;
function Init(int iView){}
function UpdateView(){}
function FacilityNarrative(EFacilityType eNewFacility){}
function OnIncreaseTimeScale(){}
function OnDecreaseTimeScale(){}
function OnScan(){}
function OnCancelScan(){}
function OnMissionInput(){}
function bool CanActivateMission(){}
function int GetMissionType(){}
function ShowUFOInterceptAlert(int iUFOindex){}
function OnChooseEvent(){}
function MissionDown(){}
function MissionUp(){}
function MissionSetSelected(int iIndex){}
function ExitMC(){}
function UpdateHeader();
function UpdateClock(){}
function bool DrawCounter(){}
function MissionNotify(){}
function UpdateMissionCounter(){}
function UpdateScan(){}
function UpdateSelectionHighlight(){}
function UpdateMissions(){}
function int GetNumMissionOptions(){}
function UpdateEvents(){}
static function int SortEvents(THQEvent e1, THQEvent e2){}
function BuildEventOptions(){}
function UpdateNotices(float fDeltaT){}
function AddNotice(EGeoscapeAlert eNotice, optional int iData1, optional int iData2, optional int iData3){}
function UpdateButtonHelp(){}
simulated function OnReceiveFocus(){}
function ChooseMusic(){}
simulated function OnLoseFocus(){}
simulated function JumpToFacility(XGFacility kFacility, optional int iView, optional name NewState){}
event Tick(float fDeltaT){}
function UpdateCamera(){}
function ProcessAlert(){}
function ProcessFCRequest(){}
function string RewardToString(EFCRewardType eReward, int iAmount){}
simulated function GetRequestData(out TFCRequest kRequestRef){}
function UpdateRequest(){}
function bool HasActiveAlert(){}
function NotifyTopAlert(){}
function bool CheckForInterrupt(){}
function OnSkyReturn(){}
function OnAbductionInput(int iOption){}
function OnAbductionOption(int iOption){}
simulated function bool OnAcceptRequest(){}
simulated function bool OnCancelRequest(){}
function bool OnFCRequest(bool bAccepted, optional bool immediatelyTurnIn){}
function UpdateAbduction(){}
function TLabeledText BuildRewardString(XGMission kMission){}
function OnAlertInput(int iOption){}
function PostOverseerMatinee(){}
function UpdateAlert(){}
