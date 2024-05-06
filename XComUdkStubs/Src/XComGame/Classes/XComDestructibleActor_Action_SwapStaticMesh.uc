class XComDestructibleActor_Action_SwapStaticMesh extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EMaterialOverrideMode
{
    OVERRIDE_Keep,
    OVERRIDE_Remove,
    OVERRIDE_MAX
};

var(XComDestructibleActor_Action) export editinline StaticMeshCue MeshCue;
var(XComDestructibleActor_Action) bool bDisableCollision;
var(XComDestructibleActor_Action) bool bRemoveLightmap;
var(XComDestructibleActor_Action) EMaterialOverrideMode MaterialOverrideMode;

defaultproperties
{
    MaterialOverrideMode=OVERRIDE_Remove
}