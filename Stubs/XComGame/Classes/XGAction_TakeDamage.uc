class XGAction_TakeDamage extends XGAction
    native(Action)
    nativereplication
    notplaceable
    hidecategories(Navigation);
//complete stub

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

var EAnimAction m_eAnimToPlay;
var ETakeDamageActionStatus m_eTakeDamageStatus;
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
var bool m_bInitialReplicationDataReceived_XGAction_TakeDamage;
var repnotify InitialReplicationData_XGAction_TakeDamage m_kInitialReplicationData_XGAction_TakeDamage;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_TakeDamage;
}
static final simulated function string InitialReplicationData_XGAction_TakeDamage_ToString(const out InitialReplicationData_XGAction_TakeDamage kInitRepData){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function bool InternalIsInterruptibleBy(class<XGAction> kActionClass){}
function bool Init(XGUnit kUnit, XGUnit kDamageDealer, int iDamage, class<DamageType> kDamageType, Vector vHitLocation, Vector vMomentum, Actor kDamageCauser, optional int iShieldDamage=0){}
function bool CanBePerformed(){}
simulated function bool ShouldPlayAnimation(){}
simulated function EAnimAction ComputeAnimationToPlay(optional int iShieldDamage=0){}
simulated event Tick(float DeltaTime){}
simulated function string GetDebugHangLog(){}
simulated function bool ShouldUseStrangleStopToGround(){}

simulated state Executing
{
    simulated event BeginState(name nmPrevState){}
}

