class XComLevelBorderManager extends Actor
    native(Level)
    config(Game)
    notplaceable
    hidecategories(Navigation);
//complete stub

var export editinline InstancedStaticMeshComponent m_kLevelBorderWalls;
var const globalconfig transient int LevelBorderTileRange;
var const globalconfig transient int LevelBorderHeightRange;
var const string LevelBorderStaticMeshName;
var int PreviousTileCalculated[3];
var transient bool bGameHidden;
var transient bool bCinematicHidden;
var bool mIsTileChanged;

function initManager()
{
    m_kLevelBorderWalls.SetTranslation(vect(0.0, 0.0, 0.0));
    m_kLevelBorderWalls.SetRotation(rot(0, 0, 0));
    m_kLevelBorderWalls.SetStaticMesh(StaticMesh(DynamicLoadObject(LevelBorderStaticMeshName, class'StaticMesh')));
}

// Export UXComLevelBorderManager::execSetBorderGameHidden(FFrame&, void* const)
native function SetBorderGameHidden(const bool bNewGameHidden);

// Export UXComLevelBorderManager::execSetBorderCinematicHidden(FFrame&, void* const)
native function SetBorderCinematicHidden(const bool bNewCinematicHidden);

// Export UXComLevelBorderManager::execShowBorder(FFrame&, void* const)
native function ShowBorder(const bool bShow);

// Export UXComLevelBorderManager::execUpdateCursorLocation(FFrame&, void* const)
native function UpdateCursorLocation(const out Vector cursorLocation, const optional bool bForceRefresh);