class XComTacticalCheatManager extends XComCheatManager within XComTacticalController
    native(Core)
	dependsOn(XGTacticalGameCoreNativeBase)
	dependsOn(XComTraceManager);

var int m_iLastTeleportedAlien;
var bool bShowShotSummaryModifiers;
var bool bDebugDisableHitAdjustment;
var bool bDebugClimbOver;
var bool bDebugClimbOnto;
var bool bDebugCover;
var bool bShowActions;
var bool bAllUnits;
var bool bShowDestination;
var bool bInvincible;
var bool bUnlimitedAmmo;
var bool bMarker;
var bool bShowPaths;
var bool bAIStates;
var bool bPlayerStates;
var bool bShowNamesOnly;
var bool bShowDropship;
var bool bShowTracking;
var bool bShowVisibleEnemies;
var bool bMinimap;
var bool bShowCursorLoc;
var bool bShowCursorFloor;
var bool bShowSpawnPoints;
var bool bShowLoot;
var bool bTurning;
var bool bVerboseOnScreenText;
var bool bAITextSkipBase;
var bool bShowInteractMarkers;
var bool bShowFlankingMarkers;
var bool bForceSuppress;
var bool bForceOverwatch;
var bool bForceAIFire;
var bool bForceFlank;
var bool bForceEngage;
var bool bForceAttackCivilians;
var bool bForceMindMerge;
var bool bForceMindControl;
var bool bForceGrenade;
var bool bForceAscend;
var bool bForceLaunch;
var bool bForcePsiPanic;
var bool bForceHunkerDown;
var bool bShowAttackRange;
var bool bShowProjectilePath;
var bool bShowProjectiles;
var bool bDebugPods;
var bool bDebugGrenades;
var bool bDebugZombies;
var bool bDebugLoot;
var bool bDebugMindMerge;
var bool bShowBadCover;
var bool bDeadEye;
var bool bForceCriticalWound;
var bool bForceNoCriticalWound;
var bool bNoLuck;
var bool bShowAbilitySelection;
var bool bShowExposedCover;
var bool bShowAllBreadcrumbs;
var bool bShowTeamDestinations;
var bool bShowTerrorDestinations;
var bool bShowHiddenDestinations;
var bool bShowTeamDestinationScores;
var bool bShowTerrorDestinationScores;
var bool bShowCivTeamDestinations;
var bool bShowCivTeamDestinationScores;
var bool bAIUseReactionFireData;
var bool bShowTargetEnemy;
var bool bRevealAllCivilians;
var bool bBerserk;
var bool bShowOrientation;
var bool bRandomSpawns;
var bool bTestFlankingLocations;
var bool bDrawFracturedMeshEffectBoxes;
var bool bDebugInputState;
var bool bDebugPOI;
var bool bDebugAnims;
var bool bDisplayAnims;
var bool bDebugDead;
var bool bSkipReactionFire;
var bool bAllGlamAlways;
var bool bShowModifiers;
var bool bShowOverwatch;
var bool bVisualizeMove;
var bool bDebugReaction;
var bool bDebugCCState;
var bool bCloseCombatCheat;
var bool bCloseCombatDesiredResult;
var bool bShowAmmo;
var bool bThirdPersonAllTheTime;
var bool bForceOverheadView;
var bool bShowPathFailures;
var bool bDebugTargetting;
var bool bDebugFireActions;
var bool bDebugCoverActors;
var bool bDebugManeuvers;
var bool bDebugTimeDilation;
var bool bDebugTreads;
var bool bDebugWeaponSockets;
var bool bDebugOvermind;
var bool bTeamAttack;
var bool bAIGrenadeThrowingVis;
var bool bSkipNonMeleeAI;
var bool bDisableClosedMode;
var bool bDebugDestroyCover;
var bool bDebugPoison;
var bool bDisplayPathingFailures;
var bool bDebugBeginMoveHang;
var bool bDebugFlight;
var bool bDebugMouseTrace;
var bool bForceKillCivilians;
var bool bForceIntimidate;
var bool bShowUnitFlags;
var bool bDisableWorldMessages;
var bool bDebugLaunchCover;
var bool bDebugPathCover;
var bool m_bDebugPodValidation;
var bool m_bVisualPodValidationDebugging;
var bool bDisableTargettingOutline;
var bool bAlwaysRushCam;
var bool bDebugActiveAI;
var bool bShowShieldHP;
var bool bShowMaterials;
var bool bTestAttackOnDropDown;
var bool bDebugWaveSystem;
var bool bDebugWaveSystemContentRequests;
var bool bDebugBadAreaLog;
var bool bForcePodQuickMode;
var bool bUseStrangleStopA;
var bool bDebugCamera;
var int iShowPath;
var Vector vDebugLoc;
var int iTestHideableActors;
var name m_DebugAnims_UnitName;
var name m_ToggleUnitVis_UnitName;
var XComRandomList kRandList;
var Vector vReferencePoint;
var array<int> arrAbilityForceEnable;
var array<int> arrAbilityForceDisable;
var int iOverrideAnim;
var Vector vLookAt;
var XComCoverPoint kDebugCover;
var int iRightSidePos;
var name XCom_Anim_DebugUnitName;
var float fStrangleDist;
var array<int> arrSkipAllExceptions;

