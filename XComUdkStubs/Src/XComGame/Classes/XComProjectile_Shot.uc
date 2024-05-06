class XComProjectile_Shot extends XComProjectile
    native(Weapon)
    hidecategories(Navigation);

var(XComProjectile) float BeamTrailTimeLength;
var(XComProjectile) export editinline ParticleSystemComponent ShotFX;
var(XComProjectile) class<XComProjectileFX_Beam> BeamClass;
var(XComProjectileBeamInfo) bool LockSourceToMuzzleLocation;
var(XComProjectileBeamInfo) bool LockSourceToMuzzleRotation;
var XComProjectileFX_Beam kBeamFX;

defaultproperties
{
    BeamTrailTimeLength=3.0
    BeamClass=class'XComProjectileFX_Beam_RubberBand'
    MyDamageType=class'XComDamageType_Bullet'

    begin object name=Mesh class=SkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'FX_WP_AssaultRifle.SM_Bullet'
    end object

    Mesh=Mesh
    Components.Add(Mesh)
}