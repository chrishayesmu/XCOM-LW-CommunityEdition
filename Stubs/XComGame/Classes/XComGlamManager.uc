class XComGlamManager extends Actor
    native(Unit)
	dependsOn(XGGameData);
//complete stub

enum ECamSituation
{
    GLAMCAM_INVALID,
    GLAMCAM_Firing,
    GLAMCAM_Death,
    GLAMCAM_Berserk,
    GLAMCAM_Rush,
    GLAMCAM_MissionVictory,
    GLAMCAM_ChryssalidBirth,
    GLAMCAM_MutonBeatDown,
    GLAMCAM_GenericLookAt,
    GLAMCAM_DoorKick,
    GLAMCAM_CloseFocus,
    GLAMCAM_ZombieBirth,
    GLAMCAM_MutonBeatUp,
    GLAMCAM_WindowSmash,
    GLAMCAM_ExaltSuicide,
    GLAMCAM_Strangle,
    GLAMCAM_KineticStrike,
    GLAMCAM_MAX
};

enum ECamSide
{
    CAMSIDE_INVALID,
    CAMSIDE_Left,
    CAMSIDE_Right,
    CAMSIDE_Both,
    CAMSIDE_MAX
};

enum eGlamWaitStatus
{
    eGWS_None,
    eGWS_ShouldWaitToPlayMatinee,
    eGWS_IsPlayingMatinee,
    eGWS_IsMovingForRushCam,
    eGWS_IsPlayingMatinee2,
    eGWS_Completed,
    eGWS_MAX
};

struct native CamCageInfo
{
    var Actor MatineeBase;
    var Actor MatineeBaseAlt;
    var array<SeqAct_Interp> Matinees;
    var ECharacter SubstituteCharacter;

};

struct native MatineeCacheResult
{
    var Vector Location;
    var Rotator Rotation;
    var SeqAct_Interp Matinee;

};

struct native MatineeCacheEntry
{
    var Vector Location;
    var Rotator Rotation;
    var XGUnitNativeBase Unit;
    var ECharacter UnitType;
    var bool IsMec;
    var XGUnitNativeBase Target;
    var ECamSituation Situation;
    var array<SeqAct_Interp> Matinees;
    var array<SeqAct_Interp> PossibleMatinees;
    var array<Actor> IgnoredActors;
    var native Pointer CamInfo;
    var int TestIndex;
    var array<string> SeqTags;
};

var CamCageInfo m_kCamCageInfo[ECharacter];
var CamCageInfo m_kCamCageMEC;
var transient array<MatineeCacheEntry> MatineeCache;
var private native transient Map_Mirror SequenceMap;
var transient XGAction FocusAction;
var transient XGUnit FocusUnit;
var transient XGUnit FocusTarget;
var transient Vector FocusLocation;
var transient Rotator FocusRotation;
var XComTacticalController m_kTacticalController;
var SeqAct_Interp m_kMatinee;
var string m_strCheat;
var bool m_bGlamBusy;
var bool m_bEnableUnitRushCam;
var transient bool bDrawCamCollision;
var transient bool bDrawSeqName;
var bool m_bPlayerTargetingForceStartCachingCams;
var transient bool m_bSetCinematicModeAffectHUD;
var transient bool m_bStatePlayingStoppedMatinee;
var ECharacter m_kForCurrentCharacter;
var eGlamWaitStatus m_eGlamWaitStatus;
var transient float m_OldGameSpeed;

function TestCollisionValidity(){}
function Init(){}
function OnGlamCamMapLoaded(name LevelName){}
function InitTacticalHUD(){}
function TimerWaitForTacticalHUD(){}
function bool IsGlamCamAllowed(){}
// Export UXComGlamManager::execCacheMatinees(FFrame&, void* const)
native function CacheMatinees();

// Export UXComGlamManager::execGetCamCageInfo(FFrame&, void* const)
native final function bool GetCamCageInfo(XGUnitNativeBase Unit, out CamCageInfo Info);

// Export UXComGlamManager::execFindMatineeBase(FFrame&, void* const)
native final function bool FindMatineeBase(const out string InTag, out Actor MatineeBase);

// Export UXComGlamManager::execBuildSequenceMap(FFrame&, void* const)
native final function BuildSequenceMap(name LevelName);

// Export UXComGlamManager::execHelper_MatineePodRulesProcessing_Initialize(FFrame&, void* const)
native final function Helper_MatineePodRulesProcessing_Initialize(XComAlienPod CheckMatineePodRulesAgainstThisPod);

// Export UXComGlamManager::execHelper_MatineePodRulesProcessing(FFrame&, void* const)
native final function bool Helper_MatineePodRulesProcessing(SeqAct_Interp Matinee, XComAlienPod CheckMatineePodRulesAgainstThisPod);

// Export UXComGlamManager::execFindMatinees_Substring(FFrame&, void* const)
native final function FindMatinees_Substring(const out string NameOrCommentTag, out array<SeqAct_Interp> Matinees);

// Export UXComGlamManager::execFindMatinees(FFrame&, void* const)
native final function FindMatinees(const out string NameOrCommentTag, out array<SeqAct_Interp> Matinees);

// Export UXComGlamManager::execSearchForMatinee(FFrame&, void* const)
native static final function SeqAct_Interp SearchForMatinee(string MatineeName);

// Export UXComGlamManager::execFindMatinee(FFrame&, void* const)
native final function SeqAct_Interp FindMatinee(string strMatinee, optional bool bRandomSelection, optional XComAlienPod CheckMatineePodRulesAgainstThisPod);

