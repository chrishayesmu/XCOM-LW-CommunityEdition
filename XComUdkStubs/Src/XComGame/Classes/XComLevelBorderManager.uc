class XComLevelBorderManager extends Actor
    native(Level)
    config(Game)
    notplaceable
    hidecategories(Navigation);

var export editinline InstancedStaticMeshComponent m_kLevelBorderWalls;
var const globalconfig transient int LevelBorderTileRange;
var const globalconfig transient int LevelBorderHeightRange;
var const string LevelBorderStaticMeshName;
var private int PreviousTileCalculated[3];
var transient bool bGameHidden;
var transient bool bCinematicHidden;
var bool mIsTileChanged;

defaultproperties
{
    LevelBorderStaticMeshName="UI_Cover.Meshes.LevelBorderTile"
    PreviousTileCalculated[0]=-1
    PreviousTileCalculated[1]=-1
    PreviousTileCalculated[2]=-1

    begin object name=LevelBorderWall class=InstancedStaticMeshComponent
        HiddenEditor=true
        bTranslucentIgnoreFOW=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        AbsoluteTranslation=true
        AbsoluteRotation=true
    end object

    m_kLevelBorderWalls=LevelBorderWall
    Components.Add(LevelBorderWall)
}