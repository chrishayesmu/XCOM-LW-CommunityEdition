class XGCameraView_Cinematic extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);

var Vector m_vStartDirection;
var Vector m_vEndDirection;
var float m_fStartDist;
var float m_fEndDist;
var float m_fAnimDuration;
var float m_fAccumTime;

defaultproperties
{
    m_vStartDirection=(X=-0.590,Y=0.520,Z=-0.620)
    m_vEndDirection=(X=-0.590,Y=0.520,Z=-0.620)
    m_bCanStack=false
    m_fFOV=75.0
    m_fMouseFOV=75.0
}