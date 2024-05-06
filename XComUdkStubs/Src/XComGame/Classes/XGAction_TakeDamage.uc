class XGAction_TakeDamage extends XGAction
    native(Action)
    nativereplication
    notplaceable
    hidecategories(Navigation);

enum ETakeDamageActionStatus
{
    ETDAS_None,
    ETDAS_Begin,
    ETDAS_ShouldPlayAnim,
    ETDAS_NeuralFeedbackHurt,
    ETDAS_Strangling,
    ETDAS_PostStrangleMove,
    ETDAS_HurtAnim,
    ETDAS_Done,
    ETDAS_MAX
};

struct native InitialReplicationData_XGAction_TakeDamage
{
    var XGUnitNativeBase m_kDamageDealer;
    var bool m_bDamageDealerNone;
    var Actor m_kDamageCauser;
    var bool m_bDamageCauserNone;
    var int m_iDamage;
    var int m_iShieldDamage;
    var class<DamageType> m_kDamageType;
    var Vector m_vHitLocation;
    var Vector m_vMomentum;
    var bool HACK_bPsiRollDamageProjectile;
    var bool HACK_bPsiLanceDamageProjectile;
};

var XComAnimNodeBlendByAction.EAnimAction m_eAnimToPlay;
var XGAction_TakeDamage.ETakeDamageActionStatus m_eTakeDamageStatus;
var XGUnit m_kDamageDealer;
var Actor m_kDamageCauser;
var XComProjectile m_kDamageCauserProjectile;
var int m_iDamage;
var int m_iShieldDamage;
var class<DamageType> m_kDamageType;
var Vector m_vHitLocation;
var Vector m_vMomentum;
var transient AnimNodeSequence tmpAnimSequence;
var bool m_bWasStrangling;
var bool HACK_bPsiRollDamageProjectile;
var bool HACK_bPsiLanceDamageProjectile;
var private bool m_bInitialReplicationDataReceived_XGAction_TakeDamage;
var private repnotify repretry InitialReplicationData_XGAction_TakeDamage m_kInitialReplicationData_XGAction_TakeDamage;