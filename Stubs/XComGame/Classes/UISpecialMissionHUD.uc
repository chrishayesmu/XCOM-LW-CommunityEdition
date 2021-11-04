class UISpecialMissionHUD extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var UISpecialMissionHUD_Arrows m_kArrows;
var UISpecialMissionHUD_MeldStats m_kMeldStats;
var UISpecialMissionHUD_CapturePointStats m_kCapturePointStats;
var UISpecialMissionHUD_BombMessage m_kBombMessage;
var UISpecialMissionHUD_TurnCounter m_kGenericTurnCounter;
var string s_TurnCountersContainer;
var const localized string m_strExtractionsTitle;
var const localized string m_strExtractionsBody;
var const localized string m_strHiveTitle;
var const localized string m_strHiveBody;

simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function RealizePosition(){}
simulated function DialogueExtraction(){}
simulated function DialogueHive(){}
simulated function Remove(){}
