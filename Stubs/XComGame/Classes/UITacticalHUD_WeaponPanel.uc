class UITacticalHUD_WeaponPanel extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

var TShotInfo kInfo;
var TShotResult kResult;
var XGWeapon m_kWeapon;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen, coerce name _name){}
simulated function OnInit(){}
simulated function SetWeaponAndAmmo(XGWeapon kWeapon){}
simulated function NewActiveWeapon(optional XGWeapon ActiveWeapon){}
simulated function string GetWeaponLabelName(XGWeapon kWeapon){}
