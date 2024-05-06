class XComSectopodDrone extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() ParticleSystem OverloadParticleSystem;

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=false
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Never
}