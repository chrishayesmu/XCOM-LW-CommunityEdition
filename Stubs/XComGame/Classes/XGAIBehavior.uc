class XGAIBehavior extends Actor
	native(AI)
	dependsOn(XComWorldData)
	dependsOn(XComSpawnPoint_Alien);

//complete stub
enum ETrackingCueAudioType
{
    eTCAT_HeardCall_Sound,
    eTCAT_HeardCall_Visual,
    eTCAT_FollowSound,
    eTCAT_HeardCall_DeathCry,
    eTCAT_HeardCall_DefendUFO,
    eTCAT_MAX
};

enum EPathingFailure
{
    ePATHING_FAILURE_COMPUTE_PATH,
    ePATHING_FAILURE_BASE_VALIDATOR,
    ePATHING_FAILURE_UNREACHABLE,
    ePATHING_FAILURE_MAX
};

struct native badcover
{
    var Vector vLoc;
    var float fRadius;
    var float fMeleeRadius;
    var int iAlien;
    var EPawnType eType;
    var ETeam ETeam;
};

struct native aoe_target
{
    var Vector vLocation;
    var XGUnit kTarget;
    var XGUnit kShooter;
    var float fAoERadius;
    var int iAbility;
};

struct native ai_cover_score
{
    var XComCoverPoint kCover;
    var Vector vLoc;
    var int nE;
    var int nF;
    var int Id;
    var int iA;
    var int iR;
    var int iC;
    var int iV;
    var int IP;
    var int iO;
    var int iB;
    var int iScore;
    var bool bTeamAttackFlankPoint;
    var bool bUseFlightPathing;
};

struct ai_unit_proximity
{
    var XGUnit kUnitA;
    var XGUnit kUnitB;
    var float fDistance;
};

struct native heal_option
{
    var XGUnit kTarget;
    var float fDamageScale;
    var int iHP;
    var int iRawDamage;
    var float fDistSqToHealer;
    var XGUnit kNearestHealer;
};

struct native tracking_cue
{
    var bool bTracking;
    var bool bVisual;
    var Vector vLoc;
    var ETrackingCueAudioType eTCATType;
    var XGUnit kTarget;
    var float fDistSq;
    var bool bArrived;
    var int iTurns;
    var int iTurnsSinceArrived;
};

struct native move_path
{
    var array<Vector> aMove;
};

struct native path_cache
{
    var bool bValidPath;
    var int iCellIndex;
};

struct CheckpointRecord
{
    var int m_iAIIndex;
    var EBehavior m_eSpawnBehavior;
    var Vector m_vLeashPoint;
    var float m_fLeashRadius;
    var tracking_cue m_kTrackingCue;
    var float m_fAggression;
    var float m_fMinAggro;
    var float m_fMaxAggro;
    var bool m_bHasSeenEnemy;
    var bool m_bSeen;
    var Actor m_kSeekTarget;
    var float m_fSeekRadius;
    var int m_nDefends;
    var bool m_bTerrorist;
    var int m_iLastHP;
    var XGUnit m_kLastCivilianTarget;
    var int m_iLastTurnStart;
    var XComAlienPod m_kPod;
    var XComAlienPod m_kPermanentPod;
    var int m_iMimicBeaconIndex;
    var int m_iTurnsUnseen;
};

struct native ai_force_move_data
{
    var Vector vDestination;
    var bool bOn;
    var bool bDebugDisplay;
    var bool bEndTurnAfterMove;

};

