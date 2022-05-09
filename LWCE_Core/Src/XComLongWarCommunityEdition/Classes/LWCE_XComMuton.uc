class LWCE_XComMuton extends XComMuton;

simulated function ApplyShredderRocket(const DamageEvent Dmg, bool enemyOfUnitHit)
{
    class'LWCE_XComUnitPawn_Extensions'.static.ApplyShredderRocket(self, Dmg, enemyOfUnitHit);
}