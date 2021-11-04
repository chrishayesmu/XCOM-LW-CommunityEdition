class XComWeapon extends Weapon
	native(Weapon)
    config(Game)
    hidecategories(Navigation);
//complete stub

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

struct CustomProjectileTemplate
{
    var XComProjectile Hit;
    var XComProjectile Miss;
    var XComProjectile Fake;
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
var() array<XGInventoryNativeBase.ELocation> FlushAttachSockets;
var() array<Texture2D> UITextures;
var() const array<Object> AdditionalResources;
var XComProjectile LastProjectile;

replication
{
    if(Role == ROLE_Authority)
        m_kGameWeapon;
}

function bool DoesHitProjectileHaveDamageType(class<DamageType> TestDamageType){}
simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent){}
simulated event SetVisible(bool bVisible){}
simulated event Vector GetMuzzleLoc(){}
native simulated function bool IsWeaponFinishedFiring();
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
simulated function GivenTo(Pawn thisPawn, optional bool bDoNotActivate){}
simulated function PlayFiringSound();
simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation);
simulated function StopFireEffects(byte FireModeNum);
function SetGameData(XGWeapon kWeapon){}
simulated function CustomFire(optional bool bCanDoDamage=true, optional bool HACK_bMindMergeDeathProjectile){}
native function bool IsTemplateValidDoDamage(int TemplateIndex);
simulated function PrepareProjectile(int TemplateIndex){}
simulated function string GetWeaponAimProfileString(){}
function ItemRemovedFromInvManager();
function DropFrom(Vector StartLocation, Vector StartVelocity);
reliable client simulated function ClientWeaponThrown();
