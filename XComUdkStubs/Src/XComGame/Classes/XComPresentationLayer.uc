class XComPresentationLayer extends XComPresentationLayerBase
    notplaceable
    hidecategories(Navigation);

const CAMERA_ZOOM_NORMAL = 1.0f;
const CAMERA_ZOOM_DETAILED_INFO = 2.5f;
const CAMERA_ZOOM_SCROLL_INCREMENT = 0.1f;
const USE_UNIT_RING = false;

var protected XComCamera m_kCamera;
var protected XG3DInterface m_k3DUI;
var protected XComActionIconManager m_kActionIconManager;
var protected XComLevelBorderManager m_kLevelBorderManager;
var protected float m_fTimeDilation;
var protected bool m_bDramaticCameraAllowed;
var protected bool m_bSuppressionMessageActive;
var bool m_bPathMessageActive;
var bool m_bAllowEnemyArrowSystem;
var bool m_bConfirmedAbortMission;
var bool m_bUse2DUnitNumber;
var bool m_bIsDebugHideSelectedUnitDisc;
var protected bool HACK_bUIBusy;
var protectedwrite bool m_bUIShowMyTurnOnOverlayInit;
var protectedwrite bool m_bUIShowOtherTurnOnOverlayInit;
var UIEnemyArrowContainer m_kEnemyArrows;
var UIMissionSummary m_kMissionSummary;
var UIUnitGermanMode m_kGermanMode;
var UIMultiplayerHUD m_kMultiplayerHUD;
var UIMultiplayerChatManager m_kMultiplayerChatManager;
var UISpecialMissionHUD m_kSpecialMissionHUD;
var UISightlineHUD m_kSightlineHUD;
var UITacticalHUD m_kTacticalHUD;
var UITacticalTutorialMgr m_kUITutorialMgr;
var UITerrorInfo m_kTerrorInfo;
var UITurnOverlay m_kTurnOverlay;
var UIUnitFlagManager m_kUnitFlagManager;
var UIWorldMessageMgr m_kWorldMessageManager;
var UIMultiplayerPlayerStats m_kMultiplayerStats;
var UIMultiplayerPostMatchSummary m_kPostMatchSummary;
var protected UICombatLose m_kCombatLose;
var private UICombatLose.UICombatLoseType m_eLoseType;
var XComMultiplayerUI m_kMPInterface;
var const localized string m_sLevelUp;
var const localized string m_sPinned;
var const localized string m_sSaved;
var const localized string m_sHunted;
var const localized string m_sAbortTitle;
var const localized string m_sExtractTitle;
var const localized string m_strAbortAlienBase;
var const localized string m_strAbortWithMissingSoldiers;
var const localized string m_strAbortWithAllSoldiers;
var const localized string m_strAbortAccept;
var const localized string m_strExtractWithMissingSoldiers;
var const localized string m_strExtractWithAllSoldiers;
var const localized string m_strExtractAccept;
var const localized string m_strAbortCancel;
var const localized string m_strSuppressed;
var const localized string m_strItemDestroyed;
var const localized string m_strItemExplodeFragments;
var const localized string m_strArmorExplodeFragments;
var const localized string m_strUnitPanicked;
var string m_strSuppressedIcon;
var array<UIObjective> m_arrPendingObjectives;

defaultproperties
{
    m_fTimeDilation=1.0
    m_bAllowEnemyArrowSystem=true
    m_strSuppressedIcon="Icon_SUPRESSION_HTML"
    m_eUIMode=eUIMode_Tactical
    m_bBlockSystemMessageDisplay=true
}