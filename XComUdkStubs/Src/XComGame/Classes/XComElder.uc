class XComElder extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var export editinline SkeletalMeshComponent MeshHead;
var export editinline SkeletalMeshComponent MeshRobe;
var() SkeletalMesh transformedMeshBody;
var() SkeletalMesh transformedMeshHead;
var() SkeletalMesh transformedMeshRobe;
var() MaterialInterface transformedRobeMaterial;

defaultproperties
{
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Never
    m_bShouldTurnBeforeMoving=true
}