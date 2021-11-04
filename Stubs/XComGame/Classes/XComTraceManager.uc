class XComTraceManager extends Actor
    native(Core)
    notplaceable;
//complete stub

enum EXComTraceType
{
    eXTrace_Screen,
    eXTrace_UnitVisibility,
    eXTrace_UnitVisibility_IgnoreTeam,
    eXTrace_UnitVisibility_IgnoreAllButTarget,
    eXTrace_CameraObstruction,
    eXTrace_World,
    eXTrace_AllActors,
    eXTrace_NoPawns,
    eXTrace_MAX
};

var EXComTraceType m_eCurrentType;
var ETeam m_eIgnoreTeam;
var Actor m_Target;

// Export UXComTraceManager::execXTrace(FFrame&, void* const)
native function Actor XTrace(EXComTraceType eType, out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional Vector Extent, optional out TraceHitInfo HitInfo, optional bool bDrawDebugLine, optional ETeam eIgnoreTeam, optional Actor Target);

// Export UXComTraceManager::execXTraceAndHideXComHideableFlaggedLevelActors(FFrame&, void* const)
native function XTraceAndHideXComHideableFlaggedLevelActors(out array<Actor> aActorsCurrentlyHidden, out int iNumLevelActorsCurrentlyHidden, Vector vTraceStart, Vector vTraceEnd, Vector vCursorExtents, int iMethod, bool bDrawDebugLines, bool bHideThisFrame);

// Export UXComTraceManager::execXTraceAndHideBuildingFloors(FFrame&, void* const)
native function XTraceAndHideBuildingFloors(out array<XComFloorVolume> aFloorVolumesPrevHidden, out int iNumFloorVolumesAffected, XGLevel kLevel, XComCutoutBox kCutoutBox, Vector vTraceStart, Vector vTraceEnd, bool bUnhideOnly);

// Export UXComTraceManager::execXTraceCameraToUnitObstruction(FFrame&, void* const)
native function Actor XTraceCameraToUnitObstruction(out Vector HitLocation, Vector vTraceStart, Vector vTraceEnd);

// Export UXComTraceManager::execIsVisibilityTrace(FFrame&, void* const)
native simulated function bool IsVisibilityTrace();