class UISpecialMissionHUD_CapturePointStats extends UI_FxsPanel
	notplaceable
	hidecategories(Navigation);
//complete stub

struct TUICapturePointData
{
	var int iCapturePointIndex;
	var XComCapturePointVolume kCapturePoint;
	var UISpecialMissionHUD_TurnCounter kCPCounter;
};

var array<TUICapturePointData> m_arrControlPointData;
var const localized string m_strEncoder;
var const localized string m_strTransmitter;
var const localized string m_strCPLost;
var const localized string m_strCPSecure;
var const localized string m_strCPHackBlocked;
var const localized string m_strCPHackInProgress;
var const localized string m_strCPLocationSecure;
var XComPresentationLayer m_kPres;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function UpdatePanel(){}
simulated function Remove(){}
