class XComAlienPod extends Actor
	native(AI)
	dependson(XComWorldData);

enum EPodType
{
    POD_TYPE_LYING_IN_WAIT,
    POD_TYPE_TERROR,
    POD_TYPE_ABDUCTION,
    POD_TYPE_HUNTER,
    POD_TYPE_MAX
};

enum ELootType
{
    LOOT_TYPE_HEALTH,
    LOOT_TYPE_WEAPON,
    LOOT_TYPE_NUMBER,
    LOOT_TYPE_SCIENCE,
    LOOT_TYPE_COMPUTER,
    LOOT_TYPE_RANDOM,
    LOOT_TYPE_MAX
};

enum EXCAPGroup
{
    XCAP_GROUP,
    XCAP_GROUP_1,
    XCAP_GROUP_2,
    XCAP_GROUP_3,
    XCAP_GROUP_4,
    XCAP_GROUP_5,
    XCAP_GROUP_6,
    XCAP_GROUP_7,
    XCAP_GROUP_8,
    XCAP_GROUP_9,
    XCAP_GROUP_10,
    XCAP_GROUP_11,
    XCAP_GROUP_12,
    XCAP_GROUP_13,
    XCAP_GROUP_14,
    XCAP_GROUP_15,
    XCAP_GROUP_ADVANCED,
    XCAP_GROUP_MAX
};

enum EPathLoopType
{
    PATH_TYPE_CIRCULAR_LOOP,
    PATH_TYPE_FORWARD_BACKWARD_LOOP,
    PATH_TYPE_MAX
};

enum EPodWaitStatus
{
    ePWS_None,
    ePWS_ActiveMoving,
    ePWS_PresCamIsBusy,
    ePWS_WaitForCamera,
    ePWS_ActivateMatineePlaying,
    ePWS_CustomReveal_CamIsBusy,
    ePWS_WaitForActiveUnit_Action,
    ePWS_MoveActiveUnitLoop,
    ePWS_MoveActiveSeekerLoop,
    ePWS_MoveActiveSeeker_Stealthing,
    ePWS_WaitForMovementToFinish,
    ePWS_LoopSkipMovementDeactivate,
    ePWS_WaitForVisibilityUpdates,
    ePWS_WaitForOvermind,
    ePWS_PodAttackWaitForEnemyMove,
    ePWS_Completed,
    ePWS_MAX
};

struct CheckpointRecord
{
	var int NumTimesSpawned;
    var int NumAliens;
    var int m_iNumAliensAlive;
    var editconst int PodIndex;
    var bool bUse;
    var bool ForceAlienType;
    var XGGameData.EPawnType AlienType;
    var array<XComAlienPod> ContingentPods;
    var array<XComAlienPod> TriggeredPods;
    var bool m_bEnabled;
    var bool m_bSeen;
    var array<XGUnit> m_arrAlien;
    var AnimTree m_kOldAnimTreeTemplate;
    var float m_fMinDist;
    var bool m_bRespawnable;
    var bool bAnsweringCallPod;
    var editconst EPodType PodType;
    var XGGameData.EItemType ItemType;
    var array<XComSpawnPoint> CoverGoToPoints;
    var bool m_bEnemySeen;
    var bool m_bShowCenterpiece;
    var bool m_bGeneratedByGameplay;
    var bool bNoMoveNextTurn;
};


