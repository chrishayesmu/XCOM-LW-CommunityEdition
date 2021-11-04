class XComBuildingVolume extends Volume
    native(Level);
//complete stub

struct native ExternalMeshHidingGroup
{
    var() string GroupName;
    var() bool bEnabled;
    var() array<Actor> m_aActors;
};
struct native FloorActorInfo
{
    var Actor ResidentActor;
    var byte CutdownFloor;
};
struct native Floor
{
    var() init array<init XComFloorVolume> FloorVolumes;
    var() array<string> ExternalMeshGroupNames;
};

var() init array<init Floor> Floors;
//var() init editoronly array<init editoronly VisGroupActor> VisGroupsToHideWhenOccluding;
var init array<init int> VisGroupIdxToHideWhenOccluding;
var() array<ExternalMeshHidingGroup> ExternalMeshGroups;
var() bool IsUfo;
var() bool IsDropShip;
var() bool IsInside;
var() bool m_bAllowBuildingReveal;
var() bool m_bIsInternalBuilding;
var transient bool IsHot;
var bool bDebuggingThisBuilding;
var bool bOccludingCursor;
var bool bPrevOccludingCursor;
var protected transient int LastShownFloor;
var native transient float fCurrentCutdownHeight;
var native transient float fCurrentCutoutHeight;
var XGLevelNativeBase m_kLevel;

// Export UXComBuildingVolume::execCacheFloorCenterAndExtent(FFrame&, void* const)
native function CacheFloorCenterAndExtent();

// Export UXComBuildingVolume::execCacheBuildingVolumeInChildrenFloorVolumes(FFrame&, void* const)
native function CacheBuildingVolumeInChildrenFloorVolumes();

// Export UXComBuildingVolume::execRebuildCachedActors(FFrame&, void* const)
native function RebuildCachedActors();

// Export UXComBuildingVolume::execCacheStreamedInActors(FFrame&, void* const)
native function CacheStreamedInActors();

// Export UXComBuildingVolume::execChangeExternalMeshHidingGroups(FFrame&, void* const)
native simulated function ChangeExternalMeshHidingGroups(out Floor FloorToChange, bool bHide);

// Export UXComBuildingVolume::execGetCenterHeightAndExtent(FFrame&, void* const)
native simulated function bool GetCenterHeightAndExtent(int iFloorIndex, out float fCenter, out float fExtent);

// Export UXComBuildingVolume::execCutoutAllVisGroups(FFrame&, void* const)
native simulated function CutoutAllVisGroups(bool bCutout);

simulated function int GetCurrentlyRevealedFloorNum(){}

simulated function Vector2D GetBounds(){}
simulated event ShowFloor_ScriptDebug(int iFloor){}

native simulated function ShowFloor(int iFloor);

simulated event HideFloors_ScriptDebug(bool bUseFade){}

// Export UXComBuildingVolume::execHideFloors(FFrame&, void* const)
native simulated function HideFloors(bool bUseFade);

// Export UXComBuildingVolume::execRevealAllFloors(FFrame&, void* const)
native simulated function RevealAllFloors();

// Export UXComBuildingVolume::execHideAllFloorsThenRevealFirstFloor(FFrame&, void* const)
native simulated function HideAllFloorsThenRevealFirstFloor();
simulated function int GetLastShownFloor(){}
simulated function int GetLowestOccupiedFloor(){}
simulated function int GetHighestOccupiedFloor(){}
simulated function float GetLowestHeightForCurrentFloor(){}
