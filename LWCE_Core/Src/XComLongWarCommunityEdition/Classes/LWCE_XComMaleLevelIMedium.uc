class LWCE_XComMaleLevelIMedium extends XComMaleLevelIMedium;

simulated function ApplyShredderRocket(const DamageEvent Dmg, bool enemyOfUnitHit)
{
    class'LWCE_XComUnitPawn_Extensions'.static.ApplyShredderRocket(self, Dmg, enemyOfUnitHit);
}

simulated function AttachItem(Actor A, name SocketName, bool bIsRearBackPackItem, out MeshComponent kFoundMeshComponent)
{
    class'LWCE_XComUnitPawn_Extensions'.static.AttachItem(self, A, SocketName, bIsRearBackPackItem, kFoundMeshComponent);
}