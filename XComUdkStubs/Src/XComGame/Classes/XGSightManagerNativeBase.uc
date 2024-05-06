class XGSightManagerNativeBase extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

const SIGHT_MGR_MAX_VISIBLE_ENEMIES = 16;
const SIGHT_MGR_MAX_VISIBLE_CIVILIANS = 32;

enum EEnemyReveal
{
    eER_FirstTimeCharacter,
    eER_FirstTimeUnit,
    eER_AlreadySeen,
    eER_MAX
};

struct CheckpointRecord
{
    var XGPlayer m_kPlayer;
};

var init privatewrite array<init XGUnit> m_arrVisibleEnemies;
var init privatewrite array<init XGUnit> m_arrVisibleCivilians;
var private repnotify const XGUnitNativeBase m_arrVisibleEnemiesReplicated[16];
var private const int m_iNumVisibleEnemiesReplicated;
var private repnotify const XGUnitNativeBase m_arrVisibleCiviliansReplicated[32];
var private const int m_iNumVisibleCiviliansReplicated;
var protected repnotify XGPlayer m_kPlayer;
var bool m_bCanSeeAllEnemies;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}