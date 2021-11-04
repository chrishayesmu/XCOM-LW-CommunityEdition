class UIMouseCursor extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var Vector2D m_v2MouseLoc;
var Vector2D m_v2MouseFrameDelta;
var bool bIsInDefaultLocation;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
event Destroyed(){}
simulated event OnCleanupWorld(){}
simulated function UpdateMouseLocation(){}
simulated function MouseStateChanged(){}
simulated function ZoomMouseCursor(optional bool zooming){}
simulated function Show(){}
simulated function ShowMouseCursor(){}
simulated function Hide(){}
simulated function HideMouseCursor(){}
simulated function ToggleVisibility(){}
