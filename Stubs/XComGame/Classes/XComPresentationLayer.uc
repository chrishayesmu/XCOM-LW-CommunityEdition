class XComPresentationLayer extends XComPresentationLayerBase
	DependsOn(UITacticalHUD_ObjectivesList)
	DependsOn(UITurnOverlay)
	DependsOn(UICombatLose);

//complete stub

var XComCamera m_kCamera;
var XG3DInterface m_k3DUI;
var XComActionIconManager m_kActionIconManager;
var XComLevelBorderManager m_kLevelBorderManager;
var float m_fTimeDilation;
var bool m_bDramaticCameraAllowed;
var bool m_bSuppressionMessageActive;
var bool m_bPathMessageActive;
var bool m_bAllowEnemyArrowSystem;
var bool m_bConfirmedAbortMission;
var bool m_bUse2DUnitNumber;
var bool m_bIsDebugHideSelectedUnitDisc;
var bool HACK_bUIBusy;
var bool m_bUIShowMyTurnOnOverlayInit;
var bool m_bUIShowOtherTurnOnOverlayInit;
var UIEnemyArrowContainer m_kEnemyArrows;
var UIMissionSummary m_kMissionSummary;
var UIUnitGermanMode m_kGermanMode;
var UIMultiplayerHUD m_kMultiplayerHUD;
var UIMultiplayerChatManager m_kMultiplayerChatManager;
var UISpecialMissionHUD m_kSpecialMissionHUD;
var UISightlineHUD m_kSightlineHUD;
var UITacticalHUD m_kTacticalHUD;
//var UITacticalTutorialMgr m_kUITutorialMgr;
var UITerrorInfo m_kTerrorInfo;
var UITurnOverlay m_kTurnOverlay;
var UIUnitFlagManager m_kUnitFlagManager;
var UIWorldMessageMgr m_kWorldMessageManager;
//var UIMultiplayerPlayerStats m_kMultiplayerStats;
var UIMultiplayerPostMatchSummary m_kPostMatchSummary;
var UICombatLose m_kCombatLose;
var UICombatLoseType m_eLoseType;
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

