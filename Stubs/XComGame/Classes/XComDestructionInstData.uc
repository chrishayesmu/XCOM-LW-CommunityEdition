class XComDestructionInstData extends Object
    native(Core);
//complete stub

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

// Export UXComDestructionInstData::execForceAllHidden(FFrame&, void* const)
native final function ForceAllHidden(bool bHidden);

// Export UXComDestructionInstData::execForceAllVisible(FFrame&, void* const)
native final function ForceAllVisible(bool bVisible);

// Export UXComDestructionInstData::execFlush(FFrame&, void* const)
native final function Flush();

// Export UXComDestructionInstData::execStartFromScratch(FFrame&, void* const)
native final function StartFromScratch();

// Export UXComDestructionInstData::execAddComponent(FFrame&, void* const)
native final function bool AddComponent(InstancedStaticMeshComponent InstComp, XComDecoFracLevelActor Parent);

// Export UXComDestructionInstData::execRemoveComponent(FFrame&, void* const)
native final function bool RemoveComponent(InstancedStaticMeshComponent InstComp, XComDecoFracLevelActor Parent);

// Export UXComDestructionInstData::execAddDebrisSMComponent(FFrame&, void* const)
native final function AddDebrisSMComponent(StaticMeshComponent MeshComp, int ColumnIdx, XComDecoFracLevelActor Parent);

// Export UXComDestructionInstData::execAddComponentsFromMaps(FFrame&, void* const)
native final function AddComponentsFromMaps();

// Export UXComDestructionInstData::execCleanupMaps(FFrame&, void* const)
native final function CleanupMaps();

// Export UXComDestructionInstData::execFixupFloorComponents(FFrame&, void* const)
native final function FixupFloorComponents();

// Export UXComDestructionInstData::execReattachComponents(FFrame&, void* const)
native final function ReattachComponents(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execGetNumStaticMeshes(FFrame&, void* const)
native final function int GetNumStaticMeshes(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execClearDebrisStaticMeshes(FFrame&, void* const)
native final function ClearDebrisStaticMeshes(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execClearAllDebrisStaticMeshes(FFrame&, void* const)
native final function ClearAllDebrisStaticMeshes();

// Export UXComDestructionInstData::execRegisterDestructionActor(FFrame&, void* const)
native final function RegisterDestructionActor(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execIsActorRegistered(FFrame&, void* const)
native final function bool IsActorRegistered(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execDeregisterDestructionActor(FFrame&, void* const)
native final function DeregisterDestructionActor(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execReinitializeComponents(FFrame&, void* const)
native final function ReinitializeComponents(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execUpdateComponentsRuntime(FFrame&, void* const)
native final function UpdateComponentsRuntime(XComDecoFracLevelActor Actor);

// Export UXComDestructionInstData::execSetHidden(FFrame&, void* const)
native function SetHidden(XComDecoFracLevelActor Actor, bool bShouldCutout);

// Export UXComDestructionInstData::execSetCutoutFlag(FFrame&, void* const)
native final function SetCutoutFlag(XComDecoFracLevelActor Actor, bool bShouldCutout);

// Export UXComDestructionInstData::execSetCutdownFlag(FFrame&, void* const)
native final function SetCutdownFlag(XComDecoFracLevelActor Actor, bool bShouldCutdown);

// Export UXComDestructionInstData::execSetCutdownHeight(FFrame&, void* const)
native final function SetCutdownHeight(XComDecoFracLevelActor Actor, float fCutdownHeight);

// Export UXComDestructionInstData::execSetVisFadeFlag(FFrame&, void* const)
native final function SetVisFadeFlag(XComDecoFracLevelActor Actor, bool bVisFade, bool bForceReattach);

// Export UXComDestructionInstData::execSetPrimitiveVisHeight(FFrame&, void* const)
native final function SetPrimitiveVisHeight(XComDecoFracLevelActor Actor, float fCutdownHeight, float fCutoutHeight, float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

// Export UXComDestructionInstData::execSetPrimitiveVisFadeValues(FFrame&, void* const)
native final function SetPrimitiveVisFadeValues(XComDecoFracLevelActor Actor, float fCutoutFade, float fTargetCutoutFade);

// Export UXComDestructionInstData::execOnMapLoad(FFrame&, void* const)
native final function OnMapLoad();

// Export UXComDestructionInstData::execInitialize(FFrame&, void* const)
native final function Initialize();