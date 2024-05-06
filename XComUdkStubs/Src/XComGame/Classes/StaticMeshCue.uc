class StaticMeshCue extends Object
    native(Core)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native StaticMeshCueEntry
{
    var() StaticMesh StaticMesh;
    var() float Weight;

    structdefaultproperties
    {
        Weight=1.0
    }
};

var() export editinline array<export editinline StaticMeshCueEntry> StaticMeshes;