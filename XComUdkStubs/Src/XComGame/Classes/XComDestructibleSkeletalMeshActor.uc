class XComDestructibleSkeletalMeshActor extends XComDestructibleActor
    abstract
    native(Destruction)
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent SkeletalMeshComponent;

defaultproperties
{
    begin object name=SkeletalMeshComponent0 class=SkeletalMeshComponent
        bSyncActorLocationToRootRigidBody=false
        LightEnvironment=MyNEWLightEnvironment
        RBChannel=RBCC_Pawn
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
        RBCollideWithChannels=(Default=true,Pawn=true,Vehicle=true,Water=true,GameplayPhysics=true,EffectPhysics=true,Untitled1=true,Untitled2=true,Untitled3=true,Untitled4=true,Cloth=true,FluidDrain=true,SoftBody=true,FracturedMeshPart=true)
    end object

    CollisionComponent=SkeletalMeshComponent0
    SkeletalMeshComponent=SkeletalMeshComponent0
    Components.Add(SkeletalMeshComponent0)
}