class XComWeatherControl extends Actor
    native(Graphics);
//complete stub

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

// Export UXComWeatherControl::execSetAllAsWet(FFrame&, void* const)
native final function SetAllAsWet(bool bWet);

// Export UXComWeatherControl::execInitEmitters(FFrame&, void* const)
native final function InitEmitters();

// Export UXComWeatherControl::execSetEmitterMaterials(FFrame&, void* const)
native final function SetEmitterMaterials(Emitter ParentEmitter, MaterialInterface NewMaterialInterface);

// Export UXComWeatherControl::execSetRainScale(FFrame&, void* const)
native final function SetRainScale(float fScale);

// Export UXComWeatherControl::execUpdateWindDirection(FFrame&, void* const)
native final function UpdateWindDirection();

// Export UXComWeatherControl::execCalculateLightningIntensity(FFrame&, void* const)
native final function float CalculateLightningIntensity(float fNormalizedFlashTime);

simulated event SpawnDirectionalEmitter(Vector kLocation, float fOpacity){}
simulated function UpdateDirectionalEmitterMIC(float fOpacity){}
simulated event SpawnSplashEmitter(){}
simulated function UpdateSplashEmitterMIC(float fOpacity){}
simulated function TriggerFlash(){}
simulated function InitializeLightningFlash(array<LightningFlashPulse> kLightningFlash){}
simulated function OnTimeOfDayChange();

simulated function ToggleRain(){}
simulated function SetThunderClapProbability(float fThunderClapProbability){}
simulated function TriggerThunderClapSound(){}
simulated function TriggerThunderAndLightning(){}
simulated function SetTimerForNextThunder(){}
simulated function SetStormIntensity(WorldInfo.StormIntensity_t NewStormIntensity, int RainSoundIntensity, float ThunderClapProbability, float RainScale){}
simulated function LightningRenderUpdate(float fDt){}
simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir){}
simulated function SetupRenderTextures(){}
simulated function InitDepthCapture(){}
simulated function PostBeginPlay(){}
simulated function Init(){}
simulated function SetWet(bool bWet){}
simulated function UpdateDynamicRainDepth(Vector CameraPosition){}
simulated event UpdateWeatherDecals(){}
simulated event Tick(float dt){}
simulated function StartFadingInParticles(){}
simulated function StartFadingOutParticles(){}
simulated function FadeParticles(){}
