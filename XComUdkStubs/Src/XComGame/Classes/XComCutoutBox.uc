class XComCutoutBox extends StaticMeshActor
    native
    hidecategories(Navigation);

enum ECardinalAxis
{
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    ECardinalAxis_MAX
};

var transient XComBuildingVisPOI m_kBuildingVisPOI;
var transient XComCutoutBox.ECardinalAxis TraceDirections[2];
var native transient Map_Mirror m_aCutoutActors;
var transient bool m_bEnabled;
var transient bool m_bIsInside;
var transient bool m_bHidingObscuredVisGroups;
var native transient bool bCutdownNeedsReset;
var transient XComBuildingVolume ObscuringBuildingVolume;
var transient Vector CutoutPosition;
var transient float TracedBoxDims[4];
var transient float TraceResults[4];
var transient float BoxHeight;
var transient float fZMaskPos;
var transient float fZMaskScale;
var native transient float fZPos;
var native transient float fZScale;
var native transient float fCutdownHeight;
var native transient float fEnableDelay;
var native transient float fBuildingCutdownZ;
var native transient float fBuildingCutoutZ;
var native transient XCom3DCursor m_kCachedCursor;
var float BoxWidth;
var native transient float fMaxZCutdown;

defaultproperties
{
    m_bEnabled=true
    m_bIsInside=true
    TracedBoxDims=100.0
    BoxWidth=600.0
    CollisionType=COLLIDE_TouchAll
    TickGroup=TG_PostAsyncWork
    bStatic=false
    bHidden=true
    bWorldGeometry=false
    bMovable=true
    bBlockActors=false
    bNoEncroachCheck=true

    begin object name=StaticMeshComponent0
        StaticMesh=StaticMesh'FX_Visibility.Meshes.ASE_UnitCube'
        CastShadow=false
        AlwaysCheckCollision=true
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        CanBlockCamera=false
        BlockRigidBody=false
        Translation=(X=0.0,Y=0.0,Z=68.0)
    end object
}