class XCom3DCursor extends XComPawn
    native(Unit)
    config(Game)
    hidecategories(Navigation);

const MIN_DRAWCYLINDER_HEIGHT_THRESHOLD = 64.0f;
const CURSOR_OUTDOOR_FLOOR_HEIGHT = 192.0f;
const CURSOR_OUTDOOR_FLOOR_HALFHEIGHT = 96.0f;

enum CursorType
{
    eCursorType_Default,
    eCursorType_Invalid,
    eCursorType_OutOfRange,
    eCursorType_MAX
};

enum CursorMode
{
    eCursorMode_Collision,
    eCursorMode_NoCollision,
    eCursorMode_ScreenPick,
    eCursorMode_MAX
};

enum CursorSearchDirection
{
    eCursorSearch_Down,
    eCursorSearch_Up,
    eCursorSearch_ExactFloor,
    eCursorSearch_MAX
};

enum CursorTraceResult
{
    eCursorTraceResult_NoHit,
    eCursorTraceResult_Embedded,
    eCursorTraceResult_EmbeddedInStepup,
    eCursorTraceResult_Valid,
    eCursorTraceResult_MAX
};

struct native CursorSearchResult
{
    var Vector m_kLocation;
    var int m_iEffectiveFloor;
    var float m_fFloorBottom;
    var float m_fFloorTop;
    var bool m_bOnGround;
};

var bool m_bMoving;
var bool m_bPathingNeedsUpdate;
var bool m_bLastCursorInBuildingStatus;
var bool m_bIgnoreCursorSnapToFloor;
var bool m_bCursorLaunchedInAir;
var bool m_bInDropShip;
var bool m_bHoverFailDetectedToggle;
var bool m_bOccluded;
var bool m_bHiddenOverride;
var export editinline StaticMeshComponent CMesh;
var StaticMesh m_CursorDefault;
var StaticMesh m_CursorInvalid;
var StaticMesh m_CursorOutOfRange;
var export editinline InstancedStaticMeshComponent m_LevelBorderWall;
var export editinline StaticMeshComponent m_kHeightCylinder;
var() const editconst export editinline DecalComponent Decal;
var transient Actor LockedActor;
var transient XComUnitPawnNativeBase ChainedPawn;
var XGCameraView m_kView;
var int m_iRequestedFloor;
var float m_fLogicalCameraFloorHeight;
var float m_fBuildingCutdownHeight;
var protectedwrite int m_iMaxFloor;
var transient CursorType m_eType;
var int m_iLastEffectiveFloorIndex;
var Actor m_kTouchingActor;
var array<XComBuildingVolume> m_arrBuildingVolumes;
var float m_fMaxChainedDistance;
var float m_fMinChainedDistance;
var Vector PreviousChainedCursorPosition;
var float ChainedCursorUpdateTimer;
var float m_fCursorOcclusion;
var float m_fCutoutFadeFactor;
var Vector2D m_vCutoutExtent;
var float m_fCursorExtentFactor;

defaultproperties
{
    m_bPathingNeedsUpdate=true
    m_iMaxFloor=3
    MaxStepHeight=26.0
    WalkableFloorZ=0.10
    GroundSpeed=1200.0
    AirSpeed=8192.0
    AccelRate=0.0
    Health=10000000
    HealthMax=10000000
    DrawScale=0.6250
    m_bReplicateHidden=false
    m_bPerformPhysicsForRoleAutonomous=true
    bOnlyRelevantToOwner=true
    bUpdateSimulatedPosition=false
    bBlockActors=false
    bProjTarget=false

    begin object name=CollisionCylinder
        CollisionHeight=64.0
        CollisionRadius=32.0
        RBChannel=RBCC_Nothing
        BlockActors=false
        RBCollideWithChannels=(Pawn=true,BlockingVolume=true)
    end object

    begin object name=TestMeshComponent class=StaticMeshComponent
        StaticMesh=StaticMesh'UnitCursor.Meshes.ASE_UnitCursor'
        bTranslucentIgnoreFOW=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        TranslucencySortPriority=1000
    end object

    CMesh=TestMeshComponent
    Components.Add(TestMeshComponent)

    begin object name=LevelBorderWall class=InstancedStaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.FloorTile'
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    m_LevelBorderWall=LevelBorderWall
    Components.Add(LevelBorderWall)

    begin object name=HeightDifferenceCylinder class=StaticMeshComponent
        HiddenGame=true
        HiddenEditor=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    m_kHeightCylinder=HeightDifferenceCylinder
    Components.Add(HeightDifferenceCylinder)
}