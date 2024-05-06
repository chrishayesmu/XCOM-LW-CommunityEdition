class XComLevelVolume extends Volume
    native
    hidecategories(Navigation,Movement,Display);

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

defaultproperties
{
    bHidden=false
    bPathColliding=true

	NeverSeenTileMaterial = Material'EngineDebugMaterials.LevelColorationLitMaterial'
	HaveSeenTileMaterial = Material'EngineDebugMaterials.LevelColorationLitMaterial'
	BlockingTileMaterial = Material'EngineDebugMaterials.LevelColorationLitMaterial'

    begin object name=BrushComponent0
		CanBlockCamera=false
    end object

    begin object name=XComWorldData class=XComWorldData
        FireParticleSystemCenter_Name=""
        FireParticleSystemFill_Name=""
        SmokeParticleSystemCenter_Name=""
        SmokeParticleSystemFill_Name=""
        CombatDrugsParticleSystemCenter_Name=""
        CombatDrugsParticleSystemFill_Name=""
        PoisonParticleSystemCenter_Name=""
        PoisonParticleSystemFill_Name=""
    end object

    WorldData=XComWorldData

    begin object name=StaticMeshComponent0 class=StaticMeshComponent
        CastShadow=false
        bAcceptsLights=false
        bUsePrecomputedShadows=true
        CollideActors=false
        CanBlockCamera=false
        BlockRigidBody=false
    end object

    StaticMeshComponent=StaticMeshComponent0
    Components.Add(StaticMeshComponent0)

    begin object name=MovementGrid class=XComMovementGridComponent
    end object

    GridComponent=MovementGrid
    Components.Add(MovementGrid)

    begin object name=MovementGridDashing class=XComMovementGridComponent
    end object

    GridComponentDashing=MovementGridDashing
    Components.Add(MovementGridDashing)

    begin object name=MovementBorder class=XComMovementGridComponent
    end object

    BorderComponent=MovementBorder
    Components.Add(MovementBorder)

    begin object name=MovementBorderDashing class=XComMovementGridComponent
    end object

    BorderComponentDashing=MovementBorderDashing
    Components.Add(MovementBorderDashing)

    begin object name=FlameThrowerHit class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Range.Meshes.FlameThrowerHit'
        bIgnoreOwnerHidden=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        AbsoluteTranslation=true
        AbsoluteRotation=true
    end object

    FlameThrowerHitTiles=FlameThrowerHit
    Components.Add(FlameThrowerHit)

    begin object name=FlameThrowerSplash class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Range.Meshes.FlameThrowerSplash'
        bIgnoreOwnerHidden=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        AbsoluteTranslation=true
        AbsoluteRotation=true
    end object

    FlameThrowerSplashTiles=FlameThrowerSplash
    Components.Add(FlameThrowerSplash)

	begin object class=XComCoverRenderingComponent name=CoverRenderingComponent0
		HiddenEditor=true
	end object
	Components.Add(CoverRenderingComponent0)
	CoverRenderingComponent=CoverRenderingComponent0

	begin object class=XComWorldDataRenderingComponent name=WorldDataRenderingComponent0
		HiddenEditor=false
	end object
	Components.Add(WorldDataRenderingComponent0)
	WorldDataRenderingComponent=WorldDataRenderingComponent0

    begin object name=InstancedMeshComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    InstancedMeshComponentNeverSeen=InstancedMeshComponent0
    Components.Add(InstancedMeshComponent0)

    begin object name=InstancedMeshComponent1 class=InstancedStaticMeshComponent
        StaticMesh=none
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    InstancedMeshComponentHaveSeen=InstancedMeshComponent1
    Components.Add(InstancedMeshComponent1)

    begin object name=InstancedMeshComponent2 class=InstancedStaticMeshComponent
        StaticMesh=none
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    InstancedMeshComponentBlocking=InstancedMeshComponent2
    Components.Add(InstancedMeshComponent2)

    begin object name=LowCoverComponent0 class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.Editor_CoverLow'
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    LowCoverComponent=LowCoverComponent0
    Components.Add(LowCoverComponent0)

    begin object name=HighCoverComponent0 class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.Editor_CoverHigh'
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    HighCoverComponent=HighCoverComponent0
    Components.Add(HighCoverComponent0)

    begin object name=PeekLeftCoverComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    PeekLeftComponent=PeekLeftCoverComponent0
    Components.Add(PeekLeftCoverComponent0)

    begin object name=PeekRightCoverComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    PeekRightComponent=PeekRightCoverComponent0
    Components.Add(PeekRightCoverComponent0)

    begin object name=CoverTileRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.CoverTile'
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

	CoverTileRenderingComponent=CoverTileRenderingComponent0
    Components.Add(CoverTileRenderingComponent0)

    begin object name=NeighborTileRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    CoverNeighborRenderingComponent=NeighborTileRenderingComponent0
    Components.Add(NeighborTileRenderingComponent0)

    begin object name=FloorRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.FloorTile'
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    FloorRenderingComponent=FloorRenderingComponent0
    Components.Add(FloorRenderingComponent0)

    begin object name=RampRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    RampRenderingComponent=RampRenderingComponent0
    Components.Add(RampRenderingComponent0)

    begin object name=WallRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    WallRenderingComponent=WallRenderingComponent0
    Components.Add(WallRenderingComponent0)

    begin object name=InteractRenderingComponent0 class=InstancedStaticMeshComponent
        StaticMesh=none
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    InteractRenderingComponent=InteractRenderingComponent0
    Components.Add(InteractRenderingComponent0)

    begin object name=TileCacheVisuals0 class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Meshes.ASE_gridPointMesh'
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    TileCacheVisuals=TileCacheVisuals0
    Components.Add(TileCacheVisuals0)
}