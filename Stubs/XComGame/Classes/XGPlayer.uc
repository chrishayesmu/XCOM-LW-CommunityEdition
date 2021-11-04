class XGPlayer extends XGPlayerNativeBase
    native(Core)
    notplaceable
    dependsOn(XGTacticalGameCoreNativeBase);

//complete stub

struct CheckpointRecord
{
    var XGSquad m_kSquad;
    var array<XGUnit> m_arrEnemiesSeen;
    var array<EPawnType> m_arrPawnsSeen;
    var array<int> m_arrTechHistory;
    var int m_iTurn;
    var int m_iHitCounter;
    var int m_iMissCounter;
    var int m_iNumOneShots;
    var bool m_bCantLose;
    var XGUnit m_kActiveUnit;
};

struct native PendingSpawnUnit
{
    var XGCharacter_Soldier kNewChar;
    var XComSpawnPoint kSpawnPoint;
    var int iContentRequests;
    var delegate<UnitSpawnCallback> Callback;
    var bool bVIP;
};

var XGSquad m_kSquad;
var array<XGUnit> m_arrEnemiesSeen;
var repnotify XGSightManager m_kSightMgr;
var array<EPawnType> m_arrPawnsSeen;
var XGUnit m_kActiveUnit;
var int m_iTurn;
var int m_iHitCounter;
var int m_iMissCounter;
var int m_iNumOneShots;
var bool m_bCantLose;
var bool m_bWaitingForNextPreviousUnitServerAck;
var bool m_bAcknowledgedSound;
var bool m_bLoadedFromCheckpoint;
var repnotify bool m_bPushStatePanicking;
var bool m_bPopStatePanicking;
var bool m_bMyTurn;
var bool m_bAbortChecked;
var bool m_bCheckForEndTurnOnLoad;
var bool m_bKismetControlledCombatMusic;
var int m_iClientBeginTurn;
var int m_iClientEndTurn;
var EPlayerEndTurnType m_ePlayerEndTurnType;
var array<int> m_arrTechHistory;
var XComUIBroadcastWorldMessage m_kBroadcastWorldMessage;
var PendingSpawnUnit m_kPendingSpawnUnit;
var int m_iLoop;
var XGUnit m_kLoopUnit;
var float m_fEndTurnCancelTargetingActionsTimeoutSeconds;
//var delegate<UnitSpawnCallback> __UnitSpawnCallback__Delegate;

