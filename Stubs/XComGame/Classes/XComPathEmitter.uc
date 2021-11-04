class XComPathEmitter extends Emitter
    native(Unit)
    hidecategories(Navigation);
//complete stub

defaultproperties
{
    begin object name=ParticleSystemComponent0
		ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    Components(0)=ParticleSystemComponent0
    
    begin object name=StaticMeshComponent class=StaticMeshComponent
        ReplacementPrimitive=none
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        CanBlockCamera=false
        BlockRigidBody=false
        Translation=(X=0.0,Y=0.0,Z=-5.0)
    end object
    Components(1)=StaticMeshComponent
    bHidden=true
    bNoDelete=false
    bNetTemporary=true
}
