class XComDeathHandler extends Object
	dependsOn(XGInventoryNativeBase);

//complete stub
struct DeathElement
{
    var() class<DamageType> DamageTypeClass;
    var() bool bCreateBloodPool;
    var() bool bUseWoundAttachEffect;
    var() editinline EffectCue WoundAttachEffect;
    var() array<XGInventoryNativeBase.ELocation> WoundAttachSockets;
};

var() array<DeathElement> DeathsList;
var(BloodPool) MaterialInterface BloodPoolDecalMaterial;
var(BloodPool) DecalProperties BloodPoolDecalProperties;
var(MindMerge) editinline EffectCue MindMergeWhiplashEffect;
var(ExplodeDeath) ParticleSystem ExplodeDeathEffect;
var(ExplodeDeath) SoundCue ExplodeDeathSound;
var const float kDefaultDecalScale;
var const float kDefaultDecalBackfaceAngle;
var DeathElement m_selectedDeath;
var XComUnitPawn m_pawn;
var SkeletalMeshSocket m_pawnHitSocket;
var bool m_bCreatedBloodPool;
var export editinline array<export editinline ParticleSystemComponent> m_arrCreatedParticleSystemComponents;

simulated function BeginDeath(class<DamageType> DamageTypeClass, XComUnitPawn DyingPawn){}
simulated function EndDeath(XComUnitPawn UnitPawn){}
simulated function Update(){}
function CreateBloodPool(){}
