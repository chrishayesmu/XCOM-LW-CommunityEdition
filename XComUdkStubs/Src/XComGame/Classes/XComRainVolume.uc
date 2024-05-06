class XComRainVolume extends Actor
    placeable
    hidecategories(Navigation,Object);

defaultproperties
{
    begin object name=StaticMeshComponent0 class=StaticMeshComponent
        StaticMesh=StaticMesh'FX_Weather.cube_offset'
        HiddenGame=true
        CastShadow=false
        Scale=640.0
    end object

    Components(0)=StaticMeshComponent0
    bStatic=true
    bNoDelete=true
    bEdShouldSnap=true
}