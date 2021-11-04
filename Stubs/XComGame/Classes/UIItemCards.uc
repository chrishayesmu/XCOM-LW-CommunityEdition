class UIItemCards extends UI_FxsScreen;
//complete stub

var const localized string m_strCloseCardLabel;
var const localized string m_strRateSlow;
var const localized string m_strRateMedium;
var const localized string m_strRateRapid;
var const localized string m_strRangeShort;
var const localized string m_strRangeMedium;
var const localized string m_strRangeLong;
var const localized string m_strGenericScaleLow;
var const localized string m_strGenericScaleMedium;
var const localized string m_strGenericScaleHigh;
var const localized string m_strHealthBonusLabel;
var const localized string m_strChargesLabel;
var const localized string m_strEffectiveRangeLabel;
var const localized string m_strBaseDamageLabel;
var const localized string m_strBaseCriticalDamageLabel;
var const localized string m_strCriticalDamageLabel;
var const localized string m_strFireRateLabel;
var const localized string m_strHitChanceLabel;
var const localized string m_strRangeLabel;
var const localized string m_strDamageLabel;
var const localized string m_strArmorPenetrationLabel;
var const localized string m_strWeaponTypeLabel;
var const localized string m_strChassisTypeLabel;
var const localized string m_strChassisTypeNormal;
var const localized string m_strChassisTypeAlloy;
var const localized string m_strChassisTypeHover;
var const localized string m_strSHIVWeaponAbilitiesListHeader;
var const localized string m_strHumanTacticalInfoTitle;
var const localized string m_strAlienInfoTitle;
var const localized string m_strHPLabel;
var const localized string m_strWillLabel;
var const localized string m_strAimLabel;
var const localized string m_strDefenseLabel;
var const localized string m_strAbilitiesListHeader;
var const localized string m_strTacticalInfoHeader;
var const localized string m_strItemCardAbilityName[EItemCardAbility];
var const localized string m_strItemCardAbilityDesc[EItemCardAbility];
var TItemCard m_tItemCard;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TItemCard cardData){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnCommand(string Cmd, string Arg);
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function XComPerkManager PERKS(){}
simulated function string GenerateAbilityData(){}
simulated function string GeneratePerkData(){}
simulated function string GenerateAlternativeAbilityData(){}
simulated function bool OnClose(optional string strOption=""){}
function RefreshNavigationHelp(){}
simulated function AS_SetCardTitle(string Title){}
simulated function AS_SetStatData(int statIndex, string statLabel, string statVal, optional string statDiff=""){}
simulated function AS_SetCardImage(string imagePath, int cardType){}
simulated function AS_AddSimpleTextCardData(string Text){}
simulated function AS_AddTacticalInfoCardData(string Title, string tacticalText){}
simulated function AS_AddAbilitiesCardData(string Title, string processedData){}
simulated function AS_AddPerksCardData(string Title, string processedData){}
simulated function AS_SetHelp(string displayString, string Icon){}
simulated function AS_ScrollUp(float _tweenDuration, int _pixelScrollRange){}
simulated function AS_ScrollDown(float _tweenDuration, int _pixelScrollRange){}
simulated function AS_InitializationComplete(){}

