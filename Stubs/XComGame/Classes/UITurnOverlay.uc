class UITurnOverlay extends UI_FxsScreen;

//complete stub

enum ETurnOverlay
{
    eTurnOverlay_Local,
    eTurnOverlay_Remote,
    eTurnOverlay_Alien,
    eTurnOverlay_MAX
};

var float m_fAnimateTime;
var float m_fAnimateRate;
var bool m_bXComTurn;
var bool m_bAlienTurn;
var bool m_bOtherTurn;
var const localized string m_sXComTurn;
var const localized string m_sAlienTurn;
var const localized string m_sOtherTurn;
var const localized string m_sExaltTurn;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function SetDisplayText(string alienText, string xcomText, string p2Text){}
simulated function ShowAlienTurn(optional bool bFirstTutorialMission){}
simulated function PulseAlienTurn(){}
simulated function HideAlienTurn(bool bFirstTutorialMission){}
simulated function SetAlienScreenGlow(float fAmount){}
simulated function AnimateIn(){}
simulated function AnimateOut(){}
simulated function AS_ShowBlackBars(){}
simulated function ShowXComTurn(){}
simulated function PulseXComTurn(){}
simulated function HideXComTurn(){}
simulated function ShowOtherTurn(){}
simulated function PulseOtherTurn(){}
simulated function HideOtherTurn(){}
simulated function bool IsShowingAlienTurn(){}
simulated function bool IsShowingXComTurn(){}
simulated function bool IsShowingOtherTurn(){}
