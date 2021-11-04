class XCom3DCursor extends XComPawn
    native(Unit)
    config(Game);
//complete  stub

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
var int m_iMaxFloor;
var transient XCom3DCursor.CursorType m_eType;
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

// Export UXCom3DCursor::execSetCursorMesh(FFrame&, void* const)
native function SetCursorMesh(XCom3DCursor.CursorType eType);

// Export UXCom3DCursor::execIsCursorOccluded(FFrame&, void* const)
native function bool IsCursorOccluded();

// Export UXCom3DCursor::execCameraLineCheck(FFrame&, void* const)
native function bool CameraLineCheck(Vector PositionToTest, out Vector OutFurthestOccluder);

// Export UXCom3DCursor::execUpdateCursorVisibility(FFrame&, void* const)
native function UpdateCursorVisibility();

// Export UXCom3DCursor::execGetCursorMode(FFrame&, void* const)
native simulated function int GetCursorMode();

// Export UXCom3DCursor::execDisplayHeightDifferences(FFrame&, void* const)
private native final simulated function DisplayHeightDifferences();

// Export UXCom3DCursor::execProcessChainedDistance(FFrame&, void* const)
private native final simulated function Vector ProcessChainedDistance(Vector vLocation);

// Export UXCom3DCursor::execWorldZToCursorFloor(FFrame&, void* const)
native function int WorldZToCursorFloor(Vector kLocation);

// Export UXCom3DCursor::execWorldZFromCursorFloor(FFrame&, void* const)
native function float WorldZFromCursorFloor(Vector2D kXYLocation, int iFloor);

// Export UXCom3DCursor::execGetLevelMinZExtent(FFrame&, void* const)
protected native function float GetLevelMinZExtent();

// Export UXCom3DCursor::execGetLevelMaxZExtent(FFrame&, void* const)
protected native function float GetLevelMaxZExtent();

// Export UXCom3DCursor::execShouldSearchExactFloors(FFrame&, void* const)
native function bool ShouldSearchExactFloors();

native function bool DoesVolumeContainPoint(Volume kVolume, Vector2D kLocation, optional float fExtent);
native function XCom3DCursor.CursorTraceResult PerformTrace(out Vector kHitResult, Vector kGroundLocationAtTopOfVolume, float fVolumeZBottom, float fExtentRadius);

// Export UXCom3DCursor::execGetFloorVolumesAtPoint(FFrame&, void* const)
private native final function array<XComFloorVolume> GetFloorVolumesAtPoint(Vector2D kLocation, float fExtent);

// Export UXCom3DCursor::execCursorSnapWithFloorVolumes(FFrame&, void* const)
private native final function CursorSearchResult CursorSnapWithFloorVolumes(array<XComFloorVolume> kFloorVolumes, Vector2D kLocation, float fExtent, int iDesiredFloor, XCom3DCursor.CursorSearchDirection eDirection);

// Export UXCom3DCursor::execCursorSnapOutside(FFrame&, void* const)
private native final function CursorSearchResult CursorSnapOutside(Vector2D kLocation, float fExtent, int iDesiredFloor, XCom3DCursor.CursorSearchDirection eType);

simulated event PostBeginPlay(){}
reliable server function ServerGotoState(name nmState){}
function Vector GetCursorFeetLocation(){}
function bool IsCursorWithinPathLengthDistance()
{
    return true;
}

simulated function SetForceHidden(bool bHiddenOverride)
{}
simulated event FellOutOfWorld(class<DamageType> dmgType)
{}
simulated function XGCameraView GetCurrentView()
{
    return m_kView;
}

reliable server function ServerSetChainedPawn(XComUnitPawn kChainedPawn)
{
    ChainedPawn = kChainedPawn;
}

simulated function MoveToUnit(XComUnitPawn Unit, optional bool bSetCamView=true, optional bool bResetChainedDistance=true){}
simulated function Vector getValidLocation(Vector NewLoc){}
simulated function CursorSetLocation(Vector NewLoc, optional bool bResetSpeedCurveRampUp=true){}
exec function TestMove(){}
simulated event SetVisible(bool bVisible){}

function MoveToLocation(Vector pos, bool bSetCamView){}
function AscendFloor();

reliable server function ServerAscendFloor()
{
    AscendFloor();
}

function DescendFloor();

reliable server function ServerDescendFloor()
{
    DescendFloor();
}
event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal){}
event UnTouch(Actor Other){}
simulated function CursorSearchResult CursorSnapToFloor(int iDesiredFloor, optional XCom3DCursor.CursorSearchDirection eSearchType){}
function bool DisableFloorChanges(){}
simulated function LogDebugInfo(){}
state LockedToActor
{
event BeginState(name P){}
event Tick(float DeltaTime){}
 event EndState(name N){}

}
state CursorMode_Collision
{
event BeginState(name P){}
event Tick(float DeltaTime){}
function AbortState_ChainedToUnit(){}

}
state CursorMode_NoCollision{}


