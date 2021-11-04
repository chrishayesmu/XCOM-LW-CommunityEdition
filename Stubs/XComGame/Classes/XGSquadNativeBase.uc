class XGSquadNativeBase extends Actor
    native(Unit);
//complete stub

const MaxUnitCount = 128;

struct CheckpointRecord
{
    var XGUnit m_arrPermanentMembers[128];
    var int m_iNumPermanentUnits;
    var int m_iNumCloseUnits;
    var string m_strName;
    var string m_strMotto;
    var Color m_clrColors;
    var XGPlayer m_kPlayer;
    var int m_iCloseCombatInit;
    var XGUnit m_arrUnits[128];
    var int m_iNumUnits;
    var ETeam m_eTeam;
    var bool m_bHasSeenOtherTeam;
    var int m_iLeader;
};

var repnotify XGUnit m_arrPermanentMembers[128];
var repnotify int m_iNumPermanentUnits;
var int m_iNumCloseUnits;
var string m_strName;
var string m_strMotto;
var Color m_clrColors;
var XGPlayer m_kPlayer;
var int m_iCloseCombatInit;
var repnotify XGUnit m_arrUnits[128];
var repnotify int m_iNumUnits;
var bool m_bHasSeenOtherTeam;
var int m_iLeader;


simulated event int GetNumMembers() {}
simulated event XGUnit GetMemberAt(int iIndex) {}
// Export UXGSquadNativeBase::execGetNumDead(FFrame&, void* const)
native simulated function int GetNumDead();

// Export UXGSquadNativeBase::execGetNumDeadOrCriticallyWounded(FFrame&, void* const)
native simulated function int GetNumDeadOrCriticallyWounded();

// Export UXGSquadNativeBase::execGetNumAliveAndWell(FFrame&, void* const)
native simulated function int GetNumAliveAndWell();

// Export UXGSquadNativeBase::execSquadCanSeeEnemy(FFrame&, void* const)
native simulated function bool SquadCanSeeEnemy(XGUnit kEnemy);

// Export UXGSquadNativeBase::execSquadHasStarOfTerra(FFrame&, void* const)
native simulated function bool SquadHasStarOfTerra(bool PowerA);
simulated function SetHasSeenOtherTeam(){}

// Export UXGSquadNativeBase::execGetSquadLeader(FFrame&, void* const)
native simulated function XGUnit GetSquadLeader();

// Export UXGSquadNativeBase::execSetSquadLeader(FFrame&, void* const)
native function SetSquadLeader(int iNewLeaderIndex);
