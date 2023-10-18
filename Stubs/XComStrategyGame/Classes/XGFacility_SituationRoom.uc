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

struct CheckpointRecord_XGFacility_SituationRoom extends CheckpointRecord
{
    var bool m_bSatHelpShown;
    var bool m_bCovertOpsHelpShown;
    var bool m_bCovertOpsHelpShownBarracks;
    var int m_iCodePieces;
    var bool m_bCodeCracked;
    var TTickerItem m_arrTickerItems[5];
    var array<int> m_arrUsedPanicTickers;
    var array<int> m_arrUsedAmbientTickers;
    var array<int> m_arrUsedMissionTickers;
    var array<int> m_arrUsedWithdrawTickers;
    var array<int> m_arrUsedExaltTickers;
    var int m_iLastPushedTicker;
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
var const localized array<localized string> TickerUSAPanic1;
var const localized array<localized string> TickerUSAPanic2;
var const localized array<localized string> TickerUSAPanic4;
var const localized array<localized string> TickerUSAPanic5;
var const localized array<localized string> TickerCanadaPanic1;
var const localized array<localized string> TickerCanadaPanic2;
var const localized array<localized string> TickerCanadaPanic4;
var const localized array<localized string> TickerCanadaPanic5;
var const localized array<localized string> TickerFrancePanic1;
var const localized array<localized string> TickerFrancePanic2;
var const localized array<localized string> TickerFrancePanic4;
var const localized array<localized string> TickerFrancePanic5;
var const localized array<localized string> TickerUKPanic1;
var const localized array<localized string> TickerUKPanic2;
var const localized array<localized string> TickerUKPanic4;
var const localized array<localized string> TickerUKPanic5;
var const localized array<localized string> TickerGermanyPanic1;
var const localized array<localized string> TickerGermanyPanic2;
var const localized array<localized string> TickerGermanyPanic4;
var const localized array<localized string> TickerGermanyPanic5;
var const localized array<localized string> TickerNigeriaPanic1;
var const localized array<localized string> TickerNigeriaPanic2;
var const localized array<localized string> TickerNigeriaPanic4;
var const localized array<localized string> TickerNigeriaPanic5;
var const localized array<localized string> TickerEgyptPanic1;
var const localized array<localized string> TickerEgyptPanic2;
var const localized array<localized string> TickerEgyptPanic4;
var const localized array<localized string> TickerEgyptPanic5;
var const localized array<localized string> TickerSouthAfricaPanic1;
var const localized array<localized string> TickerSouthAfricaPanic2;
var const localized array<localized string> TickerSouthAfricaPanic4;
var const localized array<localized string> TickerSouthAfricaPanic5;
var const localized array<localized string> TickerChinaPanic1;
var const localized array<localized string> TickerChinaPanic2;
var const localized array<localized string> TickerChinaPanic4;
var const localized array<localized string> TickerChinaPanic5;
var const localized array<localized string> TickerJapanPanic1;
var const localized array<localized string> TickerJapanPanic2;
var const localized array<localized string> TickerJapanPanic4;
var const localized array<localized string> TickerJapanPanic5;
var const localized array<localized string> TickerIndiaPanic1;
var const localized array<localized string> TickerIndiaPanic2;
var const localized array<localized string> TickerIndiaPanic4;
var const localized array<localized string> TickerIndiaPanic5;
var const localized array<localized string> TickerAustraliaPanic1;
var const localized array<localized string> TickerAustraliaPanic2;
var const localized array<localized string> TickerAustraliaPanic4;
var const localized array<localized string> TickerAustraliaPanic5;
var const localized array<localized string> TickerBrazilPanic1;
var const localized array<localized string> TickerBrazilPanic2;
var const localized array<localized string> TickerBrazilPanic4;
var const localized array<localized string> TickerBrazilPanic5;
var const localized array<localized string> TickerArgentinaPanic1;
var const localized array<localized string> TickerArgentinaPanic2;
var const localized array<localized string> TickerArgentinaPanic4;
var const localized array<localized string> TickerArgentinaPanic5;
var const localized array<localized string> TickerMexicoPanic1;
var const localized array<localized string> TickerMexicoPanic2;
var const localized array<localized string> TickerMexicoPanic4;
var const localized array<localized string> TickerMexicoPanic5;
var const localized array<localized string> TickerRussiaPanic1;
var const localized array<localized string> TickerRussiaPanic2;
var const localized array<localized string> TickerRussiaPanic4;
var const localized array<localized string> TickerRussiaPanic5;
var const localized array<localized string> TickerCountryWithdraw;
var const localized array<localized string> TickerAbductionWon;
var const localized array<localized string> TickerAbductionWonWithGeneMods;
var const localized array<localized string> TickerAbductionWonWithMecs;
var const localized array<localized string> TickerTerrorWon;
var const localized array<localized string> TickerCrashedUFOWon;
var const localized array<localized string> TickerLandedUFOWon;
var const localized array<localized string> TickerAbductionLost;
var const localized array<localized string> TickerTerrorLost;
var const localized array<localized string> TickerCrashedUFOLost;
var const localized array<localized string> TickerLandedUFOLost;
var const localized array<localized string> TickerCovertOpsWon;
var const localized array<localized string> TickerCovertOpsLost;
var const localized array<localized string> TickerAmbientAct0;
var const localized array<localized string> TickerAmbientAct1;
var const localized array<localized string> TickerAmbientAct2;
var const localized array<localized string> TickerAmbientAct3;
var const localized array<localized string> TickerExaltSabotage;
var const localized array<localized string> TickerExaltPropaganda;
var const localized array<localized string> TickerExaltResearchHack;
var const localized string TickerNarratives[ETicker_Narratives];

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