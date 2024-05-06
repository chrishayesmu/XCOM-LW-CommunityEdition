class XComDeathHandler extends Object
    dependson(XGInventoryNativeBase);

struct DeathElement
{
    var() class<DamageType> DamageTypeClass;
    var() bool bCreateBloodPool;
    var() bool bUseWoundAttachEffect;
    var() editinline EffectCue WoundAttachEffect;
    var() array<ELocation> WoundAttachSockets;

    structdefaultproperties
    {
        bCreateBloodPool=true
        bUseWoundAttachEffect=true
    }
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