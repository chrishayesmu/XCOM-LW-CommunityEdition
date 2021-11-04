class UIDisplayMovie extends UIFxsMovie;

var int MouseX;
var int MouseY;

simulated function InitMovie(Actor _pres) {}
simulated function OnInit() {}
simulated function ShowDisplay(name ActorTag) {}
simulated function HideDisplay(name ActorTag) {}
simulated function ScaleUVs(name ActorTag, Vector UVScale) {}

simulated function SetMouseLocation(Vector2D kVector2D) {}