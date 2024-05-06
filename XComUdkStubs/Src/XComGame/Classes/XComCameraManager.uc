class XComCameraManager extends Actor
    notplaceable
    hidecategories(Navigation);

struct LookAtWithZoom
{
    var Vector m_vPosition;
    var float m_fZoom;
    var bool m_bSetPOI;

    structdefaultproperties
    {
        m_fZoom=-1.0
        m_bSetPOI=true
    }
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
var private array<XComAlienPod> m_aPodReveals;
var private array<PodRevealUnits> m_aPodUnits;
var private array<XGUnit> m_aPlayerMovingUnits;
var private array<XGUnit> m_aNonPlayerMovingUnits;
var private array<XGUnit> m_aFiringUnits;
var private array<XGUnit> m_aDyingUnits;
var private array<LookAtWithZoom> m_aLookAts;
var private array<LookAtWithZoom> m_aKismetLookAts;
var private array<XGUnit> m_aOverrideVisibilityLookat;
var private bool m_bWaitForCamera;
var private bool bScroll;
var private bool bCursor;
var private bool m_bCustomTolerance;
var private transient bool bPathVisible;
var private transient bool bLastVisible;
var private InterpCurveFloat m_kSpeedCurve_TrackMultipleUnits;
var private InterpCurveFloat m_kSpeedCurve_Slow;
var private float m_fCustomTolerance;
var private transient Vector vLastHiddenLoc;
var private transient Vector vLastVisibleLoc;
var private transient float OriginalZoom;

defaultproperties
{
    // m_kSpeedCurve_TrackMultipleUnits=(Points=/* Array type was not detected. */)
    // m_kSpeedCurve_Slow=(Points=/* Array type was not detected. */)
}