class XGProjectileManager extends Object
	  native(Core);
//complete stub

var array<XComProjectile> PooledProjectiles;
var array<XComProjectileImpactActor> PooledImpactActors;

// Export UXGProjectileManager::execFindPooledProjectile(FFrame&, void* const)
native simulated function XComProjectile FindPooledProjectile(class<XComProjectile> ClassToSpawn, XComWeapon ProjectileTemplate, Vector NewPosition);

// Export UXGProjectileManager::execFindPooledImpactActor(FFrame&, void* const)
native simulated function XComProjectileImpactActor FindPooledImpactActor(XComProjectile Owner, Vector NewPosition, Rotator NewRotation, XComProjectileImpactActor ImpactActorTemplate);