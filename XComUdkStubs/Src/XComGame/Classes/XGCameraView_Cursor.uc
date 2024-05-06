class XGCameraView_Cursor extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);

var XCom3DCursor m_kCursor;
var Vector2D m_v2ScreenPos;
var Vector m_vScroll;
var float m_fLeadOffDistance;

defaultproperties
{
    m_fLeadOffDistance=64.0
    // m_kSpeedCurve=(Points=/* Array type was not detected. */)
}