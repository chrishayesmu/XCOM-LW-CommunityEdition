class XComTacticalController extends XComPlayerController
    native(Core)
    config(Game)
    hidecategories(Navigation)
	dependson(XComPathData);

//complete stub

const MAX_REPLICATED_PATH_POINTS = 128;

struct native transient CoverCheck
{
    var init array<Vector> aRaysHit;
    var init array<Vector> aRaysMissed;
    var init Vector vSourcePoint;

};

struct native AdjustedPathNotification
{
    var int m_iNumAdjustedPathPoints;
    var Vector m_vRawDestination;
    var Vector m_vAdjustedDestination;
    var XGUnitNativeBase m_kActiveUnit;
    var float m_fTimestamp;

};

var XGPlayer m_XGPlayer;
var XGUnit m_kActiveUnit;
var bool m_bCamIsMoving;
var bool m_bInCinematicMode;
var bool m_bMissionVictoryCinematic;
var bool m_bWaitingForAdjustedPath;
var bool m_bWaitingToPerformPath;
var transient bool m_bGridComponentHidden;
var transient bool m_bGridComponentDashingHidden;
var bool m_bInputInShotHUD;
var bool m_bInputSwitchingWeapons;
var repnotify bool m_bAchievementUnlocked_MindTheStep;
var int m_iBloodlustMove;
var int iCurrentLevel;
var array<Actor> aLvl1;
var array<Actor> aLvl2;
var array<Actor> aLvl3;
var array<Actor> aLvl4;
var repnotify ReplicatedPathPoint m_arrAdjustedPathPoints[128];
var repnotify AdjustedPathNotification m_kAdjustedPathNotification;
var int m_iNumAdjustedPathPoints;
var Vector m_vLastSentPathDestination;
var float m_fLastSentPathTimestamp;
var float m_fClientLastReceivedPathTimestamp;
var float m_fServerLastReceivedPathTimestamp;
var XGUnit m_kUnitWaitingToPerformPath;
var Vector m_vClientLastSentCursorLocation;
var const localized string m_strPsiInspired;
var const localized string m_strBeenPsiInspired;
var float m_fLastReplicateMoveSentTimeSeconds;
var const float m_fThrottleReplicateMoveTimeSeconds;

