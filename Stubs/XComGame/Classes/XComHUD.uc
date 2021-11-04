class XComHUD extends HUD
	config(Game);
//complete stub

var Vector CachedCameraWorldOrigin;
var Vector CachedCameraWorldDirection;
var Vector CachedMouseWorldOrigin;
var Vector CachedMouseWorldDirection;
var Vector CachedHitLocation;
var IMouseInteractionInterface CachedMouseInteractionInterface;
var MaterialInstanceConstant GammaLogo;
var bool bEnableGammaLogoDrawing;
var bool bEnableLoadingTexture;
var IMouseInteractionInterface CachedMouseInteractionInterface_Inter;
var Vector2D ViewSize;

event PostBeginPlay(){}
function SetGammaLogoDrawing(bool bDrawLogo){}
function DrawHUD(){}
event PostRender(){}
function clearMouseInteractionInterface(){}
function updateMouseInteractionInterface(optional Vector2D pickLocation){}
function CalculateCameraVectors(optional Vector2D pickLocation){}
function IMouseInteractionInterface GetMousePickActor(){}
function IMouseInteractionInterface GetMousePickInterActor(){}
event OnLostFocusPause(bool bEnable){}
