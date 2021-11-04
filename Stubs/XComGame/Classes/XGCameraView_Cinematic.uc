class XGCameraView_Cinematic extends XGCameraView
    native(Core);
//complete stub

var Vector m_vStartDirection;
var Vector m_vEndDirection;
var float m_fStartDist;
var float m_fEndDist;
var float m_fAnimDuration;
var float m_fAccumTime;

simulated function SetAnimation(Vector vStart, Vector vEnd, float fDuration){}
simulated function GetCameraPOV(float fDeltaT, out TPOV out_POV, float fUserYaw){}
simulated function Vector GetLookFromActor(Actor kLookAtActor, float fYaw, float fPitch){}
