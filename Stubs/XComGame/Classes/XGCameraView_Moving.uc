class XGCameraView_Moving extends XGCameraView
    notplaceable
    hidecategories(Navigation);
//complete stub

var Vector m_vShotTarget;
var Actor m_kShooter;
var Vector m_vScroll;
var float m_fY;
var float m_fP;

simulated function SetShooter(Actor kShooter){}
simulated function SetTarget(Vector vTarget){}
simulated function SetIndoorAngle(bool bIndoor){}
simulated function ScrollView(Vector vScroll){}
simulated function Vector GetLookAt(){}
simulated function Vector CalcLocation(Rotator rRotation){}
simulated function float GetSpeedFromCurve(float fDistanceFromDestination){}
