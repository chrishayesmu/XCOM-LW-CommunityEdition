class XComWeaponComponent extends ActorComponent
    abstract
    native(core)
    editinlinenew
    collapsecategories
    hidecategories(Object);
//complete stub

var array<XComProjectile> PooledProjectiles;

simulated function CustomFire(optional bool bCanDoDamage, optional bool HACK_bMindMergeDeathProjectile){}
simulated event Vector GetMuzzleLoc(bool bPreview){}
simulated event Rotator GetMuzzleRotation(){}
simulated function XComProjectile PerformSpawnProjectile(XComWeapon OwnerWeapon, XGAction_Fire kFireAction, class<XComProjectile> ClassToSpawn, Vector NewPosition, Vector NewDirection, bool bAnimNotify_FireWeaponCustom_DoDamage, bool HACK_bMindMergeDeathProjectile){}
simulated function KillProjectileFromPool(XComProjectile pProjectile){}
simulated function SpawnProjectile(Vector NewPosition, Vector NewDirection, bool bAnimNotify_FireWeaponCustom_DoDamage, bool HACK_bMindMergeDeathProjectile){}
simulated function InitProjectile(Vector Position, Vector Direction, out XComProjectile SpawnedProjectile, optional bool bAnimNotify_FireWeaponCustom_DoDamage){}