var int NumTimesSpawned;
var() int NumAliens;
var int m_iNumAliensAlive;
var() editconst int PodIndex;
var() bool bUse;
var(XCAP_AlienType) bool ForceAlienType;
var bool m_bEnabled;
var bool m_bSeen;
var bool m_bRespawnable;
var() bool bAnsweringCallPod;
var bool m_bEnemySeen;
var bool m_bDynamicAI;
var bool m_bSkipCinematic;
var bool m_bGeneratedByGameplay;
var() bool bCommanderPod;
var() bool bSecondaryPod;
var() bool bTriggerOnViewPod;
var() bool bNeverActivate;
var(XCAP_Contingent) editoronly bool MakeReflexive;
var bool m_bQuickMode;
var bool m_bAnsweringCall;
var bool m_bMoveToActionPoint;
var bool m_bWasModal;
var bool m_bAbortMovement;
var transient bool m_bPodRules_LOSperformed;
var transient bool m_bPodRules_LOSresult;
var bool m_bShowCenterpiece;
var bool m_bCoordinatedMovement;
var bool m_bPodRevealQueued;
var bool bNoMoveNextTurn;
var bool m_bAttacked;
var bool m_bSkipCombatMusic;
var bool bColdReset;
var bool m_bSkipActivateMatinee;
var(XCAP_AlienType) XGGameData.EPawnType AlienType;
var() editconst EPodType PodType;
var() XGGameData.EItemType ItemType;
var(XCAP_Patrol) EPathLoopType LoopType;
var EPodWaitStatus m_eWaitStatus;
var(XCAP_Contingent) array<XComAlienPod> ContingentPods;
var(XCAP_Triggered) array<XComAlienPod> TriggeredPods;
var array<XGUnit> m_arrAlien;
var array<XGUnit> m_arrRevealed;
var AnimTree m_kOldAnimTreeTemplate;
var float m_fMinDist;
var() array<XComSpawnPoint> CoverGoToPoints;
var XComAlienPod m_kPathOrigin;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var(XCAP_GROUP) editoronly array<editoronly EXCAPGroup> PodGroup;
var(XCAP_GROUP) editconst int m_iPodGroup;
var() int NumAliens_Min;
var() int NumAliens_Max;
var() array<XComSpawnPoint> CustomStartLocations;
var() Volume ConstrainedMovementVolume;
var(XCAP_Mesh) export editinline StaticMeshComponent PodMesh;
var editoronly MaterialInterface kHighlight;
var array<XComSpawnPoint_Alien> m_arrAlienSpawnPts;
var(XCAP_Patrol) array<XComAlienPathNode> PathNodes;
var(XCAP_Patrol) XComAIPathVolume TripVolume;
var Vector m_vCallSource;
var XGUnit m_kCallSource;
var array<XGUnit> m_arrMovers;
var XGUnit m_kEnemy;
var XGUnit m_kActiveUnit;
var XGUnit m_kLastActive;
var array<Vector> m_arrCoverClaimed;
var XComSpawnPoint m_kActiveCover;
var array<XComCoverPoint> ConstrainedMovementPoints;
var AnimTree m_kCinAnimTree;
var SkeletalMeshActorSpawnable m_kCinCivilian;
var SeqAct_Interp m_RevealMatinee;
var SeqAct_Interp m_ActivateMatinee;
var XGCameraView m_kSavedView;
var XGCameraView m_kPodView;
var XComTacticalController m_kTacticalController;
var int m_iAlienLimit;
var array<Vector> m_arrAlienLoc;
var array<int> m_arrAlienSequencing;
var XComAlienPathHandler m_kDynamicAI;
var array<Vector> m_aBadSpawnLoc;
var array<Vector> m_aGotoLoc;
var() export editinline StaticMeshComponent CenterpieceMesh;
var Vector m_vCenterpiece;
var Rotator m_rCenterpiece;
var int m_iLastMoveManeuverTurn;
var Vector m_vLastLocation;
var array<int> m_arrValid2x3;

