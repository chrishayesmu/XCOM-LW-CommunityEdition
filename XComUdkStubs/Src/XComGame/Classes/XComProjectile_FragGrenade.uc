class XComProjectile_FragGrenade extends XComProjectile
    native(Weapon)
    hidecategories(Navigation);

var bool m_bUsePrecomputedTrail;
var bool m_bShouldNotCauseDamageFlinch;
var privatewrite bool m_bBattleScanner;
var private bool m_bMimicBeacon;
var float m_fPrecomputedPathTime;
var init const localized string m_sMineNowMessage;
var() ParticleSystem CombatDrugsTrailFX;
var protected export editinline ParticleSystemComponent MimicBeaconPersistComponent;
var ParticleSystem MimicBeaconParticleSystemPersist;

defaultproperties
{
    m_fLifeTime=14.0
    Speed=925.0
    MaxSpeed=0.0
    bBlockedByInstigator=true
    MyDamageType=class'XComDamageType_Explosion'
    Physics=PHYS_Falling
    bUpdateSimulatedPosition=true
    bBounce=true

    begin object name=CollisionCylinder
        CollisionHeight=10.0
        CollisionRadius=10.0
        CollideActors=true
    end object

    begin object name=ProjectileMeshComponent class=SkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'WP_GrenadeFrag.Meshes.SM_GrenadeFrag'
    end object

    Mesh=ProjectileMeshComponent

    begin object name=SmokeTrail class=ParticleSystemComponent
        Template=ParticleSystem'FX_WP_Grenade.P_GrenadeFragIcon'
        bAutoActivate=false
    end object

    Components.Add(SmokeTrail)

    ProjectileTrailEffect=SmokeTrail
    ProjectileTrailSocket=gun_fire
}