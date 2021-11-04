class XGAIPlayer extends XGPlayer
    native(AI)
    notplaceable;
//complete stub
enum AIOrderMode
{
    eAIOM_StaticClosestFirst,
    eAIOM_DynamicFurthestFirst,
    eAIOM_DynamicClosestFirst,
    eAIOM_MAX
};

struct native prox_info
{
    var float fDistSq;
    var XGUnit kUnit;
    var int iAlienNum;
};

struct native Mimic_Beacon_Info
{
    var int iTurnsRemaining;
    var Vector vLoc;
    var XGUnit UnitFired;
};

struct native UFO_data
{
    var float fRadius;
    var Vector vCenter;
};

struct CheckpointRecord_XGAIPlayer extends CheckpointRecord
{
    var int m_iCurrUnit;
    var int m_uiHasBeenVisible;
    var UFO_data m_kSquadStart;
    var XGAIPlayerOvermindHandler m_kOvermindHandler;
    var XGUnit m_kVIP;
    var bool m_bVIPChecked;
    var bool m_bIsTerrorMap;
    var array<XGUnit> m_arrTerrorAliens;
    var array<Mimic_Beacon_Info> m_arrMimicBeacons;
};
struct native adjacency_list
{
    var float Dist[128];
};
struct native TeamAttack
{
    var XGUnit kFlanker;
    var XGUnit kTarget;
    var Vector vFlankPointA;
    var Vector vFlankPointB;
    var bool bValid;
    var bool bSuppressed;
};

struct mindfray_option
{
    var XGUnit kFrayer;
    var array<XGUnit> akFrayTargets;
    var array<XGUnit> akPsiControlTargets;
    var array<XGUnit> akPsiPanicTargets;
};

var array<adjacency_list> m_kTeamAdjacencyMatrix;
var array<adjacency_list> m_kEnemyAdjacencyMatrix;
var int m_iCurrUnit;
var int m_uiHasBeenVisible;
var UFO_data m_kSquadStart;
var bool m_bSkipAI;
var bool m_bShowAI;
var bool m_bAbortedMove;
var bool m_bHasUFO;
var bool m_bHasHiders;
var bool bVerboseLogging;
var bool m_bVisibleCacheDirty;
var bool m_bHomogeneousLoadouts;
var bool m_bPauseAlienTurn;
var bool m_bGrenadeThrown;
var bool m_bLaunched;
var bool m_bIdleTurn;
var bool m_bIgnoreConstraints;
var bool m_bLoadedFromSave;
var bool m_bIsTerrorMap;
var bool m_bAttackedCivilianThisTurn;
var bool m_bVIPChecked;
var bool m_bHasAoETargets;
var array<prox_info> m_akProxInfo;
var int m_iShotFired;
var int m_nMaxInactivityAlienSpawns;
var float m_fMaxUnitRadius;
var float m_fCallWaiting;
var array<XGUnit> m_arrWaitingToRespond;
var float m_fMinEndTime;
var float m_fNextRandomSoundTime;
var int m_bsCanAttack;
var XGUnit m_kFlankingTarget;
var XGUnit m_kTarget;
var array<badcover> m_arrBadCover;
var int m_iActivePawnCount[69];
var int iPathFailures;
var int iPathAttempts;
var array<XComSpawnPoint> m_arrDebugSpawnPts;
var array<XComSpawnPoint> m_arrDebugLootSpawns;
var array<XComProjectile_FragGrenade> m_arrGrenadeList;
var float fHangTimer;
var array<XGUnit> m_arrVisibleCache;
var array<XGUnit> m_arrAllEnemies;
var array<XGUnit> m_arrValidTargets;
var array<XGUnit> m_arrCachedSquad;
var array<XGUnit> m_arrActiveEngaged;
var array<XGUnit> m_arrInactive;
var array<XGUnit> m_arrNotVisible;
var array<XGUnit> m_arrEnemiesInOverwatch;
var array<XGUnit> m_arrBattleScanners;
var array<ai_cover_score> m_arrTacticalData;
var array<ai_cover_score> m_arrTerroristData;
var array<ai_cover_score> m_arrHiddenData;
var array<XComCoverPoint> m_arrFlankPoints;
var XComCoverPoint m_kLaunchTo;
var float m_fMaxWeaponRange;
var float m_fMinTeammateDistance;
var float m_fDefaultMinEngageRange;
var XGAIPlayerOvermindHandler m_kOvermindHandler;
var TeamAttack m_kTeamAttack;
var array<XGUnit> m_arrSuppressed;
var array<XGUnit> m_arrGrenadiers;
var int m_eDefaultType;
var int m_nPreplacedAliens;
var int m_iTurnsIdle;
var array<Box> m_arrDangerZones;
var array<XGInventoryItem> m_arrSeenWeapons;
var XGAIPlayer.AIOrderMode m_eOrder;
var array<XGUnit> m_arrSuppressTarget;
var array<XGUnit> m_arrPriorityList;
var(Terror) int m_iMaxCivilianKillRate;
var int m_iTerrorLastKillTurn;
var int m_nLastKillCount;
var array<XGUnit> m_arrTerrorAliens;
var array<XGUnit> m_arrHiddenTerrorAliens;
var array<XGUnit> m_arrVisibleTerrorAliens;
var XGAIAbilityRules m_kAbilityRules;
var int m_iCurrCacheVer;
var XGLevel kLevel;
var const localized string m_strAIHangAborted;
var XGUnit m_kVIP;
var array<aoe_target> m_arrAoETarget;
var aoe_target m_kDeathBlossomTarget;
var aoe_target m_kLastAoETargetUsed;
var array<XGUnit> m_arrAoECachedTargets;
var XGUnit m_kMindFrayTarget;
var XGUnit m_kPriorityUnit;
var XGUnit m_kPsiAttacker;
var int m_nMaxMindMergesPerTurn;
var int m_nMindMergesThisTurn;
var XGUnit m_kLaunchCandidate;
var XGUnit m_kDeathBlossomCandidate;
var array<XGUnit> m_arrMindMergeCandidates;
var Vector m_vUpdateUnitLookAt;
var Volume m_kPriorityVolume;
var array<XGUnit> m_arrHealer;
var array<heal_option> m_arrWounded;
var array<heal_option> m_arrHealAssignment;
var array<Mimic_Beacon_Info> m_arrMimicBeacons;
var int m_iStrangleCooldown;
var array<XGUnit> m_arrUnitsInCapZone;
var XGUnit kDebugDest;
var int m_iDebugLogPos;
var int m_iMinScore;
var int m_iMaxScore;
//var delegate<WoundedSort> __WoundedSort__Delegate;

