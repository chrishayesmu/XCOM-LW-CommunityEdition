class UIUnitGermanMode extends UI_FxsScreen;
//complete stub

var const localized string m_strCloseGermanModeLabel;
var const localized string m_strPassivePerkListTitle;
var const localized string m_strBonusesListTitle;
var const localized string m_strPenaltiesListTitle;
var const localized string m_strHealthLabel;
var const localized string m_strWillLabel;
var const localized string m_strOffenseLabel;
var const localized string m_strDefenseLabel;
var const localized string m_strCivilianNickname;
var UIUnitGermanMode_PerkList m_kPerks;
var UIUnitGermanMode_PerkList m_kBonuses;
var UIUnitGermanMode_PerkList m_kPenalties;
var UIUnitGermanMode_ShotInfo m_kInfoPanel;
var XGUnit m_kUnit;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGUnit theUnit){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int ucmd, array<string> parsedArgs){}
simulated function UpdateHeader(){}
simulated function int GetWillBonus(XGUnit kUnit){}
simulated function int GetDefenseBonus(XGUnit kUnit){}
simulated function AS_SetSoldierInformation(string _name, string _nickname, string _classIcon, string _rankIcon, bool _showPromoteIcon){}
simulated function AS_SetUnitStats(string _health, string _will, string _offense, string _defense){}
simulated function AS_SetUnitAllegiance(bool _isEnemy){}
simulated function AS_SetAlienInformation(string _name, bool _isFriendly, bool _isExalt){}
simulated function AS_ScrollUp(float _tweenDuration, int _pixelScrollRange){}
simulated function AS_ScrollDown(float _tweenDuration, int _pixelScrollRange){}
simulated function AS_SetButtonHelp(string Label, string Icon){}
