class XGLevelNativeBase extends Actor
    native(Level)
    notplaceable
    hidecategories(Navigation);

var array<XComBuildingVolume> m_arrBuildings;
var init protected array<init XComFracLevelActor> m_arrUpdateFracActorsList;
var XComPerMaterialInstancedMeshMgr PerMaterialInstancedMeshMgr;
var init protected array<init XComDestructibleActor> m_arrUpdateDestructibleActorsList;
var XComCutoutBox m_kCutoutBox;