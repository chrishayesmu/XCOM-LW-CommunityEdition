class XGPod extends XGOvermindActor;
//complete stub

struct CheckpointRecord
{
    var array<XGUnit> m_arrMembers;
    var array<XGTactic> m_arrOldTactics;
    var XGTactic m_kCurrentTactic;
    var TAlienSpawn m_kSpawnInfo;
    var EPodAnimation m_eAnim;
    var bool m_bGathered;
    var bool m_bRetreated;
    var int m_iNumLost;
    var int m_iTurnsSinceVisible;
    var int m_iPodID;
    var bool m_bCalledReinforcements;
};

var array<XGUnit> m_arrMembers;
var array<XGTactic> m_arrOldTactics;
var XGTactic m_kCurrentTactic;
var TAlienSpawn m_kSpawnInfo;
var EPodAnimation m_eAnim;
var bool m_bGathered;
var bool m_bRetreated;
var bool m_bCalledReinforcements;
var int m_iNumLost;
var int m_iTurnsSinceVisible;
var int m_iPodID;

function XGManeuver GetNextManeuver(){}
function OnManeuverCompleted(XGManeuver kManeuver, bool bSuccessfully)
{}
function AbandonTactic()
{}
function CompleteTactic()
{}
function XGTactic GetTactic()
{}
function SetTactic(XGTactic kNewTactic)
{}
function Vector GetLocation()
{}
function bool HasMoves()
{}
function float GetMoveDistRemaining()
{}
function bool HasMember(XGUnit kUnit)
{}
function EPodAnimation GetIdleAnim()
{}
function EManeuverType GetRevealManeuver()
{}
function bool Validate(optional bool bIsAlreadyInControlledPod=FALSE)
{}
function bool CanSeeEnemy(XGEnemyPod kEnemyPod)
{}
function bool IsSeenByEnemy()
{}
function array<XGEnemyUnit> GetVisibleEnemies()
{}
function XGEnemyUnit GetClosestVisibleEnemy()
{}
function float GetMoveDistance()
{}
function float GetSightRadius()
{}
function bool MustLurk()
{}
function bool ShouldConvergeOnFight()
{}
function MakeSounds()
{}
function bool ShouldRetreat()
{}
function XGPod GetRetreatTarget()
{}
function bool CanRetreat()
{}
event Destroyed()
{}

DefaultProperties
{
}
