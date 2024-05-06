class UITacticalHUD_WeaponContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

var UITacticalHUD_WeaponPanel m_kWeaponPanel0;
var UITacticalHUD_WeaponPanel m_kWeaponPanel1;
var private bool bSelectionbracketsActive;
var protected XGUnit m_kCurrentUnit;
var const localized string m_strHelpReloadWeapon;
var const localized string m_strHelpSwapWeapon;

defaultproperties
{
    s_name="theWeaponContainer"
}