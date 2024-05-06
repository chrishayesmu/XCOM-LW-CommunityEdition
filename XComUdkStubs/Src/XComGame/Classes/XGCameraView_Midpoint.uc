class XGCameraView_Midpoint extends XGCameraView
    native(Core)
    notplaceable
    hidecategories(Navigation);

const MidpointPadding = 240;
const MidpointDistAdj = 100;
const MidpointDistAttempts = 10;
const MidpointMaxDist = 3000;

var Vector m_vShotTarget;
var Actor m_kShooter;

defaultproperties
{
    m_bModal=false
    m_fDistance=1000.0
}