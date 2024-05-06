class XComCamera extends XComCameraBase
    transient
    native
    config(Camera)
    hidecategories(Navigation);

var() InterpCurveFloat MaxCameraSpeedCurve;
var transient Vector LastFocusActorLocation;
var transient Vector LastFocusActorDirection;
var transient float AimTime;
var transient TPOV AimStartPOV;
var transient TPOV AimEndPOV;
var transient Vector CameraDirection;
var transient float CameraYaw;
var transient float CameraYawCurr;
var transient float CameraYawChangeSign;
var transient float CameraPitch;
var transient XGCameraView m_kCurrentView;
var transient XGCameraView m_kSavedView;
var transient XGCameraView_Scroll m_kScrollView;
var transient bool m_bScrollLock;
var transient XGCameraView m_kLookAtView;
var transient float m_fSpeedCurveRampUp;

defaultproperties
{
    MaxCameraSpeedCurve=(Points=/* Array type was not detected. */)
    LastFocusActorDirection=(X=-0.550,Y=-0.020,Z=-0.830)
    AimStartPOV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0)
    AimEndPOV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0)
    CameraDirection=(X=-0.590,Y=0.520,Z=-0.620)
    CameraStyle=ThirdPerson
    DefaultFOV=50.0
    FreeCamOffset=(X=0.0,Y=0.0,Z=64.0)
}