class XGCameraView extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

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

defaultproperties
{
    m_bEnableDOF=true
    m_bCanStack=true
    m_bKeepTargetInView=true
    m_bModal=true
    m_fDOFFalloffExponent=4.0
    m_fDOFFocusInnerRadius=2048.0
    m_fDOFBlurKernelSize=2.0
    m_fFOV=70.0
    m_fDistance=1256.0
    m_fMouseFOV=30.0
    m_fMouseDefaultDistance=3500.0
    m_vMouseDirection=(X=-0.590,Y=0.520,Z=-0.620)
    m_vDirection=(X=-0.590,Y=0.520,Z=-0.620)
    // m_kSpeedCurve=(Points=/* Array type was not detected. */)
    m_fDefaultDistance=1256.0
    bTickIsDisabled=true
}