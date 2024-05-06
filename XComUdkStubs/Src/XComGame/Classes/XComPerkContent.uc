class XComPerkContent extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Advanced,Debug);

const MAX_PARTICLE_FX = 16;
const BODY_SHIELD_UPDATE = 1.0f;

struct native TParticleContent
{
    var() ParticleSystem FXTemplate;
    var() name FXTemplateSocket;
    var() name FXTemplateBone;
    var() float Delay;
    var() bool SetActorParameter;
    var() name SetActorName;
};

struct native TAnimContent
{
    var() bool PlayAnimation;
    var() name NoCoverAnim;
    var() name HighCoverAnim;
    var() name LowCoverAnim;
};

var() bool SkipAbilityActivation;
var() bool EndPersistentFXOnDeath;
var() bool DisablePersistentFXDuringActivation;
var() bool ExcludeCasterFromTargetParticleFXBurst;
var() bool PlayDamageFXOnDeath;
var() bool m_bUnequipWeapon;
var() const bool FinishDeactivationBeforeActivating;
var private bool m_bWasDormant;
var private bool m_bPendingActivation;
var private bool m_bActivatingFromDeactivation;
var private bool m_bHidingBodyShield;
var private bool m_bActivated;
var private bool m_bSkipRMA;
var private bool m_bCanPerformInventoryOperations;
var() TParticleContent PersistentFX;
var() TParticleContent ParticleFXOnCaster;
var() array<TParticleContent> ExtraParticleFXOnCaster;
var() TParticleContent ParticleFXOnTargetForDuration;
var() TParticleContent ParticleFXOnTargetBurst;
var() TParticleContent ParticleFXOnTargetDurationEnded;
var() TParticleContent ParticleFXOnCasterOnDamage;
var() TParticleContent ParticleFXOnCasterOnDamageLevel2;
var() TParticleContent ParticleFXOnCasterOnDamageLevel3;
var() XComWeapon PerkSpecificWeapon;
var() TAnimContent ActivationAnim;
var() TAnimContent DeactivationAnim;
var() ParticleSystem PsiSendFX_Soldier;
var() ParticleSystem PsiSendFX_Sectoid;
var() ParticleSystem PsiSendFX_Ethereal;
var() ParticleSystem PsiReceiveFX_Soldier;
var() ParticleSystem PsiReceiveFX_Sectoid;
var() ParticleSystem PsiReceiveFX_Ethereal;
var() const array<AnimSet> AnimSetsToAlwaysApply;
var() const array<AnimSet> AnimSetsForDuration;
var() const array<Object> AdditionalResources;
var private export editinline ParticleSystemComponent m_kPersistentParticleFX;
var private export editinline ParticleSystemComponent m_arrParticleFXOnCaster[16];
var private export editinline ParticleSystemComponent m_arrTargetParticleFXForDuration[16];
var private export editinline ParticleSystemComponent m_arrTargetParticleFXBurst[16];
var private export editinline ParticleSystemComponent m_arrTargetParticleFXDurationEnded[16];
var private export editinline ParticleSystemComponent m_kParticleFXOnCasterOnDamage;
var private XGUnit m_kUnit;
var private XComUnitPawn m_kPawn;
var private array<XGUnit> m_arrTargets;
var private array<XComUnitPawn> m_arrTargetPawns;
var private XComWeapon m_kWeapon;
var private name m_nmAnim;
var private int m_iDamageLevel;
var private XGUnit m_kPendingCaster;
var private array<XGUnit> m_arrPendingTargets;
var private export editinline array<export editinline ParticleSystemComponent> m_arrBodyShieldComponents;
var private Rotator m_LastBodyShieldRotation;
var private InventoryOperation TempInvOperation;