class XComExplosionLight extends PointLightComponent
    native(Graphics)
    editinlinenew
    hidecategories(Object);

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

delegate OnLightFinished(XComExplosionLight Light)
{
}

defaultproperties
{
    bCheckFrameRate=true
    HighDetailFrameTime=0.0150
    Radius=256.0
    Brightness=8.0
    LightColor=(R=255,G=255,B=255,A=255)
    CastShadows=false
    LightingChannels=(BSP=false,Static=false,Dynamic=false)
}