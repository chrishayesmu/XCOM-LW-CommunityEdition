class UISoldierAugmentation extends UI_FxsScreen;
//complete stub

var const localized string m_strScreenTitle;
var const localized string m_strBonusAbilityLabel;
var const localized string m_strWarningLabel;
var const localized string m_strWarningDescription;
var const localized string m_strWarningDescriptionGeneModded;
var const localized string m_strCostLabel;
var const localized string m_strAugmentButtonLabel;
var const localized string m_strNotNowButtonLabel;
var XGCyberneticsUI m_kLocalMgr;
var XGStrategySoldier m_kSoldier;
var XGFacility_CyberneticsLab m_kCybernetics;
var int m_iSelectedIndex;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGStrategySoldier kSoldier){}
simulated function XGCyberneticsUI GetMgr(){}
simulated function OnInit(){}
simulated function UpdateSoldierInfo(){}
simulated function UpdateRequirements(){}
simulated function UpdateButtonHelp(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function RealizeSelected(optional int Delta){}
simulated function AS_SetLabels(string Title, string bonusAbilityLabel, string warningLabel, string warningDescription){}
simulated function AS_SetSoldierData(string soldierName, string SoldierRank, string rankIcon, string oldClassIcon){}
simulated function AS_SetBonusAbilityData(string abilityName, string abilityDescription, string abilityIcon){}
simulated function AS_SetCost(string Cost){}
simulated function AS_SetButtonHelp(int Index, string Label, string Icon, bool IsDisabled){}
simulated function AS_SetSelected(int Index, bool isSelected){}
