class XGSituationRoomUI extends XGScreenMgr
    config(GameData);
//complete stub

enum ESitView
{
    eSitView_Main,
    eSitView_Mission,
    eSitView_Request,
    eSitView_RequestComplete,
    eSitView_Satellites,
    eSitView_Finances,
    eSitView_GreyMarket,
    eSitView_NewObjective,
    eSitView_PendingRequests,
    eSitView_RequestAccepted,
    eSitView_RequestExpired,
    eSitView_ObjectivesMoreInfo,
    eSitView_Exalt,
    eSitView_CovertOpsExtractionMission,
    eSitView_MAX
};

enum ESitCountryState
{
    eSitCountry_Normal,
    eSitCountry_Withdrawn,
    eSitCountry_MAX
};

enum ETickerText
{
    eTickerTxt_SitRoomActive,
    ETickerText_MAX
};

enum EMapItem
{
    eMapItem_HQ,
    eMapItem_GroundedPlanes,
    eMapItem_Hangar,
    eMapItem_Jet,
    eMapItem_AlienBase,
    eMapItem_TempleShip,
    eMapItem_UFO,
    eMapItem_Outpost,
    eMapItem_Satellite,
    eMapItem_Cell,
    eMapItem_Cell_Agent,
    eMapItem_Cell_Ready,
    eMapItem_Cell_AnimateIn,
    eMapItem_Cell_AnimateOut,
    eMapItem_Cell_AnimateOutOperative,
    eMapItem_MAX
};

enum EUICellState
{
    EUI_CELL_ACTIVE,
    EUI_CELL_AGENT_OUT,
    EUI_CELL_AGENT_DONE,
    EUI_CELL_DESTROYED,
    EUI_CELL_NONE,
    EUI_CELL_MAX
};

struct TObjectivesUI
{
    var TText txtTitle;
    var array<TText> arrSubObjectivesUI;
    var TGameObjective kObjective;
};

struct TObjectivesInDepthUI
{
    var TText txtTitle;
    var array<TText> arrSubObjectivesTitle;
    var array<TText> arrSubObjectivesInDepth;
};

struct TSitCountry
{
    var TText txtName;
    var Color clrPanic;
    var int iPanic;
    var ESitCountryState eState;
    var TText txtFunding;
    var int iEnum;
    var bool bClearedByClues;
    var bool bShowExaltBase;
    var EUICellState eCellState;
};

struct TSitCode
{
    var bool bActive;
    var bool bComplete;
    var TText txtTitle;
    var int iTotal;
    var int iCurrent;
};

struct TSitDoom
{
    var int iCountriesLost;
    var int iLimit;
    var TText txtTitle;
};

struct TSitMoney
{
    var TLabeledText ltxtMoney;
    var TLabeledText ltxtIncome;
};

struct TSitTicker
{
    var array<TText> arrTickerText;

};

struct TSitRequest
{
    var TText txtTitle;
    var TImage imgBG;
    var TText txtIntro;
    var TLabeledText ltxtDueDate;
    var TLabeledText ltxtRequired;
    var TLabeledText ltxtItemDisplay;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtSellNow;
    var TButtonText txtIgnore;
};

struct TSitRequestComplete
{
    var TImage imgBG;
    var TText txtComplete;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
};

struct TSitMission
{
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtTopSecretLabel;
    var TImage imgBG;
    var TText txtDescription;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtCancel;
};

struct TInfiltratorMission
{
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtTopSecretLabel;
    var TImage imgBG;
    var TText txtDescription;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtCancel;
};

struct TNewObjectiveUI
{
    var TText txtTitle;
    var TText txtText;
    var TText txtHelp;
    var TButtonText btxtOk;
    var TImage imgObj;
};

struct TMapItemUI
{
    var EMapItem eType;
    var float X;
    var float Y;
    var int Amount;
};

var TMenu m_mnuMain;
var array<ESitView> m_arrOptions;
var TObjectivesUI m_kObjectivesUI;
var TObjectivesInDepthUI m_kObjectivesInDepthUI;
var array<TSitCountry> m_arrCountriesUI;
var TSitCode m_kCodeUI;
var TSitMoney m_kMoney;
var TSitTicker m_kTicker;
var TSitMission m_kMission;
var TInfiltratorMission m_kInfiltratorMission;
var TSitRequest m_kRequest;
var TSitRequestComplete m_kComplete;
var TSitDoom m_kDoom;
var array<TMapItemUI> m_mapItemsUI;
var const localized string m_strMissionTitleLabel;
var const localized string m_strLabelAcceptMission;
var const localized string m_strLabelRefuseMission;
var const localized string m_strLabelRequested;
var const localized string m_strLabelTimeLimit;
var const localized string m_strLabelDays;
var const localized string m_strLabelRewards;
var const localized string m_strLabelCarryOn;
var const localized string m_strLabelSellItemDate;
var const localized string m_strLabelIgnoreRequest;
var const localized string m_strLabelCompletedRequest;
var const localized string m_strLabelOk;
var const localized string m_strLabelAcceptPendingRequest;
var const localized string m_strLabelNewRecruit;
var const localized string m_strLabelLaunchSatellite;
var const localized string m_strLabelMonitorUFO;
var const localized string m_strLabelInfiltratorMode;
var const localized string m_strLabelInfiltratorHelp;
var const localized string m_strLabelNoSatToLaunch;
var const localized string m_strLabelViewFinances;
var const localized string m_strLabelViewExpenditures;
var const localized string m_stdLabelVisitGreyMarket;
var const localized string m_stdLabelVisitGreyMarketHelp;
var const localized string m_strLabelPendingRequests;
var const localized string m_strLabelPendingRequestsHelp;
var const localized string m_strLabelObjectives;
var const localized string m_strLabelCodeDecryption;
var const localized string m_strLabelCodeDecrypted;
var const localized string m_strLabelNewObjective;
var const localized string m_strNumAlienCodePiece;
var const localized string m_strNumEngineers;
var const localized string m_strNumScientists;
var const localized string m_strNumSatellite;
var const localized string m_strReducePanic;
var const localized string m_strNumElerium;
var const localized string m_strNumExaltIntel;
var const localized string m_strInProgress;
var const localized string m_strComplete;

function Init(int iView){}
function UpdateView(){}
function int GetNextView(){}
function OnChooseMainOption(int iNewView){}
function OnMoreInfo(){}
function OnLeaveMarket(){}
function OnLeaveFacility(){}
function OnMissionInput(int iOption){}
function OnInfiltratorMissionInput(int iOption){}
function OnRequestInput(bool bSell){}
function OnRequestCompleteInput(){}
function OnRequestExpiredInput(){}
function OnRequestAccepted(){}
function UpdateInfiltratorMission(){}
function UpdateMission(){}
function UpdateRequest(){}
function UpdateRequestComplete(){}
function UpdateRequestAccepted(){}
function UpdateRequestExpired(){}
static function string RewardToString(EFCRewardType eReward, int iAmount){}
function UpdateMainMenu(){}
function UpdateCountries(){}
function UpdateObjectives(){}
function UpdateCode(){}
function UpdateWorldMoney(){}
function UpdateWorldMap(){}
function UpdateTicker(){}
function UpdateDoom(){}
function TSitCountry BuildSitCountry(XGCountry kCountry){}
function array<XGCountry> SortSitCountries(){}
function int ConvertUISlotToCountryEnum(int iSlot){}
function int GetCountryUISlot(ECountry ECountry){}
simulated function OnLoseFocus();
simulated function OnReceiveFocus(){}
simulated function bool IsMissionView(){}
