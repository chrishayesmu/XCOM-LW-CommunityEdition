class UITacticalHUD_WeaponContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

var UITacticalHUD_WeaponPanel m_kWeaponPanel0;
var UITacticalHUD_WeaponPanel m_kWeaponPanel1;
var private bool bSelectionbracketsActive;
var protected XGUnit m_kCurrentUnit;
var const localized string m_strHelpReloadWeapon;
var const localized string m_strHelpSwapWeapon;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
function ForceUpdate(){}
function Update(optional bool bForceUpdate){}
simulated function SetWeapons(XGWeapon ActiveWeapon, XGWeapon PrimaryWeapon, optional XGWeapon secondaryWeapon, optional XGWeapon tertiaryWeapon){}
simulated function AS_SetWeaponName(string displayString){}
simulated function HideSelectionBrackets(){}
simulated function SetHelp(int Index, string Icon, string DisplayText){}
