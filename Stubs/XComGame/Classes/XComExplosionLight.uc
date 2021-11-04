class XComExplosionLight extends PointLightComponent
    native(Graphics);
//complete stub

struct native LightValues
{
    var() float StartTime;
    var() float Radius;
    var() float Brightness;
    var() Color LightColor;
};

var bool bCheckFrameRate;
var bool bInitialized;
var float HighDetailFrameTime;
var float Lifetime;
var int TimeShiftIndex;
var() array<LightValues> TimeShift;
//var delegate<OnLightFinished> __OnLightFinished__Delegate;

delegate OnLightFinished(XComExplosionLight Light);
native final function ResetLight();