exec function AIDebugActiveList(optional int iRight)
{
   
}

exec function PlayDeath()
{
    
}

exec function PlayStabilize()
{
       
}

exec function PlayRevive()
{
      
}

exec function ClearDebug()
{
      
}

exec function AIDebugPodValidation(optional bool bVisual)
{
        
}

exec function AIForceIntimidate()
{
        
}

exec function AIAttackCivilians()
{
     
}

exec function ToggleDebugMouseTrace()
{
    
}

exec function AIDebugFlight()
{
     
}

exec function DebugPoison()
{
       
}

exec function DebugOvermind()
{
     
}

exec function AIDisplayPathingFailures()
{
        
}

exec function AISkipNonMeleeAI()
{
      
}

exec function AIGrenadeThrowing()
{
      
}

exec function AIShowTeamAttack()
{
       
}

exec function AIAbilityForceEnable(string strAbility)
{
  
}

exec function ToggleDebugWeaponSockets()
{
      
}

exec function DisableAimAdjust(bool shouldDisableAdjustedAim)
{
       
}

exec function DoVictoryCin()
{
   
}

exec function DoGenericLookAtGlamCamAtCursor()
{
}   

exec function TestGlamCams()
{
       
}

exec function DebugFireActions(optional int iOn)
{
      
}

exec function ToggleThirdPersonAllTheTime()
{
      
}

exec function ToggleThirdPerson()
{
       
}

exec function DEMOCams()
{
     
}

exec function ToggleCutoutBoxVisibility()
{
        
}

exec function DumpCutoutActors()
{
        
}

exec function LoadSavedCamera()
{
        
}

exec function ReportCutout()
{
    //return;    
}

exec function ToggleBuildingAndPropHiding()
{
    
}

exec function ToggleTargettingOutline()
{
       
}

exec function CursorTraceExtent(float factor)
{
        
}

exec function CutoutBoxWidth(float Width)
{
       
}

exec function CameraPitchingMode(bool bState)
{
    
}

exec function SetOutlineType(int Mode)
{
       
}

exec function Help(optional string tok)
{
        
}

exec function Prop(int N)
{
      
}

exec function AlienTurnIntensity(float X)
{
     
}

exec function ListAbilities()
{
   
}

exec function BuildingVis2(int N)
{
    //return;    
}

exec function ToggleUnitVis(bool bEnable, bool bActiveUnitOnly, bool bVisualizeFOW)
{
   
        
}

exec function UpdateVisibility(optional bool bIncremental)
{
        
}

exec function UpdateVisibilityMapForUnit()
{
    
}

exec function ShowTacticalControllerState()
{
       
}

exec function AIDebugAI(optional name unitName)
{
    
      
}

exec function AIDebugDead()
{
        
}

exec function AIShowExposedCover()
{
       
}

exec function DebugAnims(bool bEnable, optional bool bEnableDisplay, optional name unitName)
{
     
}

exec function AIDebugModifiers()
{
     
}

exec function ShowOverwatch()
{
       
}

exec function AIShowAITracking()
{
       
}

exec function AIShowVisibleEnemies()
{
        
}

exec function AIDebugManeuvers()
{
       
}

exec function TestManeuver_Attack()
{
       
}

exec function ShowCursorLoc()
{
      
}

exec function ShowCursorFloor()
{
       
}

exec function ViewLocation(float fX, float fY, float fZ)
{
    
}

exec function RemoveLookAt()
{
       
}

exec function AIShowSpawnPoints()
{
      
}

exec function ShowLoot()
{
       
}

exec function DebugTurning()
{
        
}

exec function AITextSkipBase()
{
     
}

exec function AITextVerbose()
{
       
}

exec function AIVerboseLogging()
{
        
}

exec function AIForceBloodlust()
{
       
}

exec function AIForceSuppress()
{
     
}

exec function AIForceOverwatch()
{
       
}

exec function AIForceAIFire()
{
        
}

