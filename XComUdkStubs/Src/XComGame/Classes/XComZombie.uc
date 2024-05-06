class XComZombie extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() MaterialInterface ZombieSkinMaterial;
var() MaterialInterface ZombieCivilianBodyMaterial;

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=false
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Always
    m_bShouldTurnBeforeMoving=true
}