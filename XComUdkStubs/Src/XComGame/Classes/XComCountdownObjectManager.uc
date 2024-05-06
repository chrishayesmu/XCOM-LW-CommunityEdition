class XComCountdownObjectManager extends Actor
    notplaceable
    hidecategories(Navigation);

var Actor m_kTargetObject;
var XGCameraView m_kSavedView;
var XGCameraView m_kGrenadeView;
var float m_fPreExplodeWait;
var float m_fPostExplodeWait;

defaultproperties
{
    m_fPreExplodeWait=1.0
    m_fPostExplodeWait=2.0
}