exec function AIForceFlank()
{
     
}

exec function AIForceEngage()
{
      
}

exec function AIForceAttackCivilians()
{
    
}

exec function AIForceMindMerge(optional bool bInstant)
{
   
  
      
}

exec function AIForceMindControl()
{
     
}

exec function AIForceGrenade()
{
      
}

exec function AIForceAscend()
{
      
}

exec function AIForceLaunch()
{
     
}

exec function AIForcePsiPanic()
{
    
}

exec function AIForceHunkerDown()
{
     
}

exec function AIShowAttackRange()
{
    
}

exec function AIShowProjectilePath()
{
     
}

exec function ShowProjectiles()
{
     
}

exec function ShowOrientation()
{
  
}

exec function SetPodNeverActivate()
{
  
}

exec function DeadEye()
{
    
}

exec function ForceCriticalWound()
{
    
}

exec function ForceNoCriticalWound()
{
       
}

exec function NoLuck()
{
     
}

exec function ToggleInvincibility()
{
       
}

exec function ToggleUnlimitedAmmo()
{
     
}

exec function ToggleBerserk()
{
     
}

exec function GotoDebugLoc()
{
      
}

function SetLastDebugPos(Vector vPos)
{
       
}

exec function AIShowDestination()
{
       
}

exec function AIShowPaths()
{
       
}

exec function ShowPath(int iPath)
{
   
}

exec function ShowActions()
{
        
}

exec function ToggleDebugAllUnits()
{
      
}

exec function AIShowAIStates()
{
        
}

exec function ShowPlayerStates()
{
    
}

exec function AIShowNames()
{
   
}

exec function ShowDropshipLoc()
{
       
}

exec function SetRainIntensity(int iLvl)
{
    
}

exec function TakeNoDamage()
{
     
}

exec function PowerUp()
{
  
}

exec function CheatyFace()
{
    
}

exec function APCSettings()
{
    
}

exec function KillAliensWithinCursorRadius(int nMeters)
{
   
}

exec function DebugClimbOver()
{
    
}

exec function DebugClimbOnto()
{
    
}

exec function KillUnit()
{
   
}

exec function KillAndImplantUnit()
{
   
}

exec function InjureUnit(optional int iDamage, optional name unitName)
{
       
}

exec function TestMoraleEvent(optional int iMoraleEvent)
{
    
}

exec function PanicUnit(optional XGUnit kUnit)
{
   
}

exec function DebugCover()
{
   
}

exec function ShowShotMods(bool bShowShot)
{  
}

exec function TestCoverPoint()
{
}

exec function TestNearestEnemy_Distance()
{    
}

exec function IsCursorInUFO()
{
   
}

exec function AbortCurrentAction(optional name unitName)
{
   
}

exec function HackRegisterLocalTalker()
{
   
}

function OnRecognitionComplete()
{  
}

exec function AddUnits(int iNum)
{
}

exec function ThroughFireAndFlames()
{    
}

function Do_AddUnitAtCursor(int iLoadout, optional Vector vOffset)
{ 
}

exec function AddSectoids(int iNum)
{
}

function XGUnit DropAlien(XGGameData.EPawnType eAlien, optional bool bAddToHumanTeam, optional Vector vOffset)
{
     
}

exec function DropSectoid(optional bool bAddToHumanTeam)
{
     
}

exec function DropSectoidCommander(optional bool bAddToHumanTeam)
{
       
}

exec function DropFloater(optional bool bAddToHumanTeam)
{   
}

exec function DropHeavyFloater(optional bool bAddToHumanTeam)
{  
}

exec function DropMuton(optional bool bAddToHumanTeam)
{  
}

exec function DropMutonElite(optional bool bAddToHumanTeam)
{   
}

exec function DropMutonBerserker(optional bool bAddToHumanTeam)
{
}

exec function DropThinMan(optional bool bAddToHumanTeam)
{    
}

exec function DropElder(optional bool bAddToHumanTeam)
{ 
}

exec function DropEtherealUber(optional bool bAddToHumanTeam)
{
}

exec function DropCyberdisc(optional bool bAddToHumanTeam)
{   
}

exec function DropChryssalid(optional bool bAddToHumanTeam)
{
}

exec function DropSectopod(optional bool bAddToHumanTeam)
{
}

exec function DropDrone(optional bool bAddToHumanTeam)
{ 
}

exec function DropZombie(optional bool bAddToHumanTeam)
{ 
}

exec function DropOutsider(optional bool bAddToHumanTeam)
{ 
}

exec function DropMechtoid(optional bool bAddToHumanTeam)
{   
}

