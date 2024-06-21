class XComWeatherPointLight extends XComWeatherLight
    native(Graphics)
    placeable
    hidecategories(Navigation);

var export editinline DrawLightRadiusComponent m_kDrawLightRadius;

defaultproperties
{
    Tag=PointLightEmitter

    begin object name=RainEmitter0 class=ParticleSystemComponent
        // Template=ParticleSystem'FX_Weather.Particles.P_RainPointLight'
    end object

    m_kRainEmitter=RainEmitter0
    Components.Add(RainEmitter0)
}