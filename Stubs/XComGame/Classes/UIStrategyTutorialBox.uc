class UIStrategyTutorialBox extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var string m_strHelpText;
var bool m_bPlayingOutro;
var bool m_bIsStrategy;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, string strHelpText){}
simulated function OnInit(){}
event Destroyed(){}
simulated function TweenHelp(){}
function AdjustTipPosition(){}
simulated function AS_AnchorBasedOnStrategy(bool strategyLayer){}
function SetNewHelpText(string strHelpText){}
function UpdateDisplay(){}
simulated function Show(){}
simulated function Hide(){}
simulated function ToggleDepth(bool bOnTop){}
simulated function RemoveMeFromDepthScreens(){}
simulated function bool IsVisible(){}
simulated function OnCommand(string Cmd, string Arg){}
final simulated function AS_SetText(string Text){}
simulated function AS_AnchorToTopRight(){}
simulated function AS_AnchorToBottomRight(){}
simulated function AS_AnchorToBottomLeft(){}
simulated function AS_CommLinkAdjusted(bool adjusted){}