exec function DropSeeker(optional bool bAddToHumanTeam)
{   
}

exec function DropExaltOperative(optional bool bAddToHumanTeam)
{
}
exec function DropExaltSniper(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(62, bAddToHumanTeam);
    //return;    
}

exec function DropExaltHeavy(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(63, bAddToHumanTeam);
    //return;    
}

exec function DropExaltMedic(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(64, bAddToHumanTeam);
    //return;    
}

exec function DropExaltEliteOperative(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(65, bAddToHumanTeam);
    //return;    
}

exec function DropExaltEliteSniper(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(66, bAddToHumanTeam);
    //return;    
}

exec function DropExaltEliteHeavy(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(67, bAddToHumanTeam);
    //return;    
}

exec function DropExaltEliteMedic(optional bool bAddToHumanTeam)
{
    bAddToHumanTeam = false;
    DropAlien(68, bAddToHumanTeam);
    //return;    
}

exec function DropAll(optional bool bAddToHumanTeam)
{
   
}

exec function DropExalt_AllTypes(optional bool bAddToHumanTeam)
{
    
}

exec function DropShiv(optional string Weapon)
{
   
}

exec function DropSoldier(optional int iLoadout)
{
    iLoadout = -1;
    Do_AddUnitAtCursor(iLoadout);
    //return;    
}

exec function DropDroneAndSectopodToRepair(optional bool bAddToHumanTeam)
{
   
}

exec function KillNearestAlien()
{
    KillNearestUnit(16);
    //return;    
}

exec function KillNearestUnit(ETeam InputType)
{
   
}

exec function DropMan(optional bool bAddToHumanTeam)
{
     
}

exec function DropWoman()
{
     
}

exec function AIMarkers(optional bool bRevealEnemies)
{
   
}

exec function AIRevealAllCivilians()
{
    bRevealAllCivilians = !bRevealAllCivilians;
    class'XComWorldData'.static.GetWorldData().UpdateVisibility();
    //return;    
}

exec function ToggleInteractMarkers()
{
    bShowInteractMarkers = !bShowInteractMarkers;
    //return;    
}

exec function ToggleFlankingMarkers()
{
    bShowFlankingMarkers = !bShowFlankingMarkers;
    //return;    
}

exec function AIDebugPods()
{
    bDebugPods = !bDebugPods;
    //return;    
}

exec function AIAbilityDebug()
{
   
}

exec function AIDebugBadAreas()
{
    bDebugBadAreaLog = !bDebugBadAreaLog;
    //return;    
}

exec function DebugGrenades()
{
   
}

exec function ReloadAmmo()
{
       
}

exec function DebugZombies()
{
       
}

exec function DebugMindMerge()
{
       
}

exec function AIShowBadCover()
{
       
}

exec function AIShowReactionFireData()
{
        
}

exec function AIShowTeamDestinations(optional bool bShowScores)
{
        
}

exec function AIShowTerrorDestinations(optional bool bShowScores)
{   
}

exec function AIShowHiddenDestinations()
{    
}

exec function AIRefreshTeamDestinations()
{   
}

exec function AICivShowTeamDestinations(optional bool bShowScores)
{    
}

exec function AICivRefreshTeamDestinations()
{    
}

exec function TestNearestCoverPoint(optional float fRadius)
{
}

exec function AIShowTargetEnemy()
{    
}

exec function AIShowAlienDestinations()
{   
}

function ForceUnitPathToCursor(XGUnit kUnit)
{    
}

exec function Wound(optional XGUnit kUnit)
{   
}

exec function Revive(optional XGUnit kUnit)
{    
}

exec function AIForcePathToCursor()
{  
}

exec function AICivilianForcePathToCursor()
{ 
}

exec function DrawClosestValidPoint(int iColor, optional bool bAllowFlying, optional bool bUseNone, optional bool bPrioritizeZ)
{
}

exec function DrawClosestCoverPoint()
{   
}

function DrawSphereV(Vector vLoc, optional int iColor, optional float fRadius, optional bool bLookat)
{   
}

exec function DrawSphere(float fX, float fY, float fZ, optional int ColorIndex, optional float Radius, optional bool bLookat)
{  
}

exec function AIDebugCursorCoverLocation(optional bool bLaunch)
{
}

function DrawAimLineV(Vector vStart, Vector vAim)
{
       
}

exec function DrawAimLine(float fX, float fY, float fZ, float DX, float DY, float dz)
{ 
}

exec function TestPod()
{
}

function UnlimitedMovesDelegate(XGUnit kUnit)
{   
}

exec function UnlimitedMoves()
{  
}

simulated function XComPerkManager PERKS()
{   
}


