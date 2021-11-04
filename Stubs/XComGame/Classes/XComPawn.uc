class XComPawn extends GamePawn
	native(Unit)
    config(Game)
dependson(XGGameData)
dependson(XComTacticalGRI)
implements(IMouseInteractionInterface, XComCoverInterface, IXComBuildingVisInterface);
//complete stub

var XComPawnIndoorOutdoorInfo IndoorInfo;
var XGCharacter m_kXGCharacter;
var bool bConsiderForCover;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_kXGCharacter;
}

native simulated function bool NavMeshTrace(Vector vStart, Vector vEnd, Vector vExtent, out Vector vHitLocation);
simulated function HideMainPawnMesh(){}
function SetXGCharacter(XGCharacter kXGCharacter){}
simulated function EMaterialType GetMaterialTypeBelow(){}
simulated function NotifyTacticalGameOfEvent(EXComTacticalEvent EEvent){}
event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal){}
event UnTouch(Actor Other){}
simulated event PreBeginPlay(){}
simulated function bool NavTraceBelowSelf(float fDistance, optional out Vector vHitLoc, optional out Vector vHitNormal){}
simulated function bool NavTraceBelowLocation(Vector vLoc, float fDistance, optional out Vector vHitLoc, optional out Vector vHitNormal){}
function Actor GetActor(){}
function bool TraceBelowSelf(float fDistance, optional out Vector vHitLoc, optional out Vector vHitNormal){}

function bool OnMouseEvent(int Cmd, int Actionmask, optional Vector MouseWorldOrigin, optional Vector MouseWorldDirection, optional Vector HitLocation){}
// Export UXComPawn::execConsiderForOccupancy(FFrame&, void* const)
native simulated function bool ConsiderForOccupancy();

// Export UXComPawn::execShouldIgnoreForCover(FFrame&, void* const)
native simulated function bool ShouldIgnoreForCover();

// Export UXComPawn::execCanClimbOver(FFrame&, void* const)
native simulated function bool CanClimbOver();

// Export UXComPawn::execCanClimbOnto(FFrame&, void* const)
native simulated function bool CanClimbOnto();

// Export UXComPawn::execUseRigidBodyCollisionForCover(FFrame&, void* const)
native simulated function bool UseRigidBodyCollisionForCover();

// Export UXComPawn::execGetCoverForceFlag(FFrame&, void* const)
native simulated function ECoverForceFlag GetCoverForceFlag();

// Export UXComPawn::execGetCoverIgnoreFlag(FFrame&, void* const)
native simulated function ECoverForceFlag GetCoverIgnoreFlag();

// Export UXComPawn::execGetIndoorOutdoorInfo(FFrame&, void* const)
native simulated function XComPawnIndoorOutdoorInfo GetIndoorOutdoorInfo();

// Export UXComPawn::execGetCurrentBuildingVolumeIfInside(FFrame&, void* const)
native simulated event XComBuildingVolume GetCurrentBuildingVolumeIfInside();

// Export UXComPawn::execIsInside(FFrame&, void* const)
native simulated event bool IsInside();

simulated function OnChangedIndoorStatus(){}
simulated function OnChangedFloor(){}

defaultproperties
{
	InventoryManagerClass=class'XComInventoryManager'
	Components(0)=none
	Components(1)=none
	Components(2)=none
	
	begin object name=CollisionCylinder
        ReplacementPrimitive=none
	end object
	Components.Add(CollisionCylinder)
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
}


