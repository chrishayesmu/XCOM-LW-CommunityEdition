class XComPerMaterialInstancedMeshMgr extends Actor
    native(Level)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct native MaterialActorContainer
{
    var init array<init XComInstancedMeshActor> LargeMeshActors;
};

var init array<init MaterialActorContainer> MaterialToActorMap;

// Export UXComPerMaterialInstancedMeshMgr::execRegisterFracLevelActor(FFrame&, void* const)
native simulated function RegisterFracLevelActor(XComFracLevelActor FracActor);

// Export UXComPerMaterialInstancedMeshMgr::execAddInstancedMesh(FFrame&, void* const)
native simulated function AddInstancedMesh(XComFracLevelActor FracActor, const out Box PlacementBox, float GroundZ);