native exec function DebugFlankingWithCursor();

native exec function DebugFlankingForUnit(string unitName);

exec function SetDiscState(int iState)
{
     
}

exec function TeleportAlienToCursor(optional name unitName)
{
   
}

exec function SkipAnimals()
{
     
}

exec function AISkipAnimals()
{
    
}

exec function SkipAI()
{
      
}

exec function AISkipAI()
{
    
}

exec function WatchAI()
{
       
}

exec function AIWatchAI()
{
    
}

exec function DebugCameraManager()
{
      
}

exec function SetOverheadCameraParameters(float fFOV, float fCameraDistance, float fPitchInDegrees)
{
     
}

exec function SuicideUnit(optional bool bBullet)
{   
}

exec function TriggerCameraEvent()
{  
}

exec function KillAllElse()
{
      
}

exec function UseController()
{
    XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kBattle.ProfileSettingsDebugUseController();
    //return;    
}

exec function TestGetClosest()
{
    //return;    
}

exec function TestNearestCoverDot()
{
    //return;    
}

exec function TestIntersectCloseCombat(optional bool bExtendPathToCursor)
{
   
}

exec function TestCoverPoints()
{   
}

exec function TestRangeAdvantage()
{
}

exec function VisualizePaths(coerce optional bool bEnable)
{
    bEnable = true;
    DebugPaths("final", bEnable);
    //return;    
}

exec function DebugPaths(coerce optional string DebugType, coerce optional bool bEnable)
{ 
}

exec function VisualizeMove()
{
    bVisualizeMove = !bVisualizeMove;
    //return;    
}

exec function DebugFracEffects(coerce optional bool bEnable)
{
    bEnable = true;
    bDrawFracturedMeshEffectBoxes = bEnable;
    //return;    
}

exec function TestPath(name unitName, int FromX, int FromY, int FromZ, int ToX, int ToY, int ToZ, optional bool bObeyMaxCost, optional bool bTreatAsAction)
{
 
}

exec function TestPathTo(name unitName, int ToX, int ToY, int ToZ, optional bool bObeyMaxCost, optional bool bTreatAsAction)
{
      
}

exec function TestSoldierRunForCover()
{   
}

exec function TestCivilianRunForCover()
{
}

exec function TestAlienRunForCover()
{
     
}

exec function EndTurn()
{ 
}

exec function PathAlongLine(optional bool bPathAlongLine)
{
        
}

exec function UISetDiscState(bool bDiscOn)
{
       
}

exec function UIToggleDisc()
{
    
}

exec function UIEnableEnemyArrows(bool bEnable)
{
    XComPresentationLayer(Outer.m_Pres).m_bAllowEnemyArrowSystem = bEnable;
    //return;    
}

exec function GetPathLengthData()
{
    //return;    
}

exec function DebugInteractionAnims()
{
    //return;    
}

exec function AddSightBlock(int fRadius, int fHeight, int iNumTurns)
{ 
}

exec function DropBattleScanner()
{
}

exec function TestHearNoiseAtCursor()
{   
}

exec function TestRandomSpawn(int nAliens)
{
    
}

exec function SetRandomSpawns()
{ 
}

exec function RandomAI()
{   
}

exec function TestFlankingLocations()
{
}

exec function TestIsolatedEnemy()
{
       
}

exec function TestLaunchToPosition()
{
    
}

exec function AIUnleashed()
{
      
}

exec function LowerMoraleForNearestSoldier()
{
       
}

exec function LowerAllSoldierMorale()
{
   
}

exec function TestHasOverheadClearance()
{
    
}

exec function TestVisibilityMap()
{
        
}

exec function TestTurnTowards(optional bool bAlien)
{
      
}

function InitRandList()
{
  
}

exec function TestRandomListShuffle()
{
   
}

exec function TestRandomListPop()
{
    //return;    
}

exec function TestRandomSound(optional bool bAlien)
{
   
}

exec function LogContingentPods()
{
    //return;    
}

exec function DropUnit(optional bool bAlien)
{
    
}

exec function TestOnSeeEnemy(int iRevealType)
{    
}

exec function TestToggleTeamVisibility()
{   
}

exec function TestNearestMeleePoint()
{  
}

exec function TestPodSecondaryNumbers(int n2ndAliens, int n2ndPods, int nTotalAliens, float fDesiredRatioToReg)
{    
}

exec function DebugInputState()
{     
}

exec function DebugPOI()
{
   
}

exec function CloseCombatCheat(bool bEnable, optional bool bDesiredResult)
{
     
}

exec function ToggleGhostMode()
{   
}

