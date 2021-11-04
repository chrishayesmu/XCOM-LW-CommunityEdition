interface DamageDealingAction extends Interface;
//complete stub

simulated function GetProjectileDamage(bool bCanDoDamage, XComProjectile kProjectile, XComWeapon kWeapon, out XComUnitPawn kTargetPawn, out XGUnitNativeBase kSourceUnit, out int iDamageAmount, out int iWorldDamage);

simulated function bool IsHit();

simulated function bool IsCritical();

simulated function bool IsKillShot();

simulated function bool IsReflected();