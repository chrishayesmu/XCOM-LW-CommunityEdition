class XComGlamManager extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation);

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
    var XComGlamManager.ECamSituation Situation;
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
var XComGlamManager.eGlamWaitStatus m_eGlamWaitStatus;
var transient float m_OldGameSpeed;

defaultproperties
{
    m_bEnableUnitRushCam=true
}