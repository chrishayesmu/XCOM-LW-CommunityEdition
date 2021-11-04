class XGWorldReportUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum eWRView
{
    eWRView_Link,
    eWRView_Defections,
    eWRView_Summary,
    eWRView_MAX
};

struct TWRHeader
{
    var TText txtTitle;
    var TText txtMonth;
    var TText txtYear;
    var TLabeledText ltxtFunding;
    var TLabeledText ltxtSpecialists;
    var TText txtGrade;
    var TText txtGradeLabel;
    var TText txtFeedback;
    var TText txtActivityLabel;
    var array<TText> arrActivity;
};
struct TWRCountry
{
    var TText txtName;
    var int iPanic;
    var Color clrPanic;
    var TText txtFunding;
};
struct TWRContinent
{
    var TText txtName;
    var TText txtSpecialists;
    var TText txtBonus;
    var array<TWRCountry> arrCountries;

};

struct TWRLink
{
    var TText txtLinkGibberish;
    var TText txtLinkGibberish2;
    var TText txtLinkStatus;
    var TButtonText btxtOk;

};

struct TWRDefections
{
    var TText txtDefections;
    var TText txtToLose;
    var TButtonText btxtOk;

};

var TWRLink m_kLink;
var TWRHeader m_kHeader;
var array<TWRContinent> m_arrContinents;
var TWRDefections m_kDefections;
var bool m_bReportDialogue;
var bool m_bDefections;
var const localized string m_strLinkTitle0;
var const localized string m_strLinkTitle1;
var const localized string m_strLinkStatus;
var const localized string m_strAndAppend;
var const localized string m_strManyWithdrawn;
var const localized string m_strOneWithdrawn;
var const localized string m_strNumScientists;
var const localized string m_strNumEngineers;
var const localized string m_strLabelAuthorizeTransmission;
var const localized string m_strLabelMonthlyReport;
var const localized string m_strLabelFundingAwarded;
var const localized string m_strLabelMilitaryGrade;
var const localized string m_strLabelXComActivity;
var const localized string m_strLabelSpecialistsAwarded;
var const localized string m_arrGradeNames[EMonthlyGrade];
var const localized string m_strLabelUFOShotDown;
var const localized string m_strLabelTerrorStopped;
var const localized string m_strLabelAbductionsStopped;
var const localized string m_strLabelSatellitesLaunched;
var const localized string m_strLabelResearchCompleted;
var const localized string m_strLabelUFORaided;
var const localized string m_strLabelSatellitesLost;
var const localized string m_strLabelUFOsEscaped;
var const localized string m_strLabelMismanagedResources;
var const localized string m_strLabelNoSatelliteCoverage;
var const localized string m_strLabelAbductionsIgnored;
var const localized string m_strLabelAbductionsFailed;
var const localized string m_strLabelTerrorIgnored;
var const localized string m_strLabelTerrorFailed;
var const localized string m_strLabelBaseAssaulted;
var const localized string m_strLabelFCMissions;
var const localized string m_strLabelWithdrawn;


function Init(int iView){}
function UpdateView(){}
function UpdateLink(){}
function UpdateDefections(){}
function int GetNumDefections(){}
function OnAdvance(){}
function OnLeaveReport(){}
function UpdateHeader(){}
function TLabeledText GetSpecialistsText(int iScientists, int iEngineers){}
function TText GetGradeText(){}
function BuildActivityText(out TWRHeader kHeader){}
function UpdateContinents(){}
function TWRContinent BuildContinentReport(XGContinent kContinent){}
function TWRCountry BuildCountryReport(XGCountry kCountry){}
