class XComWeatherLight extends Actor
    abstract
    native(Graphics)
    notplaceable
    hidecategories(Navigation);

var() float m_fRadius;
var() float m_fFalloffExp;
var() Color m_kLightColor;
var() float m_fBrightness;
var export editinline MaterialInstanceConstant m_kLightEmitterMIC;
var export editinline ParticleSystemComponent m_kRainEmitter;
var export editinline SpriteComponent m_kEditorIcon;
var MaterialInterface m_kWeatherLightMI;
var float m_fSpawnRate;

defaultproperties
{
    // m_kLightEmitterMIC=MaterialInstanceConstant'FX_Weather.Materials.M_RaindropsPointLight_INST'
    // m_kWeatherLightMI=Material'FX_Weather.Materials.M_RaindropsPointLight'
    m_fSpawnRate=0.00010
    Tag=WeatherLightEmitter
}