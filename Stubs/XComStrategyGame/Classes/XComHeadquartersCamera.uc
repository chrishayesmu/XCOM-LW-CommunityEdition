class XComHeadquartersCamera extends XComBaseCamera
    transient
    config(Camera)
    hidecategories(Navigation);

var transient float CurrentZoom;
var name RoomTransitioningToFromEarthView;
var Rotator m_kEarthViewRotation;
var bool bHasFocusQueued;
var Vector2D QueuedEarthFocusLoc;
var float fQueuedInterpTime;
var name CurrentRoom;
var float fEarthTransitionInterp;

function InitializeFor(PlayerController PC){}
function bool IsMoving(){}
function SetZoom(float Amount){}

function ResetZoom(){}
function GetCameraStateView(XComCameraState CamState, float DeltaTime, out CameraStateOrientation NewOrientation){}
function GetViewDistance(out float ViewDistance){}
function SetRelativeViewDistance(float fRelativeDist){}
function SetViewDistance(float fDist){}
function StartStrategyShellView(){}
function StartHeadquartersView(){}
function StartRoomView(name RoomName, float InterpTime){}
function StartRoomViewNamed(name RoomName, float fInterpTime){}
function TriggerKismetEvent(name RoomName){}
function FocusOnFacility(name RoomName){}
function LookRelative(Vector vRelativeLoc, optional float fZoomPercent){}
function ForceEarthViewImmediately(){}
function FocusOnEarthLocation(Vector2D vLoc, optional float fZoom, optional float fInterpTime){}
state BaseView{}
state BaseRoomView{}
state FreeMovementView{}
state EarthView{}
state EarthViewFocusingOnLocation{}
state EarthViewTransition{}
state EarthViewReverseTransition{}
simulated state BootstrappingStrategy{}

