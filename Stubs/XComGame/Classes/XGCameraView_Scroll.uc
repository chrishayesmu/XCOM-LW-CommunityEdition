class XGCameraView_Scroll extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

var Vector m_vOffset;
var XCom3DCursor m_kCursor;

simulated function SetLocationTarget(Vector vTarget){}
simulated function Scroll(Vector vScrollAmount){}
simulated function ResetScroll(){}
simulated function Vector GetLookAt(){}
simulated function SetCursor(XCom3DCursor kCursor){}
