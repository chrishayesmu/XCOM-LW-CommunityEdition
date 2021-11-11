class Highlander_XGDebriefUI extends XGDebriefUI;

function int GetUnlockItem(out TTech kTech)
{
    `HL_LOG_DEPRECATED_CLS(GetUnlockItem);
    return 0;
}

function int HL_GetUnlockItem(out HL_TTech kTech)
{
    local int I, iItem;

    for (I = 0; I < kTech.arrItemReqs.Length; I++)
    {
        if (HQ().m_arrLastCargo[kTech.arrItemReqs[I]] > 0)
        {
            return kTech.arrItemReqs[I];
        }
    }

    if (kTech.kCost.arrItems.Length > 0)
    {
        for (I = 0; I < kTech.kCost.arrItems.Length; I++)
        {
            iItem = kTech.kCost.arrItems[I].iItemId;

            if (HQ().m_arrLastCargo[iItem] > 0)
            {
                return iItem;
            }
        }
    }
    else if (kTech.iTechId == 15) // Advanced Body Armor
    {
        return kTech.iTechId;
    }
    else if (kTech.iTechId == eTech_Xenobiology)
    {
        return eItem_SectoidCorpse;
    }
    else if (LABS().IsInterrogationTech(kTech.iTechId))
    {
        return HQ().m_arrLastCaptives[0];
    }

    return 0;
}

function OnExit()
{
    local TMissionReward kEmptyReward;

    `HL_LABS.m_arrHLMissionResults.Remove(0, `HL_LABS.m_arrHLMissionResults.Length);
    HQ().m_kLastReward = kEmptyReward;

    Sound().PlayMusic(Game().GetActMusic());
    PRES().PopState();
    PlayCloseSound();

    XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).DoRemoteEvent('SituationRoom_FundingCouncil_Off');
    class'SeqEvent_HQUnits'.static.PlayRoomSequence("Barracks");

    if (ISCONTROLLED())
    {
        if (!SETUPMGR().IsInState('Base4_MissionControl'))
        {
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().DoAutosave(Game().m_bIronMan);
        }
    }
    else
    {
        XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().DoAutosave(Game().m_bIronMan);
    }

    if (IsViewValid(eDebriefView_Council))
    {
        Narrative(`XComNarrativeMoment("FCRClosed"));
    }

    if (EXALT().m_bCellClearedPostCombat)
    {
        if (EXALT().m_bFirstCellClearedPostCombat)
        {
            Narrative(`XComNarrativeMoment("FirstCellRemoved"));
            EXALT().m_bFirstCellClearedPostCombat = false;
        }
        else
        {
            Narrative(`XComNarrativeMoment("Robo_NewClue"));
        }
    }

    if (HQ().m_kLastResult.bSuccess && HQ().m_kLastResult.eType == eMission_ExaltRaid)
    {
        Narrative(`XComNarrativeMoment("EXALTHQ_Success"));
    }

    BARRACKS().m_aLastMissionSoldiers.Remove(0, BARRACKS().m_aLastMissionSoldiers.Length);

    if (World().m_kFundingCouncil.m_bPlayAnnetteMusing)
    {
        switch (World().m_kFundingCouncil.m_iNextAnnetteMusing)
        {
            case 1:
                Narrative(`XComNarrativeMoment("AnnetteStoryMusingI"));
                break;
            case 2:
                Narrative(`XComNarrativeMoment("AnnetteStoryMusingII"));
                break;
            case 3:
                Narrative(`XComNarrativeMoment("AnnetteStoryMusingIV"));
                break;
        }
    }

    PRES().m_kStrategyHUD.m_kMenu.Show();
}

