class XGCharacter_BattleScanner extends XGCharacter
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationInfo_XGCharacter_BattleScanner
{
    var Vector m_vLocation;
    var ETeam m_eTeamVisibilityFlags;
    var bool m_bReplicateFlipFlop;
};

var repnotify InitialReplicationInfo_XGCharacter_BattleScanner m_kInitialReplicationInfo_XGCharacter_BattleScanner;
var privatewrite bool m_bInitialReplicationInfoReceived_XGCharacter_BattleScanner;

defaultproperties
{
    m_eType=ePawnType_BattleScanner
    m_kUnitPawnClassToSpawn=class'XComBattleScanner'
}