class XComFiredProjectileList extends Actor
    native(Weapon)
    notplaceable
    hidecategories(Navigation);

const TICK_PROCESS_PROJECTILES_INTERVAL_SECONDS = 3.0f;

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
var privatewrite int m_iNumServerProjectiles;
var privatewrite int m_iNumClientProjectiles;
var bool m_bHasDeadProxies;
var bool m_bBeginTearOffCountdown;
var bool m_bBeginDestroyCountdown;
var bool m_bCreatedFromFireAction;
var bool m_bFireActionDoneAddingProjectiles;
var privatewrite float m_fTearOffTimer;
var privatewrite float m_fDestroyTimer;
var privatewrite float m_fProcessProjectilesTimer;

defaultproperties
{
    m_fTearOffTimer=5.0
    m_fDestroyTimer=10.0
    m_fProcessProjectilesTimer=3.0
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}