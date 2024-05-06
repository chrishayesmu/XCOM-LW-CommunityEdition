class XComBuildingVisPOI extends StaticMeshActor
    native
    hidecategories(Navigation)
    implements(IXComBuildingVisInterface);

var export editinline CylinderComponent CylinderComponent;
var XComPawnIndoorOutdoorInfo IndoorInfo;
var XComPawnIndoorOutdoorInfo LevelTraceIndoorInfo;
var int m_iNumLevelTraceCurrentFloorVolumes;

defaultproperties
{
    CollisionType=COLLIDE_TouchAll
    bStatic=false
    bWorldGeometry=false
    bMovable=true
    bBlockActors=false

    begin object name=UnitCollisionCylinder class=CylinderComponent
        CollisionHeight=64.0
        CollisionRadius=14.0
        RBChannel=RBCC_Pawn
        HiddenGame=false
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=false
        CanBlockCamera=true
        BlockRigidBody=true
        RBCollideWithChannels=(Default=true,Vehicle=true,Water=true,GameplayPhysics=true,EffectPhysics=true,Untitled1=true,Untitled2=true,Untitled3=true,Untitled4=true,Cloth=true,FluidDrain=true,SoftBody=true,BlockingVolume=true,DeadPawn=true)
    end object

    CollisionComponent=UnitCollisionCylinder
    CylinderComponent=UnitCollisionCylinder
    Components.Add(UnitCollisionCylinder)
}