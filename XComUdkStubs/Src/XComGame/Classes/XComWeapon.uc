class XComWeapon extends Weapon
    native(Weapon)
    config(Game)
    hidecategories(Navigation);

enum EWeaponAnimIdleState
{
    WS_UnEquipped,
    WS_Lowered,
    WS_Raised,
    WS_MAX
};

enum eWeaponType
{
    WAP_Rifle,
    WAP_Pistol,
    WAP_Unarmed,
    WAP_Rocket,
    WAP_MiniGun,
    WAP_Grapple,
    WAP_Default,
    WAP_Turret,
    WAP_MecLeftArm,
    WAP_MecRightArm,
    WAP_MAX
};

struct native CustomProjectileTemplate
{
    var() XComProjectile Hit;
    var() XComProjectile Miss;
    var() XComProjectile Fake;
};

var(Sounds) array<SoundCue> WeaponFireSnd;
var() export editinline ParticleSystemComponent WeaponFlashEffect;
var XGWeapon m_kGameWeapon;
var XComUnitPawnNativeBase m_kPawn;
var() XComAnimNodeWeapon AnimNode;
var() export editinline XComWeaponComponent WeaponComponent;
var() XComProjectile ProjectileTemplate;
var() array<CustomProjectileTemplate> ProjectileTemplates;
var() export editinline ParticleSystemComponent GunLightBeam;
var() export editinline LensFlareComponent GunLightLensFlare;
var() array<AnimSet> CustomUnitPawnAnimsets;
var() array<AnimSet> CustomUnitPawnFlightAnimsets;
var() array<AnimSet> CustomTankPawnAnimsets;
var() array<AnimSet> CustomTankPawnFlightAnimsets;
var() eWeaponType WeaponAimProfileType;
var() name WeaponFireAnimSequenceName;
var() name CollateralDamageAnimSequenceName;
var() ParticleSystem CollateralDamageAreaFX;
var bool bPreviewAim;
var bool bCalcWeaponFireMiss;
var() editinline EffectCue FlushAttachEffect;
var() array<ELocation> FlushAttachSockets;
var() array<Texture2D> UITextures;
var() const array<Object> AdditionalResources;
var XComProjectile LastProjectile;

defaultproperties
{
    WeaponFireAnimSequenceName=FF_FireA
    FiringStatesArray(0)="WeaponFiring"
    WeaponFireTypes(0)=EWFT_Custom
    FireInterval(0)=0.0100000
    Spread(0)=0.0000000
    EquipTime=0.0
    PutDownTime=0.0

    begin object name=GunAttachMeshComponent class=SkeletalMeshComponent
        bUpdateSkelWhenNotRendered=false
        bHasPhysicsAssetInstance=true
        bUpdateKinematicBonesFromAnimation=false
        RBChannel=RBCC_GameplayPhysics
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockRigidBody=true
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
    end object
    Mesh=GunAttachMeshComponent
    Components.Add(GunAttachMeshComponent)

    bAlwaysRelevant=true
}