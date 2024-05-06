class XComVolumeDuckingMgr extends Object;

var private WatchVariableMgr WatchVarMgr;
var private int CommLinkWatchVar;
var private bool m_bVolumeDucked;
var private float m_fVolumeDuckBlendTimeFadeIn;
var private float m_fVolumeDuckBlendTimeFadeOut;
var private float m_fVolumeDuckBlendTimeToGo;
var private float m_fCurrentVolumeSoundFX;
var private float m_fCurrentVolumeMusic;
var private float m_fVolumeDuckPercent;

defaultproperties
{
    m_fVolumeDuckBlendTimeFadeIn=3.0
    m_fVolumeDuckBlendTimeFadeOut=0.20
    m_fVolumeDuckPercent=0.650
}