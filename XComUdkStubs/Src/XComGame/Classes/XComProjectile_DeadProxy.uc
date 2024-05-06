class XComProjectile_DeadProxy extends XComProjectile
    native(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    RemoteRole=ROLE_None
    bCollideActors=false
    bCollideWorld=false
}