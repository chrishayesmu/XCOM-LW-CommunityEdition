class XComWeatherSpotLight extends XComWeatherLight
    native(Graphics)
    placeable
    hidecategories(Navigation);

var export editinline DrawLightConeComponent m_kDrawLightCone;
var export editinline DrawLightRadiusComponent m_kDrawLightRadius;
var() float m_fConeAngle;

defaultproperties
{
    begin object name=RainEmitter0 class=ParticleSystemComponent
        Template=ParticleSystem'FX_Weather.Particles.P_RainSpotlight'
        Translation=(X=-50.0,Y=0.0,Z=0.0)
    end object

    m_kRainEmitter=RainEmitter0
    m_kWeatherLightMI=Material'FX_Weather.Materials.M_RaindropsSpotLightNewer'
    Components(0)=none
    Components(1)=none
    Components(2)=none
    Components(3)=RainEmitter0
    Tag=SpotLightEmitter
}