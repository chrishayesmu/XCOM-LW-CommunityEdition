class XComDestructibleSkeletalMeshActor_Action_SwapSkeletalMesh extends XComDestructibleActor_Action within XComDestructibleSkeletalMeshActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(XComDestructibleActor_Action) export editinline SkeletalMeshCue MeshCue;
var(XComDestructibleActor_Action) bool bDisableCollision;

// Export UXComDestructibleSkeletalMeshActor_Action_SwapSkeletalMesh::execActivate(FFrame&, void* const)
native function Activate();
