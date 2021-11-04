class UIUnitGermanMode_ShotInfo extends UI_FxsPanel;
//complete  stub

var const localized string m_sCriticalLabel;
var const localized string m_sShotChanceLabel;
var string m_strTitle;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function UpdateDisplay(){}
private final simulated function ProcessModifiers(array<string> arrLabels, array<int> arrValues, bool bIsCritType){}
simulated function AS_SetShotInfo(string _name, string hitPercent, string hitLabel, string critPercent, string critLabel){}
simulated function AS_AddCritItem(string _name, string _percent){}
simulated function AS_AddRegularItem(string _name, string _percent){}
