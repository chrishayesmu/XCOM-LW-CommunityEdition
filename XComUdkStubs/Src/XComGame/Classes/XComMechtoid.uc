class XComMechtoid extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var string m_strShieldFX;
var string m_strShieldDissolveFX;
var() ParticleSystem ShieldFX;
var() ParticleSystem ShieldDissolveFX;
var export editinline ParticleSystemComponent m_kShieldFX;
var export editinline ParticleSystemComponent m_kShieldDissolveFX;
var() XComPawnPhysicsProp SectoidCorpseTemplate;
var XComPawnPhysicsProp SectoidCorpse;
var bool m_bShieldFXActive;

defaultproperties
{
    m_strShieldFX="FX_CH_Mechtoid.P_Mectoid_Merge_Shield_Persistent"
    m_strShieldDissolveFX="FX_CH_Mechtoid.P_Mectoid_Merge_Shield_Dissolve"
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Never
}