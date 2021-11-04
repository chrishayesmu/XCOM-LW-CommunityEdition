class XComFiredProjectileList extends Actor
    native(Weapon);
//complete stub

struct native TXComFiredProjectileListNode
{
    var XComProjectile m_kNextFiredProjectile;
    var bool m_bNextFiredProjectileNone;
    var XComProjectile m_kPrevFiredProjectile;
    var bool m_bPrevFiredProjectileNone;
    var int m_iIndexInList;
};

var repnotify XComProjectile m_kServerHead;
var repnotify XComProjectile m_kServerTail;
var XComProjectile m_kClientHead;
var XComProjectile m_kClientTail;
var int m_iNumServerProjectiles;
var int m_iNumClientProjectiles;
var bool m_bHasDeadProxies;
var bool m_bBeginTearOffCountdown;
var bool m_bBeginDestroyCountdown;
var bool m_bCreatedFromFireAction;
var bool m_bFireActionDoneAddingProjectiles;
var float m_fTearOffTimer;
var float m_fDestroyTimer;
var float m_fProcessProjectilesTimer;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_iNumServerProjectiles, m_kServerHead, 
        m_kServerTail;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool IsEmpty(){}
final function AddProjectileToServerListEnd(XComProjectile kProjectile){}
final simulated function AddProjectileToClientListEnd(XComProjectile kProjectile){}
private final simulated function AddProjectileToListEnd(XComProjectile kProjectile, out XComProjectile kHead, out XComProjectile kTail, out int iNumProjectiles){}
simulated function ProcessAllProjectiles(){}
private final simulated function bool CheckAllProjectilesExploded(XComProjectile kListHead, out array<XComProjectile_DeadProxy> arrDeadProxies){}
simulated event Tick(float DeltaTime){}
simulated event TornOff(){}
simulated event Destroyed(){}
simulated function string ToString(){}
private final simulated function string ToStringHelper(const out XComProjectile kHead, const out XComProjectile kTail, string strPrefix){}
