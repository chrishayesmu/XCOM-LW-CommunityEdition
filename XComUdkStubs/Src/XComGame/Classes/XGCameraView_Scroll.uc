class XGCameraView_Scroll extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);

var Vector m_vOffset;
var XCom3DCursor m_kCursor;

defaultproperties
{
    m_bModal=false
}