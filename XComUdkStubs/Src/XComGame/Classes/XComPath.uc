class XComPath extends Object
    native(Unit)
    dependson(XComPathData);

var protectedwrite array<PathPoint> Path;
var private transient array<PathPoint> BuildPath;
var protectedwrite float Radius;
var protectedwrite float Height;
var private transient float TraversalLength;
var private transient int Cost;
var private transient int PointOnPath_LastIndex;
var private transient float PointOnPath_LastDistance;
var protectedwrite transient Vector RawDestination;
var protectedwrite transient Vector AdjustedDestination;
var transient bool bDrawOriginalPath;
var transient bool bDrawObstacleChecks;
var transient bool bDrawStringPulling;
var transient bool bDrawFinalPath;
var transient bool bJetpackPath;
var private const bool bClientPathLocked;

defaultproperties
{
    PointOnPath_LastIndex=-1
}