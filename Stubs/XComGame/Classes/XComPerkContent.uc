class XComPerkContent extends Actor
    native(Unit)
    notplaceable
    dependsOn(XGGameData);
//complete stub

const MAX_PARTICLE_FX = 16;
const BODY_SHIELD_UPDATE = 1.0f;

struct TParticleContent
{
    var ParticleSystem FXTemplate;
    var name FXTemplateSocket;
    var name FXTemplateBone;
    var float Delay;
    var bool SetActorParameter;
    var name SetActorName;
};

struct TAnimContent
{
    var bool PlayAnimation;
    var name NoCoverAnim;
    var name HighCoverAnim;
    var name LowCoverAnim;
};


var bool SkipAbilityActivation;
var bool EndPersistentFXOnDeath;
var bool DisablePersistentFXDuringActivation;
var bool ExcludeCasterFromTargetParticleFXBurst;
var bool PlayDamageFXOnDeath;
var bool m_bUnequipWeapon;
var const bool FinishDeactivationBeforeActivating;
var bool m_bWasDormant;
var bool m_bPendingActivation;
var bool m_bActivatingFromDeactivation;
var bool m_bHidingBodyShield;
var bool m_bActivated;
var bool m_bSkipRMA;
var bool m_bCanPerformInventoryOperations;
var TParticleContent PersistentFX;
var TParticleContent ParticleFXOnCaster;
var array<TParticleContent> ExtraParticleFXOnCaster;
var TParticleContent ParticleFXOnTargetForDuration;
var TParticleContent ParticleFXOnTargetBurst;
var TParticleContent ParticleFXOnTargetDurationEnded;
var TParticleContent ParticleFXOnCasterOnDamage;
var TParticleContent ParticleFXOnCasterOnDamageLevel2;
var TParticleContent ParticleFXOnCasterOnDamageLevel3;
var XComWeapon PerkSpecificWeapon;
var TAnimContent ActivationAnim;
var TAnimContent DeactivationAnim;
var ParticleSystem PsiSendFX_Soldier;
var ParticleSystem PsiSendFX_Sectoid;
var ParticleSystem PsiSendFX_Ethereal;
var ParticleSystem PsiReceiveFX_Soldier;
var ParticleSystem PsiReceiveFX_Sectoid;
var ParticleSystem PsiReceiveFX_Ethereal;
var const array<AnimSet> AnimSetsToAlwaysApply;
var const array<AnimSet> AnimSetsForDuration;
var const array<Object> AdditionalResources;
var  export editinline ParticleSystemComponent m_kPersistentParticleFX;
var  export editinline ParticleSystemComponent m_arrParticleFXOnCaster[16];
var  export editinline ParticleSystemComponent m_arrTargetParticleFXForDuration[16];
var  export editinline ParticleSystemComponent m_arrTargetParticleFXBurst[16];
var  export editinline ParticleSystemComponent m_arrTargetParticleFXDurationEnded[16];
var  export editinline ParticleSystemComponent m_kParticleFXOnCasterOnDamage;
var  XGUnit m_kUnit;
var  XComUnitPawn m_kPawn;
var  array<XGUnit> m_arrTargets;
var  array<XComUnitPawn> m_arrTargetPawns;
var  XComWeapon m_kWeapon;
var  name m_nmAnim;
var  int m_iDamageLevel;
var  XGUnit m_kPendingCaster;
var  array<XGUnit> m_arrPendingTargets;
var  export editinline array<export editinline ParticleSystemComponent> m_arrBodyShieldComponents;
var  Rotator m_LastBodyShieldRotation;
var private InventoryOperation TempInvOperation;

simulated function StartParticleSystem(XComUnitPawn kPawn, TParticleContent Content, out ParticleSystemComponent kComponent){}
simulated function StartPersistentFX(XComUnitPawn kPawn){}
simulated function OnPawnDeath(){}
simulated function StopPersistentFX(){}
simulated function XComWeapon GetPerkWeapon(){}
simulated function AddPerkTarget(XGUnit kUnit){}
simulated function RemovePerkTarget(XGUnit kUnit){}
simulated function OnPerkActivation(XGUnit kUnit, array<XGUnit> arrTargets, optional bool bSkipRMA){}
simulated function OnPerkDurationEnded(){}
simulated function OnDamaged(XGUnit kUnit, optional int iLevel=1){}
simulated function DoCasterParticleFX(){}
simulated function StopCasterParticleFX(){}
simulated function DoCasterParticleFXOnDamage(){}
simulated function DoTargetParticleFXBurst(){}
simulated function DoTargetParticleFXForDuration(){}
simulated function DoTargetParticleFXForDurationEnded(){}
function ParticleSystem GetPsiSendFXTemplate(XGGameData.ECharacter CharType){}
simulated function ParticleSystem GetPsiReceiveFXTemplate(XGGameData.ECharacter CharType){}
simulated function ParticleSystem GetParticleFXOnTargetForDurationTemplate(){}
simulated function AddAnimSetsToPawn(XComUnitPawn kPawn){}
simulated function UpdateDurationAnimSets(XComUnitPawn kPawn){}
simulated function bool IsActivated(){}
static function name ChooseAnimationForCover(XGUnit kUnit, name NoCover, name LowCover, name HighCover){}
simulated function BodyShieldTick(float fDelta){}
simulated function PerkFinished(ParticleSystemComponent PSystem){}
simulated state PerkActivation{}
simulated state PerkTakeDamage{}
simulated state PerkDeactivation{
    simulated event EndState(name nmNext){}
}
