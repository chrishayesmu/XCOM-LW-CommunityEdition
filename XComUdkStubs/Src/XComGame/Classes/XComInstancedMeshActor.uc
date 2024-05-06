class XComInstancedMeshActor extends XComLevelActor
    native(Level)
    hidecategories(Navigation,StaticMeshActor);

var() const editconst export editinline InstancedStaticMeshComponent InstancedMeshComponent;

defaultproperties
{
    begin object name=InstancedMeshComponent0 class=InstancedStaticMeshComponent
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    InstancedMeshComponent=InstancedMeshComponent0
    Components.Add(InstancedMeshComponent0)
}