exec function ShowAmmo()
{
       
}

exec function SkipReactionFire()
{
      
}

exec function DebugReaction()
{  
}

exec function DebugCCState()
{
    bDebugCCState = !bDebugCCState;
    //return;    
}

function XGUnit GetClosestUnitToCursor(optional bool bAlienOnly, optional bool bXComOnly)
{
}

exec function TestToggleInFlight()
{
    local XGUnit kUnit;

    kUnit = GetClosestUnitToCursor();
    kUnit.m_bIsFlying = !kUnit.m_bIsFlying;
    //return;    
}

exec function TestToggleInAscent()
{
    local XGUnit kUnit;

    kUnit = GetClosestUnitToCursor();
    kUnit.m_bInAscent = !kUnit.m_bInAscent;
    //return;    
}

exec function SwapTeamsOnNearestUnit()
{
    
}

exec function TestBlockTile()
{
    
}

exec function SetReferencePoint()
{   
}

function XComInteractiveLevelActor FindNearestDynamicAIDoor(Vector vLoc)
{  
}

exec function TestBehindDoor()
{
   
}

exec function AIShowPathFailures()
{
     
}

exec function LogMapName()
{
    
}

exec function TestTileLocation(float fX, float fY, float fZ)
{
   
}

exec function ShowTileLocation(int X, int Y, int Z, optional float fR, optional float fG, optional float fB, optional float fA)
{
}

exec function GetBoneLocation(optional name kName)
{
   
}

exec function DrawLine(float Z1, float Z2)
{
       
}

exec function AISelectHealAssignments()
{   
}

exec function AIDestSpheres_ShowNextUnit()
{  
}

exec function AIDestSpheres_ShowClosestUnit()
{
}

exec function SetVolume(float fVolume)
{  
}

exec function DebugExitCover(XGUnit kUnit, XGUnit kTarget)
{
    //return;    
}

exec function DebugTargetting(bool bEnable)
{
    bDebugTargetting = bEnable;
    //return;    
}

exec function DebugCoverActors()
{
    bDebugCoverActors = !bDebugCoverActors;
    //return;    
}

exec function DebugXDA()
{
}

exec function DebugFLA()
{
}

exec function DebugTreads()
{    
}

exec function SetTreadFactor(XGUnit kUnit, float fFactor)
{
}

exec function SetWheelFactor(XGUnit kUnit, float fFactor)
{
}

exec function DebugTimeDilation()
{   
}

exec function ExplodeIt(float fRadius, float fDamage, float fWorldDamage, optional class<XComDamageType> DamageTypeClass, optional bool bInstigatorIsSelectedUnit)
{
}

exec function DebugTrace(XComTraceManager.EXComTraceType eTraceType, float TargetX, float TargetY, float TargetZ, float SourceX, float SourceY, float SourceZ, float fExtentSize)
{
    //return;    
}

exec function DamageUnit(XGUnit kUnit, int iDamageAmount)
{   
}

exec function OpenCyberdisc(optional XGUnit kUnit)
{
        
}

exec function CloseCyberdisc()
{  
}

exec function DisableClosedMode(bool bDisable)
{   
}

exec function DebugLoadout()
{
}

exec function TestAnimation(name strAnim)
{    
}

exec function ResetGrenadePreview()
{
    XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.iNumKeyframes = 0;
    //return;    
}

exec function AIDebugLogHang()
{
}

exec function AIDebugDestroyCover()
{
    bDebugDestroyCover = !bDebugDestroyCover;
    //return;    
}

exec function DebugPathing()
{ 
}

exec function FoundryCheat()
{
    //return;    
}

exec function DropWeapon()
{
}

exec function SetHP(int iHealth)
{
}

exec function SetAllHP(int iHealth)
{ 
}

exec function ShowShieldHP()
{
}

exec function SetWill(int iWill)
{
}

exec function SetDifficulty(XGGameData.EDifficultyLevel Difficulty)
{ 
}

exec function DebugPrintBattleInfo()
{
    //return;    
}

exec function DrawDistributedPointsAroundNearestPod()
{ 
}

exec function DebugBeginMoveHang()
{
    bDebugBeginMoveHang = !bDebugBeginMoveHang;
    //return;    
}

exec function TestPodClearance()
{
    //return;    
}

exec function TestSectopodDamage(int iNewHP)
{
}

exec function DebugPrintAbilities()
{
    //return;    
}

exec function DropPoison()
{
}

exec function TestValidCursorLoc()
{
    //return;    
}

exec function TestValidLoc(float fX, float fY, float fZ, string strUnitName)
{
    //return;    
}

