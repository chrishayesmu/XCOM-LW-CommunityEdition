class XComDestructibleSkeletalMeshActor extends XComDestructibleActor
    native(Destruction);
//complete stub

var() export editinline SkeletalMeshComponent SkeletalMeshComponent;

// Export UXComDestructibleSkeletalMeshActor::execSetStaticMesh(FFrame&, void* const)
native simulated function SetStaticMesh(StaticMesh NewMesh, optional Vector NewTranslation, optional Rotator NewRotation, optional Vector NewScale3D);

// Export UXComDestructibleSkeletalMeshActor::execSetSkeletalMesh(FFrame&, void* const)
native simulated function SetSkeletalMesh(SkeletalMesh InSkeletalMesh);
