class XComChryssalid extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=false
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Always
    MeleeRange=192.0
}