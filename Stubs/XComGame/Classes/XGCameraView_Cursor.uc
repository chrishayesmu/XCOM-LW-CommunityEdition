class XGCameraView_Cursor extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

var XCom3DCursor m_kCursor;
var Vector2D m_v2ScreenPos;
var Vector m_vScroll;
var float m_fLeadOffDistance;

simulated function SetActorTarget(Actor kTarget){}
simulated function Vector GetLookAt(){}
simulated function Vector2D CalcScreenLoc(Vector vWorldLoc){}
