class XComSkeletalMeshActor extends SkeletalMeshActor
    hidecategories(Navigation);

var() const editconst export editinline XComFloorComponent FloorComponent;
var() VisibilityBlocking VisibilityBlockingData;
var() bool bEnableXComPhysicsSetup;

defaultproperties
{
    VisibilityBlockingData=(bBlockUnitVisibility=true)
    bWorldGeometry=true
    bCollideActors=true
}