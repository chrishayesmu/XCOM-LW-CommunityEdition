class XComPathingPawn extends XComUnitPawnNativeBase
	native(Unit)
    config(Game);
//complete stub

enum ReachabilityStatus
{
    StandardMovement,
    DashMovement,
    ReachabilityStatus_MAX
};
var XComUnitPawnNativeBase MyUnit;
var int MaxPathCost;
var transient bool bOutOfRange;
var transient bool bPathDirty;
var bool bPathAlongLine;
var bool bShowPathRibbon;
var bool bShowFullTacticalGrid;
var bool bUseTargetPoint;
var bool bSnapToTargetPoint;
var bool bFirstMoveOutOfCover;
var const bool bClientPathLocked;
var bool bShowTileCache;
var transient int StandardMoveLength;
var transient ReachabilityStatus DestinationReachability;
var transient Vector LastDestination;
var transient XComPath Path;
var Vector vTargetPoint;
var InterpCurveVector kSplineInfo;
var XComPathEmitter kRibbonEmitter;
var ParticleSystem kRibbonParticleSystem[2];
var export editinline XComRenderablePathComponent kRenderablePath;
var const string PathingRibbonMaterialName[2];
var const string strParticleSystemNameController[2];
var const string strParticleSystemNameMouse[2];
var int iParticleSystemInEffect;
var float fEmitterTimeStep;
var float fEmitterHeightOffset;
var int iPathLengthOffset;
var Vector vLastDrawnValidPathEndPoint;
var float LastMaxPathCost;
var int m_hOnReachabilityChange;

native function BuildSpline(bool bUseRawPath);
native function MoveEmitterAlongPath(float fDeltaTime);
native function TickParticleSystem(float fDeltaTime);
native function UpdateRenderablePath();
native function DebugPathing();
native function EnableParticleSystem(int System);
native function SetDirectedTargetPoint(Vector TargetPoint, bool bSnap);
native function ClearDirectedTargetPoint();
native function bool ClearedToTarget();
simulated function SetEmitterTimeStep(float fTimeStep){}
simulated function SetEmitterHeightOffset(float fHeightOffset){}
simulated function SetPathLengthOffset(int iLengthOffset){}
simulated function int GetCurrentPathCost(){}
simulated function int GetMaxPathCost(){}
simulated function SetMaxPathCost(int MaxCost){}
native simulated function SetClientPathLocked(bool bLocked);
native simulated function bool ComputePath2(Vector Destination, optional bool bObeyUnitMaxCost, optional bool bForceTileCacheUpdate);
native simulated function bool ComputeGrapplePath(out Vector Destination, out int iLowestTileX, out int iLowestTileY, out int iLowestTileZ);
native simulated function bool ComputeJetpackPath(const out Vector Destination, optional bool bObeyUnitMaxCost, optional bool bDebugLog, optional bool bForceLand);
native simulated function bool ComputeLaunchPath(const out Vector Destination);
native simulated function UpdateTileCacheVisuals(const out Vector CursorPosition, bool bForceTileCacheUpdate);
function int GetTempMaxDist(XGUnitNativeBase kUnit, Vector vDest, out int iOldMaxDist){}
function bool IsValidPathForFlyingUnit(){}
native function BuildTileCacheForUnit(XGUnitNativeBase kAIXGUnit);
native function bool QueryTileCacheForReachability(XGUnitNativeBase kAIXGUnit, const out Vector Destination, out ReachabilityStatus Reachability);
function bool ComputePathForAIUnit(XGUnitNativeBase kAIXGUnit, Vector vDest, bool bVisibleBreadcrumbs, bool bObeyUnitMaxCost, bool bComputeCostOnly, optional bool bDebugBreadcrumbsVisibleToAll, optional bool bPathToAction, optional bool bForceTileCacheUpdate, optional bool bCanDash){}
native simulated function bool DestinationIsReachable(const out Vector Destination);
simulated function bool HasValidNonZeroPath(){}
simulated function Vector GetPointInPath(float fDistance, optional bool bIsContinuing=true){}
simulated function SetShowPathRibbon(bool bShowRibbon){}
simulated function SetShowFullTacticalGrid(bool bShowTacticalGrid){}
native simulated function bool GetCursorOutOfRangeStatus();
simulated function Vector GetPathDestinationLimitedByCost(){}
simulated function Vector GetPathDestination(){}
event NotifyPathChanged();
simulated event TakeDirectDamage(const DamageEvent Dmg);
simulated event PreBeginPlay(){}
simulated event PostBeginPlay(){}
simulated event FellOutOfWorld(class<DamageType> dmgType){}
simulated event SetActive(XGUnitNativeBase kActiveXGUnit, optional bool bCanDash){}
simulated event Destroyed(){}
simulated function ChangeDashState(){}
static function float GetMaxDistanceFromTime(int iTime){}
simulated function DrawPath(optional bool bOnlyDrawIfFriendlyToLocalPlayer=true, optional bool bUseRawPath){}
simulated function ClearPathGraphics(){}
simulated function InitializeEmitter(){}
native simulated function UpdateBorderHideHeights();
simulated event Tick(float DeltaTime){}
simulated function GetPathPoints(out array<Vector> arrPathPoints, optional bool bReverse){}

defaultproperties
{
}