function AbortMovement();
function Activate(optional XGUnit kEnemy){}
function AddAlien(XGUnit kAlien){}
simulated function bool AlienTypeShouldHideOnReveal(){}
function BlockLastDestination(XGUnit kUnit){}
function bool CanHearCallAt(Vector vSource, optional out float fDistSqOut){}
function CenterLocationOnTile(){}
function bool CheckProgress(Vector vDestination){}
function bool CustomReveal(optional bool bDoSound){}
simulated function Deactivate()
{}
function DebugLogHang(){}
simulated function DrawDebugLabel(Canvas kCanvas){}
function DrawPath(optional bool bPersistent){}
simulated function bool FindAndUpdateVariableLinkByLinkDesc(out SeqAct_Interp kMatinee, string strDesiredLinkDesc, SeqVar_Object OverrideSeqVar, optional out SeqVar_Object kFoundSeqVarPawn)
{}
function Vector FindCoverLocation()
{}
simulated function GenerateAlienSequencingArray(out array<int> arrAlienSequence){}
function Vector GetAdjustedPodLocation(Vector vUnitDestination, array<Vector> arrFallback, optional bool bReset2x3, optional bool bMarkMoveCompleteOnFailure)
{}
function string GetDebugLabel()
{}
function Vector GetDistributedLocationAround(Vector vLocation, int iAlien, optional Rotator rReference, optional bool bUse2x3)
{}
function bool GetFallbackPositions(XGUnit kUnit, Vector vDestination, out array<Vector> arrOutDest)
{}
function XGUnit GetNearestToCover(out XComSpawnPoint kNearestSpawn_out)
{}
function XGUnit GetNearestToEnemy(optional XGUnit kEnemy, optional bool bVisibleOnly, optional out float fNearestDistSq)
{}
simulated function XGManeuver GetOvermindManeuver()
{}
function Rotator GetPathReferenceDirection(int iNextNode)
{}
event Vector GetPodLocation(optional bool bForceRecalc)
{}
event Vector GetPodLocation_AdjustedByPeekTestHeight()
{}
simulated function bool GetPodSupportedAliensByPawnType(XGGameData.EPawnType eAlienType, out string strAlien, bool BerserkerBecomesMuton)
{}
function GetPodTileBounds(out Box kBounds)
{}
function XComSpawnPoint_Alien GetSpawnPoint(int iAlien, out Vector vLoc_Out, optional bool bUseDefault)
{}
function bool HasBeenSeen()
{}
function bool HasBegunTrippedPatrol()
{}
function bool HasMovedThisTurn()
{}
simulated function bool HasPath()
{}
function bool HasVisibleEnemies(optional bool bTwoWayCheck)
{}
native function HidePodBody();
simulated function Init()
{}
function InitDynamicStartLocation()
{}
function Initialize_Terror_Civilian()
{}
function InitializeMatineeWithCenterpeice(SeqAct_Interp kMatinee)
{}
function bool InitMoveManeuver(Vector vManeuverDest)
{}
simulated function InitNonPodUnit(XGUnit kUnit){}
function InitTrippedPatrol()
{}
function InitTurn_DynamicAI()
{}
native function bool Intersects(const out Box kBounds1, const out Box kBounds2);function bool IntersectsBox(Box kTileBounds)
{}
function bool IsActive()
{}
function bool IsAlive()
{}
function bool IsDynamicPodMoving()
{}
function bool IsHanging(string szDesc, optional float fTime=10.0)
{}
function bool IsIn3x3Area()
{}
native function bool IsInBadArea(const out Vector vLoc);
function bool IsInGroup(int IGroup)
{}
function bool IsMoving()
{}
function bool IsNearGotoLoc(Vector vLocation, float fMaxDist, out float fDistSq)
{}
function bool IsOpeningDoor()
{}
function bool IsPathVisible(Vector vPodLoc, Vector vHiddenLoc, out XGUnit kVisibleUnit)
{}
function bool IsUpdating()
{}
function bool IsWithin3x3AreaAround(Vector vCenter, Vector vNewLoc)
{}
function LoadInit(int iPod)
{}
function MarkEnemySeen()
{}
function MarkSeen(optional bool ViewerHidden)
{}
function MoveToCover(XComSpawnPoint kCover)
{}
simulated function OnActivatePodMatineeNotPlayed()
{}
function OnHearCall(Vector vSource, XGUnit kSource);
function OnTakeDamage(){}
simulated function OnTouchPath(XComUnitPawn kPawn)
{}
function OpenCyberdisc(XGUnit kUnit)
{}
simulated function bool PlayActivatePodMatinee()
{}
simulated function bool PlayRevealPodMatinee(XGUnit kRevealedByUnit)
{}
function bool PodCoverValidator(Vector vLoc)
{}
function bool PodCoverValidatorWithinRange(Vector vLoc)
{}
function bool PodLocationNeedsUpdate()
{}
function Post_InitializeMatineeWithCenterpeice(SeqAct_Interp kMatinee)
{}
simulated function PostActivatePodMatinee()
{}
function PostSpawnInit(optional bool bForceActivate)
{}
simulated function PreActivatePodMatinee()
{}
function PreSpawnInit(optional bool bPresetCounts)
{}
function PrestreamAlienTextures()
{}
function bool PullAlien(optional bool bRemoveFromGame)
{}
function bool RandomizeLocation(XGUnit kAlien, optional bool bPairUp, optional XGUnit kLastAlien)
{}
function bool ReleaseAlienFromPod(XGUnit kAlien, XGUnit kHuman)
{}
function RemoveAlien(out XGUnit kAlien, optional bool bRemoveFromGame, optional bool bResetAnims)
{}
function RemoveAllAliens(optional bool bRandomizeLoc, optional bool bRemoveFromGame)
{}
function ResetHangTimer()
{}
function ResetRevealMatinee()
{}
function ResetTripped()
{}
simulated function bool ResetVariableLinkByLinkDesc(out SeqAct_Interp kMatinee, string strDesiredLinkDesc)
{}
function RestoreGameAnims(optional XGUnit kOverrideEnemy)
{}
function RestoreGameAnimsForUnit(int I, optional XGUnit kOverrideEnemy)
{}
function SaveAlienLocations(optional bool bClearIfIdentical)
{}
function SetData(XComAlienPod kPod, optional bool bSetVolume=true)
{}
function SetItemType(XGGameData.EItemType eType);
simulated function SetupCivilian(out SeqAct_Interp kMatinee)
{}
function bool ShouldActivateTriggeredPodsOnSight()
{}
native function ShowPodBody();
simulated function bool SkipMovement()
{}
simulated function bool SnapToGround(optional float Distance=128.0)
{}
function StopRevealMatinee(optional bool bClearPodRevealFlag)
{}
event Tick(float fDeltaT)
{}
function UninitMoveManeuver()
{}
function UpdatePodLocation(optional bool bForceRecalc)
{}
function bool WalkPodToLocation(Vector vDestination, optional bool bAllowWarping=true)
{}

