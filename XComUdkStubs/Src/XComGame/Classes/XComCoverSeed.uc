class XComCoverSeed extends Actor
    native(Cover)
    placeable
    hidecategories(Navigation,Object,Display,Attachment,Actor,Collision,Physics,Advanced,Mobile);

var() bool bDiagonalCover;
var() const editconst export editinline StaticMeshComponent TileBoxComponent;

defaultproperties
{
    begin object name=TileBoxComponent0 class=StaticMeshComponent
        StaticMesh=StaticMesh'UI_Cover.Editor_Meshes.TileBox'
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    CollisionComponent=TileBoxComponent0
    TileBoxComponent=TileBoxComponent0
    Components.Add(TileBoxComponent0)
}