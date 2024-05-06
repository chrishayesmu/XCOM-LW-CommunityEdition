class XComProjectileFX_Beam extends Object;

var Vector vBulletStart;
var Vector vBulletVelocity;
var ImpactInfo ProjectileTraceInfo;
var bool bInited;
var bool bFinished;
var bool bLockToMuzzleLocation;
var bool bLockToMuzzleRotation;
var const float kDefaultTraceLength;
var float kOverrideTraceLength;

defaultproperties
{
    bInited=true
    kDefaultTraceLength=32000.0
    kOverrideTraceLength=-1.0
}