state Active
{function BeginState(name P){} function SetActiveUnit(){}function TurnAllTowardsEnemy(){}
function UpdateMovers(){}  function ActivateTriggeredPods(){} function float GetPercentCamToPod(){}
function InitPodVisibilityForReveal(){}
   function UninitPodVisibilityForReveal(){}
   function SetNextActive(){}function InitCamViewAliens(){}function UninitCamViewAliens(){}
   function bool HasPriorityMovementUnit(out XGUnit kPriorityUnit){}
   function SetBlockingTiles(){}

}

auto state Dormant
{
	function Activate(optional XGUnit kEnemy){}
	function OnSeeEnemy(XGUnit kEnemy){}
	function OnHearCall(Vector vSource, XGUnit kSource){}

Begin:
    stop;                
}
state Inactive{}
state Patrol extends Dormant
{
	 function bool IsUpdating(){}
	 function bool IsOpeningDoor(){}
	 function AbortMovement(){}

    function string GetDebugLabel()
    {
        return m_kDynamicAI.GetDebugLabel();
    }

    function DebugLogHang()
    {
        if(m_kDynamicAI.IsDynamicPodMoving())
        {
        }
        super(XComAlienPod).DebugLogHang();
    }
}
state PatrolReveal extends Patrol
{
    ignores AbortMovement;

    function OnSeeEnemy(XGUnit kEnemy)
    {
        if(m_kEnemy == none)
        {
            m_kEnemy = kEnemy;
        }
    }

    function string GetDebugLabel()
    {
        return m_kDynamicAI.GetDebugLabel();
    }

    function XGUnit ShowEnemySeen()
    {
        local XGUnit kNearest;

        kNearest = GetNearestToEnemy(m_kEnemy, true);
        if(kNearest == none)
        {
            kNearest = GetNearestToEnemy(m_kEnemy, false);
        }
        if(kNearest != none)
        {
            kNearest.SpawnOnSeenEnemyAction(m_kEnemy);
        }
        return kNearest;
    }       
}
defaultproperties
{
    NumAliens=2
    PodIndex=-1
    bUse=true
    AlienType=ePawnType_Sectoid
    begin object class=DynamicLightEnvironmentComponent name=MyLightEnvironment
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
        bForceNonCompositeDynamicLights=true
    end object
    // Reference: DynamicLightEnvironmentComponent'Default__XComAlienPod.MyLightEnvironment'
    LightEnvironment=MyLightEnvironment
    Components(0)=MyLightEnvironment

    begin object class=StaticMeshComponent name=PodFocusMesh
        WireframeColor=(R=255,G=0,B=255,A=255)
        ReplacementPrimitive=none
        LightEnvironment=MyLightEnvironment
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object
    // Reference: StaticMeshComponent'Default__XComAlienPod.PodFocusMesh'
    CenterpieceMesh=PodFocusMesh
    Components(1)=PodFocusMesh

	m_iPodGroup=1
    NumAliens_Min=-1
    NumAliens_Max=-1
    begin object class=StaticMeshComponent name=AlienPodStaticMeshComponent
        StaticMesh=none
        WireframeColor=(R=255,G=0,B=255,A=255)
        ReplacementPrimitive=none
        LightEnvironment=MyLightEnvironment
        HiddenGame=true
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object
    // Reference: StaticMeshComponent'Default__XComAlienPod.AlienPodStaticMeshComponent'
    PodMesh=AlienPodStaticMeshComponent
    Components(2)=AlienPodStaticMeshComponent
	m_iAlienLimit=8
    bCanStepUpOn=false
}