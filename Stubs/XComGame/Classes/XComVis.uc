class XComVis extends Actor
    native;
//complete stub

var export editinline SceneCapture2DComponent m_kCapturePrimary;
var export editinline SceneCapture2DComponent m_kCaptureSecondary;
var XComCamera m_kCamera;
var Vector2D m_vTargetSize;
var Vector2D m_vBufferSize;
var TextureRenderTarget2D m_kRT;
var float m_fPrevFOV;
var int m_nDownsampleFactor;
var PostProcessChain m_kPPChain;
//var XComEdgeEffect m_kEdgeEffect;
var MaterialInstanceConstant m_kMIC;
var Texture m_kOldTexture;
var LinearColor m_3POutlineColor;
var LinearColor m_BuildingOutlineColor;

function InitResources(){}
function SetOutlineType(int OutlineType);
simulated event PreBeginPlay(){}
simulated function PostBeginPlay();
simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir){}
function bool FillResolutionStruct(){}
function bool DetectResolutionChange(){}
function Tick(float DeltaTime){}
simulated event OnCleanupWorld(){}
function RemoveReferences(){}
