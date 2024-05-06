class XComOpacityFadeLevelActor extends XComLevelActor
    hidecategories(Navigation);

var() float m_fFadeStartDistance;
var() float m_fFadeStopDistance;
var() float m_fMinOpacity;
var() float m_fMaxOpacity;
var MaterialInstanceConstant m_kMIC;

defaultproperties
{
    m_fFadeStartDistance=2000.0
    m_fFadeStopDistance=8000.0
    m_fMinOpacity=0.010
    m_fMaxOpacity=0.150
}