delegate int WoundedSort(heal_option kOptionA, heal_option kOptionB);
simulated function AddActiveUnit(XGUnit kUnit, optional bool bUpdate){}
simulated function int AddAliensAt(Vector vLoc, int iNum, XGGameData.EPawnType eAlienType, optional Vector vSpawnDir){}
function AddHoloTargetingToPriorityList(){}
simulated function AddMindControlledUnits(out array<XGUnit> arrList){}
function AddSeekerPriorities(){}
function AddSuppressTarget(XGUnit kEnemy, optional bool RebuildDistances){}
function bool AlienCanFlank(XGUnit kUnit){}
simulated function class<XGAIBehavior> AlienTypeToBehaviorClass(XGGameData.EPawnType eAlienType){}
function ApplyCheckpointRecord(){}
function heal_option AssignHealers(optional XGUnit kUnit){}
function bool AvoidVIP(){}
simulated function int CalculateCoverScore(out ai_cover_score kScore, optional XGUnit kUnit){}
simulated function int CalculateDestinationScore(out ai_cover_score kScore, optional XGUnit kUnit, optional bool bVis=true){}
simulated function CallRespond(XGUnit kUnit, optional float fMinWait=0.50){}
simulated function bool CanAttack(int iIndex){}
simulated function bool CanAttackEnemyFromLocation(XGUnit kUnit, Vector vLoc){}
simulated function bool CanCrit(){}
simulated function bool CanHear(XGUnit kUnit, Vector vSoundPos){}
function bool CanMindMerge(){}
simulated function bool CanOneShot(int iDamage, int iUnitHP, XGUnit kDamageDealer){}
simulated function bool CanPathToLocation(Vector vLocation, XGUnit kUnit, optional int iNumMoves, optional out float fPathLength){}
function bool CanSuppressFlankedUnit(XGUnit kUnit, optional bool bSetPredeterminedAbility=true){}
simulated function bool CanUnitAscend(){}
simulated function bool CanUnitSuppress(XGUnit kUnit){}
simulated function CheckForAoETargetUpdate(optional bool bForceUpdate, optional XGUnit kShooter){}
function CheckForStuckAliens(array<XGPod> arrPodList){}
simulated function CollectEnemiesDelegate(XGUnit kUnit){}
simulated function CollectTargetEnemies(XGUnit kUnit){}
simulated function bool CompareProxInfoOrderBefore(prox_info kNewInfo, prox_info kInfo){}
function int CountDrones(array<XGUnit> arrList){}
function CreateCheckpointRecord(){}
simulated function CreateSquad(array<XComSpawnPoint> arrSpawnPoints, array<XGGameData.EPawnType> arrPawnTypes){}
simulated function DebugDrawCoverPointHandles(const out array<XComCoverPoint> arrCoverPoints, optional bool bPersistent){}
simulated function DebugDrawCoverPoints(const out array<ai_cover_score> arrCoverPoints, optional bool bPersistent){}
function DebugLogHang(){}
function DebugShowNextAlienValidDestinations(optional XGUnit kUnit){}
simulated function DemoteDestination(Vector vLocation, optional bool bDelete){}
simulated function DemoteDestinationInArray(out array<ai_cover_score> aData, Vector vLocation, optional bool bDelete){}
function int DetermineOverwatchDangerZone(XGUnit kUnit, Vector vLocation){}
simulated function bool DoesPathEnterCloseCombat(XGUnit kFlanker, Vector vDestination){}
simulated function DoRandomSpawns(){}
simulated function DoResponseCall(){}
simulated function DrawDebugLabel(Canvas kCanvas){}
function DrawDebugPath(array<TTile> arrPath, bool bSuccess){}
simulated function DrawSpawnPoints(){}
simulated function XGUnit FindBestIsolatedTarget(optional out XGUnit kNextClosestEnemy){}
function bool FindCommonFrayAttackTargets(array<mindfray_option> arrFrayOptions){}
function XGUnit FindMostRemoteUnit(array<XGUnit> arrList){}
function bool FindRocketDestinationForCluster(out Vector vMidpoint, const out aoe_target kTarget, const out array<XGUnit> arrCluster){}
function XGUnit FindSuppressionSupport(Vector vLoc, float fMaxDist, XGUnit kIgnore, optional out int nUnitsToMove, optional bool bNonMeleeOnly=true){}
function XGUnit FindUnitByAIIndex(int iIndex){}
function bool FindVisibleLocationFromList(out Vector vVisibleLoc, const out array<int> arrList, const out XGUnit kShooter){}
function FireBeginTurnKismetEvent(){}
function FireEndingTurnKismetEvent(){}
simulated function bool FlankDestinationUpdate(XGUnit kFlanker, XGUnit kTarget, Vector vDestination){}
simulated function bool ForceUnitFlank(XGUnit kUnit){}
simulated function bool ForceUnitSuppress(XGUnit kUnit){}
function float GetAcceptableOverwatchMovementSightRadiusPercent(){}
function int GetAdjacencyIndex(XGUnit kUnit, optional bool bEnemy){}
function GetAdjacencyList(XGUnit kUnit, const out array<XGUnit> arrUnits, out adjacency_list kList_Out){}
function GetAdjacentUnits(XGUnit kBaseUnit, out array<XGUnit> arrTeam, out array<XGUnit> arrEnemies, float fMaxDist, optional bool bIncludeBaseUnit){}
function GetAllActiveCyberdiscs(out array<XGUnit> arrUnits_Out){}
function GetAllActiveFloaters(out array<XGUnit> arrFloaters_Out, bool bFilterJustLaunched){}
function GetAllActiveTeammatesOfType(XGGameData.EPawnType eType, out array<XGUnit> arrUnits_Out){}
simulated function array<XGUnit> GetAllAoETargets(optional bool bPullLastAoETarget){}
simulated function GetAllEnemies(out array<XGUnit> arrEnemies){}
simulated function GetAllNearbyCoverPoints(out array<XComCoverPoint> arrCover, optional float fMaxDist, optional XGUnit kUnit, optional bool bUseUnseenEnemies=true, optional bool bLogging){}
simulated function bool GetAoEDestination(out Vector vDest, out XGUnit kNearest, float fSplashRadius, optional bool bPullLastTargets=true){}
simulated function float GetAttackRange(XGUnit kUnit){}
simulated function class<XGAIBehavior> GetBehaviorClass(XGGameData.EPawnType eAlienType){}
simulated function GetCloseRangeCounts(XGSquad kSquad, out int nMaxHP, out int nLowHP, out int nCP, optional out int iAggro){}
simulated function XGUnit GetCloserUnit(XGUnit kActiveUnit, XGUnit kUnitA, XGUnit kUnitB){}
function XGUnit GetClosestHealerToUnit(XGUnit kTarget, out float fBestDistSq, array<XGUnit> arrHealers){}
simulated function Vector GetClosestPointAlongLineToTestPoint(Vector vLinePointA, Vector vLinePointB, Vector vTestPoint){}
simulated function XGUnit GetClosestPriorityTarget(XGUnit kSource){}
function bool GetClusterIntersection(out array<int> arrIntersection, const out array<XGUnit> arrUnit, float fRadius){}
simulated function XGUnit GetFirstToAct(){}
simulated function float GetFurthestScore(XGUnit kSource, array<XGUnit> arrSet){}
simulated function XGUnit GetFurthestUnitFromSet(array<XGUnit> arrSet){}
simulated function bool GetGoodCoverPoints(out array<ai_cover_score> arrOutCover, optional out array<XComCoverPoint> arrFlank, optional out array<ai_cover_score> arrOutTerror, optional out array<ai_cover_score> arrOutHidden, optional XGUnit kUnit, optional bool bUseUnseenEnemies=true, optional bool bLogging){}
function Vector GetHeardLocation(XGUnit kCaller){}
simulated function int GetLastAttackerIndex(XGUnit kAttackedUnit){}
simulated function float GetMaxAttackRange(){}
simulated function int GetMaxEnemyWeaponStrength(){}
function int GetMaxEngagedAI(){}
simulated function Vector GetMidPoint(array<XGUnit> arrUnit){}
function bool GetMindFrayOption(out mindfray_option kOptionOut){}
simulated function bool GetNearbyFlankers(out array<XGUnit> arrFlankers, XGUnit kUnit){}
simulated function XGUnit GetNearestEnemy(Vector vPoint, optional out float fClosestDist, optional bool bUseVisibleList, optional bool bConsiderCiviliansEnemies){}
simulated function XGUnit GetNearestIdleEnemy(Vector vPoint, optional bool bSkipStrangle){}
simulated function int GetNearestSpawnPoint(XComSpawnPoint kLootSpawn, array<XComSpawnPoint> arrSpawnPoints){}
function XGUnit GetNearestTerrorist(Vector vLoc){}
native simulated function XGUnit GetNearestVisibleEnemy(Vector vPoint, optional out float fDistSq_out, optional XGUnit kIgnore);
simulated function GetNonCoverPointsAround(out array<Vector> arrLoc, Vector vCenter, float fRadius);function int GetNumActiveAliensOfType(int iPawnType){}
function int GetNumEnemiesThatCanSeeLocation(Vector vLoc, optional XGUnit kUnit){}
simulated function int GetNumTargetsInRange(Vector vLocation, float fSplashRadiusSq, optional array<XGUnit> arrUnitsToCheck, optional out array<XGUnit> arrUnits, optional bool bSortVIP, optional float fHeight=-1.0){}
simulated function XGPod GetPod(XGUnit kUnit){}
simulated function bool GetPointOutsideEnemyCCRange(out Vector vPoint, XGUnit kTarget, XGUnit kFlanker, Vector vDestination){}
function bool GetPointsOutsideEnemyRange(out array<Vector> arrPoints_Out, int nPoints, Vector vTowardsLoc){}
function XComSpawnPoint GetRandomSpawnPoint(Vector vNotHere){}
function bool GetRocketDestination(out aoe_target kTarget){}
simulated function array<XComCoverPoint> GetSortedDestinationList(XGUnit kUnit, optional bool bColdReset){}
simulated function GetSquadLocation(out Vector vSquadLoc, out float fRadius){}
function string GetTacticsText(XGPod kPod){}
function bool GetValidHealerList(out array<XGUnit> arrHealFirstList){}
simulated function GetVisibleEnemies(out array<XGUnit> arrVisibleEnemies, optional bool bEngagedOnly, optional bool bIgnoreWounded){}
simulated function HandleAlienDeath(XGUnit kAlien){}
simulated function HandleEnemyDeath(XGUnit kUnit){}
simulated function bool HasAoEAbilities(out array<aoe_target> arrAoE, optional XGUnit kShooter){}
simulated function bool HasBeenVisible(int iUnit){}
function bool HasExaltSoldiers(){}
function bool HasGoodCoverInRange(XGUnit kHealer, XGUnit kTarget, float fRange){}
function bool HasLimitedActiveAI(){}
simulated function bool HasNearbySuppressor(Vector vLocation, float fDistance){}
simulated function bool HasPriorityTarget(XGUnit kSource){}
simulated function bool HasSquadFired(){}
simulated function bool HasTeammateSupport(XGUnit kUnit, float fDistance){}
simulated function bool HasUnitFired(int iAlienIndex){}
function bool HasUnitsInOverwatch(){}
simulated function bool HasUnshieldedMechtoids(){}
function Init(optional bool bLoading){}
simulated function InitAttackRange(){}
function InitCallWaiting(optional float fMinTime=0.40, optional float fTimeRange=0.80){}
simulated function InitMindMerge(){}
simulated function bool InitPodCoordination(const out array<XGUnit> arrUnit, out array<XComSpawnPoint> arrMoveTo, const out XGUnit kEnemy){}
simulated function InitRules(){}
simulated function InitTeamAttack(){}
simulated function InitTurn(){}
function InitVIP(){}
simulated function InvalidateVisibleCachedEnemies(){}
function bool IsAcceptableMindMergeLocation(Vector vLocation, XGUnit kSectoid, optional bool bTargetIsMechtoid){}
function bool IsAlienWaveSystemActive(){}
function bool IsAtLowHealth(XGUnit kUnit, XGUnit kEnemy){}
simulated function bool IsEnemyAttackableFromCover(XComCoverPoint kCover, optional XGUnit kUnit){}
simulated function bool IsGoodFlankDestination(Vector vLocation, XGUnit kFlanker, optional out float fDist, optional bool bDebugLog){}
simulated function bool IsHanging(string szDesc, optional float fHangLength=15.0){}
native simulated function bool IsInBadArea(Vector vLoc, XGUnitNativeBase kUnitToIgnore, optional bool bIgnoreSquaddies, optional bool bMeleeOnly, optional bool bDebugLog, optional bool bIgnoreAoE);
native simulated function bool IsInDangerousArea(Vector vLoc);simulated function bool IsInSameTile(TTile v1, TTile v2, optional int Z_fudge){}
simulated function bool IsInSameTileV(Vector v1, Vector v2){}
simulated function bool IsInsideUfo(Actor KActor, optional bool bFailWhenVolumeMissing){}
simulated function bool IsLocationWithinGrenadeRadius(Vector vLoc, Vector vGrenadeLoc, float fRadius, optional out float fOutDistSq){}
function bool IsOnStrangleCooldown(){}
simulated function bool IsSuppressingEnemy(){}
function bool IsUnitStuck(XGUnit kUnit, optional bool bDebugging, optional bool bOptimal){}
simulated function bool IsValidEnemyTarget(XGUnit kEnemy, XGUnit kSource, optional bool bForSuppression){}
function bool IsWithinRange(XGUnit kBaseUnit, XGUnit kTargetUnit, float fMaxDist){}
simulated function LoadInit(){}
simulated function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<XGGameData.EPawnType> arrPawnTypes){}
simulated function MarkDestinationCacheDirty(){}
simulated function MarkShotFired(int iAlienIndex){}
simulated function MarkTargetAndCallOthers(XGUnit kTarget, int iCurrUnit, optional bool bAudioOnly, optional XGAIBehavior.ETrackingCueAudioType eCallType){}
simulated function bool NeedsHiddenCoverOptions(){}
event OnBeginSplashDamage(DamageEvent kDmg, out array<XComUnitPawnNativeBase> arrPawns_Out){}
function OnCriticalWound(XGUnit kUnit){}
simulated function OnDeathUpdateActiveList(XGUnit kUnit){}
function bool OneEnemyLeft(){}
simulated function int OnHearCall(XGUnit kCaller, XGUnit kEnemy, XGAIBehavior.ETrackingCueAudioType eCallType, optional bool bRespond){}
simulated function OnHearEnemy(XGUnit kUnit, XGUnit kEnemy){}
function OnMimicBeacon(Vector vLoc, XGUnit InUnitFired){}
function OnMoveComplete(XGUnit kAlien, XGManeuver kManeuver){}
function OnPodMoveComplete(XComAlienPod kPod, XGManeuver kManeuver){}
function OnReveal(XGUnit kAlien, XGUnit kEnemy){}
function OnRevealComplete(array<XGUnit> arrAlien, XGUnit kEnemy){}
simulated function OnSeeEnemy(XGUnit kEnemy);function OnSound(Vector vLoc, XGUnit kSourceUnit){}
function OnSpawn(int iSpawn, array<XGUnit> kAlien){}
function OnSpawnUnit(XGUnit kAlien){}
simulated function OnUnitDeath(XGUnit kUnit){}
function OnUnitKilled(XGUnit DeadUnit, XGUnit Killer){}
function OnUnitSwapTeams(optional XGUnit kUnit){}
simulated function OnUnitWounded(XGUnit kUnit){}
function OnUpdateCapturePoints(){}
simulated function PlaceSavedMimicBeacons(){}
simulated function PreInitTeamAttack(){}
simulated function XComPresentationLayer PRES(){}
function EPawnType PullRandCharacterType(out array<XGGameData.EPawnType> arrPawnTypes){}
simulated function RecordOneShot(){}
function heal_option RefreshHealerAssignments(optional out XGUnit kUnit){}
function RemovePriorityUnit(XGUnit kUnit){}
simulated function RemoveUnit(XGUnit kUnit, optional bool bUninitOnly){}
simulated function RemoveUnitsInLastAoeTarget(out array<XGUnit> arrCluster){}
simulated function ResetAllDestinationCache(){}
simulated function ResetBadCover(){}
simulated function ResetCoverScore(out ai_cover_score kScore){}
simulated function ResetHangTimer(){}
simulated function ResetShotFired(){}
function ResetStrangleCooldown(optional int iTurns){}
simulated function ScoreCover(XComCoverPoint kCover, out ai_cover_score kScore, optional XGUnit kUnit){}
simulated function SetBadCoverZone(Vector vBadLoc, float fRadius, float fMeleeRadius, ETeam Team, int iAlienIdx, optional XGGameData.EPawnType kType){}
simulated function SetCanAttack(int iIndex){}
simulated function SetFirstUnit(XGUnit kUnit){}
simulated function SetHasBeenVisible(int iUnit){}
simulated function SetLastUnit(XGUnit kUnit, optional bool bBeforeInactive=true){}
simulated function bool SetNextUnit(XGUnit kUnit){}
function SetSuppressedEnemies(XGUnit kTarget){}
function SetUnitOrder(XGAIPlayer.AIOrderMode eOrder){}
simulated function bool ShouldGrenade(){}
simulated function ShowTeamDestinationScores(Canvas kCanvas, optional bool bTerror){}
simulated function SignalEnemyTarget(XGUnit kCaller, XGUnit kEnemy){}
simulated function SkipCallResponse(XGUnit kUnit){}
simulated function SnapToBorders(out Vector vPoint){}
simulated function SortInactiveList(){}
function int SortPotentialCappers(XGUnit kUnit1, XGUnit kUnit2){}
simulated function XGUnit SpawnAlien(XGGameData.EPawnType eAlienType, XComSpawnPoint_Alien kSpawnPt, optional bool bSnapToCover, optional bool bSnapToGround, optional bool bAddFlag, optional bool bUseAltWeapon, optional bool bBattleScanner){}
function SpawnAliensFromList(out array<XComSpawnPoint> kList, int nSpawns, out array<XGGameData.EPawnType> arrPawnTypes, Vector vFacing, optional bool bSnapToCover){}
simulated function SpawnForced(out array<XComSpawnPoint> arrSpawnPoints, out array<XGGameData.EPawnType> arrPawnTypes, optional bool bSnapToCover){}
simulated function SpawnRandomAlien(XGGameData.EPawnType eType, int iCount){}
function TerrorMap_DoOffscreenKill(){}
function TerrorMap_OverwatchUpdate(XGUnit kUnit){}
simulated function TerrorMap_PostTurnUpdate(){}
simulated function TerrorMap_TurnInit(){}
simulated function bool TestHasCover(XComCoverPoint kCover, const out array<XGUnit> arrEnemies, optional bool bLog){}
simulated function bool TestMindMergeVisibility(Vector vPoint, XGUnit kSource, XGUnit kTarget){}
event Tick(float fDeltaT){}
function bool UnitHasMovePriorityOver(XGUnit kUnitA, XGUnit kUnitB){}
simulated function bool UnitIsReady(XGUnit kUnit){}
simulated function UpdateActiveUnits(optional bool bCheckAllActive){}
function UpdateAdjacencyMatrix(optional bool bTeam=true, optional bool bEnemy=true){}
simulated function bool UpdateAoETargets(optional XGUnit kShooter, optional bool bDebugDraw){}
simulated function UpdateBadCoverZone(Vector vBadLoc, int iAlienIdx, ETeam Team, optional float fRadius){}
simulated function UpdateCachedSquad(optional bool bDebugLogging){}
function UpdateCappers(){}
function UpdateCooldowns(){}
function UpdateDangerousAreas(){}
function UpdateDeathBlossomCandidate(){}
function UpdateDeferredList(array<XGUnit> arrException){}
simulated function UpdateEnemiesList(){}
simulated function UpdateEnemyWeapons(){}
simulated function XGUnit UpdateFlanking(optional out int nFlankers){}
function bool UpdateHealers(){}
simulated function UpdateHeardArray(Vector vSource, out array<XGUnit> arrHeard, XGUnit kUnit, int nMAX){}
function UpdateLaunchCandidate(){}
simulated function UpdateMaxWeaponRangeDelegate(XGUnit kUnit);
final function UpdateMimicBeacons(){}
simulated function UpdateNotVisible(){}
simulated function UpdateOverwatchingEnemies(){}
simulated function UpdatePathFailures(bool bFailed){}
simulated function UpdatePawnCounts(){}
simulated function UpdatePawnCountsDelegate(XGUnit kUnit){}
function XGUnit UpdatePriorityUnit(){}
simulated function UpdateProximityList(){}
function UpdatePsiList(){}
simulated function UpdateRandomSounds(){}
simulated function UpdateResponseCalls(float fTime){}
function XGUnit UpdateStrangleTargets(XGUnit kSeeker){}
simulated function XGUnit UpdateSuppressors(){}
simulated function bool UpdateTacticalDestinations(optional bool bColdReset, optional bool bUseUnseenEnemies=true, optional XGUnit kUnit, optional bool bLogging){}
simulated function UpdateTeamTarget(){}
simulated function UpdateTerrorAliens(){}
simulated function UpdateTerroristData(){}
function UpdateTerrorMission(){}
simulated function UpdateValidEnemyTargets(){}
simulated function UpdateWeaponTactics(XGInventory kInventory){}
function bool UpdateWounded(){}
function WarpPodToValidLocation(XGPod kPod){}
simulated function bool WillAoEDamageCapturePoints(Vector vCenter, float fSplashRadius){}

simulated state Active
{
    simulated function bool EndTurn(XGGameData.EPlayerEndTurnType eEndTurnType)
    {
    }

    function DebugLogHang()
    {
    }
}
simulated state BeginningTurn
{
    simulated function PlayAlienActivitySound()
    {
    }
}
state ExecutingAI
{
    function XGUnit UpdatePriorityUnit()
    {
        local XGUnit kUnit;

        kUnit = global.UpdatePriorityUnit();
        if(kUnit != none)
        {
            return kUnit;
        }
        return none;
    }

    simulated function ResetMinTimer()
    {
    }

    simulated function bool HasExceededMinTimer()
    {
        if(m_arrNotVisible.Length > 0)
        {
            return WorldInfo.TimeSeconds > m_fMinEndTime;
        }
        return true;
    }

    simulated function bool CheckForCloseCombatMode()
    {
        return false;
    }

    simulated function OnUnitDeath(XGUnit kUnit)
    {
    }
}

auto simulated state Inactive
{
    simulated function BeginTurn()
    {
        GotoState('BeginningTurn');
    }

    simulated event Tick(float fDeltaT)
    {
        UpdateResponseCalls(fDeltaT);
    }    
}