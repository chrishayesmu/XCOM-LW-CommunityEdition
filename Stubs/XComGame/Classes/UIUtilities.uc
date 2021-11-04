class UIUtilities extends Object
	DependsOn(XGGameData);
//complete  stub

const NORMAL_HTML_COLOR = "67E8ED";
const HILITE_HTML_COLOR = "B9FFFF";
const DISABLED_HTML_COLOR = "808080";
const BAD_HTML_COLOR = "EE1C25";
const GOOD_HTML_COLOR = "5CD16C";
const CASH_HTML_COLOR = "5CD16C";
const WARNING_HTML_COLOR = "FFD038";
const WARNING2_HTML_COLOR = "F67420";
const PSIONIC_HTML_COLOR = "A09CD6";
const HYPERWAVE_HTML_COLOR = "F78000";
const FLASH_DOCUMENT_WIDTH = 1280.0;
const FLASH_DOCUMENT_HEIGHT = 720.0;
const MELD_NORMAL = "meld_blue";
const MELD_GOOD = "meld_green";
const MELD_WARNING = "meld_orange";
const MELD_BAD = "meld_red";
const MELD_DISABLED = "meld_grey";
const MELDTAG = "#MELDTAG";
const MELD_TEMPLATE_ITEMCARD_IMG = "img:///UILibrary_MPCards.MPCard_GeneMod";

var const localized string m_strGenericOK;
var const localized string m_strGenericConfirm;
var const localized string m_strGenericCancel;
var const localized string m_strGenericBack;
var const localized string m_strDay;
var const localized string m_strDays;
var const localized string m_strHour;
var const localized string m_strHours;
var const localized string m_strMPPlayerEndTurnDialog_Title;
var const localized string m_strMPPlayerEndTurnDialog_Body;
var const localized string m_strUpperYWithUmlaut;
var const localized string m_strLowerYWithUmlaut;
var const localized string KNOWN_NULL_CHARACTER_DO_NOT_TRANSLATE;

static function string GetDaysString(int iDays){}
static function string GetHoursString(int iDays){}
static function ClampIndexToArrayRange(int arrLength, out int Index){}
static function string GetHTMLColoredText(string txt, int iState, optional int FontSize=-1) {}
static function string InjectHTMLImage(string imgID, optional int Width, optional int Height, optional int VerticalOffset) {}
static simulated function string GetPerkIconLabel(int iPerk, XComPerkManager perkMgr){}
static simulated function string GetAbilityIconLabel(int iAbility){}
static simulated function string GetMECItemToAbilityIconLabel(int eItem){}
static simulated function string GetMPMapImagePath(name MapName){}
static simulated function string GetMapImagePath(name MapName){}
static simulated function string GetMapImagePackagePath(name MapName){}
static simulated function string GetCoreMapPackage(){}
static simulated function string GetHQAssaultMapPackage(){}
static simulated function bool IsHQAssaultMap(name MapName){}
static simulated function string CapsCheckForGermanScharfesS(string Str) {}
static simulated function string GetCountryLabel(int iCountry){}
static simulated function string GetCharacterCardImage(ECharacter eChar, optional bool bIsGeneModded, optional bool bIsMec){}
static simulated function string GetOTSImageLabel(int iImg){}
static simulated function string GetFoundryImagePath(int iImg){}
static simulated function string GetItemImagePath(EItemType eItem){}
static simulated function string GetInventoryImagePath(int iImg){}
static simulated function string GetTechImagePath(int iImg){}
static simulated function string GetRankLabel(int iRank, optional bool bIsShiv){}
static simulated function string GetStrategyImagePath(int iImg){}
static simulated function string GetResearchCreditImagePath(int iImg){}
static simulated function string GetFacilityLabel(int eFacilityImageType){}
static simulated function string GetButtonName(int iGameCoreButtonEnum){}
static simulated function string GetClassLabel(int iClass, optional bool bIsPsiSoldier, optional bool bIsGeneModded){}
static simulated function string GetShipIconLabel(EShipType Type){}
static simulated function string GetMissionListItemIcon(int iImage, optional int iState=2){}
static simulated function string GetEventListFCRequestIcon(int iContinentMakingRequest){}
static simulated function string GetMPPingLabel(int Ping){}
static simulated function StripSpecialMissionFromMapName(out string MapName){}
static simulated function SantizeUserName(out string UserName){}
static simulated function StripUnsupportedCharactersFromUserInput(out string userString){}
static simulated function string HTMLFormatMeld(int iAmount, int iState){}
static simulated function string HTMLGetMeldImage(int iState){}
static simulated function string GetMedalLabels(int medalsArr[EMedalType]){}
static simulated function string GetMedalLabel(int Type){}
static simulated function string GetMedalImagePath(int iImg){}
static simulated function string GetLargeMedalImagePath(int iImg){}
static simulated function string GetPowerImagePath(int iImg){}
static final function string GetEItemType_InfoIcon(EItemType_Info ItemInfo){}

