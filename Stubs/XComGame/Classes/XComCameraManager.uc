class XComCameraManager extends Actor;
//complete stub

struct LookAtWithZoom
{
    var Vector m_vPosition;
    var float m_fZoom;
    var bool m_bSetPOI;
};

struct PodRevealUnits
{
    var array<XGUnit> m_arrUnits;
    var XComAlienPod m_kPod;
};

var private XCom3DCursor m_kCursor;
var Vector m_kVisibilityLoc;
var float m_fFocusHeight;
var float m_fFocusRadius;
var array<XComAlienPod> m_aPodReveals;
var array<PodRevealUnits> m_aPodUnits;
var array<XGUnit> m_aPlayerMovingUnits;
var array<XGUnit> m_aNonPlayerMovingUnits;
var array<XGUnit> m_aFiringUnits;
var array<XGUnit> m_aDyingUnits;
var array<LookAtWithZoom> m_aLookAts;
var array<LookAtWithZoom> m_aKismetLookAts;
var array<XGUnit> m_aOverrideVisibilityLookat;
var bool m_bWaitForCamera;
var bool bScroll;
var bool bCursor;
var bool m_bCustomTolerance;
var transient bool bPathVisible;
var transient bool bLastVisible;
var InterpCurveFloat m_kSpeedCurve_TrackMultipleUnits;
var InterpCurveFloat m_kSpeedCurve_Slow;
var float m_fCustomTolerance;
var transient Vector vLastHiddenLoc;
var transient Vector vLastVisibleLoc;
var transient float OriginalZoom;

simulated function Init();
simulated function SetCustomTolerance(float fTolerance){}
simulated function ClearCustomTolerance(){}
simulated function float GetAdjustedTolerance(float fTolerance){}
simulated function bool IsCameraBusyWithKismetLookAts(){}
simulated function OnCursorMoved(){}
simulated function OnScrollMoved(){}
simulated function DumpInfo(){};
event PostBeginPlay(){}
simulated function SetCameraWaitFlag(){}
simulated function ClearCameraWaitFlag(){}
simulated function bool WaitForCamera(){}
simulated function ResetCameraSpeedCurveRampUp(float fRampUp){}
simulated function AddCursor(XCom3DCursor kCursor){}
simulated function XCom3DCursor GetCursor(){}
simulated function AddLookAt(Vector vLookAt, optional float fZoom=-1.0, optional bool bSetPOI=true){}
simulated function RemoveLookAt(Vector vLookAt, optional bool bNoUpdate){}
simulated function ClearLookAts(optional bool bUpdateAfterClear){}
simulated function AddKismetLookAt(Vector vLookAt, optional float fZoom){}
simulated function RemoveKismetLookAt(Vector vLookAt, optional bool bNoUpdate){}
simulated function ClearKismetLookAts(optional bool bUpdateAfterClear){}
simulated function AddMovingUnit(XGUnit kUnit){}
simulated function RemoveMovingUnit(XGUnit kUnit, optional bool bNoUpdate){}
simulated function bool ShouldControlVisibility(){}
simulated function UpdateVisibilityPosition(Vector VisPosition){}
simulated function UpdateVisibilityUnit(XGUnit kUnit){}
simulated function AddFiringUnit(XGUnit kUnit, optional bool bFront){}
simulated function RemoveFiringUnit(XGUnit kUnit, optional bool bNoUpdate){}
simulated function bool IsTrackingFiringUnit(XGUnit kUnit){}
simulated function AddDyingUnit(XGUnit kUnit, optional bool bAddToFront){}
simulated function RemoveDyingUnit(XGUnit kUnit, optional bool bNoUpdate){}
simulated function bool IsTrackingDyingUnit(XGUnit kUnit){}
simulated function AddPodReveal(XComAlienPod Pod){}
simulated function RemovePodRevealUnit(XComAlienPod Pod, XGUnit kUnit){};
simulated function RemovePodReveal(XComAlienPod Pod){}
simulated function bool IsDoingPodReveal(){}
simulated function SetReactionFireHappening(bool bReactionFire){};
simulated function Track(name nmState, optional float fRampUp=0.05){}
simulated function Update(){}
simulated function AddUnitVisibilityOverride(XGUnit kUnit){}
simulated function RemoveUnitVisibilityOverride(XGUnit kUnit){}
simulated function TacticalUpdate(){}
function UnstickCamera(){}

simulated state UpdateState{

    event BeginState(name PrevState){}
    simulated function bool ShouldControlVisibility(){}
}
simulated state TrackingCursor{
}
simulated state TrackingScroll{
}
simulated state TrackingMovingPlayerUnit{
    simulated function RemoveMovingUnit(XGUnit kUnit, optional bool bNoUpdate){}
    simulated function bool ShouldControlVisibility(){}
    simulated event Tick(float DeltaTime){}
}
simulated state TrackingSingleMovingNonPlayerUnit{
    event BeginState(name PreviousStateName){}
    simulated function RemoveMovingUnit(XGUnit kUnit, optional bool bNoUpdate){}
    simulated function bool ShouldControlVisibility(){}
    simulated event Tick(float DeltaTime){}
}

simulated state TrackingMultipleMovingNonPlayerUnit{

    simulated function RemoveMovingUnit(XGUnit kUnit, optional bool bNoUpdate){}
    simulated function Vector GetCombinedPosition(){}
    event Tick(float DeltaTime){}
    simulated function bool ShouldControlVisibility(){}
}
simulated state TrackingPodReveal{
    simulated function RemovePodRevealUnit(XComAlienPod Pod, XGUnit kUnit){}
    simulated function RemovePodReveal(XComAlienPod Pod){}
    simulated function bool ShouldControlVisibility(){}
    event Tick(float DeltaTime){}
    simulated function Vector GetCombinedPosition(){}
}
simulated state TrackingFiringUnit{

    simulated function RemoveFiringUnit(XGUnit kUnit, optional bool bNoUpdate){}
    simulated function bool ShouldControlVisibility(){}
    event Tick(float DeltaTime){}
}
simulated state TrackingDyingUnit{
    simulated function RemoveDyingUnit(XGUnit kUnit, optional bool bNoUpdate){}
    simulated function bool ShouldControlVisibility(){}
    event Tick(float DeltaTime){}
}
simulated state TrackingLookAts
{
    simulated function RemoveLookAt(Vector vLookAt, optional bool bNoUpdate=true){}
    simulated function ClearLookAts(optional bool bUpdateAfterClear){}
    simulated function bool ShouldControlVisibility(){}
}
simulated state TrackingKismetLookAts{

    simulated function RemoveKismetLookAt(Vector vLookAt, optional bool bNoUpdate){}
    simulated function ClearKismetLookAts(optional bool bUpdateAfterClear){}
    simulated function bool ShouldControlVisibility(){}
}