function UpdateScienceDebrief()
{
    local TScienceDebrief kDebrief;
    local TScienceDebriefItem kItem;
    local TDebriefLootItem kLootItem;
    local HL_TTech kTech;
    local TScienceProject kProjectUI;
    local TResearchProject kCurrentProject;
    local int iTech, iItem, eitm;
    local Highlander_XGFacility_Labs kLabs;
    local XGHeadQuarters kHQ;

    kLabs = `HL_LABS;
    kHQ = HQ();

    PRES().CAMLookAtNamedLocation("Cargo", 0.0);

    kDebrief.txtOpName.StrValue = m_kSkyranger.m_strLastOpName;
    kDebrief.txtOpName.iState = eUIState_Warning;

    kDebrief.txtTitle.StrValue = m_strSalvageAnalysis;
    kDebrief.txtTitle.iState = eUIState_Highlight;

    kDebrief.imgAdvisor.iImage = eImage_ChiefScientist;
    kDebrief.txtAdvisor.StrValue = m_strChiefScientist;
    kDebrief.txtAdvisor.iState = eUIState_Warning;

    for (iTech = 0; iTech < kLabs.m_arrHLMissionResults.Length; iTech++)
    {
        if (kLabs.m_arrHLMissionResults[iTech].eAvailabilityState == eTechState_Available)
        {
            kTech = `HL_TECH(kLabs.m_arrHLMissionResults[iTech].iTechId);
            iItem = HL_GetUnlockItem(kTech);

            // Not sure how this bit works or how necessary it is
            if (iItem != 0)
            {
                kItem.imgTech.strPath = kTech.ImagePath;
            }
            else
            {
                kItem.imgTech.strPath = "";
            }

            kItem.txtTitle.StrValue = m_strNewResourceProject;
            kItem.txtTitle.iState = eUIState_Good;
            kItem.txtTech.StrValue = kTech.strName;
            kItem.txtTech.iState = eUIState_Highlight;
            kDebrief.arrItems.AddItem(kItem);

            if (kLabs.IsInterrogationTech(kLabs.m_arrHLMissionResults[iTech].iTechId))
            {
                kLabs.m_bNewCaptive = true;
            }
        }
    }

    kProjectUI.txtTitle.StrValue = m_strLabelCurrentResearch;
    kCurrentProject = kLabs.GetCurrentProject();

    if (kCurrentProject.iTech == 0)
    {
        kProjectUI.txtProject.StrValue = m_strLabelNone;
        kProjectUI.txtProject.iState = eUIState_Bad;
    }
    else
    {
        kTech = `HL_TECH(kCurrentProject.iTech);
        kProjectUI.txtProject.StrValue = kTech.strName;
        kProjectUI.txtProject.iState = eUIState_Highlight;
        kProjectUI.txtProgress = kLabs.GetCurrentProgressText();
    }

    kDebrief.kProject = kProjectUI;
    kDebrief.kProject.txtVisit.StrValue = m_strLabelVisitLabs;
    kDebrief.iHighlighted = m_kScienceDebrief.iHighlighted;

    if (kDebrief.iHighlighted == 0)
    {
        kDebrief.kProject.bVisitHighlighted = true;
    }

    kDebrief.txtLootTitle.StrValue = m_strLabelArtifactsRecovered;
    kDebrief.txtLootTitle.iState = eUIState_Warning;

    // First iterate and find "special" (aka story-critical) items
    for (iItem = 0; iItem < kHQ.m_arrLastCargo.Length; iItem++)
    {
        if (kHQ.m_arrLastCargo[iItem] > 0 && IsSpecialLootItem(iItem))
        {
            kLootItem.imgItem.iImage = Item(iItem).iImage;
            kLootItem.imgItem.strPath = class'UIUtilities'.static.GetItemImagePath(EItemType(iItem));
            kLootItem.txtItem.StrValue = Item(iItem).strName;
            kLootItem.txtItem.iState = eUIState_Highlight;
            kLootItem.txtQuantity.StrValue = string(kHQ.m_arrLastCargo[iItem]);
            kLootItem.txtQuantity.iState = eUIState_Highlight;
            kDebrief.arrLoot.AddItem(kLootItem);

            for (eitm = 0; eitm < kDebrief.arrItems.Length; eitm++)
            {
                if (kDebrief.arrItems[eitm].kDebriefLootItem.txtItem.StrValue == kLootItem.txtItem.StrValue)
                {
                    kDebrief.arrItems[eitm].kDebriefLootItem = kLootItem;
                }
            }
        }
    }

    // Then go through again for all the ordinary items
    for (iItem = 0; iItem < kHQ.m_arrLastCargo.Length; iItem++)
    {
        if (kHQ.m_arrLastCargo[iItem] > 0 && !IsSpecialLootItem(iItem))
        {
            kLootItem.imgItem.iImage = Item(iItem).iImage;
            kLootItem.imgItem.strPath = class'UIUtilities'.static.GetItemImagePath(EItemType(iItem));
            kLootItem.txtItem.StrValue = Item(iItem).strName;
            kLootItem.txtItem.iState = eUIState_Highlight;

            if (iItem == eItem_Elerium115)
            {
                if (ENGINEERING().IsFoundryTechResearched(38)) // Alien Nucleonics
                {
                    kHQ.m_arrLastCargo[iItem] *= 1.20;
                }
            }

            if (iItem == eItem_AlienAlloys)
            {
                if (ENGINEERING().IsFoundryTechResearched(25)) // Alien Metallurgy
                {
                    kHQ.m_arrLastCargo[iItem] *= 1.20;
                }
            }

            if (iItem == eItem_WeaponFragment)
            {
                if (ENGINEERING().IsFoundryTechResearched(39)) // Advanced Salvage
                {
                    kHQ.m_arrLastCargo[iItem] *= 1.20;
                }
            }

            kLootItem.txtQuantity.StrValue = string(kHQ.m_arrLastCargo[iItem]);
            kLootItem.txtQuantity.iState = eUIState_Highlight;
            kDebrief.arrLoot.AddItem(kLootItem);

            for (eitm = 0; eitm < kDebrief.arrItems.Length; eitm++)
            {
                if (kDebrief.arrItems[eitm].kDebriefLootItem.txtItem.StrValue == kLootItem.txtItem.StrValue)
                {
                    kDebrief.arrItems[eitm].kDebriefLootItem = kLootItem;
                }
            }
        }
    }

    m_kScienceDebrief = kDebrief;
}