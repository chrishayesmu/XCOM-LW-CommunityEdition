class XComProjectile_Ranged extends XComProjectile
    hidecategories(Navigation);

var(XComProjectile) export editinline ParticleSystemComponent RangedFX;
var Vector vProjectileDirection;

defaultproperties
{
    m_fLifeTime=5.0
    Speed=0.0
    MaxSpeed=0.0
    MomentumTransfer=0.0
    MyDamageType=class'XComDamageType_Psionic'
}