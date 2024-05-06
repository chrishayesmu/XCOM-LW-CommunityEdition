class XComPathEmitter extends Emitter
    native(Unit)
    hidecategories(Navigation);

defaultproperties
{
    bDestroyOnSystemFinish=true
    bHidden=true
    bNoDelete=false
    bNetTemporary=true

    begin object name=ParticleSystemComponent0
        bOverrideLODMethod=true
        SecondsBeforeInactive=0.0
        LODMethod=ParticleSystemLODMethod.PARTICLESYSTEMLODMETHOD_DirectSet
        bTranslucentIgnoreFOW=true
    end object

    begin object name=StaticMeshComponent class=StaticMeshComponent
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        CanBlockCamera=false
        BlockRigidBody=false
        Translation=(X=0.0,Y=0.0,Z=-5.0)
    end object

    Components.Add(StaticMeshComponent)
}