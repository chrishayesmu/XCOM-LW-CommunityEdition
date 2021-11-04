class XGCameraView_Midpoint extends XGCameraView
    native(Core);

//complete stub

var Vector m_vShotTarget;
var Actor m_kShooter;

simulated function SetShooter(Actor kShooter){}
simulated function SetTarget(Vector vTarget){}
simulated function Vector GetLookAt(){}
simulated function Vector CalcLocation(Rotator rRotation){}
simulated function bool OnScreen(Vector vTarget, TPOV kPOV){}
