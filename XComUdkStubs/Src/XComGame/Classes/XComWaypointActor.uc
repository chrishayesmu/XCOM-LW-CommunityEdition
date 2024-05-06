class XComWaypointActor extends StaticMeshActor
    hidecategories(Navigation,StaticMeshActor);

var() export editinline SpriteComponent VisualizeSprite;
var() bool bLowCover;
var() export editinline StaticMeshComponent CoverArrowMeshComponent;

defaultproperties
{
    CollisionType=COLLIDE_NoCollision
    bStatic=false
    bWorldGeometry=false
    bCollideActors=false
    bBlockActors=false

    begin object name=Sprite class=SpriteComponent
        HiddenGame=true
    end object

    VisualizeSprite=Sprite
    Components.Add(Sprite)

    begin object name=WayPointMeshComponent class=StaticMeshComponent
        HiddenGame=true
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
        CollideActors=false
        BlockActors=false
        BlockRigidBody=false
        bDisableAllRigidBody=true
    end object

    CollisionComponent=WayPointMeshComponent
    StaticMeshComponent=WayPointMeshComponent
    Components.Add(WayPointMeshComponent)

    begin object name=CoverArrowMesh class=StaticMeshComponent
        HiddenGame=true
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
        CollideActors=false
        BlockActors=false
        BlockRigidBody=false
        bDisableAllRigidBody=true
        Translation=(X=0.0,Y=0.0,Z=120.0)
        Rotation=(Pitch=0,Yaw=16384,Roll=-15500)
    end object

    CoverArrowMeshComponent=CoverArrowMesh
    Components.Add(CoverArrowMesh)
}