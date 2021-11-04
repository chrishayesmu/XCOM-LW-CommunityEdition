class UITacticalHUD_InfoPanel extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

enum eUI_BonusIcon
{
    eUIBonusIcon_Flanked,
    eUIBonusIcon_Height,
    eUIBonusIcon_MAX
};

var XGUnit m_kUnit;
var XGAbility m_kAbility;
var const localized string m_sMessageShotUnavailable;
var const localized string m_sNoTargetsHelp;
var const localized string m_sNoAmmoHelp;
var const localized string m_sOverheatedHelp;
var const localized string m_sMoveLimitedHelp;
var const localized string m_sCriticalLabel;
var const localized string m_sUnavailable;
var const localized string m_sFreeAimingTitle;
var const localized string m_sShotChanceLabel;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int ucmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function Update(XGUnit kUnit, XGAbility kAbility){}
simulated function Timer(){}
simulated function OnFreeAimChange(){}
simulated function SetIsAvailable(bool bIsAvailable){}
simulated function SetShotName(string Label, string Desc){}
simulated function SetHelp(string Desc){}
simulated function string FormatModifiers(array<string> arrLabels, array<int> arrValues, optional string sValuePrefix, optional string sValueSuffix){}
simulated function SetModifiers(string Soldier, string Enemy){}
simulated function AS_SetGermanModeButtonVisibility(bool bVisible){}
simulated function AS_SetOKButtonVisibility(bool bVisible){}
simulated function SetCriticalChance(string Label, string Desc){}
simulated function SetShotChance(string Label, string Desc){}
simulated function SetWeaponStats(string weaponName){}
simulated function UpdateLayout(){}
