class XGCameraView_AimingThirdPerson extends XGCameraView
    native(Core)
    dependson(XGUnitNativeBase)
    notplaceable
    hidecategories(Navigation);

var Vector m_vShotTarget;
var Actor m_kShooter;
var XGUnit m_kTargetUnit;
var Vector m_vScroll;
var float m_fY;
var float m_fP;
var float m_fHeightDistance;
var float m_fSideDistance;
var Vector m_vCorrectedLocation;
var float m_fObstructionModifier;
var Vector m_vLoc;
var Vector m_vDir;
var float m_fComputedFOV;
var float m_fComputedAddYaw;
var float m_fComputedAddPitch;
var float m_fComputedAddRoll;
var bool bFirstRun;
var bool bWasEvaluatingStance;
var bool bDebuggingCamera;
var int iCameraIdx;
var int iBestCameraIdx;
var float fBestCameraFactor;
var int iNumCameras;
var float fCurrentObstructionDistance;
var Vector m_vCurrentLocation;
var Vector m_vCurrentDirection;
var ECoverState eLastCover;
var ECoverState eTargetLastCover;
var int iDebugForceCamera;

defaultproperties
{
    bFirstRun=true
    iBestCameraIdx=-1
    fBestCameraFactor=10000000.0
    iNumCameras=10
    fCurrentObstructionDistance=9999999.0
    iDebugForceCamera=-1
    m_bCanStack=false
    m_bKeepTargetInView=false
    m_bModal=false
    m_fDOFMaxFarBlurAmount=1.0
    m_fDOFFocusInnerRadius=700.0
    m_fFOV=60.0
    m_fDistance=1000.0
    // m_kSpeedCurve=(Points=/* Array type was not detected. */)
}