delegate UnitSpawnCallback(XGUnit SpawnedUnit);
function CreateCheckpointRecord();
function ApplyCheckpointRecord(){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool IsInitialReplicationComplete(){}
reliable client simulated function ClientOnFirstGameTurn(bool bActivePlayer);
simulated function class<XGAIBehavior> GetBehaviorClass(EPawnType eAlienType){}
simulated function InitBehavior(XGUnit kUnit){}
function SetPlayerController(XComTacticalController PlayerController){}
simulated function SetSightMgr(XGSightManager kSightMgr){}
simulated function XGSightManager GetSightMgr(){}
simulated function bool IsEnemyUnitVisibleFromPos(XGUnit kTarget, Vector vPoint, optional bool bCheckBothWays, optional bool bIgnoreHidden){}
simulated function bool IsEnemyUnitVisibleFromTile(int TileX, int TileY, int TileZ, int AltZ, optional bool bIgnoreHidden){}
native function bool TestUnitCoverExposure(XComCoverPoint kTestCover, XGUnitNativeBase kEnemy, optional out float fDot, optional bool bDrawLines);
function bool IsCoverExposed(XComCoverPoint kTestCover, XGUnit kEnemy, const out array<XGUnit> arrEnemies, optional out float fDot, optional bool bDrawLines){}
simulated function GetAllEnemies(out array<XGUnit> arrEnemies){}
function bool CanAttackLocation(Vector vLoc){}
simulated function UpdateVisibility(){}
simulated function GetVisibleEnemies(out array<XGUnit> arrVisibleEnemies, optional bool bEngagedOnly, optional bool bIgnoreWounded=true){}
simulated function SetActiveUnit(XGUnit kNewActive, optional int iBindToClientProxyID=-1){}
simulated function XGUnit GetActiveUnit(){}
simulated function bool NextPreviousUnit(bool bNext, optional int iBindToClientProxyID=-1, optional XGUnit kOverrideTargetUnit){}
simulated function bool NextUnit(optional int iBindToClientProxyID=-1, optional XGUnit kOverrideTargetUnit){}
reliable server function ServerNextUnit(optional int iBindToClientProxyID=-1, optional XGUnit kOverrideTargetUnit){}
reliable client simulated function ClientNextPreviousUnitAck(bool bNextPrevSuccess, XGUnit kNextPreviousUnit){}
simulated function bool PreviousUnit(optional int iBindToClientProxyID=-1, optional XGUnit kOverrideTargetUnit){}
reliable server function ServerPreviousUnit(optional int iBindToClientProxyID=-1, optional XGUnit kOverrideTargetUnit){}
simulated function bool IsTurnDone(){}
simulated function XGSquad GetSquad(){}
event XGSquadNativeBase GetNativeSquad(){}
event XGSquadNativeBase GetEnemySquad(){}
simulated function bool HasSeenEnemy(XGUnit kEnemy){}
simulated function AddSeenEnemy(XGUnit kEnemy){}
simulated function bool HasSeenCharacter(EPawnType inputPawnType){}
simulated function AddSeenCharacter(EPawnType inputPawnType){}
simulated function EPawnType GetLastPawnTypeSeen(){}
native simulated function XGUnitNativeBase GetClosestSquadMember(Vector vLocation, optional float fMaxRadius, optional bool bSkipTanks, optional out float fClosestSq, optional XGUnitNativeBase kExclude, optional bool bSkipMelee, optional bool bSkipStrangle, optional bool bOnlyPermanentMembers);
simulated function XGUnit GetNearestEnemy(Vector vPoint, optional out float fClosestDist, optional bool bUseVisibleList, optional bool bConsiderCiviliansEnemies){}
function XGUnit AcknowledgeHiddenMovementSound(Vector vLocation, optional bool bForceAcknowledge){}
function OnHearEnemy(XGUnit kUnit, XGUnit kEnemy){};
function OnUnitSeen(XGUnit MyUnit, XGUnit EnemyUnit){}
function OnUnitKilled(XGUnit DeadUnit, XGUnit Killer){}
function CreateSquad(array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes){};
function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes){}
function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround, optional bool bBattleScanner){}
function SpawnUnitAt(class<XGUnit> UnitClass, ELoadoutTypes LoadoutType, XComSpawnPoint SpawnPoint, optional XGTacticalGameCoreNativeBase.EGender eForceGender, optional delegate<UnitSpawnCallback> Callback, optional bool bVIP){}
function bool IsSpawningUnit(){}
function PendingArchetypeLoaded(Object LoadedArchetype, int ContentId, int SubID){}
function CheckPendingSpawn(){}
function TickFinishPendingSpawnUnit(){}
function FinishPendingSpawnUnit(){}
function XGUnit SpawnAlien(EPawnType eAlienType, XComSpawnPoint_Alien kSpawnPt, optional bool bSnapToCover, optional bool bSnapToGround, optional bool bAddFlag, optional bool bUseAltWeapon, optional bool bBattleScanner){}
static simulated function class<XGCharacter> AlienTypeToClass(EPawnType eAlienType){}
function RemoveUnit(XGUnit kUnit, optional bool bUninitOnly){}
function Uninit(){}
function Init(optional bool bLoading){}
function LoadInit(){}
function EquipTank(XGUnit kTank, ELoadoutTypes eLoadout){}
function PreCloseCombatInit(XGUnit kInstigator){}
simulated function BeginTurn(){}
simulated function bool EndTurn(EPlayerEndTurnType eEndTurnType){}
function FireBeginTurnKismetEvent(){}
function FireEndingTurnKismetEvent(){}
function Vector GetRandomValidPoint(XGUnit kUnit, Vector vCenter, float fMaxRadius, optional float fMinRadius, optional Vector VDir){}
simulated function bool DropLocationToGround(out Vector vLocation, optional float Distance=128.0){}
function Vector GetRandomPoint(Vector vCenter, float fMaxRadius, optional float fMinRadius, optional Vector VDir){}
simulated function bool WaitingForSquadActions(){}
function bool CheckAllClientsHaveEndedTurn(bool bCountPathActionsAsIdle){}
simulated function bool CanOneShot(int iDamage, int iUnitHP, XGUnit kDamageDealer){}
simulated function RecordOneShot(){}
event OnBeginSplashDamage(DamageEvent kDmg, out array<XComUnitPawnNativeBase> arrPawns_Out){}
simulated function bool RemainingAvailableUnitsArePanicked(XGUnit kNext){}
simulated function bool CheckForEndTurn(XGUnit kUnit);
function DecrementPanicCounters(){}
function DecrementCriticalWoundCounters(){}
function bool IsAlienWaveSystemActive(){}
reliable server function ServerPerformEndTurn(EPlayerEndTurnType eEndTurnType){}

simulated state BeginningTurn
{
    simulated event BeginState(name PreviousStateName){}
    simulated event PushedState(){}
}
state ServerWaitingForClientsToEndTurn
{
	    function CancelAllTargetingActions(){}
    event Tick(float fDeltaTime)
	{}
}
simulated state EndingTurn
{
    simulated event BeginState(name PreviousStateName){}
    simulated event PushedState(){}
    simulated function bool UnitsAreDonePostKismet(){}
}
simulated state Active
{
    simulated event BeginState(name PreviousStateName){}
    simulated function bool EndTurn(EPlayerEndTurnType eEndTurnType){}
    simulated event ContinuedState(){}
    simulated function bool CheckForEndTurn(XGUnit kUnit){}
}
auto simulated state Inactive
{
	    simulated event BeginState(name PreviousStateName){}
    simulated function BeginTurn(){}
    simulated event Tick(float fDeltaT){}
}
simulated state Panicking
{
    simulated function BeginTurn(){}
    simulated event PushedState(){}
    simulated function bool HandleSoldierPanic(){}
    simulated function bool SoldierPanicking(){}
}




