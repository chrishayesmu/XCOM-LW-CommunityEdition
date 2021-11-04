class XGCharacter_BattleScanner extends XGCharacter
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationInfo_XGCharacter_BattleScanner
{
    var Vector m_vLocation;
    var ETeam m_eTeamVisibilityFlags;
    var bool m_bReplicateFlipFlop;
};

var repnotify InitialReplicationInfo_XGCharacter_BattleScanner m_kInitialReplicationInfo_XGCharacter_BattleScanner;
var bool m_bInitialReplicationInfoReceived_XGCharacter_BattleScanner;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationInfo_XGCharacter_BattleScanner;
}

simulated event ReplicatedEvent(name VarName){}
simulated function bool IsInitialReplicationComplete(){}
simulated event PostBeginPlay(){}
simulated function TimerOnInitialReplicationComplete_InitBattleScannerUnit(){}
