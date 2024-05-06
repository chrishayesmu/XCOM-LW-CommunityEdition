class XComDestructionInstData extends Object
    native(Core);

struct native DebrisMeshInfo
{
    var int ColumnIdx;
    var export editinline StaticMeshComponent MeshComponent;
};

struct native DecoFracStats
{
    var int nDecoInstances;
    var int nDecoComponents;
    var int nDebrisInstances;
    var int nDebrisComponents;
    var int nDebrisSMComponents;
};

var XComLevelVolume LevelVolume;
var private int MaxJoinKey;
var private native const MultiMap_Mirror DecoFracToDecoComponents;
var private native const MultiMap_Mirror DecoFracToDebrisComponents;
var private native const MultiMap_Mirror DecoFracToDebrisStaticMeshInfos;