class XComPathingPawn extends XComUnitPawnNativeBase
    native(Unit)
    config(Game)
    hidecategories(Navigation);

const PATH_SEGMENT_DISTANCE = 64;

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
var private bool bShowPathRibbon;
var private bool bShowFullTacticalGrid;
var bool bUseTargetPoint;
var bool bSnapToTargetPoint;
var bool bFirstMoveOutOfCover;
var const bool bClientPathLocked;
var bool bShowTileCache;
var transient int StandardMoveLength;
var transient XComPathingPawn.ReachabilityStatus DestinationReachability;
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

defaultproperties
{
    bShowPathRibbon=true
    PathingRibbonMaterialName[0]="MarcPackage.Materials.TrailRibbon"
    PathingRibbonMaterialName[1]="MarcPackage.Materials.TrailRibbonBad"
    strParticleSystemNameController[0]="MarcPackage.boxCursor.boxCursor_Dest"
    strParticleSystemNameController[1]="MarcPackage.boxCursor.boxCursor_DestBad"
    strParticleSystemNameMouse[0]="MarcPackage.ParticleSystems.CursorTrail"
    strParticleSystemNameMouse[1]="MarcPackage.ParticleSystems.CursorTrailBad"
    iParticleSystemInEffect=-1
    fEmitterTimeStep=10.0
    fEmitterHeightOffset=10.0
    iPathLengthOffset=-2
    MaxStepHeight=26.0
    WalkableFloorZ=0.10
    GroundSpeed=200.0
    AirSpeed=200.0
    ControllerClass=none

    begin object name=PathComponent class=XComRenderablePathComponent
        iPathLengthOffset=-2
        fRibbonWidth=10.0
        bTranslucentIgnoreFOW=true
        TranslucencySortPriority=100
    end object

    kRenderablePath=PathComponent
    Components.Add(PathComponent)

	Components.Remove(CollisionCylinder)

    begin object name=UnitCollisionCylinder class=CylinderComponent
        CollisionHeight=128.0
        CollisionRadius=30.0
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    CollisionComponent=UnitCollisionCylinder
    CylinderComponent=UnitCollisionCylinder
    Components.Add(UnitCollisionCylinder)

    bTickIsDisabled=true
    bCollideActors=false
    bBlockActors=false
    RotationRate=(Pitch=65000,Yaw=65000,Roll=65000)
}