exec function ShowOccupiedTilesAroundCursor()
{ 
}

exec function SetCharacterVoice(XGGameData.ECharacterVoice Voice)
{
}

exec function MakeCharacterSpeak(XGGameData.ECharacterSpeech Event)
{   
}

exec function DoBerserk()
{ 
}

exec function CheckNearestAlienStuck(bool bOptimal)
{   
}

exec function ForceOverwatch(optional bool bTeamXCOM)
{ 
}

exec function HunkerDownAll()
{ 
}

exec function LogAppliedAffectingAbilities()
{   
}

exec function RefreshAllUnitsVisibility()
{ 
}

exec function ToggleUnitFlags()
{ 
}

exec function ToggleWorldMessages()
{
    bDisableWorldMessages = !bDisableWorldMessages;
    //return;    
}

exec function ToggleFlankingIconSystem()
{
}

exec function TestAoEFinder()
{
}

exec function ToggleAlienGlam()
{
}

exec function marketing()
{
}

exec function DebugVisTeams()
{  
}

exec function DebugSendUIBroadcastWorldMessage_ErrAbilityFail()
{  
}

exec function DebugSendUIBroadcastWorldMessage_SentinelFlyover()
{
}

exec function DebugSendUIBroadcastWorldMessage_AbilityTargetMessage()
{
}

exec function DebugSendUIBroadcastWorldMessage_UnexpandedLocalizedString()
{ 
}

exec function DebugSendUIBroadcastWorldMessage_HoverFuel()
{  
}

exec function DebugSendUIBroadcastWorldMessage_UnitReflectedAttack()
{
}

exec function DebugSendUIBroadcastWorldMessage_WeaponOverheated()
{
}

exec function DebugSendUIBroadcastMessage_CloseEncounter()
{   
}

exec function DebugSendUIBroadcastMessage_OverwatchShot()
{   
}

exec function DebugSendUIBroadcastMessage_CriticallyWounded()
{ 
}

exec function DebugSendUIBroadcastMessage_SoldierDied()
{
}

exec function DebugSendUIBroadcastMessage_TankDied()
{
}

exec function DebugSendUIBroadcastMessage_Stunned()
{
}

exec function DebugSendUIBroadcastMessage_RecoveredFromCriticalWound()
{
}

exec function DebugSendUIBroadcastMessage_Stablized()
{  
}

exec function DebugSendUIBroadcastMessage_BleedingOut(bool bBleeding)
{
}

exec function DebugSendUIBroadcastMessage_Reanimate()
{
}

exec function AlwaysRushCam()
{  
}

exec function ShowHelpTip(bool bShow)
{   
}

exec function ShowAllPodBodies()
{ 
}

exec function HideAllPodBodies()
{   
}

exec function TogglePodBody(XComAlienPod kPod)
{  
}

exec function UIBuildTacticalHUDAbilities()
{  
}

exec function UIUnitFlagsRealizeCover()
{ 
}

exec function UISetAllUnitFlagHitPoints(bool bUseCurrentHP, optional int iHP, optional int iMaxHP)
{
}

exec function GetAllUnitHP()
{   
}

exec function SetWillBonus(int bonusAmount)
{  
}

function GiveBottomPerksDelegate(XGUnit kUnit)
{
}

function GiveTopPerksDelegate(XGUnit kUnit)
{
}

function GivePsiPerksDelegate(XGUnit kUnit)
{
}

reliable server function ServerGiveTopPerks()
{
 }

exec function GiveTopPerks()
{
      
}

reliable server function ServerGiveBottomPerks()
{
       
}

exec function GiveBottomPerks()
{
    
}

reliable server function ServerGivePsiPerks()
{
     
}

exec function GivePsiPerks()
{  
}

exec function ShowPerks()
{  
}

exec function ShowPerksForAllUnits()
{
}

private final function ShowPerkForUnit(XGUnit kUnit)
{ 
}

exec function GivePsiGift()
{ 
}

exec function GiveXP(int newXP)
{
}

exec function GivePsiXP(int newPsiXP)
{ 
}

exec function ShowXP()
{
}

reliable server function ServerGivePerk(string strName)
{
}

exec function GivePerk(string perkName)
{   
}

exec function SetAmmo(int Amount)
{
}

reliable server function ServerSetMediKitCharges(int charges)
{
}

exec function SetMediKitCharges(int charges)
{    
}

exec function SetRockets(int numOfRockets)
{
}

exec function SetShredderRockets(int numOfRockets)
{   
}

exec function InfiniteGrenades(optional bool bAll)
{   
}

function SetInfiniteGrenades(XGUnit kUnit)
{
}

