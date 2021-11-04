class XGFacility_SituationRoom extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);

const TICKER_MAX_HEADLINES = 5;
const TICKER_AMBIENT_PUSH_HOURS = 120;
const TICKER_AMBIENT_ROLL = 5;
const TICKER_AMBIENT_ROLLS_AGNOSTIC = 2;

struct TTickerItem
{
    var ETicker_Types eType;
    var ECountry ECountry;
    var int iCode;
    var TText kTickerText;

};

var TTickerItem m_arrTickerItems[5];
var array<int> m_arrUsedPanicTickers;
var array<int> m_arrUsedAmbientTickers;
var array<int> m_arrUsedMissionTickers;
var array<int> m_arrUsedWithdrawTickers;
var array<int> m_arrUsedNarrativeTickers;
var array<int> m_arrUsedExaltTickers;
var int m_iLastPushedTicker;
var bool m_bSatHelpShown;
var bool m_bCovertOpsHelpShown;
var bool m_bCovertOpsHelpShownBarracks;
var bool m_bCodeCracked;
var bool m_bDisplayMissionDetails;
var bool m_bDisplayExaltRaidDetails;
var bool m_bDisplayInfiltratorMissionDetails;
var int m_iCodePieces;
var XGMission m_kCurrentInfiltratorMission;
var const localized string m_strObjBuildGallopChamber;
var const localized string m_strObjShootEtherealUFO;
var const localized string m_strObjBuildFirestorm;
var const localized string m_strObjBuildHperwaveDecoder;
var const localized string m_strObjFindAlienBase;
var const localized string m_strObjInterrogateCaptive;
var const localized string m_strObjCaptureAlien;
var const localized string m_strObjInterrogatePsionicAlien;
var const localized string m_strObjCapturePsionicAlien;

function Update(){}
function PushFundingCouncilHeadline(ECountry ECountry, TText kHeadline){}
function PushNarrativeHeadline(ETicker_Narratives eNarrative){}
function PushCountryWithdrawHeadline(ECountry ECountry){}
function PushMissionSpecificHeadline(XGMission kMission, bool bSuccess, int iGeneModCount, int iMecCount){}
function PushExaltOperationHeadline(ECountry ECountry, int iOperation){}
function PushAmbientHeadline(int iAct){}
function PushPanicHeadline(ECountry ECountry, int iPanic){}
final function MoveHeadlinesDown(){}
final function RemoveHeadline(int iIndex){}
final function bool RemoveCountrySpecificHeadline(ECountry ECountry){}
final function InitTickerItems(){}
final function bool IsCountrySpecificTickerType(ETicker_Types eType){}
final function GetCountryPanicTickerString(ECountry ECountry, int iPanic, array<string> arrItems, out TTickerItem kTicker){}
final function GetAmbientTickerString(int iAct, array<string> arrItems, out TTickerItem kTicker){}
final function GetExaltOperationTickerString(int iOperation, array<string> arrItems, out TTickerItem kTicker){}
final function GetSpecificMissionTickerString(int iMissionType, bool bSuccess, array<string> arrItems, out TTickerItem kTicker){}
final function int EncodeAmbientString(int iAct, int iIndex){}
final function int DecodeAmbientStringIndex(int iCode){}
final function int EncodePanicString(int iCountry, int iPanic, int iIndex){}
final function int DecodePanicStringIndex(int iCode){}
final function bool IsAmbientStringUsed(int iEncodedString){}
final function bool IsPanicStringUsed(int iEncodedString){}
final function int EncodeMissionString(int iMissionType, bool bSuccess, int iIndex){}
final function int DecodeMissionStringIndex(int iCode){}
final function bool IsMissionStringUsed(int iEncodedString){}
final function int EncodeExaltString(int iOpType, int iIndex){}
final function int DecodeExaltStringIndex(int iCode){}
final function bool IsExaltStringUsed(int iEncodedString){}
function bool IsCodeActive(){}
function bool IsCodeCracked(){}
function int GetCurrentCode(){}
function bool IsGreyMarketUnlocked(){}
function bool GrantCodePieces(int iNumCodePieces){}
function bool CheckForCodeComplete(){}
function OnCodeCracked(){}
function OnShipTransferExecuted(XGShip_Interceptor kShip){}
function OnShipSuccessfullyTransferred(XGShip_Interceptor kShip){}
function array<TText> GetTickerText(){}
function Init(bool bLoadingFromSave){}
function InitNewGame(){}
function Enter(int iView){}
function Exit(){}
function SetInfiltratorMission(XGMission kMission){}