simulated function Init(){}
simulated function InitUIScreens(){}
simulated function PollForUIScreensComplete(){}
simulated function InitUIScreensComplete(){}
simulated function ClearUIToHUD(){}
simulated function UIWorldMessageMgr GetWorldMessenger(){}
simulated function UITacticalHUD_ObjectivesList GetObjectivesList(){}
simulated function UIControllerMap(){}
simulated function UIShowSquad(){}
simulated function UIHideSquad(){}
simulated function ZoomCameraOut(){}
simulated function ZoomCameraIn(){}
simulated function ZoomCameraScroll(bool bZoomIn, optional float Amount=0.10){}
simulated function UIMPShowGameOverScreen(bool bWinner){}
simulated function UILeaveMultiplayerMatch(){}
simulated function UIMPShowPlayerStats(XComMultiplayerUI kMPInterface){}
simulated function UICombatLoseScreen(UICombatLoseType eLoseType){}
simulated function UIUpdate(){}
simulated function UpdateSuppressionMsg(){}
simulated function XComCamera GetCamera(){}
simulated function UIProtoScreen GetProtoUI(){}
simulated function UITacticalHUD GetTacticalHUD(){}
simulated function UITerrorInfo GetTerrorInfo(){}
simulated function XComActionIconManager GetActionIconMgr(){}
simulated function XComLevelBorderManager GetLevelBorderMgr(){}
simulated function RemoveAllCursorBasedIcons(){}
simulated function RedrawFlankingIcons(){}
simulated function RemoveLevelBorder(){}
function DebugLogHang(){}
simulated function bool IsBusy(){}
function ToggleDramaticCameras(){}
function bool IsDramaticCameraAllowed(){}
simulated function bool CAMIsBusy(){}
simulated function XGCameraView CAMGetCurrentView(){}
simulated function XGCameraView CAMGetLookAtView(){}
simulated function ShowFriendlySquadStatistics(){}
simulated function HideFriendlySquadStatistics(){}
simulated function ShowEnemySquadStatistics(){}
simulated function HideEnemySquadStatistics(){}
simulated function HUDHide(){}
simulated function HUDShow(){}
simulated function ActivateRadar(){}
simulated function DeactivateRadar(){}
simulated function ShowUIForCinematics(){}
simulated function PHUDMissionObjective(string strObjective){}
simulated function PHUDShowHPBar(XGUnit kUnit, optional float fTimer=-1.0, optional int iDamage){}
simulated function PHUDHideHPBar(XGUnit kUnit){}
simulated function PHUDLevelUp(XGCharacter_Soldier kSoldier){}
simulated function MSGHunted(XGUnit kUnit);
simulated function MSGWeaponFragments(string strItem, int iNumFragments){}
simulated function MSGItemDestroyed(string strItem){}
simulated function MSGArmorFragments(XGAbility_Targeted strChar){}
simulated function MSGCloseEncounter(XGUnit kUnit){}
simulated function MSGOverwatchShot(XGAbility_Targeted kUnit){}
simulated function MSGCriticallyWounded(XGUnit kUnit){}
simulated function MSGSoldierDied(XGUnit kUnit){}
simulated function MSGTankDied(XGUnit kUnit){}
simulated function MSGStunned(XGUnit kUnit){}
simulated function MSGRecoveredFromCriticalWound(XGUnit kUnit){}
simulated function MSGStabilized(XGUnit kUnit){}
simulated function MSGBleedingOut(XGUnit kUnit){}
simulated function MSGReanimate(XGUnit kUnit){}
function PHUDPanicking(XGUnit kUnit){}
simulated function PHUDShowSquad();
simulated function bool UIIsBusy(){}
simulated function SetHackUIBusy(bool bBusy){}
simulated function UIEndGame(){}
simulated function UIAbortMission(){}
simulated function OnAbortMission(EUIAction eAction){}
simulated function UITimerMessage(string sLabel, string sCounter, int iUIState, bool bShow){}
simulated function UpdateShortcutText(){}
simulated function PopTargetingStates(){}
simulated function UIAbilityMenu(){}
simulated function UIMissionSummaryScreen(){}
simulated function UIUnitGermanMode(XGUnit TargetUnit){}
simulated function OnTurnTimerExpired(){}
simulated function UIFriendlyFirePopup(){}
simulated function UIMissionSummary_MP(XGBattleResult kResults){}
simulated function UIEndBattle(){}
simulated function UIEndTurn(ETurnOverlay eOverlayType){}
simulated function UIMPShowPostMatchSummary(){}
simulated function UIShowMyTurnOverlay(){}
simulated function UIShowOtherTurnOverlay(){}
simulated function UICloseChat(){}
simulated function DRAWRange(Vector vLocation, float fRadius, LinearColor clrRange){}
simulated function DRAWControlCone(Vector vStart, Vector VDir, float fDist, float fAngle, LinearColor kColor){}
simulated function DRAWPinningCone(Vector vStart, XGUnit kPinnedUnit, LinearColor kColor){}
simulated function DRAWSelectionCone(Vector vStart, Vector VDir, float fDist, float fAngle, LinearColor kColor){}
simulated function bool NeedsSpecialMissionUI(){}
simulated function InitializeSpecialMissionUI(){}
simulated function bool CanSquadSee(Vector Loc){}
simulated function bool isOnScreen(Vector vLocation, out Vector2D v2ScreenCoords, optional float fPadding, optional float fYPlaneOffset){}
simulated function ChangeDifficutly(int difficutlyLevel){}
simulated function int GetDifficulty(){}
simulated function ToggleUIWhenPaused(bool bShow){}
function bool PlayerCanSave(){}
simulated function bool IsGameplayOptionEnabled(EGameplayOption Option){}
reliable client simulated function UIOvermind(){}


simulated state State_TutorialMgr extends BaseScreenState{
	    simulated function Activate(){}
    simulated function Deactivate(){}
}

simulated state State_WorldMessageMgr extends BaseScreenState{
		    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_FlagMgr extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_ControllerMap_Tactical extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_SightlineHUD extends BaseScreenState{
	simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_TerrorInfo extends BaseScreenState{
	simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_TurnOverlay extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_EnemyArrows extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_PostMatchSummary extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
    simulated function OnRaiseFocus(){}
    simulated function OnLoseFocus(){}
}
simulated state State_MPShowPlayerStats extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_UICombatLose extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_AbortMission extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_AbilityHUD extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_AbilityMenu extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_MissionSummary extends BaseScreenState{
    simulated function Activate(){}
    simulated function Deactivate(){}
}

simulated state State_GermanMode extends BaseScreenState{
    simulated function OnTurnTimerExpired(){}
    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_FriendlyFirePopup extends BaseScreenState{
    simulated function OnTurnTimerExpired(){}
}
simulated state State_SpecialMissionUI extends BaseScreenState{
	    simulated function Activate(){}
    simulated function Deactivate(){}
}
simulated state State_Overmind extends PROTOBaseScreenState{
	simulated function Activate(){}
    simulated function Deactivate(){}
	simulated function OnReceiveFocus(){}
	simulated function OnLoseFocus(){}
}




