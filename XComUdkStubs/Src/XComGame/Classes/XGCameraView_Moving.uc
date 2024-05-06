class XGCameraView_Moving extends XGCameraView
    notplaceable
    hidecategories(Navigation);

var Vector m_vShotTarget;
var Actor m_kShooter;
var Vector m_vScroll;
var float m_fY;
var float m_fP;

defaultproperties
{
    m_bCanStack=false
    m_bModal=false
    m_fFOV=60.0
    m_fDistance=1000.0
    // m_kSpeedCurve=(Points=/* Array type was not detected. */)
}