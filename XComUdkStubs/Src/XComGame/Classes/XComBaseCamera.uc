class XComBaseCamera extends XComCameraBase
    abstract
    transient
    config(Camera)
    hidecategories(Navigation);

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