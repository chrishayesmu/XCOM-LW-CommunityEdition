class XGScreenMgr extends XGStrategyActor
	abstract
	config(GameData)
	notplaceable;
//complete stub
struct TMiniWorld
{
    var TImage imgWorld;
    var TLabeledText ltxtFunding;
    var array<TRect> arrCountries;
    var array<Color> arrColors;
    var array<TText> arrTickerText;
};
var int m_iCurrentView;
var string m_strVirtualKeyboard;
var TMiniWorld m_kMap;
var IScreenMgrInterface m_kInterface;
var const localized string m_aResourceTypeNames[EResourceType];
var const localized string m_strCreditsPrefix;

function bool Narrative(XComNarrativeMoment Moment, optional bool availableInDebug){}
function bool UnlockItem(XGGameData.EItemType eItem){}
function bool UnlockFacility(XGGameData.EFacilityType eFacility){}
function bool UnlockFoundryProject(XGGameData.EFoundryTech eProject){}
function bool UnlockGeneMod(XGGameData.EGeneModTech eGene){}
function bool UnlockMecArmor(XGGameData.EItemType eArmor){}
function Init(int iView){}
function UpdateView(){}
function GoToView(int iView){}
function array<string> GetHeaderStrings(array<int> arrCategories){}
function array<int> GetHeaderStates(array<int> arrCategories){}
function PlayGoodSound(){}
function PlayBadSound(){}
function PlayOpenSound(){}
function PlayCloseSound(){}
function PlaySmallOpenSound(){}
function PlaySmallCloseSound(){}
function PlayScrollSound(){}
function PlayToggleSelectContinent(){}
function PlayActivateSoldierPromotion(){}
function PlayScienceLabScreenOpen(){}
function PlayHologlobeActivation(){}
function PlayHologlobeDeactivation(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus();
simulated function OnDeactivate(){}
function IScreenMgrInterface GetUIScreen(){}
function SetStringFromVirtualKeyboard(string strKeyboard){}
function CanceledFromVirtualKeyboard();
static function string ConvertCashToString(int iAmount){}
function string GetResourceLabel(int iResource){}
function string GetResourceString(int iResource){}
function int GetResourceUIState(int iResource){}
function TLabeledText GetResourceText(int iResource){}
