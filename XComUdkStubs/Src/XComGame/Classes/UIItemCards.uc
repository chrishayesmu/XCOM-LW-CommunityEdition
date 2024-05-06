class UIItemCards extends UI_FxsScreen
    dependson(XGTacticalGameCoreData)
    notplaceable
    hidecategories(Navigation);

const SCROLLING_PIXEL_RANGE = 20;

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

defaultproperties
{
    s_package="/ package/gfxItemCards/ItemCards"
    s_screenId="gfxItemCards"
    e_InputState=eInputState_Evaluate
    s_name="theScreen"
}