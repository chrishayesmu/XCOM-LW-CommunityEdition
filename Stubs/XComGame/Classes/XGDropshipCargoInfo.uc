class XGDropshipCargoInfo extends Actor
	DependsOn(XGBattleDesc);

//complete stub

var array<int> m_arrTechHistory;
var array<TTransferSoldier> m_arrSoldiers;
var TTransferSoldier m_kCovertOperative;
var bool m_bHasCovertOperative;
var bool m_bNeedAlien;
var bool m_bNeedOutsider;
var bool m_bAllPointsHeld;
var bool m_bAlienDiedByExplosive;
var array<int> m_arrArtifacts;
var TMissionReward m_kReward;
var int m_iBattleResult;
var int m_iCiviliansSaved;
var int m_iCiviliansTotal;
var XGNarrative m_kNarrative;

function PostLoadFromCombat();

DefaultProperties
{
}
