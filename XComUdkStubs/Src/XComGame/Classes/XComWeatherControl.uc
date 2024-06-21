class XComWeatherControl extends Actor
    native(Graphics)
    placeable
    hidecategories(Navigation);

struct native LightningFlashPulse
{
    var float fFrequency;
    var float fIntensity;
};

struct native LightEmitterInstance
{
    var Emitter LightEmitter;
    var MaterialInstanceConstant LightEmitterMaterialConstant;
    var float fSpawnRate;
    var float fMaxLifetime;
};

var bool m_bRainy;
var bool m_bWet;
var bool m_bFade;
var bool m_bFadeOut;
var bool m_bInitialized;
var bool m_bNeedsMPInit;
var() float m_fIntensity;
var() float m_fOpacityModifier;
var float m_fBuildingWeatherFade;
var() float m_fBuildingWeatherFadeRate;
var float m_fEmitterDistance;
var float m_fFadeDistance;
var float m_fGlobalSpawnRate;
var float m_fDT;
var() Actor BoundingActor;
var export editinline SceneCapture2DComponent m_kStaticDepthCapture;
var export editinline SceneCapture2DComponent m_kDynamicDepthCapture;
var TextureRenderTarget2D m_kStaticDepthTexture;
var TextureRenderTarget2D m_kDynamicDepthTexture;
var int m_nDynamicCaptureFrustumX;
var int m_nDynamicCaptureFrustumY;
var Rotator m_kCaptureRotator;
var Vector m_kBVDimensions;
var Vector m_kBVCenter;
var float m_fFlashTime;
var Color m_kOriginalColor;
var float m_fOriginalBrightness;
var const float m_fLightningFlashLength;
var float CurrentThunderClapProbability;
var array<LightningFlashPulse> m_kLightningFlash;
var Vector m_kWindVelocity;
var() ParticleSystem m_kDLightTemplate;
var ParticleSystem m_kPLightTemplate;
var ParticleSystem m_kSLightTemplate;
var() ParticleSystem m_kSplashTemplate;
var MaterialInterface m_kPointLightMI;
var MaterialInterface m_kSpotLightMI;
var() MaterialInterface m_kDirectionalLightMI;
var() MaterialInterface m_kSplashMI;
var() MaterialInstanceConstant m_kPuddleMIC;
var LightEmitterInstance m_kSplashEmitter;
var LightEmitterInstance m_kGlobalRainEmitter;
var() SoundCue m_sThunderClap;
var() SoundCue m_sThunderRumble;

defaultproperties
{
    m_bFadeOut=true
    m_fOpacityModifier=6.0
    m_fBuildingWeatherFade=1.0
    m_fBuildingWeatherFadeRate=1.0
    m_fEmitterDistance=3500.0
    m_fFadeDistance=1500.0
    RemoteRole=ROLE_Authority
    m_bNoDeleteOnClientInitializeActors=true
    m_nDynamicCaptureFrustumX=1000
    m_nDynamicCaptureFrustumY=1000
    m_fLightningFlashLength=0.40
    m_kWindVelocity=(X=300.0,Y=0.0,Z=0.0)
    // m_kDLightTemplate=ParticleSystem'FX_Weather.Particles.RainDirectional'
    // m_kSplashTemplate=ParticleSystem'FX_Weather.Particles.P_Splashes'
    // m_kDirectionalLightMI=Material'FX_Weather.Materials.RaindropsDirectional'
    // m_kSplashMI=Material'FX_Weather.Materials.MPar_Splashes'
    // m_kPuddleMIC=MaterialInstanceConstant'FX_Weather.Materials.M_PuddleDecalINST'

    begin object name=SceneCapture2DComponent0 class=SceneCapture2DComponent
        NearPlane=10000.0
        FarPlane=1.0
        bUpdateMatrices=false
    end object

    m_kStaticDepthCapture=SceneCapture2DComponent0

    begin object name=SceneCapture2DComponent1 class=SceneCapture2DComponent
        NearPlane=10000.0
        FarPlane=1.0
        bUpdateMatrices=false
    end object

    m_kDynamicDepthCapture=SceneCapture2DComponent1
}