var int m_iAIIndex;
var EBehavior m_eSpawnBehavior;
var Vector m_vLeashPoint;
var float m_fLeashRadius;
var tracking_cue m_kTrackingCue;
var float m_fAggression;
var float m_fMinAggro;
var float m_fMaxAggro;
var bool m_bHasSeenEnemy;
var bool m_bSeen;
var bool m_bTerrorist;
var bool m_bCallResponse;
var bool m_bSimultaneousMoving;
var bool m_bCanMove;
var bool m_bShouldEngage;
var bool m_bAbortMove;
var bool m_bIsCoverAvailable;
var bool m_bTeamTargetSet;
var bool m_bMoveToActionPoint;
var bool m_bIgnorePathCost;
var bool m_bDescended;
var bool m_bShouldIgnoreCover;
var bool m_bCanIgnoreCover;
var bool m_bCanEngage;
var bool m_bKeepHidden;
var bool m_bMoveAndDeactivate;
var bool m_bIsMindControlled;
var bool m_bCapper;
var bool m_bAvoidCap;
var bool m_bDefensiveMove;
var bool m_bHasMultishot;
var bool m_bOverwatchUnrevealed;
var bool m_bHasOverwatchingEnemy;
var bool m_bHasVulnerableTarget;
var bool m_bIgnoreOverwatchers;
var bool m_bUseAoETarget;
var bool m_bBadAreaChecksIgnoreAoE;
var bool m_bHasSquadSightAbility;
var bool m_bForceMoveToCapZone;
var bool m_bCanDash;
var Actor m_kSeekTarget;
var float m_fSeekRadius;
var int m_nDefends;
var int m_iLastHP;
var XGUnit m_kLastCivilianTarget;
var XGAIPlayer m_kPlayer;
var XGUnit m_kUnit;
var XComAlienPod m_kPod;
var XComAlienPod m_kPermanentPod;
var float m_fSpacingBuffer;
var int m_iMaxWeaponStrengthIgnoreCover;
var XGAIAbilityDM m_kAbilityDM;
var XGUnit m_kAttackTarget;
var array<XGUnit> m_arrVisibleEnemy;
var array<XGUnit> m_arrValidTargets;
var Vector m_vFlankDest;
var name m_kLastAIState;
var int m_iFleeUrge;
var int m_bsLastEngaged;
var int m_bsEngaged;
var XComProjectile_FragGrenade m_kNearestGrenade;
var float m_fGrenadeDistSq;
var float m_fDistFromTargetSq;
var Vector m_vLastPosition;
var Vector m_vLastDestination;
var float m_fDistFromEnemy;
var XGAction_FireImmediate m_kAttackFireAction;
var int m_iCurrCacheVer;
var XGUnit m_kDefendTarget;
var int m_nRepairs;
var int m_iLastTurnStart;
var float m_fDistWeight;
var float m_fProxWeight;
var float m_fFlankWeight;
var float m_fAngleWeight;
var float m_fVisWeight;
var float m_fCoverWeight;
var int m_iMimicBeaconIndex;
var Vector m_vDebugDestination;
var array<move_path> m_PathHistory;
var array<Vector> m_WarpHistory;
var LinearColor m_kDebugColor;
var Vector m_vDebugDir[2];
var Vector m_vPathingOffset;
var ai_force_move_data m_kForceMove;
var string m_strDebugLog;
var int m_iErrorCheck;
var Vector m_vFailureBegin;
var array<int> m_iFailureDest_CP;
var array<int> m_iFailureDest_BV;
var array<int> m_iFailureDest_UR;
var int m_iLastFailureAdded;
var array<XComCoverPoint> m_arrValidDestination;
var array<XComCoverPoint> m_arrHiddenDestination;
var XGManeuver m_kManeuver;
var array<path_cache> m_arrPathCache;
var Vector m_vLookAt;
var int m_iOverwatchDangerZone;
var XGUnit m_kVulnerableTarget;
var aoe_target m_kAoETarget;
var XGUnit m_kTargetToView;
var XGAbility_Targeted m_kPredeterminedAbility;
var int m_iCurrRangeBonus;
var XGUnit m_kSuppressionFlankTarget;
var int m_iDebugHangLocation;
var Vector m_vSortLoc;
var XGUnit m_kClosestCivilian;
var int m_iTurnsUnseen;
//var delegate<DecreasingDistanceSort> __DecreasingDistanceSort__Delegate;

