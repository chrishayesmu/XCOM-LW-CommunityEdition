class XComVis extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var export editinline SceneCapture2DComponent m_kCapturePrimary;
var export editinline SceneCapture2DComponent m_kCaptureSecondary;
var XComCamera m_kCamera;
var Vector2D m_vTargetSize;
var Vector2D m_vBufferSize;
var TextureRenderTarget2D m_kRT;
var float m_fPrevFOV;
var int m_nDownsampleFactor;
var PostProcessChain m_kPPChain;
var XComEdgeEffect m_kEdgeEffect;
var MaterialInstanceConstant m_kMIC;
var Texture m_kOldTexture;
var LinearColor m_3POutlineColor;
var LinearColor m_BuildingOutlineColor;

defaultproperties
{
    begin object name=SceneCapture2DComponent0 class=SceneCapture2DComponent
        bForceNoClear=true
        ColorWriteMask=ECaptureWriteMask.eCaptureWriteMask_RED
    end object
    m_kCapturePrimary=SceneCapture2DComponent0

    begin object name=SceneCapture2DComponent1 class=SceneCapture2DComponent
        bForceNoResolve=true
        ClearColor=(R=255,G=255,B=255,A=255)
        ColorWriteMask=ECaptureWriteMask.eCaptureWriteMask_GREEN
    end object
    m_kCaptureSecondary=SceneCapture2DComponent1

    m_fPrevFOV=-1.0
    m_nDownsampleFactor=2
    m_3POutlineColor=(R=0.0,G=0.0,B=1.0,A=1.0)
    m_BuildingOutlineColor=(R=0.9290,G=0.9090,B=0.4040,A=1.0)

    Components(0)=SceneCapture2DComponent1
    Components(1)=SceneCapture2DComponent0

    TickGroup=TG_PostUpdateWork
}