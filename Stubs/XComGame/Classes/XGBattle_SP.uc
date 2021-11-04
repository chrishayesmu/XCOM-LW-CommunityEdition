class XGBattle_SP extends XGBattle
    abstract
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

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

function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
simulated function PostLoadSaveGame(){}
function InitResults(){}
function UninitResults(){}
function InitDescription(){}
function UninitDescription(){}
simulated function InitLevel(){}
simulated function PostLevelLoaded(){}
function InitMeldContainers(){}
function InitCapturePoints(){}
function InitPlayers(optional bool bLoading=false){}
simulated function SaveHQAssaultReinforcements(XGPlayer kPlayer, array<TTransferSoldier> Reinforcements){}
function AlienPlayerDeferredInit(){}
function int GetDifficulty(){}
function XGBattleDesc GetDesc(){}
function array<XComSpawnPoint> GetSpawnPoints(ETeam eUnitTeam, optional int iNumSpawnPoints){}
function array<XComSpawnPoint> GetAnimalSpawnPoints(){}
function array<XComSpawnPoint> GetCivilianSpawnPoints(){}
function array<XComSpawnPoint> GetLootSpawnPoints(){}
function InitVisiblity(){}
function InitLoadedItems(){}
function UpdateVisibility(){}
simulated function XGSquad GetEnemySquad(XGPlayer kPlayer){}
simulated function XGPlayer GetEnemyPlayer(XGPlayer kPlayer){}
function bool TurnIsComplete(){}
function bool ReadyForNewTurn(){}
function BeginNewTurn(optional bool bIsLoading){}
final function UpdateMeldCountdowns(){}
function CheckForVictory(optional bool bIgnoreBusy){}
function bool IsVictory(bool bIgnoreBusyCheck){}
function bool IsDefeat(){}
function TTransferSoldier BuildReturningDropshipSoldier(XGUnit kSoldier, bool bFirstSoldier){}
function PutSoldiersOnDropship(){}
function CompleteCombat(){}
function XGBattleResult_SP GetResults(){}
simulated function XGPlayer GetLocalPlayer(){}
function XGPlayer GetHumanPlayer(){}
function XGPlayer GetAIPlayer(){}
function XGPlayer GetAnimalPlayer(){}
function bool PlayerCanSave(){}
function bool PlayerCanAbort(){}
function HideCiviliansNearLoc(Vector vHideLoc, float fSafeDistance){}
simulated function XComPresentationLayer PRES(){}
simulated function XGBattleDesc Desc(){}
function UpdateRandomSpawns(int iTurnsIdle, int iUnitsActive){}
static function bool IsExaltMap(){}
function AddBlueshirtKills(int iKills){}
state Running
{
	event BeginState(name PrevState){}
    simulated event Tick(float fDeltaT){}
    function DebugLogHang(){}
    function bool IsPaused(){}
}
state IntroUI
{}
state OuttroUI
{
	simulated event Tick(float fDeltaT){}
    simulated function bool VolunteerIsMine(bool bMakeItMine){}
    simulated function bool VolunteerIsHiding(bool bStartUnhide){}
    simulated function ShowFinalNarrativeMoment(){}
    simulated function AddVolunteerToMatinee(){}
    simulated function PrepUnitForMatinee(XComHumanPawn kPawn, bool isVolunteer){}
    simulated function SendPawnToKismet(XComHumanPawn kVolunteer, XComHumanPawn kSoldier1, XComHumanPawn kSoldier2){}
    simulated function GetVolunteerPawns(out XComHumanPawn kVolunteer, optional out XComHumanPawn kSoldier1, optional out XComHumanPawn kSoldier2, optional bool bHideOthers){}
    simulated function FinishedFinalNarrativeMoment(){}
}
state AbortMissionCheck
{
    function AbandonBattle(bool bAbandon){}
    function bool ShouldShowAbortDialog(){}
}
state EndTurnUI
{}



