class UIPauseMenu extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var protected int m_iCurrentSelection;
var protected int MAX_OPTIONS;
var protected bool m_bIsIronman;
var protected bool m_bAllowSaving;
var protected bool m_bBlockInputWhileExiting;
var const localized string m_sPauseMenu;
var const localized string m_sSaveGame;
var const localized string m_sReturnToGame;
var const localized string m_sSaveAndExitGame;
var const localized string m_sLoadGame;
var const localized string m_sControllerMap;
var const localized string m_sInputOptions;
var const localized string m_sAbortMission;
var const localized string m_sExitGame;
var const localized string m_sXComDatabase;
var const localized string m_sQuitGame;
var const localized string m_sAccept;
var const localized string m_sCancel;
var const localized string m_sAcceptInvitations;
var const localized string m_kExitGameDialogue_title;
var const localized string m_kExitGameDialogue_body;
var const localized string m_kExitMPRankedGameDialogue_body;
var const localized string m_kExitMPUnrankedGameDialogue_body;
var const localized string m_kQuitGameDialogue_title;
var const localized string m_kQuitGameDialogue_body;
var const localized string m_kQuitMPRankedGameDialogue_body;
var const localized string m_kQuitMPUnrankedGameDialogue_body;
var const localized string m_sRestartLevel;
var const localized string m_sRestartConfirm_title;
var const localized string m_sRestartConfirm_body;
var const localized string m_sChangeDifficulty;
var const localized string m_sViewSecondWave;
var const localized string m_sUnableToSaveTitle;
var const localized string m_sUnableToSaveBody;
var const localized string m_sSavingIsInProgress;
var const localized string m_sUnableToAbortTitle;
var const localized string m_sUnableToAbortBody;
var const localized string m_kSaveAndExitGameDialogue_title;
var const localized string m_kSaveAndExitGameDialogue_body;
var protected int m_optReturnToGame;
var protected int m_optSave;
var protected int m_optLoad;
var protected int m_optRestart;
var protected int m_optChangeDifficulty;
var protected int m_optViewSecondWave;
var protected int m_optControllerMap;
var protected int m_optOptions;
var protected int m_optXComDatabase;
var protected int m_optExitGame;
var protected int m_optQuitGame;
var protected int m_optAbortMission;
var protected int m_optAcceptInvite;

defaultproperties
{
    MAX_OPTIONS=-1
    s_package="/ package/gfxPauseMenu/PauseMenu"
    s_screenId="gfxPausemenu"
    m_bAnimateOutro=false
    e_InputState=eInputState_Consume
    s_name="thePauseMenu"
}