class UITacticalHUD_InfoPanel extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

enum eUI_BonusIcon
{
    eUIBonusIcon_Flanked,
    eUIBonusIcon_Height,
    eUIBonusIcon_MAX
};

var private XGUnit m_kUnit;
var private XGAbility m_kAbility;
var const localized string m_sMessageShotUnavailable;
var const localized string m_sNoTargetsHelp;
var const localized string m_sNoAmmoHelp;
var const localized string m_sOverheatedHelp;
var const localized string m_sMoveLimitedHelp;
var const localized string m_sCriticalLabel;
var const localized string m_sUnavailable;
var const localized string m_sFreeAimingTitle;
var const localized string m_sShotChanceLabel;

defaultproperties
{
    s_name="theInfoBox"
}