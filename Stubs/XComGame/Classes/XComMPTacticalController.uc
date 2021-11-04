class XComMPTacticalController extends XComTacticalController
    config(Game);
//complete stub

var bool m_bRankedMatchStartedFlagWritten;
var bool m_bRoundEnded;
var bool m_bConnectionFailedDuringGame;
var bool m_bReturnToMPMainMenu;
var bool m_bIsCleaningUpGame;
var bool m_bHasCleanedUpGame;
var bool m_bHasEndedSession;
var bool m_bPingingMCP;
var bool m_bAttemptedGameInvite;

simulated event ReplicatedEvent(name VarName){}
simulated function InitPres(){}
simulated function bool IsInitialReplicationComplete(){}
simulated event ReceivedPlayer(){}
reliable server function ServerSetPlayerLanguage(string strLanguage){}
simulated function bool CalcHasBubonic(){}
reliable server function ServerClientIsGameCoreInitialized(){}
reliable server function ServerClientIsInitialized(){}
reliable server function ServerClientIsRunning(){}
reliable client simulated function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete){}
reliable client simulated function ClientWriteOnlinePlayerScores(int LeaderboardId);
reliable client simulated function ClientArbitratedMatchEnded();
reliable client simulated function ClientEndOnlineGame(){}
reliable client simulated function ClientWriteRankedMatchStartedFlag(){}
reliable server function ServerSetMatchStartedFlag(bool bMatchStarted){}
event bool NotifyDisconnect(string Command){}
simulated function AttemptExit(){}
simulated function ForcedExit(){}
reliable server function ServerForfeit(XComMPTacticalController kForfeitController, optional bool bReturnToMPMainMenu){}
function NotifyConnectionError(EProgressMessageType MessageType, optional string Message, optional string Title){}
simulated function UpdateEndOfGamePRIDueToDisconnect(bool bOtherPlayerDisconnected){}
simulated function StatsWriteWinDueToDisconnect(){}
simulated function DisplayEndOfGameDialog(){}
simulated function LinkStatusChange(bool bIsConnected){}
simulated function ConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus){}
simulated function LoginStatusChange(ELoginStatus NewStatus, UniqueNetId NewId){}
simulated function bool OnCheckReadyForGameInviteAccept(){}
simulated function LostConnection(EQuitReason Reason){}
private final function OnPingMCPCompleteFinishLostConnection(bool bWasSuccessful, XComMCPTypes.EOnlineEventType EventType){}
private final function FinishLostConnection(bool bOtherPlayerDisconnected){}
private final function OnPingMCPCompleteFinishLostConnectionWhilePlayerWaiting(bool bWasSuccessful, XComMCPTypes.EOnlineEventType EventType){}
private final function FinishLostConnectionWhilePlayerWaiting(bool bOtherPlayerDisconnected){}
event PreBeginPlay(){}
simulated event OnCleanupWorld(){}
simulated event Destroyed(){}
simulated function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful){}
simulated function OnDestroyedOnlineGame(name SessionName, bool bWasSuccessful){}
simulated function CleanedUpOnlineGame(){}
function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner){}
reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner){}
simulated function bool IsReturningToMPMainMenu(){}
function FinishGameOver(){}
reliable client simulated function ClientFinishGameOver(bool bReturnToMPMainMenu){}
function ExitOrStay(){}

auto state PlayerWaiting{
	function SeePlayer(Pawn Seen);
function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);
function bool NotifyBump(Actor Other, Vector HitNormal);
function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
function PhysicsVolumeChange(PhysicsVolume NewVolume);
exec function NextWeapon();
exec function PrevWeapon();
exec function SwitchToBestWeapon(optional bool bForceNewWeapon);
function NotifyConnectionError(EProgressMessageType MessageType, optional string Message, optional string Title)
{}
simulated function LostConnection(EQuitReason Reason){}
}

state RoundEnded{
	function SeePlayer(Pawn Seen);
function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);
function KilledBy(Pawn EventInstigator);
function bool NotifyBump(Actor Other, Vector HitNormal);
function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp);
function bool NotifyHeadVolumeChange(PhysicsVolume NewVolume);
function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume);
function Falling();
function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
exec function Suicide();
function NotifyConnectionError(EProgressMessageType MessageType, optional string Message, optional string Title)
{
    GetALocalPlayerController().bIgnoreNetworkMessages = true;
    LostConnection(0);
}
simulated function LostConnection(EQuitReason Reason)
{
    XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).QueueQuitReasonMessage(Reason);
}
reliable server function ServerRestartPlayer();
function bool IsSpectating()
{
    return true;
}
exec function ThrowWeapon();
exec function Use();
event Possess(Pawn aPawn, bool bVehicleTransition);
reliable server function ServerRestartGame();
exec function StartFire(optional byte FireModeNum);
function PlayerMove(float DeltaTime);
unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View);
function FindGoodView();
event Timer()
{
}
unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ);
event BeginState(name PreviousStateName)
{
}
event EndState(name NextStateName)
{}
}



state WaitingForGameInitialization
{
function SeePlayer(Pawn Seen);
function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);
function bool NotifyBump(Actor Other, Vector HitNormal);
function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
function PhysicsVolumeChange(PhysicsVolume NewVolume);
exec function NextWeapon();
exec function PrevWeapon();
exec function SwitchToBestWeapon(optional bool bForceNewWeapon);
event BeginState(name PreviousStateName)
{
}
event EndState(name NextStateName)
{
}
event PlayerTick(float DeltaTime);
}