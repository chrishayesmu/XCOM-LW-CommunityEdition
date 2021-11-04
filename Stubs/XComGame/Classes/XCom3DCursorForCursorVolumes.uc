class XCom3DCursorForCursorVolumes extends XCom3DCursor
    native(Unit)
    config(Game)
    hidecategories(Navigation);
//complete stub

var XComLevelVolume m_kLevelVolume;
var array<XComCursorVolume> m_arrCachedCursorVolumes;
var Vector m_kLastCursorLocation;
var XComCursorVolume m_kLastStairVolume;

// Export UXCom3DCursorForCursorVolumes::execWorldZToCursorFloor(FFrame&, void* const)
native function int WorldZToCursorFloor(Vector kLocation);

// Export UXCom3DCursorForCursorVolumes::execWorldZFromCursorFloor(FFrame&, void* const)
native function float WorldZFromCursorFloor(Vector2D kXYLocation, int iFloor);

// Export UXCom3DCursorForCursorVolumes::execGetCursorVolume(FFrame&, void* const)
native function XComCursorVolume GetCursorVolume(Vector2D kXYLocation, int iFloor);

// Export UXCom3DCursorForCursorVolumes::execGetCursorVolumesAtLocation(FFrame&, void* const)
native simulated function GetCursorVolumesAtLocation(Vector2D kLocation, out array<XComCursorVolume> arrVolumes, optional float fExtent=0.0);

// Export UXCom3DCursorForCursorVolumes::execTraceCursorVolume(FFrame&, void* const)
native simulated function CursorTraceResult TraceCursorVolume(XComCursorVolume kCursorVolume, Vector kLocation, float fCollisionRadius, out Vector kHitGroundLocation, out float fBottomOfSearchVolumeZ);

// Export UXCom3DCursorForCursorVolumes::execCursorSnapToFloorInternal(FFrame&, void* const)
native simulated function CursorSearchResult CursorSnapToFloorInternal(int iDesiredFloor, CursorSearchDirection eSearchType, out XComCursorVolume kVolume);

// Export UXCom3DCursorForCursorVolumes::execCollidesWithTopOfStairVolume(FFrame&, void* const)
native final simulated function bool CollidesWithTopOfStairVolume(XComCursorVolume kCursorVolume, Vector kStartLocation, Vector kEndLocation);

simulated event PostBeginPlay(){}


simulated function CursorSetLocation(Vector NewLoc, optional bool bResetSpeedCurveRampUp=true){}
simulated function CursorSearchResult CursorSnapToFloor(int iDesiredFloor, optional CursorSearchDirection eSearchType){}

state CursorMode_NoCollision
{
    function Reset(){}
    protected function int GetIdealPawnFloor(XComUnitPawnNativeBase kPawn){}
    function DescendFloor(){}
}