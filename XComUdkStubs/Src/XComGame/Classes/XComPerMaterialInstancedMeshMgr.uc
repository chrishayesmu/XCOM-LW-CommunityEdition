class XComPerMaterialInstancedMeshMgr extends Actor
    native(Level)
    notplaceable
    hidecategories(Navigation);

struct native MaterialActorContainer
{
    var init array<init XComInstancedMeshActor> LargeMeshActors;
};

var init array<init MaterialActorContainer> MaterialToActorMap;