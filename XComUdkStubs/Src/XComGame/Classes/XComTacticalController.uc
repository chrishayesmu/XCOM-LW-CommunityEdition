class XComTacticalController extends XComPlayerController
    native(Core)
    config(Game)
    hidecategories(Navigation);

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
var protected XGUnit m_kActiveUnit;
var bool m_bCamIsMoving;
var bool m_bInCinematicMode;
var bool m_bMissionVictoryCinematic;
var bool m_bWaitingForAdjustedPath;
var bool m_bWaitingToPerformPath;
var transient bool m_bGridComponentHidden;
var transient bool m_bGridComponentDashingHidden;
var bool m_bInputInShotHUD;
var bool m_bInputSwitchingWeapons;
var privatewrite repnotify bool m_bAchievementUnlocked_MindTheStep;
var protectedwrite int m_iBloodlustMove;
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
var private Vector m_vClientLastSentCursorLocation;
var const localized string m_strPsiInspired;
var const localized string m_strBeenPsiInspired;
var privatewrite float m_fLastReplicateMoveSentTimeSeconds;
var const float m_fThrottleReplicateMoveTimeSeconds;

defaultproperties
{
    m_bGridComponentHidden=true
    m_bGridComponentDashingHidden=true
    iCurrentLevel=4
    m_fThrottleReplicateMoveTimeSeconds=0.20
    m_kPresentationLayerClass=class'XComPresentationLayer'
    CameraClass=class'XComCamera'
    CheatClass=class'XComTacticalCheatManager'
    InputClass=class'XComTacticalInput'
}