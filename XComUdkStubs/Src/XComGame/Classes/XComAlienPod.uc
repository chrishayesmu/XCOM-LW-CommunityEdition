class XComAlienPod extends Actor
    native(AI)
    dependson(XComWorldData, XGGameData)
    placeable
    hidecategories(Navigation,Display,Attachment,Collision,Physics,Advanced,Mobile,Debug);

const DYNAMIC_PODS_SKIP_CINEMATICS = true;
const ABORT_MOVEMENT_LENGTH = 192;
const MAX_FAILURES_BEFORE_ABORT = 32;

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
    var EPawnType AlienType;
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
    var EItemType ItemType;
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
var(XCAP_AlienType) EPawnType AlienType;
var() editconst XComAlienPod.EPodType PodType;
var() EItemType ItemType;
var(XCAP_Patrol) XComAlienPod.EPathLoopType LoopType;
var XComAlienPod.EPodWaitStatus m_eWaitStatus;
var(XCAP_Contingent) array<XComAlienPod> ContingentPods;
var(XCAP_Triggered) array<XComAlienPod> TriggeredPods;
var array<XGUnit> m_arrAlien;
var array<XGUnit> m_arrRevealed;
var AnimTree m_kOldAnimTreeTemplate;
var float m_fMinDist;
var() array<XComSpawnPoint> CoverGoToPoints;
var XComAlienPod m_kPathOrigin;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var(XCAP_GROUP) editoronly array<editoronly XComAlienPod.EXCAPGroup> PodGroup;
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

defaultproperties
{
    NumAliens=2
    PodIndex=-1
    bUse=true
    AlienType=ePawnType_Sectoid
    m_iPodGroup=1
    NumAliens_Min=-1
    NumAliens_Max=-1
    m_iAlienLimit=8
    bStaticCollision=true
    bCanStepUpOn=false

    begin object name=MyLightEnvironment class=DynamicLightEnvironmentComponent
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
        bForceNonCompositeDynamicLights=true
    end object

    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    begin object name=PodFocusMesh class=StaticMeshComponent
        WireframeColor=(R=255,G=0,B=255,A=255)
        LightEnvironment=DynamicLightEnvironmentComponent'Default__XComAlienPod.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object

    CenterpieceMesh=PodFocusMesh
    Components.Add(PodFocusMesh)

    begin object name=AlienPodStaticMeshComponent class=StaticMeshComponent
        StaticMesh=none
        WireframeColor=(R=255,G=0,B=255,A=255)
        LightEnvironment=DynamicLightEnvironmentComponent'Default__XComAlienPod.MyLightEnvironment'
        HiddenGame=true
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object

    PodMesh=AlienPodStaticMeshComponent
    Components.Add(AlienPodStaticMeshComponent)
}