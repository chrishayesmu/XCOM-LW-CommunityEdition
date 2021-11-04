class UILoadGame extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation)
	dependson(UIDialogueBox)
	dependson(UIProgressDialogue);
//complete stub

const m_bBlockingSavesFromOtherLanguages = true;

var int m_iCurrentSelection;
var array<OnlineSaveGame> m_arrSaveGames;
var bool m_bPlayerHasConfirmedLosingProgress;
var bool m_bLoadInProgress;
var bool m_bNeedsToLoadDLC1MapImages;
var bool m_bNeedsToLoadDLC2MapImages;
var bool m_bNeedsToLoadHQAssaultImage;
var bool m_bLoadCompleteCoreMapImages;
var bool m_bLoadCompleteDLC1MapImages;
var bool m_bLoadCompleteDLC2MapImages;
var bool m_bLoadCompleteHQAssaultImage;
var int m_iLoadGameAsync;
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

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnReadSaveGameListStarted(){}
simulated function OnReadSaveGameListComplete(bool bWasSuccessful){}
simulated function bool FilterSaveGameList(){}
simulated function OnSaveDeviceLost(){}
simulated function OnInit(){}
simulated function UpdateButtonHelp(){}
event Destroyed(){}
simulated event OnCleanupWorld(){}
simulated function DetachDelegates(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OutdatedSaveWarningCallback(EUIAction eAction){}
simulated function ShowSaveLanguageDialog(){}
simulated function LoadSelectedSlot(){}
simulated function ReadSaveGameComplete(bool bWasSuccessful){}
simulated function ProgressCheckCallback(EUIAction eAction){}
simulated function DevDownloadableContentCheckOverride(EUIAction eAction){}
simulated function OnUAccept(){}
simulated function OnUCancel(){}
simulated function OnUDelete(){}
simulated function DeleteSaveWarningCallback(EUIAction eAction){}
simulated function DeleteSelectedSaveFile(){}
simulated function ShowRefreshingListDialog(optional delegate<UIProgressDialogue.ProgressDialogOpenCallback> ProgressDialogOpenCallback=NONE){}
simulated function OnUDPadUp(){}
simulated function OnUDPadDown(){}
simulated function SetTitle(string sTitle){}
simulated function SetSelected(int iTarget){}
simulated function BuildMenu(){}
simulated function AS_AddListItem(int Id, string Desc, string gameTime, string saveTime, bool bIsDisabled, string imagePath){}
simulated function int GetSaveID(int iIndex){}
simulated function int GetNumSaves(){}
simulated function CoreImagesLoaded(Object LoadedObject){}
simulated function DLC1ImagesLoaded(Object LoadedObject){}
simulated function DLC2ImagesLoaded(Object LoadedObject){}
simulated function HQAssaultImagesLoaded(Object LoadedObject){}
simulated function bool QueryAllImagesLoaded(){}
simulated function TestAllImagesLoaded(){}
simulated function ReloadImages(){}
simulated function ImageCheck(){}
simulated function AS_Clear(){}
simulated function AS_ReloadImages(){}
simulated function AS_ClearImage(int iIndex){}

simulated state LoadGameAsync
{
}