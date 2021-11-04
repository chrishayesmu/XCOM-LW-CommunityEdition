class XComBaseCamera extends XComCameraBase
    abstract
    transient
    config(Camera)
    hidecategories(Navigation);
//complete stub

struct CameraStateOrientation
{
    var transient Vector Focus;
    var transient Rotator Rotation;
    var transient float ViewDistance;
    var transient float FOV;
};

var transient XComCameraState CameraState;
var transient CameraStateOrientation OldCameraStateOrientation;
var transient CameraStateOrientation LastCameraStateOrientation;
var transient bool bHasOldCameraState;
var transient float AnimTime;
var transient float TotalAnimTime;

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
function XComCameraState SetCameraState(class<XComCameraState> NewStateClass, float InInterpTime){}
function UpdateCameraState(float DeltaTime, out Vector out_Location, out Rotator out_Rotation, out float out_FOV){}
function InterpCameraState(float DeltaTime, out Vector out_Location, out Rotator out_Rotation, out float out_FOV){}
function GetCameraStateView(XComCameraState CamState, float DeltaTime, out CameraStateOrientation NewOrientation){}
function OnCameraInterpolationComplete(){}
final function float GetDoubleTweenedRatio(float tVal){}
