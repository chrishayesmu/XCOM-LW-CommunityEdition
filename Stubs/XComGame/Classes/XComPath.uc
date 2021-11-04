class XComPath extends Object
	native(Unit)
dependson(XComPathData);
//complete stub

var array<PathPoint> Path;
var transient array<PathPoint> BuildPath;
var float Radius;
var float Height;
var transient float TraversalLength;
var transient int Cost;
var transient int PointOnPath_LastIndex;
var transient float PointOnPath_LastDistance;
var transient Vector RawDestination;
var transient Vector AdjustedDestination;
var transient bool bDrawOriginalPath;
var transient bool bDrawObstacleChecks;
var transient bool bDrawStringPulling;
var transient bool bDrawFinalPath;
var transient bool bJetpackPath;
var const bool bClientPathLocked;
// Export UXComPath::execClear(FFrame&, void* const)
native final simulated function Clear();

// Export UXComPath::execIsValid(FFrame&, void* const)
native final simulated function bool IsValid();

// Export UXComPath::execIsReachable(FFrame&, void* const)
native final simulated function bool IsReachable();

// Export UXComPath::execGetStartPoint(FFrame&, void* const)
native final simulated function Vector GetStartPoint();

// Export UXComPath::execGetEndPoint(FFrame&, void* const)
native final simulated function Vector GetEndPoint();

// Export UXComPath::execPathSize(FFrame&, void* const)
native final simulated function int PathSize();

// Export UXComPath::execGetPoint(FFrame&, void* const)
native final simulated function Vector GetPoint(int Index);

// Export UXComPath::execGetTraversalType(FFrame&, void* const)
native final simulated function ETraversalType GetTraversalType(int Index);

// Export UXComPath::execGetActor(FFrame&, void* const)
native final simulated function Actor GetActor(int Index);

// Export UXComPath::execGetCost(FFrame&, void* const)
native final simulated function int GetCost();

// Export UXComPath::execGetTraversalLength(FFrame&, void* const)
native final simulated function float GetTraversalLength();

native final simulated function SubdivideSegments(float SegmentLength, out array<Vector> Points, optional float MaxTraversalLength=-1.0);

native simulated function Vector FindPointOnPath(float PathDistance, optional bool bIsContinuing=TRUE, optional bool bAllowSpecialTraversalSubdivision=false);

native simulated function bool DoesPathIntersectSphere(Vector vCenter, float fRadius, optional bool bDrawSegment=false);

// Export UXComPath::execInitFromReplicatedData(FFrame&, void* const)
native final simulated function InitFromReplicatedData(const out array<PathPoint> arrPathPoints, Vector vRawDestination, Vector vAdjustedDestination);

// Export UXComPath::execQuantizePathDestinationToTile(FFrame&, void* const)
native final simulated function QuantizePathDestinationToTile();

// Export UXComPath::execIsEndPointHighCover(FFrame&, void* const)
native simulated function bool IsEndPointHighCover();

// Export UXComPath::execIsEndPointLowCover(FFrame&, void* const)
native simulated function bool IsEndPointLowCover();

// Export UXComPath::execGetPathDistanceFromTileCache(FFrame&, void* const)
native simulated function float GetPathDistanceFromTileCache();
// Export UXComPath::execGetPathTileArray(FFrame&, void* const)
native simulated function bool GetPathTileArray(out array<TTile> arrTiles_Out, optional bool bReverseOrder=false);

simulated event string ToString(){}
