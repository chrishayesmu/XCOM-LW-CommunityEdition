class XComWeatherSpotLight extends XComWeatherLight
    native(Graphics)
    placeable
    hidecategories(Navigation);

var export editinline DrawLightConeComponent m_kDrawLightCone;
var export editinline DrawLightRadiusComponent m_kDrawLightRadius;
var() float m_fConeAngle;

defaultproperties
{
    // m_kWeatherLightMI=Material'FX_Weather.Materials.M_RaindropsSpotLightNewer'
    Tag=SpotLightEmitter

    begin object name=RainEmitter0 class=ParticleSystemComponent
        // Template=ParticleSystem'FX_Weather.Particles.P_RainSpotlight'
        Translation=(X=-50.0,Y=0.0,Z=0.0)
    end object

    m_kRainEmitter=RainEmitter0
    Components.Add(RainEmitter0)
}