class XComElder extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var export editinline SkeletalMeshComponent MeshHead;
var export editinline SkeletalMeshComponent MeshRobe;
var() SkeletalMesh transformedMeshBody;
var() SkeletalMesh transformedMeshHead;
var() SkeletalMesh transformedMeshRobe;
var() MaterialInterface transformedRobeMaterial;

simulated function AttachAuxMesh(SkeletalMesh SkelMesh, out SkeletalMeshComponent SkelMeshComp){}
function HideHelmet(){}
function HideRobes(){}
function SetDyingPhysics(){}
function OnFinishRagdoll(){}
