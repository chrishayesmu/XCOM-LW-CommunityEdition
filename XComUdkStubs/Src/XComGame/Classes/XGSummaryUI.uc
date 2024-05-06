class XGSummaryUI extends XGTacticalScreenMgr
    notplaceable
    hidecategories(Navigation);

enum eSummaryView
{
    eSummaryView_Mission,
    eSummaryView_Artifacts,
    eSummaryView_Soldiers,
    eSummaryView_MAX
};

enum ESummaryRating
{
    eSR_Terrible,
    eSR_Poor,
    eSR_Good,
    eSR_Excellent,
    eSR_MAX
};

enum ESummaryStatus
{
    eSummStatus_Dead,
    eSummStatus_Injured,
    eSummStatus_Active,
    eSummStatus_MAX
};

enum ESummaryFactor
{
    eSF_AliensKilled,
    eSF_SoldiersKilled,
    eSF_CiviliansSaved,
    eSF_MissionLength,
    eSF_ResponseTime,
    eSF_MeldCollected,
    eSF_MAX
};

struct TMissionFactor
{
    var string strFactor;
    var string strResult;
    var string strRating;
    var int iState;
    var int iRating;
    var int iResult;
    var int iIcon;
};

struct TSummaryHeader
{
    var TText txtOpName;
    var TText txtLocation;
    var TText txtMissionType;
    var TText txtTime;
    var TText txtCommandingOfficer;
    var array<TText> arrBulletins;
    var TText txtResult;
    var TText txtRating;
    var TText txtInfluence;
    var int iStatus;
};

struct TMissionSummary
{
    var TTableMenu mnuSummary;
    var array<TMissionFactor> arrFactors;
};

struct TArtifactTable
{
    var TTableMenu mnuSummary;
};

struct TSoldierTable
{
    var TTableMenu mnuSummary;
};

struct TResultSummary
{
    var TText txtSummary;
};

var int m_iInfluence;
var int m_iMissionRating;
var TSummaryHeader m_kHeader;
var TMissionSummary m_kMissionInfo;
var TResultSummary m_kResultSummary;
var TArtifactTable m_kArtifacts;
var TSoldierTable m_kSoldiers;
var const localized string m_strMissionComplete;
var const localized string m_strMissionFailed;
var const localized string m_strMissionAbandoned;
var const localized string m_strLabelAliensKilled;
var const localized string m_sLabelExaltKilled;
var const localized string m_strLabelOperativesLost;
var const localized string m_strLabelCiviliansSaved;
var const localized string m_strLabelMeldCollected;
var const localized string m_strRatingExcellent;
var const localized string m_strRatingGood;
var const localized string m_strRatingPoor;
var const localized string m_strRatingTerrible;
var const localized string m_strRatingUnrated;
var const localized string m_strResultsMeld;
var const localized string m_strKIA;
var const localized string m_strWounded;
var const localized string m_strReady;
var const localized string m_strDestroyed;
var const localized string m_strDamaged;
var const localized string m_strPromotedTo;
var const localized string m_strPromotedToDead;