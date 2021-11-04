class XComLevelVolume extends Volume
	native;
//complete stub

var notforconsole Material LevelBoundsMaterial;
var() const editconst export editinline StaticMeshComponent StaticMeshComponent;
var XComWorldData WorldData;
var XComDestructionInstData DestructionData;
var notforconsole StaticMesh TileMesh;
var notforconsole Material NeverSeenTileMaterial;
var notforconsole MaterialInstanceConstant NeverSeenMIC;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent InstancedMeshComponentNeverSeen;
var notforconsole Material HaveSeenTileMaterial;
var notforconsole MaterialInstanceConstant HaveSeenMIC;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent InstancedMeshComponentHaveSeen;
var notforconsole Material BlockingTileMaterial;
var notforconsole MaterialInstanceConstant BlockingMIC;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent InstancedMeshComponentBlocking;
var() notforconsole const editconst export editinline XComWorldDataRenderingComponent WorldDataRenderingComponent;
var() notforconsole const editconst export editinline XComCoverRenderingComponent CoverRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent LowCoverComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent HighCoverComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent PeekLeftComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent PeekRightComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent CoverTileRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent CoverNeighborRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent FloorRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent RampRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent WallRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent InteractRenderingComponent;
var() notforconsole const editconst export editinline InstancedStaticMeshComponent TileCacheVisuals;
var const export editinline XComMovementGridComponent GridComponent;
var const export editinline XComMovementGridComponent GridComponentDashing;
var const export editinline XComMovementGridComponent BorderComponent;
var const export editinline XComMovementGridComponent BorderComponentDashing;
var export editinline InstancedStaticMeshComponent FlameThrowerHitTiles;
var export editinline InstancedStaticMeshComponent FlameThrowerSplashTiles;
var bool bInitializedFlamethrowerResources;

simulated event PreBeginPlay(){}

event Destroyed(){}
native function UpdateFlameThrowerTiles();
native function ClearFlameThrowerTiles();
event InitializeFlamethrowerResources(){}
