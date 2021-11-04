class XComCamera extends XComCameraBase
    transient
    native
    config(Camera)
    hidecategories(Navigation);
//complete stub

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

simulated function Init(){}
function InitializeFor(PlayerController PC){}
simulated function ResetCurveRampUp(float fRampUp){}
simulated function SetCameraYaw(float fDegrees, optional bool bInterpolate=true){}
simulated function YawCamera(float fDegrees){}
simulated function PitchCamera(float fDegrees){}
simulated function ApplyYaw(float fYawDegrees){}
simulated function ApplyPitch(float fPitchDegrees){}
simulated function bool IsMoving(){}
simulated function pushPostProcess(PostProcessChain kPostProccess){}
simulated function popPostProcess(){}
simulated function bool isActorBlocked(Vector vTarget, Vector vFromLocation, Actor SourceActor, out Vector vHitLoc){}
simulated function bool isOnScreen(Vector vTarget, TPOV kPOV){}
simulated function LookAt(Vector vLocation, optional float fZoom=-1.0, optional InterpCurveFloat SpeedCurve){}
simulated function InterpCameraFocusLocation(float DeltaTime, Vector OldLocation, out Vector CurrentLocation){}
simulated function InterpCameraFocusRotation(float DeltaTime, Rotator OldRotation, out Rotator CurrentRotation){}
simulated function bool getCameraForTargetVisible(Vector vTarget, out TPOV out_POV){}
simulated function bool getCameraForAnchorsVisible(Vector vTarget, Vector vAnchor1, Vector vAnchor2, out TPOV out_POV){}
simulated function bool getRotationForActorVisible(Vector vTarget, Vector vAnchor1, Vector vAnchor2, out TPOV out_POV){}
simulated event UpdateCamera(float DeltaTime){}
simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
simulated function UpdateCameraView(float DeltaTime, out TPOV out_POV){};
simulated function ApplyModifiers(float DeltaTime, out TPOV out_POV){};
simulated function LockPan(){}
simulated function UnlockPan(){}
simulated function UpdateTurnAndLookUp(float fTurn, float fLookUp){}
simulated function ToggleThirdPerson(){}
simulated function PostProcessInput(){};
simulated function CalculateGameCameraPOV(Vector vTarget, out TPOV out_POV){}
simulated function CalculateCameraLocation(Vector vTarget, out TPOV out_POV){}
simulated function XGCameraView GetCurrentView(){}
simulated function SetCurrentView(XGCameraView kView, optional InterpCurveFloat SpeedCurve){}
simulated function ResetView(bool bCut){}
simulated function UpdateView(){}
simulated function ClearView(){}
function XComPresentationLayer PRES(){}
function UpdateWorldInfoDOF(float DeltaTime){}
simulated function bool IsCameraAtCachedCalcLocation(float fAlpha){}

simulated state CursorView
{
    simulated event BeginState(name PrevStateName){}
    simulated function UpdateCameraView(float DeltaTime, out TPOV out_POV){}
    simulated function ApplyModifiers(float DeltaTime, out TPOV out_POV){}
    function InterpolatePOV(float fDeltaT, out TPOV out_POV){}
    simulated function UpdateTurnAndLookUp(float fTurn, float fLookUp){}
}

simulated state ProfileGridView
{
    simulated function UpdateCameraView(float DeltaTime, out TPOV out_POV){}
}

simulated state DebugView
{
	   simulated function DisplayDebugMsg(){}
    simulated event EndState(name NextState){}
    simulated function UpdateCameraView(float DeltaTime, out TPOV out_POV){}
    simulated function PostProcessInput(){}
}