native final function bool ChooseMatineeFromCache(XComGlamManager.ECamSituation Situation, XGUnitNativeBase Unit, XComGlamManager.ECamSide Side, out MatineeCacheResult Matinee);

function OnAITargeting(XGUnit AIUnit, XGAction_Fire FireAction){}
function StartCachingGenericLookAtGlamCam(XGUnit Unit, Vector vLoc, Rotator rRot){}
function OnMissionVictory(XGUnit Unit){}
function OnStrangle(XGUnit Unit){}
function OnExaltSuicide(XGUnit Unit){}
function OnChryssalidBirth(XGUnit Unit, XGAction_ChryssalidBirth_Alien Action){}
function OnMutonBeatDown(XGUnit Unit, XGAction_Fire FireAction){}
function OnMutonBeatUp(XGUnit Unit, XGAction_Fire FireAction){}
function OnBerserk(XGUnit Unit, XGAction BerserkAction){}
function OnRush(XGUnit Unit, XGAction MoveAction){}
function OnDoorKick(XGUnit Unit, XGAction KickAction){}
function OnWindowSmash(XGUnit Unit, XGAction SmashAction){}
function OnKineticStrike(XGUnit Unit, XGUnit Target, XGAction FireAction){}
function OnNonOwningPlayerStartedExecutedFireAction(XGUnit Unit, XGAction_Fire FireAction){}
function OnNonOwningPlayerFinishedExecutedFireAction(XGAction_Fire FireAction){}
function OnPlayerTargetingChanged(){}
function StopMatinee(optional bool bResetGameSpeed=true){}
function bool InterruptMatinee(SeqAct_Interp kNewMatinee){}
function SetupUnitsToKismet(XGUnit kUnit){}
function bool CanDoGlamCam(XGAction Action){}
function bool TrySpecificGlamCam(ECamSituation eType, XGUnit kUnit, bool bCinematicModeAffectHUD){}
function bool TryGlamCam(XGAction kAction, bool bCinematicModeAffectHUD){}
function MoveMatineeBaseForUnit(XGUnit Unit, Vector NewLocation, Rotator NewRotation){}
function MoveMatineeBaseByType(XGUnit Unit, Vector NewLocation, Rotator NewRotation){}
function bool FindValidDeathMatinee(out MatineeCacheResult Matinee){}
function bool FindValidMatinee(out MatineeCacheResult Matinee){}
function Vector GetGlamCamLoc(XGUnit kUnit){}
static final function bool IsCloseFocusAction(XGAction kAction){}
static final function bool IsPsiShotAbility(XGAbility kAbility){}
static final function bool IsPsiBlastAbility(XGAbility kAbility){}
static final function GetSequenceTags(ECamSituation Situation, XGUnit Unit, out array<string> SeqTags, optional XGAction Action){}
static final function InterpData GetMatineeData(SeqAct_Interp Matinee){}
static final function ClonePodRules(optional SeqAct_Interp OriginalMatinee, optional SeqAct_Interp NewMatinee){}
static final function SeqAct_Interp CloneMatinee(SeqAct_Interp OriginalMatinee, optional InterpData MatineeData){}

// Export UXComGlamManager::execDrawCamCollision(FFrame&, void* const)
native final function DrawCamCollision(SeqAct_Interp Matinee, const out Vector CamLocation, const out Rotator CamRotation);

// Export UXComGlamManager::execFlushMatineeCache(FFrame&, void* const)
native final function FlushMatineeCache();

// Export UXComGlamManager::execUpdateMatineeCache(FFrame&, void* const)
native final function UpdateMatineeCache(optional bool bBlockUntilFinished);

// Export UXComGlamManager::execUseFixedTimeStep(FFrame&, void* const)
native final function UseFixedTimeStep(bool bFixedTimeStep);

function GetFiringCamTransform(XGAction FireAction, out Vector GlamLoc, out Rotator GlamRot){}
function CacheFiringCam(XGAction FireAction){}
function GetDeathCamTransform(XGUnit shooter, XGUnit Target, out Vector DeathLoc, out Rotator DeathRot){}
function CacheGenericLookAtCam(XGUnit shooter, Vector vPos, Rotator rRot){}
function CacheMissionVictoryCam(XGUnit shooter){}
function CacheStrangleCam(XGUnit Unit){}
function CacheChryssalidBirthCam(XGUnit shooter){}
function CacheMutonBeatDownCam(XGUnit shooter, XGUnit Target){}
function CacheMutonBeatUpCam(XGUnit shooter, XGUnit Target){}
function CacheBerserkCam(XGUnit shooter){}
function CacheRushCam(XGUnit kUnit){}
function CacheDoorKickCam(XGUnit kUnit){}
function CacheWindowSmashCam(XGUnit kUnit){}
function CacheDeathCam(XGUnit shooter, XGUnit Target){}
function CacheCloseFocusCam(XGUnit Unit, XGUnit Target){}
function CacheExaltSuicideCam(XGUnit Unit){}
function CacheKineticStrikeCam(XGUnit Unit, XGUnit Target){}
function StartCachingCams(XGAction Action){}
function DebugLogHang(){}

simulated function DumpMatineeCache();

simulated state PlayerTargeting{
    event BeginState(name PreviousStateName){}
    function Tick(float DeltaTime){}

}
simulated state UpdatingMatineeCache{
    function Tick(float DeltaTime){}
}

simulated state Playing{
    function PlayMatinee(){}
    function StopMatinee(optional bool bResetGameSpeed=true){}
    function OnMatineeFinished(bool bResetGameSpeed){}
    function bool ShouldWaitToPlayMatinee(){}
    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
}


