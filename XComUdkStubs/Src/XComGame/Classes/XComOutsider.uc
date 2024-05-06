class XComOutsider extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() MaterialInterface StartInvisibleMaterial;
var() MaterialInterface RevealMaterial;
var() MaterialInterface RevealWeaponMaterial;
var transient bool m_bHasSetStartingWeaponMaterials;

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=false
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Never
}