replication
{
    if(Role == ROLE_Authority)
        m_eSpawnBehavior, m_fLeashRadius, 
        m_kUnit, m_vLeashPoint;
}
delegate int DecreasingDistanceSort(XComCoverPoint kPointA, XComCoverPoint kPointB);
simulated function AddAudioTrackingCue(Vector vLocation, ETrackingCueAudioType eTCATType, XGUnit kUnit){}
simulated function bool AddManeuver(XGManeuver kManeuver){}
function AddNonCoverPoint(out array<XComCoverPoint> arrList, Vector vLoc){}
function AddOtherPoints(out array<XComCoverPoint> Points, Vector vLoc);
function AddPriorityFlightDestinations(out array<XComCoverPoint> Points);
simulated function AddToPathCache(Vector vLoc, bool bValid){}
simulated function AddToPathHistory(optional bool bPathEnd=FALSE){}
simulated function AddVisibleEnemy(XGUnit kEnemy, optional bool bVisible=TRUE){}
simulated function AttackPsi(XGUnit kEnemy){}
simulated function bool AvoidVIP(){}
simulated function bool BaseValidator(Vector vCoverLoc){}
simulated function BeginNewMovePath(){}
simulated function BeginTurn();
simulated function CallOthers(optional EManeuverType eManeuver){}
function bool CanAoEHit(array<XGUnit> arrTargetList, int iAbilityType){}
function bool CanDeathBlossom(optional out XGAbility_Targeted kAbility_Out){}
simulated function bool CanEngage(){}
simulated function bool CanFly(){}
function bool CanHitAnyAoETarget(out aoe_target kTarget){}
function bool CanHitAoETarget(out aoe_target kTarget){}
simulated function bool CanIgnoreCover(){}
function bool CanLaunch(){}
function bool CanMeleeAttack(optional out XGUnitNativeBase kTarget){}
simulated function bool CanSeeTrackingTarget(){}
simulated function bool CanThrowGrenadeAtTarget(XGAbility_Targeted kAbility, optional XGUnit kTargetOverride=none, optional out Vector vEndPosition){}
simulated function bool CanUseCover(){}
simulated function bool CaresAboutMimicBeacons(){}
simulated function CheckHasCoverWithinRange(){}
simulated function bool CheckPathCache(Vector vDest, out int iValidPath){}
simulated function ChooseWeapon(){}
simulated function ClearDead(){}
simulated function ClearTrackingCue(){}
simulated function bool ComputePathTo(Vector vLoc, optional bool bObeyMaxCost=TRUE, optional bool bCostOnly=FALSE, optional bool bPathToAction=FALSE, optional bool bSkipCache=FALSE, optional bool bCanDash=FALSE){}
simulated function DebugDrawDestination(){}
simulated function DebugDrawPath(){}
simulated function DebugDrawPathFailures(){}
simulated function DebugInit(){}
function DebugInitTurn(){}
function DebugLogPathingFailure(Vector vDest, int eReason){}
simulated function DebugUninit(){}
function Vector DecideNextDestination(optional out string strFail){}
function bool DestinationIsReachable(Vector vLocation){}
function DetermineOverwatchDangerZone(){}
simulated function DoAttack(XGUnit kEnemy){}
function DoOverwatch(){}
simulated function DoStateTransition(){}
simulated function DrawDebugLabel(Canvas kCanvas, out Vector vScreenPos){}
simulated function bool EncroachCoverValidator(Vector vCoverLoc){}
simulated function bool EngageCoverValidator(Vector vCoverLoc){}
function EnterCustomMoveState(){}
function ExecuteAbility(){}
simulated function ExecuteMoveAbility(){}
simulated function FilterAbilities(out array<XGAbility> arrAbilities, optional bool bLastResort=FALSE){}
simulated function bool FindDestinationAlongPath(out Vector vOutDest, Vector vTarget, optional float fMaxDist=-1.0, optional bool bUseClosestCoverOnBadDestination=TRUE, optional bool bCanDash=FALSE){}
simulated function Vector FindFiringPosition(XGUnit kEnemy){}
function Vector FindMeleeDestination(XGUnit kEnemy, optional out string strFail){}
function bool FindPriorityAbility(out XGAbility_Targeted kAbility_Out){}
simulated function bool FindRunawayPosition(out Vector vDestination, XGUnit kEnemy, optional out Vector vDirToEnemy, optional float fMetersFromEdge, optional out string strFail){}
simulated function Vector FindValidPathDestinationToward(Vector vTarget, optional float fMaxDistance, optional bool bFilterDests, optional bool bSkipBuildDestList, optional out string strFail, optional bool bUseAStar){}
simulated function bool FlankingCoverValidator(Vector vCoverLoc){}
function bool FlanksEnemy(optional Vector vUnitLocation=m_kUnit.Location, optional bool bFailIfEnemyNotInCover=TRUE){}
simulated function ForceMove(Vector vDest, optional bool bEndTurnAfterMove=TRUE, optional bool bDebugDisplayDest=FALSE){}
simulated function Vector GetAdjacentMeleePoint(badcover kObstruction, XGUnit kTarget, bool bPosDir){}
simulated function Vector GetAnyRunawayLocation(optional XGUnit kEnemy=none, optional out string strFail){}
function Vector GetAverageCoverDir(XComCoverPoint kCover){}
function bool GetAverageDirToOtherEnemies(out Vector vAvgDir, XGUnit kPrimaryEnemy, optional float fMaxRadius=500.0){}
simulated function XGUnit GetBestAttackTarget(){}
function Vector GetBestFlankingPointAgainst(XGUnit kEnemy){}
simulated function XGUnit GetClosestCivilian(){}
simulated function bool GetConstrainedMovementPoints(optional out array<XComCoverPoint> outputArrPoints){}
function int GetCoverNoMoveMinHitChanceBump(){}
simulated function array<XComCoverPoint> GetDestinations(optional bool bFiltered=FALSE, optional bool bSkipBuildDestList=FALSE, optional bool bUseUnseenEnemies=TRUE, optional bool bLogging=FALSE){}
simulated function bool GetDestinationTowardsTrackingCue(out Vector vDest){}
function float GetDistanceFromEnemy(XGUnit kEnemy){}
function array<XGUnit> GetEnemiesInOverwatch(optional bool bVisibleToTeam=FALSE){}
simulated function int GetEngagedBitSet(){}
function bool GetEngageLocation(out Vector vCover, XGUnit kEnemy, optional bool bOutOfRange=FALSE, optional out string strFail){}
function bool GetFlankLocationAgainst(XGUnit kTarget, out Vector vLoc, optional bool bAllowFlying=FALSE){}
simulated function bool GetFleeLocation(out Vector vCover, XGUnit kEnemy, optional bool bInternal=TRUE, optional out string strFail){}
function Vector GetFlightDestinationAbove(Vector vLoc, float fIdealHeight){}
simulated function bool GetFurthestPathablePointFrom(XGUnit kEnemy, out Vector vDestination, optional bool bUseHidden=TRUE, optional bool bForceCover=TRUE, optional out string strFail){}
simulated function float GetGrenadeSplashRadius(XComProjectile_FragGrenade kGrenade, optional float fExtraRadius=128.0, optional bool bSquared=TRUE){}
simulated function float GetGrenadeThrowRange(){}
function int GetHighCoverScoreHelper(){}
simulated function float GetHitChance(XGUnit kEnemy){}
function int GetHitChanceEstimateFrom(Vector vLocation, XGUnit kEnemy, optional bool TestVisibility=TRUE){}
simulated function float GetLeashRadius(optional bool bUnits=FALSE, optional bool bSquared=FALSE){}
static simulated function float GetLeashRadiusStatic(EBehavior eBeh, optional bool bUnits=FALSE, optional bool bSquared=FALSE){}
function int GetLowCoverScoreHelper(){}
simulated function int GetMaxDangerLevelForMovement(){}
simulated function float GetMaxEngageRange(){}
simulated function float GetMaxPathDistance(){}
function float GetMaxPathDistanceConstraint(float fDefaultLength){}
simulated function float GetMinEngageRange(){}
simulated function int GetMinHitChance(array<XGAbility_Targeted> arrAbilities){}
function int GetMinMoveDistance(){}
simulated function float GetMoveDefenseScore(){}
simulated function float GetMoveOffenseScore(){}
simulated function Vector GetNearestDestination(array<XComCoverPoint> arrCover, Vector vLoc, optional bool bValidate=FALSE){}
simulated function bool GetNearestValidPathablePointToMeleeRange(XGUnit kTarget, out Vector vBestPoint, optional bool bSkipCache=FALSE, optional out int iHasMeleePoint, optional bool bGetAnyGoodDestination=TRUE, optional bool bAvoidLowCover=FALSE){}
simulated function XGUnit GetNearestVisibleEnemy(optional bool bVisibleToTeam=TRUE){}
simulated function XGUnit GetNewTarget(optional XGUnit kBadTarget=none){}
simulated function int GetNumAoETargets(XGAbility_Targeted kAbility){}
simulated function Vector GetPodRevealMoveToLocation(XGUnit kTarget){}
simulated function Vector GetPointWithinMeleeRange(XGUnit kTarget, optional float fExtraDist=0.0, optional bool bAvoidLowCover=false){}
simulated function bool GetPostMoveFacingTarget(out Vector vTarget){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
function int GetPrimaryAttackType(){}
function float GetReasonableAttackRange(){}
simulated function bool GetScoredCoverDestination(out Vector vLoc, optional bool bAttackRange=FALSE){}
simulated function array<XComCoverPoint> GetValidDestinations(optional bool bIgnoreTeamDestinations=FALSE, optional bool bSortDecreasingDistance=FALSE){}
function int GetWeaponRangeModAtLocation(Vector vLocation, XGUnit kEnemy){}
simulated function HandleEnemyDeath(XGUnit kUnit){}
simulated function bool HasAoEAbility(optional out int iType, optional out float fDamageRadius){}
simulated function bool HasAscendDestination(){}
function bool HasBackupShotAbility(out XGAbility_Targeted kShot){}
simulated function bool HasConstrainedMovementVolume(optional out Volume kVolume){}
simulated function bool HasCustomAbilityValidityCheck(){}
function bool HasCustomMoveOption(){}
simulated function bool HasHighHitChance(XGAbility_Targeted kAbility){}
simulated function bool HasMaxRepairsThisTurn(){}
simulated function bool HasNearbySuppressor(){}
simulated function bool HasOverheadClearance(optional Vector vLocation=m_kUnit.Location){}
simulated function bool HasPotentialKillShot(out XGAbility_Targeted kAbility_Out){}
simulated function bool HasPredeterminedAbility(){}
simulated function bool HasRecentlyLaunched(){}
simulated function bool HasScoredCoverOptions(){}
function bool HasStartedTurn(){}
function bool HasTargetVisibleFromNewLocation(Vector vNewLocation, XGUnit kTarget, bool bSquadSight){}
simulated function bool HasValidAoETarget(){}
simulated function bool HasValidDestinationToward(Vector vTarget, out Vector vDestination, optional float fMaxDistance=-1.0, optional bool bFilterDests=TRUE, optional bool bSkipBuildDestList=FALSE, optional bool bUseAStar=FALSE, optional bool bCanDash=FALSE){}
simulated function bool HasValidManeuver(){}
simulated function bool HasVulnerableTarget(array<XGAbility> arrAbilities, optional out XGUnit kTarget){}
function bool HasVulnerableTargetsFromNewLocation(Vector vNewLocation){}
simulated function bool IgnoresActiveList(){}
function Init(XGUnit kUnit){}
simulated function InitExecuteAbility(){}
simulated function InitFromPlayer(){}
function InitMimicBeaconToHunt(){}
function InitMindControlled(){}
simulated function InitPod(int iPod, optional bool bActive=TRUE){}
simulated function InitPredeterminedAbility(XGAbility kAbility){}
simulated function InitShouldEngage(){}
simulated function InitTargets(){}
simulated function InitTurn(){}
simulated function bool IsAbilityValid(XGAbility kAbility){}
simulated function bool IsAboveFloorTile(Vector vLoc, optional int iMinTiles=1){}
simulated function bool IsAcceptableTeamAttackAbility(XGAbility kAbility){}
simulated function bool IsActionComplete(string kHangDebug){}
simulated function bool IsActive(){}
simulated function bool IsAnimal(){}
function bool IsAnyCoverPointInPriorityVolume(array<XComCoverPoint> arrCover){}
simulated function bool IsAoEAbility(XGAbility_Targeted kAbility, optional out float fDamageRadius){}
simulated function bool IsBattlePaused(string kHangDebug){}
simulated function bool IsBehaviorDefined(){}
function bool IsBetterLocation(Vector vNewLoc, XComCoverPoint kNewCover){}
simulated function bool IsCapturePointUncontested(){}
simulated function bool IsCloserToTarget(Vector vNewLoc, Vector vTarget){}
function bool IsCloserToUnit(Vector vLoc, XGUnit kTarget){}
simulated function bool IsDestinationCacheDirty(){}
native simulated function bool IsDormant(optional bool bFalseIfActivating=FALSE);
simulated function bool IsGoodAscendLocation(optional Vector vLocation=m_kUnit.Location){}
simulated function bool IsGrounded(){}
simulated function bool IsInBadArea(Vector vLoc, optional bool bDebugLog=FALSE){}
function bool IsInDangerousArea(){}
simulated function bool IsInMeleeRange(optional out XGUnitNativeBase kNearest){}
function bool IsInsidePriorityVolume(Vector vLoc){}
function bool IsMovingToAttack(){}
simulated function bool IsPathVisible(Vector vDestination, out Vector vLastHidden){}
function bool IsValidAbilityAgainstTarget(XGAbility kAbility, array<XGUnit> arrTargetList){}
simulated function bool IsValidAttackDestination(Vector vLoc){}
native simulated function bool IsValidCivilianTarget(XGUnitNativeBase kUnit);
simulated function bool IsValidFlightPathDestination(Vector vLoc, optional bool bCanDash=false){}
simulated function bool IsValidPathDestination(Vector vLoc, optional bool bSkipCache=FALSE, optional bool bCanDash=FALSE){}
simulated function bool IsValidPathDestinationAway(Vector vLoc){}
simulated function bool IsValidPathDestinationDel(Vector vLoc){}
simulated function bool IsValidTerroristDestination(Vector vLoc){}
simulated function bool IsVisibleToEnemy(){}
simulated function bool IsWithinLeashRadius(Vector vLocation, optional float fExtraRange=0.0){}
simulated function bool IsWithinRangeOfTeamTarget(){}
simulated function LoadInit(XGUnit kUnit){}
simulated function MakeDebugColor(optional float fAlpha){}
simulated function MarkLaunched(){}
simulated function MarkSeen(optional bool ViewerHidden){}
function MarkTurnStarted(){}
simulated function MeleeAttackPositionUnavailableHandler(out Vector vDest_Out){}
simulated function bool MoveToPoint(Vector vDestination, bool bHiddenMovement){}
simulated function bool MoveUnit(){}
simulated function bool NearManeuver(Vector vCoverLoc){}
simulated function OnCompleteAbility(int iAbilityType){}
simulated function OnDeath(XGUnit kKiller){}
simulated function OnGuardDeath(XGUnit kUnit);
simulated function bool OnHear(Vector vLocation, ETrackingCueAudioType eTCATType, XGUnit kUnit, optional bool bRespond=FALSE, optional float fMinResponseWait=0.50){}
simulated function OnKill(XGUnit kVictim){}
simulated function OnMoveComplete(){}
simulated function OnMoveFailure(){}
simulated function OnRepair(){}
simulated function OnSeeEnemy(XGUnit kEnemy){}
simulated function OnTakeDamage(int iDamage, class<DamageType> DamageType){}
simulated function OnUnitEndTurn(){}
simulated function bool OutsideEnemyRangeValidator(Vector vCoverLoc){}
simulated function bool Overlaps(Vector vCenter1, float fRadius1, Vector vCenter2, float fRadius2){}
simulated function bool PerformImmediateManeuver(){}
simulated function PickFlankLocations(out array<Vector> akLocations, Vector vCoverDirection, Vector vEnemyLocation){}
simulated function PodRevealPreMoveInit();
function PopulateDestinations(out array<XComCoverPoint> Points, out array<XComCoverPoint> arrNonCoverPoints, out array<XComCoverPoint> arrOtherPoints, optional bool bLogging=FALSE){}
simulated function PostBuildAbilities(){}
simulated function PostEquipInit();
simulated function PreBuildAbilities(){}
simulated function bool PrecomputeGrenadePath(XGAbility_Targeted kAbility, Vector vTargetLoc){}
function bool PrefersLowCover(){}
function PreMarkTurnStartedInit();function PsiControlInit(){}
simulated function bool Reload(){}
simulated function ResetDestinationCacheVer(){}
function ResetErrorCheck(){}
simulated function ResetLocationHeight(out Vector vLoc, optional bool bSetToFloor=TRUE){}
simulated function ResetPathCache(){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}
function XGUnit SelectCivilianTarget(){}
function XGUnit SelectEnemyToEngage(){}
simulated function SelectFireMode(XGAction_FireImmediate kFireAction, XGAbility_Targeted kAbility){}
simulated function XGUnit SelectGrenadeTarget(optional XGAbility_Targeted kGrenadeAbility, optional out Vector vLoc_Out){}
simulated function SetBehavior(XComSpawnPoint_Alien kSpawnPoint){}
simulated function SetDebugDir(Vector VDir, optional bool bIsNormalized=FALSE, optional bool bAlt=FALSE){}
simulated function SetDefaultBehavior(){}
simulated function SetTeamAttackTarget(XGUnit kTarget){}
simulated function SetTrackingCue(Vector vLocation, XGUnit kUnit, bool bVisual, optional ETrackingCueAudioType eTCATType=0){}
function bool ShouldAttackCivilians(){}
simulated function bool ShouldAvoidMovement(){}
simulated function bool ShouldDrawProximityRing(){}
simulated function bool ShouldFindCover(optional out XComCoverPoint Cover){}
simulated function bool ShouldFlank(){}
simulated function bool ShouldFlee(){}
simulated function bool ShouldIgnoreCover(){}
function bool ShouldKeepHidden(){}
simulated function bool ShouldTrack(){}
simulated function SwitchToAttack(optional string strReason=""){}
simulated function bool TargetVIP(){}
function bool TestPotentialAoEDestination(Vector vAoeLocation, float fDamageRadius, int iAbility, optional out array<XGUnit> arrHitUnits){}
simulated function bool TestPotentialGrenadeDestination(Vector vLocation, float fSplashRadius, optional bool bFailOnFewEnemiesHit=FALSE){}
function TestValidLocation(Vector vLoc, optional string strLabel){}
simulated event Tick(float fDeltaT){}
simulated function bool TurnTowards(Vector vLocation){}
simulated function UndoOnHear(){}
simulated function Uninit(){}
function bool UpdateAoETargetLocation(out aoe_target kTarget, Vector vTraceStart, optional out array<XGUnit> arrHitUnits){}
function UpdateClosestCivilian(){}
simulated function UpdateDestinationCacheVer(){}
simulated function UpdateDestinations(optional bool bSkipBuildDestList=FALSE, optional bool bLogging=FALSE){}
function UpdateErrorCheck(){}
function bool UpdateGrenadeDestination(out aoe_target kTarget, XGAbility_Targeted kAbility){}
function UpdateHasVulnerableTarget(array<XGAbility> arrAbilities){}
simulated function UpdateHiddenDestinations(optional bool bSorted){}
simulated function UpdateNearestVisible(){}
simulated function UpdateOverwatchingEnemies(array<XGUnit> arrOverwatchingEnemies){}
simulated function UpdateSeek(){}
simulated function UpdateShouldIgnoreCover(){}
simulated function UpdateTracked(){}
function UpdateTurnsUnseen(){}
simulated function array<XGUnit> UpdateValidTargets(array<XGUnit> arrValidTargetsList){}
simulated function Vector ValidateDestination(Vector vLoc){}
simulated function bool WarpTo(Vector vLoc, optional bool bValidate=FALSE, optional bool bDrop=TRUE, optional bool bForceExactLoc=FALSE, optional bool bEvaluateStance=TRUE){}
function WarpToDropship();
simulated function UpdateTrackingCue(out tracking_cue kEvent){}

state Active{
	simulated event BeginState(name P);
	simulated event EndState(name N);
}
state MoveState
{
    simulated function LogMoveAbilityData(){}
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
}
state AttackState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N);
}
state Berserk extends MoveState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
    simulated function Vector DecideNextDestination(optional out string strFail){}
}
state CapVolume extends MoveState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
    simulated function Vector DecideNextDestination(optional out string strFail){}   
}
state DestroyTerrain{
    simulated event BeginState(name P){}
    simulated event EndState(name N);
    function Vector GetDestroyTargetLocation(){}
}
state EndOfTurn{
	simulated event BeginState(name P);
    simulated event EndState(name N);
    simulated function OnUnitEndTurn(){}
    simulated function AddZombiePukeAction(){}
}
state Engage extends MoveState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
	simulated function Vector DecideNextDestination(optional out string strFail){}
}
state ExecutingAI
{
    simulated event BeginState(name P){}
    simulated event EndState(name N);
}
state Flank extends MoveState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
    simulated function Vector DecideNextDestination(optional out string strFail){}
}
state Flee extends MoveState
{
    simulated event BeginState(name P){}
    simulated function bool FindRunawayPosition(out Vector vLoc, XGUnit kEnemy, optional out Vector vDirToEnemy, optional float fMetersFromEdge, optional out string strFail){}
    simulated event EndState(name N){}
    function Vector DecideNextDestination(optional out string strFail)
    {}   
}
state ForceMoveTo extends MoveState
{
    simulated event BeginState(name P)
    {}
    simulated event EndState(name N)
    {}
    simulated function Vector DecideNextDestination(optional out string strFail)
    {}
    simulated function DoStateTransition()
    {}  
}
state GenericAbility
{
    ignores BeginState;
    simulated event EndState(name N)
    {}
}
state HuntMimicBeacon extends MoveState
{
    simulated event BeginState(name P){}
    simulated event EndState(name N){}
    simulated function Vector DecideNextDestination(optional out string strFail){} 
}
state IgnoreCoverMove extends MoveState
{
    simulated event BeginState(name P)
    {}
    simulated event EndState(name N)
    {}
    simulated function Vector DecideNextDestination(optional out string strFail)
	{}
}

auto state Inactive
{
    simulated event BeginState(name P)
    {}
    simulated event EndState(name N);
    simulated function bool IsActive()
    {}
    simulated function BeginTurn()
    {}
}
state MindControlledMove extends MoveState
{
    simulated event BeginState(name P)
    {}
    simulated event EndState(name N)
    {}
    simulated function Vector DecideNextDestination(optional out string strFail)
	{}
}
state MoveManeuver extends MoveState
{
    simulated event EndState(name N)
    {}
    function Vector DecideNextDestination(optional out string strFail)
	{}
}


state PodMove
{
}
state Roam extends MoveState
{
    function Vector DecideNextDestination(optional out string strFail){}  
}
state TacticalMove extends MoveState
{
    simulated event BeginState(name P)
    {}
    simulated function bool FindRunawayPosition(out Vector vLoc, XGUnit kEnemy, optional out Vector vDirToEnemy, optional float fMetersFromEdge, optional out string strFail)
    {}
    simulated event EndState(name N)
	{}
    simulated function Vector DecideNextDestination(optional out string strFail)
	{}
}
state Tracking extends MoveState
{
    function Vector DecideNextDestination(optional out string strFail)
    {}   
}
