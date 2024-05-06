class XGBattle_SP extends XGBattle
    abstract
    native(Core)
    notplaceable
    hidecategories(Navigation);

const REINFORCEMENT_START = 3;

struct CheckpointRecord_XGBattle_SP extends CheckpointRecord
{
    var bool m_bAchivementsEnabled;
    var int m_iCurePoison;
    var bool m_bAchievementsDisabledXComHero;
    var bool m_bMissionAlreadyWon;
    var int m_iBlueshirtKills;
};

var bool m_bInCinematic;
var bool m_bAchivementsEnabled;
var bool m_bAbandoned;
var bool m_bAchievementsDisabledXComHero;
var bool m_bMissionAlreadyWon;
var int m_iCurePoison;
var int m_iBlueshirtKills;

defaultproperties
{
    m_bAchivementsEnabled=true
    m_kBattleResultClass=class'XGBattleResult_SP'
}