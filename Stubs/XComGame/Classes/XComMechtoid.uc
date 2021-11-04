class XComMechtoid extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var string m_strShieldFX;
var string m_strShieldDissolveFX;
var() ParticleSystem ShieldFX;
var() ParticleSystem ShieldDissolveFX;
var export editinline ParticleSystemComponent m_kShieldFX;
var export editinline ParticleSystemComponent m_kShieldDissolveFX;
var() XComPawnPhysicsProp SectoidCorpseTemplate;
var XComPawnPhysicsProp SectoidCorpse;
var bool m_bShieldFXActive;

simulated event PostBeginPlay(){}
simulated function OnKilledByKineticStrike(){}
simulated function ActivateShield(optional bool bForce){}
simulated function DeactivateShield(){}
simulated function UpdateShield(int iCurrShieldHP){}
simulated function OnParticleSystemFinished(ParticleSystemComponent PSC){}

simulated state DeactivatingShield
{
}
