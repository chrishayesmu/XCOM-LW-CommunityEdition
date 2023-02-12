class LWCE_UISaveGame extends UISaveGame;

simulated function BuildMenu()
{
    local int I, iSaveId, iSaveVersion;
    local string FriendlyName, MapName, mapPath, Language, languageInfo;

    local XComOnlineEventMgr OnlineEventMgr;
    local bool bIsValidSave;

    OnlineEventMgr = `ONLINEEVENTMGR;
    AS_Clear();
    AS_AddListItem(0, m_sEmptySlot, " ", " ", false, "");

    for (I = 1; I < m_arrSaveGames.Length; I++)
    {
        iSaveId = GetSaveID(I);
        iSaveVersion = m_arrSaveGames[i - 1].SaveGames[0].SaveGameHeader.VersionNumber; // SaveGames[0] seems to be the only entry ever

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
            languageInfo = class'UILoadGame'.default.m_strLanguageLabel @ Language @ "DEV WARNING: LANGUAGE MISMATCH";
        }

        FriendlyName = Repl(FriendlyName, "(outdated)", "");

        if (iSaveVersion < class'LWCE_XComOnlineEventMgr'.const.FIRST_LWCE_SAVE_VERSION)
        {
            FriendlyName $= class'UIUtilities'.static.GetHTMLColoredText("\n" $ class'LWCE_UILoadGame'.default.m_strSaveNotFromLWCEWarning, eUIState_Bad);
        }
        else if (iSaveVersion < class'LWCE_XComOnlineEventMgr'.const.CURRENT_LWCE_SAVE_VERSION)
        {
            FriendlyName $= class'UIUtilities'.static.GetHTMLColoredText("\n" $ class'LWCE_UILoadGame'.default.m_strSaveFromOlderLWCEWarning, eUIState_Warning);
        }

        AS_AddListItem(I, FriendlyName @ languageInfo, " ", " ", /* bShowRedSaveSlot */ false, mapPath);
    }

    m_iCurrentSelection = 0;
    AS_SetSelected(m_iCurrentSelection);
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
    local TInputDialogData kInputDialogData;

    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);

    if (m_iCurrentSelection > 0)
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_sOverwriteSaveTitle;
        kDialogData.strText = m_sOverwriteSaveText;
        kDialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
        kDialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
        kDialogData.fnCallback = OverwritingSaveWarningCallback;
        controllerRef.m_Pres.UIRaiseDialog(kDialogData);
    }
    else
    {
        kInputDialogData.strTitle = "Enter Save Name";
        kInputDialogData.iMaxChars = 40;
        kInputDialogData.fnCallbackAccepted = OnSaveNameInputBoxAccepted;
        kInputDialogData.fnCallbackCancelled = OnSaveNameInputBoxCanceled;

        controllerRef.m_Pres.UIInputDialog(kInputDialogData);

        // Save();
    }
}

function OnSaveNameInputBoxAccepted(string Text)
{

}

function OnSaveNameInputBoxCanceled(string Text)
{

}