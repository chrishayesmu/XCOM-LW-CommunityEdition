class SkeletalMeshCue extends Object
    native(Core)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native SkeletalMeshCueEntry
{
    var() SkeletalMesh SkeletalMesh;
    var() float Weight;

    structdefaultproperties
    {
        Weight=1.0
    }
};

var() export editinline array<export editinline SkeletalMeshCueEntry> SkeletalMeshes;