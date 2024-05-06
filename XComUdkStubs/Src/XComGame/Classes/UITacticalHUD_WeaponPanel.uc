class UITacticalHUD_WeaponPanel extends UI_FxsPanel
    dependson(XGAbility_Targeted)
    notplaceable
    hidecategories(Navigation);

var TShotInfo kInfo;
var TShotResult kResult;
var XGWeapon m_kWeapon;

defaultproperties
{
    s_name="<WEAPON PANEL NAME NOT SET>"
}