class XGLevelNativeBase extends Actor
    hidecategories(Navigation)
    native(Level)
    notplaceable;
//completet stub

var array<XComBuildingVolume> m_arrBuildings;
var init protected array<init XComFracLevelActor> m_arrUpdateFracActorsList;
var XComPerMaterialInstancedMeshMgr PerMaterialInstancedMeshMgr;
var init protected array<init XComDestructibleActor> m_arrUpdateDestructibleActorsList;
var XComCutoutBox m_kCutoutBox;

// Export UXGLevelNativeBase::execIsStreamingComplete(FFrame&, void* const)
protected native function bool IsStreamingComplete();

// Export UXGLevelNativeBase::execInitFractureSystems(FFrame&, void* const)
native final function InitFractureSystems();