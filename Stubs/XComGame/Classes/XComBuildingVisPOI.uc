class XComBuildingVisPOI extends StaticMeshActor
    native
    hidecategories(Navigation)
    implements(IXComBuildingVisInterface)
	dependson(XComTacticalGRI);
//complete stub

//var private native const noexport Pointer VfTable_IIXComBuildingVisInterface;
var export editinline CylinderComponent CylinderComponent;
var XComPawnIndoorOutdoorInfo IndoorInfo;
var XComPawnIndoorOutdoorInfo LevelTraceIndoorInfo;
var int m_iNumLevelTraceCurrentFloorVolumes;

// Export UXComBuildingVisPOI::execTickNative(FFrame&, void* const)
native simulated function TickNative(float fDeltaTime);

simulated event PreBeginPlay(){}
simulated function DebugVis(Canvas kCanvas, XComCheatManager kCheatManager){}
simulated event Tick(float fDeltaTime){}
function NotifyTacticalGameOfEvent(EXComTacticalEvent EEvent){}
event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal){}
event UnTouch(Actor Other){}
function Actor GetActor(){}
function OnChangedIndoorStatus(){}
function OnChangedFloor(){}
function XComPawnIndoorOutdoorInfo GetIndoorOutdoorInfo(){}
event XComBuildingVolume GetCurrentBuildingVolumeIfInside(){}
event bool IsInside(){}
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir){}
