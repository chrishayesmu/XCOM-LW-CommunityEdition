class XComProjectile_BlasterBombShot extends XComProjectile_Shot
    native(Weapon)
    hidecategories(Navigation);

var bool m_bUsePrecomputedTrail;
var float m_fPrecomputedPathTime;

defaultproperties
{
    m_bUsePrecomputedTrail=true
}