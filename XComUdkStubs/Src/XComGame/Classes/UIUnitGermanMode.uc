class UIUnitGermanMode extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

const SCROLLING_PIXEL_RANGE = 30;

var const localized string m_strCloseGermanModeLabel;
var private const localized string m_strPassivePerkListTitle;
var private const localized string m_strBonusesListTitle;
var private const localized string m_strPenaltiesListTitle;
var private const localized string m_strHealthLabel;
var private const localized string m_strWillLabel;
var private const localized string m_strOffenseLabel;
var private const localized string m_strDefenseLabel;
var private const localized string m_strCivilianNickname;
var private UIUnitGermanMode_PerkList m_kPerks;
var private UIUnitGermanMode_PerkList m_kBonuses;
var private UIUnitGermanMode_PerkList m_kPenalties;
var private UIUnitGermanMode_ShotInfo m_kInfoPanel;
var private XGUnit m_kUnit;

defaultproperties
{
    s_package="/ package/gfxUnitGermanMode/UnitGermanMode"
    s_screenId="gfxUIUnitGermanMode"
    e_InputState=eInputState_Consume
    b_OwnsMouseFocus=true
    s_name="theScreen"
}