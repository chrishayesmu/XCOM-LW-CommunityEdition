class LWCE_UILoadGame extends UILoadGame;

const FIRST_LWCE_SAVE_VERSION = 17;   // LW 1.0's save version is 16
const CURRENT_LWCE_SAVE_VERSION = 17; // When updating this value, you must update the bytecode patch for XComOnlineEventMgr.FillInHeaderForSave also

var const localized string m_strSaveNotFromLWCEBody;
var const localized string m_strSaveNotFromLWCETitle;
var const localized string m_strSaveNotFromLWCEWarning;
var const localized string m_strSaveFromOlderLWCEBody;
var const localized string m_strSaveFromOlderLWCETitle;
var const localized string m_strSaveFromOlderLWCEWarning;
var const localized string m_strLoadAnyway;

simulated function BuildMenu()
{
    local int I, iSaveId, iSaveVersion;
    local XComOnlineEventMgr OnlineEventMgr;
    local string FriendlyName, MapName, mapPath, Language, languageInfo;

    local bool bIsValidSave;

    if (XComGameInfo(WorldInfo.Game) == none)
    {
        return;
    }

    OnlineEventMgr = XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager);
    OnlineEventMgr.EnsureSavesAreComplete();
    AS_Clear();
    SaveSlotStatus.Remove(0, SaveSlotStatus.Length);

    for (I = 0; I < m_arrSaveGames.Length; I++)
    {
        iSaveId = GetSaveID(I);
        iSaveVersion = m_arrSaveGames[i].SaveGames[0].SaveGameHeader.VersionNumber; // SaveGames[0] seems to be the only entry ever

        bIsValidSave = OnlineEventMgr.GetSaveSlotMapName(iSaveId, MapName);
        OnlineEventMgr.GetSaveSlotDescription(iSaveId, FriendlyName);
        OnlineEventMgr.GetSaveSlotLanguage(iSaveId, Language);
        class'UIUtilities'.static.StripSpecialMissionFromMapName(MapName);
        mapPath = bIsValidSave ? class'UIUtilities'.static.GetMapImagePath(name(MapName)) : "";

        if (class'UIUtilities'.static.IsDLC1Map(name(MapName)))
        {
            m_bNeedsToLoadDLC1MapImages = true;
        }

        if (class'UIUtilities'.static.IsDLC2Map(name(MapName)))
        {
            m_bNeedsToLoadDLC2MapImages = true;
        }

        if (class'UIUtilities'.static.IsHQAssaultMap(name(MapName)))
        {
            m_bNeedsToLoadHQAssaultImage = true;
        }

        languageInfo = "";

        if (Language != "" && GetLanguage() != Language)
        {
            languageInfo = m_strLanguageLabel @ Language @ "DEV WARNING: LANGUAGE MISMATCH";
        }

        FriendlyName = Repl(FriendlyName, "(outdated)", "");

        if (iSaveVersion < class'LWCE_XComOnlineEventMgr'.const.FIRST_LWCE_SAVE_VERSION)
        {
            FriendlyName $= class'UIUtilities'.static.GetHTMLColoredText("\n" $ m_strSaveNotFromLWCEWarning, eUIState_Bad);
            SaveSlotStatus.AddItem(2);
        }
        else if (iSaveVersion < class'LWCE_XComOnlineEventMgr'.const.CURRENT_LWCE_SAVE_VERSION)
        {
            FriendlyName $= class'UIUtilities'.static.GetHTMLColoredText("\n" $ m_strSaveFromOlderLWCEWarning, eUIState_Warning);
            SaveSlotStatus.AddItem(1);
        }
        else
        {
            SaveSlotStatus.AddItem(0);
        }

        AS_AddListItem(I, FriendlyName @ languageInfo, " ", " ", /* bShowRedSaveSlot */ false, mapPath);
    }

    SetSelected(0);
    `CONTENTMGR.RequestObjectAsync("UILibrary_MapImages.URB_Bar", self, CoreImagesLoaded);

    if (m_bNeedsToLoadDLC1MapImages)
    {
        `CONTENTMGR.RequestObjectAsync("UILibrary_MapImages_DLC1.DLC1_1_LowFriends", self, DLC1ImagesLoaded);
    }

    if (m_bNeedsToLoadDLC2MapImages)
    {
        `CONTENTMGR.RequestObjectAsync("UILibrary_MapImages_DLC2.DLC2_1_Portent", self, DLC2ImagesLoaded);
    }

    if (m_bNeedsToLoadHQAssaultImage)
    {
        `CONTENTMGR.RequestObjectAsync("UILibrary_MapImages_HQAssault.EWI_HQAssault", self, HQAssaultImagesLoaded);
    }

    controllerRef.m_Pres.UILoadAnimation(true);
}

simulated function OnUAccept()
{
    local TDialogueBoxData kDialogData;
    local string MapName;

    MapName = WorldInfo.GetMapName();
    class'UIUtilities'.static.StripSpecialMissionFromMapName(MapName);

    if (m_iCurrentSelection < 0 || m_iCurrentSelection >= m_arrSaveGames.Length)
    {
        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
    }
    else if (!m_bPlayerHasConfirmedLosingProgress && MapName != "XComShell")
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_strLostProgressTitle;
        kDialogData.strText = m_strLostProgressBody;
        kDialogData.strAccept = m_strLostProgressConfirm;
        kDialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
        kDialogData.fnCallback = ProgressCheckCallback;
        controllerRef.m_Pres.UIRaiseDialog(kDialogData);
    }
    else if (SaveSlotStatus[m_iCurrentSelection] == 2 && !m_arrSaveGames[m_iCurrentSelection].bIsCorrupt)
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_strSaveNotFromLWCETitle;
        kDialogData.strText = m_strSaveNotFromLWCEBody;
        kDialogData.strAccept = m_strLoadAnyway;
        kDialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
        kDialogData.fnCallback = OutdatedSaveWarningCallback;

        controllerRef.m_Pres.UIRaiseDialog(kDialogData);
    }
    else if (SaveSlotStatus[m_iCurrentSelection] == 1 && !m_arrSaveGames[m_iCurrentSelection].bIsCorrupt)
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_strSaveFromOlderLWCETitle;
        kDialogData.strText = m_strSaveFromOlderLWCEBody;
        kDialogData.strAccept = m_strLoadAnyway;
        kDialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
        kDialogData.fnCallback = OutdatedSaveWarningCallback;

        controllerRef.m_Pres.UIRaiseDialog(kDialogData);
    }
    else
    {
        LoadSelectedSlot();
    }
}