exec function ListAllUnusedPods()
{
}

exec function DebugPrintAllNetExecActionQueues()
{
}

exec function DebugPrintAllActionQueues()
{   
}

exec function FindActionClassInNetQs(class<XGAction> kActionClass)
{
}

exec function FindActionClassNameInNetQs(name kActionClassName)
{
}

exec function DoDeathOnOutsideOfBounds(optional name nmUnitName)
{
}

exec function TestRMABug()
{
}

exec function TestDisablingShot(optional bool bAllAI)
{
}

exec function ForceEvaluateStance(string strUnitName)
{ 
}

exec function TestMechtoids(optional int iOption)
{ 
}

exec function SpawnAllMeldContainers(optional int iSpawnGroup)
{
}

exec function SetAutopsyComplete_Sectoid()
{   
}

exec function SetAutopsyComplete_SectoidCommander()
{
}

exec function SetAutopsyComplete_Floater()
{
     
}

exec function SetAutopsyComplete_ThinMan()
{
      
}

exec function SetAutopsyComplete_Muton()
{
    
}

exec function SetAutopsyComplete_Chryssalid()
{
       
}

exec function SetAutopsyComplete_Zombie()
{
        
}

exec function SetAutopsyComplete_Cyberdisc()
{
       
}

exec function SetAutopsyComplete_MutonBerserker()
{
       
}

exec function SetAutopsyComplete_HeavyFloater()
{
    
}

exec function SetAutopsyComplete_MutonElite()
{
      
}

exec function SetAutopsyComplete_Elder()
{
      
}

exec function SetAutopsyComplete_Sectopod()
{
   
}

exec function SetAutopsyComplete_Drone()
{
     
}

exec function SetAutopsyComplete_Mechtoid()
{
       
}

exec function SetAutopsyComplete_Seeker()
{
        
}

function SetAutopsyComplete(int iAutopsy)
{
  
}

exec function TogglePodRevealAttacks()
{
      
}

exec function RestartLevelWithSameSeed()
{
     
}

exec function SetXComAnimUnitName(name SetName)
{
  }

function bool MatchesXComAnimUnitName(name CheckName)
{
       
}

native function NativeSetXComAnimUnitName(name SetName);

exec function TestAlienPodUnderWorld()
{
}

exec function ActivatePerk(XGUnit Unit, XGTacticalGameCoreNativeBase.EPerkType Perk)
{    
}

exec function DeactivatePerk(XGUnit Unit, XGTacticalGameCoreNativeBase.EPerkType Perk)
{    
}

exec function ForceStrangle()
{ 
}

exec function ForceStealth()
{   
}

exec function IncTerrorForMedals(optional int Amount)
{   
}

exec function IncExaltForMedals(optional int Amount)
{ 
}

exec function IncContinentsForMedals(optional int Amount)
{
}

exec function HideMeldUI()
{
}

exec function UnstickCamera()
{  
}

exec function SetStrangleDist(float fDist)
{
}

exec function AIDebugMaterials()
{
}

exec function AITestSmokeBombDestination()
{  
}

exec function AISkipAllBut(int iCharType1, optional int iCharType2)
{
}

function bool ShouldSkipUnitType(int iCharType)
{  
}

exec function AIPlayOnlyHeavies()
{ 
}

exec function AIPlayOnlyMedics()
{    
}

exec function AIPlayOnlyOperatives()
{  
}

exec function AIPlayOnlySnipers()
{
}

exec function AIPlayAll()
{
}

exec function AITestAttackOnDropDown()
{   
}

exec function AIDebugWaveSystem(optional bool bOnScreen)
{   
}

exec function AIDebugWaveSystemContentRequests(optional bool bEnable)
{  
}

exec function DebugCamera(bool bOnOff, optional int ForceIndex)
{
}

exec function TestSoundCue(name strSoundCueClass, name strSoundCueName)
{
}

exec function AIForceSkipPodReveal()
{  
}

exec function SkipWaitForCamera()
{
   
}

exec function DisablePanic()
{
      
}

exec function AIForceStrangleAll()
{
  
}

exec function TestSeekerStrangle()
{
   
}

exec function ToggleSeekerStrangleStop()
{
     
}

exec function TestStrangleStopDest()
{
   
}

exec function TestTileBlocked(int X, int Y, int Z)
{   
}

exec function ExplodeAlien(name unitName)
{
}

exec function ForceRecalcRevealMatineeLocations()
{    
}

defaultproperties
{
    bShowUnitFlags=true
    iTestHideableActors=1
    iOverrideAnim=75
    iRightSidePos=1600
    fStrangleDist=64.0
}