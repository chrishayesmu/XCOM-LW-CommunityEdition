class UISaveGame extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation);

enum ESaveStage
{
    SaveStage_None,
    SaveStage_OpeningProgressDialog,
    SaveStage_SavingGame,
    SaveStage_SavingProfile,
    SaveStage_MAX
};

var protectedwrite int m_iCurrentSelection;
var protected array<OnlineSaveGame> m_arrSaveGames;
var privatewrite ESaveStage m_SaveStage;
var const localized string m_sSaveTitle;
var const localized string m_sEmptySlot;
var const localized string m_sRefreshingSaveGameList;
var const localized string m_sSavingInProgress;
var const localized string m_sSavingInProgressPS3;
var const localized string m_sOverwriteSaveTitle;
var const localized string m_sOverwriteSaveText;
var const localized string m_sDeleteSaveTitle;
var const localized string m_sDeleteSaveText;
var const localized string m_sSaveFailedTitle;
var const localized string m_sSaveFailedText;
var const localized string m_sStorageFull;
var const localized string m_sSelectStorage;
var const localized string m_sFreeUpSpace;
var bool m_bUseStandardFormSaveMsg;
var bool m_bSaveNotificationTimeElapsed;
var bool m_bSaveSuccessful;
var bool m_bNeedsToLoadDLC1MapImages;
var bool m_bNeedsToLoadDLC2MapImages;
var bool m_bNeedsToLoadHQAssaultImage;
var bool m_bLoadCompleteCoreMapImages;
var bool m_bLoadCompleteDLC1MapImages;
var bool m_bLoadCompleteDLC2MapImages;
var bool m_bLoadCompleteHQAssaultImage;
var array<Object> m_arrLoadedObjects;

defaultproperties
{
    s_package="/ package/gfxLoadSave/LoadSave"
    s_screenId="gfxSave"
    e_InputState=eInputState_Consume
    s_name="theLoadSave"
}