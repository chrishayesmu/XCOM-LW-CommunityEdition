class XGCameraView extends Actor
    native(Core);

//complete stub

enum ETransitionType_XGCamera
{
    eTransition_Blend,
    eTransition_Cut,
    eTransition_MAX
};

enum ECameraEffect
{
    eCE_ShakyCam,
    eCE_ScreenShake,
    eCE_MotionBlur,
    eCE_DepthOfField,
    eCE_BlownOut,
    eCE_FilmGrain,
    eCE_MAX
};

struct native TShakyCamModifier
{
    var float m_fAccumTime;
    var float m_fAnimTime;
    var Rotator m_rStart;
    var Rotator m_rEnd;
    var float m_fAccumZTime;
    var float m_fAnimZTime;
    var float m_fStartZoom;
    var float m_fEndZoom;

};

struct native TScreenShakeModifier
{
    var float m_fShakeTimer;
    var Vector m_vStartShake;
    var Vector m_vEndShake;
};

var int iObstacleObstructionPitch;
var bool m_bEnableDOF;
var bool m_bCanStack;
var bool m_bKeepTargetInView;
var bool m_bModal;
var bool m_bLocationLocked;
var bool m_bDestroyWhenCleared;
var Vector m_vDOFPosition;
var float m_fDOFMaxFarBlurAmount;
var float m_fDOFMaxNearBlurAmount;
var float m_fDOFFalloffExponent;
var float m_fDOFFocusInnerRadius;
var float m_fDOFBlurKernelSize;
var Vector m_vTarget;
var Actor m_kActorTarget;
var() float m_fFOV;
var() float m_fDistance;
var() float m_fMouseFOV;
var() float m_fMouseDefaultDistance;
var Vector m_vMouseDirection;
var float m_fZoom;
var Vector m_vDirection;
var ETransitionType_XGCamera m_eTransition;
var() InterpCurveFloat m_kSpeedCurve;
var float m_fAdditionalRoll;
var float m_fAdditionalPitch;
var float m_fAdditionalYaw;
var float m_fDefaultDistance;
var array<XGUnit> m_arrUnits_For_AutoZooming;
var int m_iMaxAutoZoomingUnits;
var int m_aiEffects[ECameraEffect];
var TShakyCamModifier m_kShakyCam;
var TScreenShakeModifier m_kScreenShake;
var Vector m_vCachedCalcLocation;
var transient array<GameCameraBlockingVolume> m_aGCBV;

native static function ChangeOverheadCameraDefaults(float fFOV, float fCameraDistance, float fPitchInDegrees);

event PostBeginPlay(){}
simulated function string DebugCameraView(){}
simulated function SetActorTarget(Actor kTarget){}
simulated function SetLocationTarget(Vector vTarget){}
simulated function SetDOFPosition(Vector vDOFPosition){}
simulated function bool IsAutoZooming(){}
simulated function int GetNumAutoZoomUnits(){}
simulated function XGUnit GetFirstAutoZoomUnit(){}
simulated function Vector GetAutoZoomLookAtCenter(){}
simulated function AutoZoom_AddUnit(XGUnit kZoomUnit){}
simulated function AutoZoom_RemoveUnit(XGUnit kZoomUnit){}
simulated function AutoZoomReset(){}
simulated function SetZoom(float fZoom){}
simulated function float GetZoom(){}
simulated function SetTransition(ETransitionType_XGCamera eTransition){}
simulated function ETransitionType_XGCamera GetTransition(){}
simulated function AddCameraEffect(ECameraEffect eEffect){}
simulated function RemoveCameraEffect(ECameraEffect eEffect){}
simulated function bool HasModifiers(){}
simulated function CopyView(XGCameraView kView){}
simulated function AddPitch(float fDegrees){}
simulated function LockLocation(bool bLock){}
simulated function GetCameraPOV(float fDeltaT, out TPOV out_POV, float fUserYaw){}
simulated function float GetDistance(){}
simulated function GetLockedPOV(float fDeltaT, out TPOV out_POV, float fUserYaw){}
simulated function Vector GetLookAt(){}
simulated function Vector AutoZoomProcessing(Rotator rRotation){}
simulated function Vector CalcLocation(Rotator rRotation){}
native simulated function Vector ClampCameraZ(Vector vLocation, Vector vRotation, Actor LookAtActor);

simulated function bool IsModal(){}
simulated function SetModal(bool bModal){}
simulated function float DegToUnr(float fDegrees){}
simulated function bool IsTargetBlockedFromView(Vector vLookAt, Vector vFrom, out Vector vHitLoc){}
simulated function PitchCameraToAvoidObstacles(out Vector vLocation, out Rotator rRotation, float fDeltaT){}
simulated function float ComputeClosenessModifier(Vector vLocation, Vector vComparisonLoc, float fCurrentModifier){}
simulated function bool isOnScreen(Vector vLocation, out Vector2D v2ScreenCoords, optional float fPadding){}
simulated function float GetSpeedFromCurve(float fDistanceFromDestination){}
simulated function ApplyModifiers(float fDeltaT, out TPOV out_POV){}
simulated function ApplyShakyCam(float fDeltaT, out TPOV out_POV){}
