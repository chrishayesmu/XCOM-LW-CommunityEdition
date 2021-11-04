class XGRecapUI extends XGScreenMgr
    config(GameData);

//complete stub
enum ERecapView
{
    eRecapView_Loading,
    eRecapView_Main,
    eRecapView_MAX
};

enum EPlaystyleType
{
    ePlaystyle_PerfectHero,
    ePlaystyle_Underdog,
    ePlaystyle_Science,
    ePlaystyle_Combat,
    ePlaystyle_Money,
    ePlaystyle_MAX
};

enum ERecapStatComparison
{
    eRC_None,
    eRC_Higher,
    eRC_Lower,
    eRC_MAX
};

struct TRecapItem
{
    var string strTitle;
    var TText txtValue;
    var TText txtWorldValue;
};

struct TRecapUI
{
    var TText txtTitle;
    var array<TRecapItem> arrItems;
    var TImage imgBackground;

};

var TText m_txtTitle;
var TText m_txtDifficulty;
var TLabeledText m_ltxtPlaystyle;
var array<TRecapUI> m_arrPages;
var int m_iCurrentPage;
var EDifficultyLevel m_eDiff;
var bool m_bGlobalStatsReceived;
var bool m_bSecondWave;
var const localized string m_strWin;
var const localized string m_strLose;
var const localized string m_strPlayLabel;
var const localized string m_strSummTitle;
var const localized string m_strCombatTitle;
var const localized string m_strSpecialistsTitle;
var const localized string m_strResourcesTitle;
var const localized string m_strLossTitle;
var const localized string DAYS;
var const localized string Pct;
var const localized string m_strSecondWaveTitle;
var const localized string m_strSecondWaveBody;
var const localized string m_strSecondWaveOK;
var init const localized string m_aRecapDesc[ERecapStats];
var init const localized string m_aPlaystyleDesc[EPlaystyleType];
var init const localized string m_aRecapDiff[EDifficultyLevel];

function OnWorldStatsReceived(){}
function Init(int iView){}
function UpdateView(){}
function UpdateMain(){}
function TRecapUI BuildSummaryPage(){}
function TRecapUI BuildCombatPage(){}
function TRecapUI BuildSpecialistsPage(){}
function TRecapUI BuildResourcesPage(){}
function TRecapUI BuildLossPage(){}
function AddPage(TRecapUI kPageUI){}
function OnLeaveRecap(){}
function string FormatForRecap(float fIn){}
function TRecapItem BuildRecapItem(ERecapStats eStat, string strSuffix, ERecapStatComparison eCompare, optional ERecapStats eCountStat){}
function UISecondWave(IScreenMgrInterface kScreen){}
function UISecondWaveCB(EUIAction eAction){};
event Destroyed(){}
simulated event OnCleanupWorld(){}
function CleanupDelegates(){}
