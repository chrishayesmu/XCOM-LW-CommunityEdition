class XGAIBehavior extends Actor
    native(AI)
    notplaceable
    hidecategories(Navigation);

const SOLDIER_MELEE_BUFFER = 32;
const MIN_REASONABLE_ATTACK_RANGE = 30;
const MIN_HIT_CHANCE_TO_NOT_MOVE = 70;
const MAX_TURNS_UNSEEN_BEFORE_RUSH = 5;

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

defaultproperties
{
    m_eSpawnBehavior=EAIBehavior_Hunt
    m_fMaxAggro=1.0
    m_fSpacingBuffer=1.20
    m_iLastTurnStart=-1
    m_fDistWeight=1.0
    m_fProxWeight=1.0
    m_fFlankWeight=1.0
    m_fAngleWeight=1.0
    m_fVisWeight=1.0
    m_fCoverWeight=1.0
    m_iMimicBeaconIndex=-1
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}