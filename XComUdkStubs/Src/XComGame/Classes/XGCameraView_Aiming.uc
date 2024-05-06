class XGCameraView_Aiming extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);

var XCom3DCursor m_kCursor;
var Vector m_vShotTarget;
var Actor m_kShooter;
var Vector m_vScroll;
var bool m_bFreeAiming;

defaultproperties
{
    m_bModal=false
    m_fDistance=1000.0
}