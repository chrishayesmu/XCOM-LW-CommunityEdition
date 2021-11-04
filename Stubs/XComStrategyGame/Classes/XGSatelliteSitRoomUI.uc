class XGSatelliteSitRoomUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation)
    implements(IFCRequestInterface);
//complete stub

enum ESatelliteView
{
    eSatelliteView_Main,
    eSatelliteView_Confirm,
    eSatelliteView_Bonus,
    eSatelliteView_Alert,
    eSatelliteView_Help,
    eSatelliteView_MAX
};

struct TSatelliteUI
{
    var TMenu mnuSatellites;
    var TButtonText btxtRotate;
    var TLabeledText ltxtCapacity;
    var TButtonText btxtExit;
    var int Current;
    var int Max;
};

struct TSatCursorUI
{
    var bool bEnabled;
    var TButtonText txtHelp;
};

struct TSatCountryUI
{
    var TText txtCountry;
    var TText txtFunding;
    var int iPanicLevel;
    var bool bHasSatCoverage;
};

struct TSatContinentUI
{
    var TText txtContinent;
    var TText txtInterceptors;
    var array<TText> arrBonuses;
    var array<TText> arrBonusLabels;
    var int iHighlightedBonus;
};

struct TSatNodeUI
{
    var TButtonText btxtHelp;
    var TText txtCountry;
    var TText txtFunding;
    var TText txtPanicLabel;
    var int iPanicLevel;
    var TText txtContinent;
    var array<TText> arrBonuses;
    var array<TText> arrBonusLabels;
    var TText txtWarning;
    var bool bEnabled;
    var bool bEmpty;
};

struct TSatAlert
{
    var TText txtTitle;
    var TText txtBody;
    var TImage imgAlert;
    var TMenu mnuOptions;
};

struct TSatHelp
{
    var TText txtTitle;
    var TText txtBody;
    var TButtonText btxtOk;

};

struct TSatFCAlert
{
    var TImage imgAlert;
    var TText txtFunding;
    var TText txtContinent;
    var TText txtBonus;
    var TButtonText txtContinue;
};

struct TSatConfirm
{
    var TImage imgAlert;
    var TText txtTitle;
    var TText txtCountryLabel;
    var TText txtTravelTimeLabel;
    var TText txtFundingLabel;
    var TText txtCountry;
    var TText txtTravelTime;
    var TText txtFunding;
    var TText txtContinentCollection;
    var TLabeledText txtSpecialists;
    var TButtonText btxtLaunch;
    var TButtonText btxtCancel;
};

struct TSatBonusUI
{
    var TText txtTitle;
    var TText txtBonusName;
    var TText txtBonusDesc;
    var TButtonText btxtOk;
};

var TSatelliteUI m_kUI;
var TSatAlert m_kAlert;
var TSatNodeUI m_kSatNodeUI;
var TSatCursorUI m_kCursorUI;
var TSatCountryUI m_kCountryUI;
var TSatContinentUI m_kContinentUI;
var TSatHelp m_kHelp;
var TSatConfirm m_kConfirm;
var TSatBonusUI m_kBonusUI;
var int m_iHighlighted;
var int m_iCountry;
var int m_iContinent;
var bool m_bLaunched;
var bool m_bWarnUplinkCapacity;
var TFCRequest m_tCompletedSatelliteRequest;
var const localized string m_strLabelUplinkCapacity;
var const localized string m_strLabelNoSatellitesToLaunch;
var const localized string m_strLabelAwaitingLaunch;
var const localized string m_strLabelNoInterceptorsInRegion;
var const localized string m_strLabelNoInterceptorsInRange;
var const localized string m_strLabelCarryOn;
var const localized string m_strLabelSatelliteTitle;
var const localized string m_strLabelSatelliteBody;
var const localized string m_strLabelContinue;
var const localized string m_strLabelOk;
var const localized string m_strLabelBonusInRegion;
var const localized string m_strLabelNoSatellites;
var const localized string m_strLabelHasSatellite;
var const localized string m_strLabelLaunchSatellite;
var const localized string m_strLabelDays;
var const localized string m_strLabelPerMonth;
var const localized string m_strLabelInterceptors;
var const localized string m_strLabelCurrent;
var const localized string m_strLabelNew;
var const localized string m_strSatSingular;
var const localized string m_strSatPlural;
var const localized string m_strLabelBonus;
var const localized string m_strLabelConfirmLaunch;
var const localized string m_strLabelCountry;
var const localized string m_strLabelTravelTime;
var const localized string m_strLabelFundingIncrease;
var const localized string m_strLabelMonitoring;
var const localized string m_strLabelReward;
var const localized string m_strLabelLaunchSatelliteLower;
var const localized string m_strLabelCancelSatelliteLower;
var const localized string m_strLabelScientist;
var const localized string m_strLabelEngineer;
var const localized string m_strLabelScientists;
var const localized string m_strLabelEngineers;
var const localized string m_strLabelNoCapacity;
var const localized string m_strLabelLeftXCom;

function Init(int iView){}
function UpdateView(){}
function bool HasUplinkCapacity(){}
function CheckUplinkCapacity(){}
function UpdateMain(){}
function bool ShowAlert(){}
function UpdateAlert(){}
function UpdateHelp(){}
function bool ShowBonus(){}
function UpdateBonus(){}
function UpdateCountryHelp(){}
function UpdateCountry(){}
function UpdateContinent(){}
function string GetSatString(int iNumSats){}
function UpdateSatNodeUI(){}
function UpdateConfirmUI(){}
function string BuildBonusString(int iNumSatellites, XGContinent kContinent){}
function OnCancelLaunch(){}
function OnAcceptHelp(){}
function OnPressButton(){}
function OnConfirmLaunch(){}
function OnDeclineLaunch(){}
function OnConfirmBonus(){}
function OnChooseAlertOption(int iOption){}
function OnLeaveAlert(){}
function OnOption(int iOption){}
function SetTargetCountry(int targetCountry){}
simulated function GetRequestData(out TFCRequest kRequestRef){}
simulated function bool OnAcceptRequest(){}
simulated function bool OnCancelRequest(){}
