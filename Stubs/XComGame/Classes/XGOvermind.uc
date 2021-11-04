class XGOvermind extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<XGPod> m_arrPods;
    var array<XGPod> m_arrActivePods;
    var array<XGPod> m_arrControlledPods;
    var XGLayout m_kLayout;
    var XGDeployAI m_kDeploy;
    var XGEnemy m_kEnemy;
    var array<XGHuntTarget> m_arrHuntTargets;
    var array<TAlienSpawn> m_arrSpawns;
    var int m_iTurnsSinceContact;
    var int m_iTurnsSinceCall;
    var bool m_bConverged;
    var array<XGUnit> m_arrVisibleEnemies;
    var Vector m_vEnemySpawn;
    var Vector m_vPlay;
    var int m_iDeflection;
    var name m_strState;
    var float m_fPlayDist;
    var XComWaveSystem m_kWaveSystem;
};

var array<XGPod> m_arrPods;
var array<XGPod> m_arrActivePods;
var array<XGPod> m_arrControlledPods;
var XGLayout m_kLayout;
var XGDeployAI m_kDeploy;
var XGEnemy m_kEnemy;
var array<XGHuntTarget> m_arrHuntTargets;
var array<TAlienSpawn> m_arrSpawns;
var int m_iTurnsSinceContact;
var int m_iTurnsSinceCall;
var bool m_bConverged;
var array<XGUnit> m_arrVisibleEnemies;
var Vector m_vEnemySpawn;
var Vector m_vPlay;
var int m_iDeflection;
var name m_strState;
var float m_fPlayDist;
var XComCapturePointVolume m_kActiveCapPoint;
var XComWaveSystem m_kWaveSystem;

function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
function array<XGPod> BeginTurn(){}
function array<XGPod> Update(){}
function array<XGPod> OnReveal(XGPod kPod, XGUnit kRevealedTo){}
function array<XGPod> OnRevealComplete(XGPod kPod, XGUnit kRevealedTo){}
function array<XGPod> OnSound(Vector vSoundLoc, XGUnit kSoundMaker, optional bool bMoving){}
function array<XGPod> OnMimicBeacon(Vector vLoc){}
function bool IsValidPodForMimicBeacon(XGPod kPod, Vector vLoc){}
function OnEnemiesAppeared(array<XGEnemyUnit> arrEnemies){}
function OnEnemiesInvalidated(array<XGEnemyUnit> arrEnemies){}
function OnEnemiesDisappeared(array<XGEnemyUnit> arrEnemies){}
function OnHuntCompleted(XGHuntTarget kHunt){}
function OnPodSpawned(int iSpawn, array<XGUnit> arrAliens, optional bool bFromSpawnList=true){}
function AddControlledPod(XGUnit kControlled){}
function ValidatePodIDs(){}
function int GetNextUniquePodID(){}
function EndTurn(){}
function Clear(){}
function array<XGPod> GetPods(){}
function XGPod GetPod(XGUnit kAIUnit){}
function UpdatePods(){}
function CheckForPodsLeftBehind(){}
function float ParamaterizePosition(Vector vPos){}
function UpdatePodVisibility(){}
function bool DoReinforcementsExist(){}
function RemovePod(XGPod kPod){}
function array<XGUnit> GetAliens(){}
function BuildVisibility(){}
function Init(out array<TAlienSpawn> arrSpawns){}
function InitWaveSystem(){}
function int ToggleDeflection(){}
function CalcMapDirection(out array<TAlienSpawn> arrSpawn){}
function CalcPlayDist(){}
function HandleEnemyEvents(){}
function HuntEnemies(array<XGEnemyUnit> arrEnemies){}
function InvalidateHuntedEnemies(array<XGEnemyUnit> arrEnemies){}
function InvalidateFightingEnemies(array<XGEnemyUnit> arrEnemies){}
function ClearFights(){}
function UpdateHuntTargets(){}
function RemoveHuntTarget(XGHuntTarget kTarget){}
function XGHuntTarget CreateHuntTarget(Vector vLocation, int iTurnsLeft, bool bSearch, optional array<XGEnemyUnit> arrEnemies, optional bool bMimicBeacon){}
function AddHuntTarget(XGHuntTarget kNewTarget){}
function ClearSearchTargets(){}
function CheckForPatrolActivation(Vector vLocation){}
function bool Enabled(){}
function SetHunter(XGPod kHunter, XGHuntTarget kTarget){}
function ResetHunt(array<XGPod> arrHunters){}
function XGPod GetClosestPod(Vector vPoint, array<XGPod> arrPods, optional bool bMimicBeacon){}
function BeginSearch(array<XGPod> arrHunters){}
function UpdateGoal(){}
function BuildActivePodList(){}
function SetNewGoal(name nmNewGoal){}
function BeginGoalTurn(){};
function BeginMission(){}
function DetermineTactics(){}
function AbortInvalidTactics(){}
function DetermineAbductionTactics(){}
function bool UpdateActiveCapturePoint(){}
function DetermineHQAssaultTactics(){}
function DetermineCaptureAndHoldTactics(){}
function DetermineCovertExtractionTactics(){}
function int SortPodsToSpawn(XGPod kPod1, XGPod kPod2){}
function DetermineUFOTactics(){}
function Converge(){}
function MakeSounds(optional XGPod kCaller){}
function array<XGPod> GetIdlePods(){}
function array<XGPod> GetPotentialHunters(){}
static function ClearDummyCharFromSpawnList(out array<TAlienSpawn> arrPodList){}
function ClearDummyCharType(){}
function bool HasWaves(){}
function UpdateWaves(bool bBeginningOfTurn){}

state OvermindGoal{
	event BeginState(name PreviousStateName);
	event EndState(name PreviousStateName);
    function UpdateGoal(){}
}
state Hunt extends OvermindGoal{

    event BeginState(name nmPrevState){}
    function CheckForLastLurk(){}
    function bool CheckForHuntReset(){}
    function UpdateHunt(){}
    function UpdateGoal(){}
}

state Fight extends OvermindGoal{
    event BeginState(name nmPrevState){}
    event EndState(name nmNextState){}
    function array<XGEnemyPod> GetPodTargets(XGPod kPod){}
    function ClearFights(){}
    function array<XGPod> AssembleFighters(){}
    function array<XGPod> GetFighters(){}
    function bool CheckForConverge(XGPod kPod){}
    function CreateFight(XGPod kPod){}
    function Retreat(XGPod kPod){}
    function SeekFight(XGPod kPod, XGEnemyUnit kEnemy){}
    function SeekToFights(array<XGPod> arrSeekers){}
    function BeginGoalTurn(){}
    function UpdateFights(){}
    function UpdateGoal(){}
}
