class XGPendingRequestsUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation)
    implements(IFCRequestInterface)
	dependson(XGFundingCouncil);
//complete stub

enum EPRequest
{
    ePRequest_Main,
    ePRequest_Selected,
    ePRequest_MAX
};

struct TPendingRequest
{
    var EFCRequest eRequest;
    var ECountry ECountry;
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtTopSecretLabel;
    var TText txtDescription;
    var TLabeledText ltxtDueDate;
    var TLabeledText ltxtRequired;
    var TLabeledText ltxtInStorage;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtIgnore;
    var TImage img;
};

var int m_iHighlight;
var array<TFCRequest> m_arrRequests;
var bool m_bCanDoSelectedRequest;
var TPendingRequest m_kRequest;
var const localized string m_strNumCodePieces;
var const localized string m_strNumEngineers;
var const localized string m_strNumScientist;
var const localized string m_strNumSatellite;
var const localized string m_strNewRecruit;
var const localized string m_strTitleLabel;
var const localized string m_strLabelRequested;
var const localized string m_strValueRequested;
var const localized string m_strValueInStorage;
var const localized string m_strLabelTimeLimit;
var const localized string m_strLabelInStorage;
var const localized string m_strTimeLimitDays;
var const localized string m_strLabelRewards;
var const localized string m_strLabelSellItems;
var const localized string m_strLabelTransferSatellite;
var const localized string m_strSellItemsDate;
var const localized string m_strLabelIgnoreRequest;
var const localized string m_strRequestCompletedTitleLabel;
var const localized string m_strLabelAwarded;

function Init(int iView){}
function UpdateView(){}
function string RewardToString(EFCRewardType eReward, int iAmount){}
simulated function GetRequestData(out TFCRequest kRequestRef){}
function UpdateRequest(TFCRequest kRequest){}
function BuildSelectedRequest(){}
function BuildItemList(){}
function OnHighlightUp(){}
function OnHighlightDown(){}
function int GetNumOfRequests(){}
function TFCRequest GetHLRequest(){}
function bool CanSelectCurrentRequest(){}
simulated function bool OnAcceptRequest(){}
simulated function bool OnCancelRequest(){}
function OnLeaveFacility(){}
