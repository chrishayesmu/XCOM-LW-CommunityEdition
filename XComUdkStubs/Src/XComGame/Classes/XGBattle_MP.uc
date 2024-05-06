class XGBattle_MP extends XGBattle
    notplaceable
    hidecategories(Navigation);

struct TCharacterTypesUsedInfo
{
    var byte m_arrCharacterTypesUsed[ECharacter];
};

var protectedwrite array<XComMPTacticalController> m_arrGameCoreInitializedClients;
var protectedwrite array<XComMPTacticalController> m_arrInitializedClients;
var protectedwrite array<XComMPTacticalController> m_arrRunningClients;
var private XComMPTacticalController m_kCachedLocalPC;
var protectedwrite int m_iMaxTurnTimeSeconds;
var protectedwrite float m_fTurnTimeLeftSeconds;
var protectedwrite int m_iTurnTimeLeftSeconds;
var protectedwrite repnotify int m_iReplicatedTurnTimeLeftSeconds;
var protectedwrite int m_iReplicatedTurnTimeThresholdSeconds;
var private int m_iLastTurnTimeLeftSeconds;
var private int m_iTurnTimeBeepThresholdSeconds;
var privatewrite bool m_bTurnComplete;
var privatewrite bool m_bCharacterTypesUsedInfoReceived;
var repnotify TCharacterTypesUsedInfo m_kCharacterTypesUsedInfo;

defaultproperties
{
    m_iReplicatedTurnTimeThresholdSeconds=2
    m_iTurnTimeBeepThresholdSeconds=11
    m_bShowLoadingScreen=false
    m_bPlayCinematicIntro=false
    m_bAllowItemFragments=false
    m_kBattleResultClass=class'XGBattleResult_SP'
}