simulated event ReplicatedEvent(name VarName){}
native simulated function float GetCursorAccel();
native simulated function float GetCursorDecel();
simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, Vector vCameraPosition, Vector vCameraDir){}
simulated function XComPresentationLayer GetPres(){}
simulated function PRESRemoveAllCursorBasedIcons(){}
reliable client simulated function ClientPHUDLevelUp(XGCharacter_Soldier kSoldier){}
simulated function bool IsBusy(){}
simulated function XComUnitPawn GetActiveUnitPawn(){}
function SetXGPlayer(XGPlayer XGPlayer){}
function XCom3DCursor GetCursor(){}
function Vector GetCursorPosition(){}
reliable client simulated function ClientSetCursorLocation(Vector vLocation){}
simulated function ActiveUnitChanged(){}
simulated function SetInputState(name nStateName){}
simulated event PostBeginPlay(){}
event ResetCameraMode(){};
simulated function XComUnitPawn GetActivePawn(){}
simulated function XGUnit GetActiveUnit(){}
simulated function SetActiveUnit(XGUnit kNewActiveUnit){}
simulated function UnregisterPlayerDataStores(){}
exec function PlayUnitOnMoveSound(){}
exec function PlayUnitSelectSound(){}
exec function SetCameraYaw(float fDegrees){}
exec function YawCamera(float fDegrees){}
exec function float GetCameraYaw(){}
exec function PitchCamera(float fDegrees){}
exec function ZoomCamera(float fDistance){}
event Possess(Pawn aPawn, bool bVehicleTransition){}
exec function ToggleDramaticCameras(){}
exec function ToggleDebugCamera(){}
function DrawDebugLabels(Canvas kCanvas){}
function DrawDebugData(HUD H){}
simulated function PerformBerserk(XGUnit kUnit, optional XGUnit kTarget){}
simulated function PerformPath(XGUnit kUnit, optional bool bNoCost, optional bool bSpeak){}
function NormalTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function ClimbOverTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function BreakWindowTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function KickDoorTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function ClimbOntoTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function LandingTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function DropDownTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit, optional bool bIgnoreInterrupts=true, optional bool bSpawnedAlien, optional XComSpawnPoint_Alien kSpawnPt, optional bool bOverwatch, optional int iAttackChance){}
function GrappleTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function ClimbLadderTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function JumpUpTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit){}
function WallClimbTraversalPoint(ETraversalType LastTraversalType, Vector Point, Vector NextPoint, Vector NewDirection, float DistanceBetweenPoints, int Index, XGUnit kUnit, optional bool bIgnoreInterrupts=true){}
function bool JetMove(XGUnit kUnit, bool bAscend){}
function bool JetLaunch(XGAbility_Launch kLaunchAbility){}
simulated function Vector GetStranglerLookAtPoint(XGUnit kTarget){}
simulated function Vector GetStrangleLocation(XGUnit kTarget, XGUnit kSeeker){}
simulated function bool IsInStrangleLocation(XGUnit kSeeker, XGUnit kTarget){}
function MoveToStrangleLocation(XGAbility_Targeted kStrangleAbility){}
function PerformStrangleAbility(XGAbility_Targeted kStrangleAbility){}
function bool DoBullRush(XGAbility_BullRush kBullRushAbility){}
function MindMerge(XGAbility_Targeted kMindMergeAbility){}
function PsiInspire(XGAbility_Targeted kAbility, array<XGUnit> kTargets){}
function ParsePath(XGUnit kUnit, optional bool bNoCost, optional bool bSpeak, optional XGAbility kAbility, optional bool bSpawnedAlienWalkIn, optional XComSpawnPoint_Alien kSpawnPt, optional bool bOverwatch){}
reliable server function ServerPerformPath(XGUnit kUnit, optional bool bNoCost, optional bool bSpeak){}
simulated function bool PerformEndTurn(EPlayerEndTurnType eEndTurnType){}
final simulated function bool InternalPerformEndTurn(EPlayerEndTurnType eEndTurnType){}
simulated function ShowEndTurnDialog(){}
simulated function EndTurnDialogueCallback(EUIAction eAction){}
function PerformEquip(XGUnit kUnit, int iSlotFrom){}
function PerformUnequip(XGUnit kUnit){}
reliable server function bool PerformAction(){}
simulated function bool CheckForClimbOnto(){}
function Actor TestForCoverCollision(Vector vStart, Vector VDir, out Vector HitLocation, out Vector HitNormal, float fRange){}
function Vector GetGroundPosition(Vector vPoint){}
simulated function bool IsInCover(){}
simulated function XComLadder FindLadder(optional int iRadius=96, optional int iMaxHeightDiff=100){}
reliable client simulated function ClientFailedSwitchWeapon(){}
function bool PerformRaisingTargetWithFireAction(optional XGUnit kTargetedUnit, optional bool forceNewAction){}
reliable client simulated function ClientFailedPerformingRaisingTargetWithFireAction(){}
reliable server function ServerPerformRaisingTargetWithFireAction(optional XGUnit kTargetedUnit, optional bool forceNewAction){}
reliable server function ServerDecRefAction(XGAction kAction){}
reliable server function ServerDecRefRemovingAbility(XGAbility_Targeted kAbility){}
reliable server function ServerDecRefExecutingAbility(XGAbility kAbility){}
event BeginState(name PreviousStateName);
event EndState(name NextStateName);
simulated function OnToggleUnitFlags(SeqAct_ToggleUnitFlags inAction){}
function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, optional bool bDoClientRPC, optional bool bOverrideUserMusic){}
reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD){}
native simulated function ForceCursorUpdate();
simulated function CinematicModeToggled(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD){}
function SetUnitVisibilityStates(bool bIsCinematic){}
reliable server function ServerTeleportActiveUnitTo(Vector vLoc){}
function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot){}
unreliable server function UnreliableServerSetLastCursorLocation(Vector vLocation, float fTimestamp){}
reliable server function ReliableServerSetLastCursorLocation(Vector vLocation, float fTimestamp){}
function ServerSetLastCursorLocation(Vector vLocation, float fTimestamp){}
native final function DebugPrintPathDestinationDiff(const out Vector vNewDestination, const out Vector vOldDestination);
reliable server function ServerSetPathDestination(Vector vPathDestination, float fTimestamp, XGUnitNativeBase kActiveUnit){}
simulated function AdjustPath(){}
event SendClientAdjustment(){}
unreliable client simulated function ClientUpdatePing(float fTimestamp){}
unreliable client simulated function ClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase);
unreliable client simulated function ShortClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase);
unreliable client simulated function VeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase);
unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ);
simulated function XComPerkManager PERKS(){}
exec function SoldierSpeak(string speechName){}
exec function TestItemCard(){}
reliable client simulated event Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization){}
event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest){}
function StartMatinee(){}
function ContinueToDestination(){}
simulated function OnToggleHUDElements(SeqAct_ToggleHUDElements Action){}
reliable client simulated function ClientSetOnlineStatus(){}
simulated function bool IsInCinematicMode(){}
simulated function bool ShouldBlockPauseMenu(){}
simulated function IncBloodlustMove(){}
simulated function DecBloodlustMove(){}

simulated state PlayerDebugCamera{
	function SeePlayer(Pawn Seen);
	function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType);
	function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal);
	event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume);
    exec function ToggleDebugCamera(){}
    event PushedState(){}
    event PoppedState(){}

}
simulated state PlayerWalking{
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot){}
    function PlayerMove(float DeltaTime){}
    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
}

simulated state PlayerAiming{
	event BeginState(name PreviousStateName){}
	event EndState(name NextStateName){}
	function PlayerMove(float DeltaTime);
}
simulated state CloseCombat{
	function PlayerMove(float DeltaTime);
    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}   
}
state CinematicMode{
	event BeginState(name PreviousStateName){}
	event EndState(name NextStateName){}
	exec function ShowMenu();
	exec function PlayUnitSelectSound();
}
