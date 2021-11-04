class XGAIPlayer_Animal extends XGAIPlayer
    native(AI)
    notplaceable
    hidecategories(Navigation);
//complete stub

const MAX_SPAWN_DIST_FROM_PODS = 960;

var bool m_bSkipAnimals;
var bool m_bSpawningSurvivor;
var array<XGUnit> m_akMovingUnit;
var(Terror) array<XGUnit> m_arrCivilian;
var(Terror) int m_nDeadCivilians;
var(Terror) int m_nLiveCivilians;
var(Terror) int m_nSavedCivilians;
var(Terror) int m_nHiddenCivilians;
var(Terror) array<XGUnit> m_arrHiddenCivilian;
var(Salvage) array<XGUnit> m_arrSurvivor;
var array<Vector> m_arrPodLoc;
var const localized string m_strCivilianSaved;
var const localized string m_strSurvivorRescued;
//var delegate<CoverValidator> __CoverValidator__Delegate;

delegate bool CoverValidator(Vector vCoverLoc, XComCoverPoint kPoint);
function Init(optional bool bLoading){}
simulated function LoadInit(){}
simulated function class<XGAIBehavior> AlienTypeToBehaviorClass(XGGameData.EPawnType eAlienType){}
simulated function UpdateCivilianCounts(){}
simulated function int GetRemainingCivilians(){}
function ExecuteRandomCivilian(int iNum){}
function int TerrorMap_GetZombifyChance(){}
simulated function bool HasSurvivors(){}
simulated function bool ValidateRunToLocation(Vector vLoc){}
function OnUnitSeen(XGUnit MyUnit, XGUnit EnemyUnit){}
simulated function bool OnUnitEndMove(XGUnit kUnit){}
simulated function DrawDebugLabel(Canvas kCanvas){}
simulated function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<XGGameData.EPawnType> arrPawnTypes){}
simulated function CreateSquad(array<XComSpawnPoint> arrSpawnPoints, array<XGGameData.EPawnType> arrPawnTypes){}
simulated function InitializeCivilians(){}
function XGUnit SpawnCivilian(XComSpawnPoint kSpawnPoint, optional bool bFemale, optional bool bAddFlag){}
function XGUnit SpawnCivilianAt(Vector vLocation, optional bool bFemale, optional bool bAddFlag){}
simulated function bool IsValidLocationToPods(XComCoverPoint kPoint, Vector vLoc, optional float fCloseRangeSq=Square(320.0), optional float fOuterRangeSq=Square(960.0)){}
simulated function bool CivilianStartPointValidator(Vector vLocation, XComCoverPoint kPoint){}
function SpawnCivilians(int iNumCiviliansToSpawn){}
simulated function bool IsWithinSquadMemberArea(Vector vLoc, XGSquad kSquad, float fDist){}
simulated function Vector DecideNextDestination(XGUnit kUnit){}
simulated function Attack(XGUnit kAttacker, XGUnit kEnemy);
simulated function UpdateProximityList(){}
simulated function InitTurn(){}
simulated function UpdateActiveUnits(optional bool bCheckAllActive){}
simulated function ResetBadCover(){}
simulated function bool UpdateCameraLookat(XGUnit kUnit, optional bool bPop){}
simulated function UpdateEnemiesList(){}
simulated function bool UpdateTacticalDestinations(optional bool bColdReset, optional bool bUseUnseenEnemies, optional XGUnit kUnit, optional bool bLogging){}
simulated function bool GetGoodCoverPoints(out array<ai_cover_score> arrOutCover, optional out array<XComCoverPoint> arrFlank, optional out array<ai_cover_score> arrOutTerror, optional out array<ai_cover_score> arrOutHidden, optional XGUnit kUnit, optional bool bUseUnseenEnemies, optional bool bLogging){}
simulated function bool DefaultCoverValidator(Vector vCoverLoc, XComCoverPoint kPoint){}
simulated function bool GetGoodCoverPoints_Civilian(out array<ai_cover_score> arrOutCover, optional out array<XComCoverPoint> arrFlank, optional bool bForSpawning, optional delegate<CoverValidator> dCoverValid, optional XGUnit kUnit){}
simulated function int CalculateCoverScore(out ai_cover_score kScore, optional XGUnit kUnit){}
simulated function int CalculateDestinationScore(out ai_cover_score kScore, optional XGUnit kUnit, optional bool bVis=true){}
function FireBeginTurnKismetEvent(){}
function FireEndingTurnKismetEvent(){}
simulated function XGUnit GetReactingSoldier(XGUnit kActingUnit){}
simulated function bool WaitingForSquadActions(){}

simulated state BeginningTurn
{}

simulated state Active
{
	    simulated function bool EndTurn(XGGameData.EPlayerEndTurnType eEndTurnType){}
}
auto simulated state Inactive
{
    simulated function BeginTurn(){}
}

state ExecutingAI
{}

state MoveRandom
{}

state EndOfTurn
{}



