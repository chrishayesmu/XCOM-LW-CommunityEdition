class UILoadGame extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation);

const m_bBlockingSavesFromOtherLanguages = true;

var protectedwrite int m_iCurrentSelection;
var protected array<OnlineSaveGame> m_arrSaveGames;
var protected bool m_bPlayerHasConfirmedLosingProgress;
var privatewrite bool m_bLoadInProgress;
var bool m_bNeedsToLoadDLC1MapImages;
var bool m_bNeedsToLoadDLC2MapImages;
var bool m_bNeedsToLoadHQAssaultImage;
var bool m_bLoadCompleteCoreMapImages;
var bool m_bLoadCompleteDLC1MapImages;
var bool m_bLoadCompleteDLC2MapImages;
var bool m_bLoadCompleteHQAssaultImage;
var private int m_iLoadGameAsync;
var const localized string m_sLoadTitle;
var const localized string m_sLoadingInProgress;
var const localized string m_sMissingDLCTitle;
var const localized string m_sMissingDLCText;
var const localized string m_sLoadFailedTitle;
var const localized string m_sLoadFailedText;
var const localized string m_strLostProgressTitle;
var const localized string m_strLostProgressBody;
var const localized string m_strLostProgressConfirm;
var const localized string m_strDeleteLabel;
var const localized string m_strLanguageLabel;
var const localized string m_strWrongLanguageText;
var array<int> SaveSlotStatus;
var array<Object> m_arrLoadedObjects;

defaultproperties
{
    s_package="/ package/gfxLoadSave/LoadSave"
    s_screenId="gfxLoad"
    m_bAnimateOutro=false
    e_InputState=eInputState_Consume
    s_name="theLoadSave"
}