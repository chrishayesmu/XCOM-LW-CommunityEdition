class UISaveGame extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation)
	DependsOn(UIDialogueBox)
	DependsOn(UIProgressDialogue);

enum ESaveStage
{
    SaveStage_None,
    SaveStage_OpeningProgressDialog,
    SaveStage_SavingGame,
    SaveStage_SavingProfile,
    SaveStage_MAX
};

var int m_iCurrentSelection;
var array<OnlineSaveGame> m_arrSaveGames;
var ESaveStage m_SaveStage;
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

delegate ProgressDialogOpenCallback();

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnReadSaveGameListStarted(){}
simulated function OnReadSaveGameListComplete(bool bWasSuccessful){}
simulated function FilterSaveGameList(){}
simulated function OnSaveDeviceLost(){}
simulated function OnInit(){}
simulated function UpdateButtonHelp(){}
event Destroyed(){}
simulated event OnCleanupWorld(){}
simulated function DetachDelegates(){}
simulated function bool OnUnrealCommand(int ucmd, int Actionmask){}
simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnUAccept(){}
simulated function OverwritingSaveWarningCallback(EUIAction eAction){}
simulated function Save(){}
simulated function SaveProgressDialogOpen(){}
simulated function SaveNotificationTimeElapsed(){}
simulated function SaveGameComplete(bool bWasSuccessful){}
simulated function SaveProfileSettingsComplete(bool bWasSuccessful){}
simulated function CloseSavingProgressDialogWhenReady(){}
simulated function FailedSaveDialog(){}
simulated function StorageFullDialog(){}
simulated function StorageFullDialogCallback360(EUIAction eAction){}
simulated function StorageFullDialogCallbackPS3(EUIAction eAction){}
simulated function OnUCancel(){}
simulated function OnUDelete(){}
simulated function DeleteSaveWarningCallback(EUIAction eAction){}
simulated function DeleteSelectedSaveFile(){}
simulated function ShowRefreshingListDialog(optional delegate<ProgressDialogOpenCallback> ProgressDialogOpenCallback){}
simulated function OnUDPadUp(){}
simulated function OnUDPadDown(){}
simulated function BuildMenu(){}
simulated function int GetSaveID(int iIndex){}
simulated function int GetNumSaves(){}
simulated function CoreImagesLoaded(Object LoadedObject){}
simulated function DLC1ImagesLoaded(Object LoadedObject){}
simulated function DLC2ImagesLoaded(Object LoadedObject){}
simulated function HQAssaultImagesLoaded(Object LoadedObject){}
simulated function bool QueryAllImagesLoaded(){}
simulated function TestAllImagesLoaded(){}
simulated function ReloadImages(){}
simulated function AS_AddListItem(int Id, string Desc, string gameTime, string saveTime, bool bIsDisabled, string imagePath){}
simulated function AS_ReloadImages(){}
simulated function AS_Clear(){}
simulated function AS_ClearImage(int iIndex){}
simulated function AS_SetTitle(string sTitle){}
simulated function AS_SetSelected(int Index){}
