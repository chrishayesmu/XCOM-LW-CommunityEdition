class Highlander_XGDebriefUI extends XGDebriefUI;

function bool CheckForMatinee()
{
    local Highlander_XGHeadquarters kHQ;

    kHQ = `HL_HQ;

    if (m_bPlayedMatinee)
    {
        return false;
    }

    if (m_bFirstTime)
    {
        PRES().UINarrative(`XComNarrativeMoment("TP_SurvivorReturns_02"),, PostFirstTimeMatinee);
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kHLLastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(OutsiderShard)))
    {
        PRES().UINarrative(`XComNarrativeMoment("AlienCode"),, PostShardMatinee);
        STAT_SetStat(eRecap_ObjCollectShards, Game().GetDays());
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kHLLastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(HyperwaveBeacon)) && STAT_GetStat(eRecap_ObjAssaultBase) == 0)
    {
        PRES().UINarrative(`XComNarrativeMoment("HyperWaveRetrieved"),, PostHyperwaveMatinee);
        STAT_SetStat(eRecap_ObjAssaultBase, STAT_GetStat(eRecap_Days));
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kHLLastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(EtherealDevice)))
    {
        PRES().UINarrative(`XComNarrativeMoment("PsiLinkRecovered"),, PostPsiLinkMatinee);
        STAT_SetStat(eRecap_ObjRecoverPsiLink, Game().GetDays());
        m_bPlayedMatinee = true;
        return true;
    }

    return false;
}

/// <summary>
/// In base Enemy Within, this function would check for newly-awardable medals earned during the mission.
/// In Long War, it has been rewritten to show a list of items that were lost or damaged instead. In the
/// Highlander, that functionality is in UpdateEngineeringDebrief, and this function is deprecated.
/// </summary>
function CheckForMedals()
{
    `HL_LOG_CLS("XGDebriefUI.CheckForMedals is deprecated in the Highlander. Stack track follows.");
    ScriptTrace();
}

function int GetUnlockItem(out TTech kTech)
{
    `HL_LOG_DEPRECATED_CLS(GetUnlockItem);
    return 0;
}

function int HL_GetUnlockItem(out HL_TTech kTech)
{
    local int I, iItemId;
    local Highlander_XGHeadquarters kHQ;

    kHQ = `HL_HQ;

    for (I = 0; I < kTech.kPrereqs.arrItemReqs.Length; I++)
    {
        iItemId = kTech.kPrereqs.arrItemReqs[I];

        if (kHQ.m_kHLLastCargoArtifacts.HasNonzeroEntry(iItemId))
        {
            return kTech.kPrereqs.arrItemReqs[I];
        }
    }

    if (kTech.kCost.arrItems.Length > 0)
    {
        for (I = 0; I < kTech.kCost.arrItems.Length; I++)
        {
            iItemId = kTech.kCost.arrItems[I].iItemId;

            if (kHQ.m_kHLLastCargoArtifacts.HasNonzeroEntry(iItemId))
            {
                return iItemId;
            }
        }
    }
    else if (kTech.iTechId == `LW_TECH_ID(AdvancedBodyArmor))
    {
        return kTech.iTechId;
    }
    else if (kTech.iTechId == `LW_TECH_ID(Xenobiology))
    {
        return eItem_SectoidCorpse;
    }
    else if (LABS().IsInterrogationTech(kTech.iTechId))
    {
        // TODO: not sure how correct this is, since nothing ever seems to clear out this array
        return kHQ.m_arrHLLastCaptives[0];
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
            Narrative(`XComNarrativeMomentEW("FirstCellRemoved"));
            EXALT().m_bFirstCellClearedPostCombat = false;
        }
        else
        {
            Narrative(`XComNarrativeMomentEW("Robo_NewClue"));
        }
    }

    if (HQ().m_kLastResult.bSuccess && HQ().m_kLastResult.eType == eMission_ExaltRaid)
    {
        Narrative(`XComNarrativeMomentEW("EXALTHQ_Success"));
    }

    BARRACKS().m_aLastMissionSoldiers.Remove(0, BARRACKS().m_aLastMissionSoldiers.Length);

    if (World().m_kFundingCouncil.m_bPlayAnnetteMusing)
    {
        switch (World().m_kFundingCouncil.m_iNextAnnetteMusing)
        {
            case 1:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingI"));
                break;
            case 2:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingII"));
                break;
            case 3:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingIV"));
                break;
        }
    }

    PRES().m_kStrategyHUD.m_kMenu.Show();
}

function UpdateEngineeringDebrief()
{
    local Highlander_XGStorage kStorage;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;
    local TEngineeringDebriefItem kData;

    kStorage = `HL_STORAGE;

    m_kEngineeringDebrief.txtAdvisor.StrValue = m_sMedalUnlockTitle;
    m_kEngineeringDebrief.txtTitle.StrValue = m_sMedalAwardTitle;

    // In base Long War, items would naturally be sorted by item ID. In the Highlander, we can sort
    // them however we want, but for now we just use the order they're inserted in.

    // Lost items are listed first
    foreach kStorage.m_arrHLItemsLostLastMission(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `HL_ITEM(kItemQuantity.iItemId);

        kData.txtItem.StrValue = kItemQuantity.iQuantity > 1 ? kItem.strNamePlural : kItem.strName;
        kData.txtBody.StrValue = string(kItemQuantity.iQuantity);
        kData.imgItem.strPath = kItem.ImagePath;

        m_kEngineeringDebrief.arrItems.AddItem(kData);
    }

    m_kEngineeringDebrief.iHighlighted = m_kEngineeringDebrief.arrItems.Length;

    // Now list damaged items
    foreach kStorage.m_arrHLItemsDamagedLastMission(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `HL_ITEM(kItemQuantity.iItemId);

        kData.txtItem.StrValue = kItemQuantity.iQuantity > 1 ? kItem.strNamePlural : kItem.strName;
        kData.txtBody.StrValue = string(kItemQuantity.iQuantity);
        kData.imgItem.strPath = kItem.ImagePath;

        m_kEngineeringDebrief.arrItems.AddItem(kData);
    }
}

function UpdateScienceDebrief()
{
    local TScienceDebrief kDebrief;
    local TScienceDebriefItem kDebriefItem;
    local TDebriefLootItem kLootItem;
    local HL_TItem kItem;
    local HL_TTech kTech;
    local TScienceProject kProjectUI;
    local TResearchProject kCurrentProject;
    local int iTech, iItem, eitm;
    local Highlander_XGFacility_Labs kLabs;
    local Highlander_XGHeadQuarters kHQ;

    kLabs = `HL_LABS;
    kHQ = `HL_HQ;

    `HL_LOG_CLS("UpdateScienceDebrief: kHQ.m_kHLLastCargoArtifacts.m_arrEntries.Length = " $ kHQ.m_kHLLastCargoArtifacts.m_arrEntries.Length);
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
                kDebriefItem.imgTech.strPath = kTech.ImagePath;
            }
            else
            {
                kDebriefItem.imgTech.strPath = "";
            }

            kDebriefItem.txtTitle.StrValue = m_strNewResourceProject;
            kDebriefItem.txtTitle.iState = eUIState_Good;
            kDebriefItem.txtTech.StrValue = kTech.strName;
            kDebriefItem.txtTech.iState = eUIState_Highlight;
            kDebrief.arrItems.AddItem(kDebriefItem);

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
    for (iItem = 0; iItem < kHQ.m_kHLLastCargoArtifacts.m_arrEntries.Length; iItem++)
    {
        if (kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity > 0 && IsSpecialLootItem(iItem))
        {
            kItem = `HL_ITEM(kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iItemId);
            kLootItem.imgItem.strPath = kItem.ImagePath;
            kLootItem.txtItem.StrValue = kItem.strName;
            kLootItem.txtItem.iState = eUIState_Highlight;
            kLootItem.txtQuantity.StrValue = string(kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity);
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
    for (iItem = 0; iItem < kHQ.m_kHLLastCargoArtifacts.m_arrEntries.Length; iItem++)
    {
        if (kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity > 0 && !IsSpecialLootItem(iItem))
        {
            kItem = `HL_ITEM(kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iItemId);
            kLootItem.imgItem.strPath = kItem.ImagePath;
            kLootItem.txtItem.StrValue = kItem.strName;
            kLootItem.txtItem.iState = eUIState_Highlight;

            if (kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(Elerium))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienNucleonics)))
                {
                    kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            if (kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(AlienAlloy))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienMetallurgy)))
                {
                    kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            if (kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(WeaponFragment))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(ImprovedSalvage)))
                {
                    kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            kLootItem.txtQuantity.StrValue = string(kHQ.m_kHLLastCargoArtifacts.m_arrEntries[iItem].iQuantity);
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

function UpdateView()
{
    local Highlander_XGHeadquarters kHQ;
    local array<EXComSpeakerType> arrSpeakers;
    local bool bMeldWasPossible, bMeldWasRetrieved;

    kHQ = `HL_HQ;

    switch (m_iCurrentView)
    {
        case eDebriefView_Council:
            UpdateCouncilDebrief();
            break;
        case eDebriefView_Science:
            UpdateScienceDebrief();
            break;
        case eDebriefView_Engineering:
            UpdateEngineeringDebrief();
            break;
        case eDebriefView_Soldiers:
            UpdateSoldierDebrief();
            break;
        case eDebriefView_CovertOp:
            UpdateCovertOpDebrief();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (CheckForMatinee())
    {
        return;
    }

    if (m_iCurrentView == eDebriefView_Science)
    {
        Narrative(`XComNarrativeMoment("MissionUnload"));

        if (LABS().m_bNewCaptive)
        {
            Narrative(`XComNarrativeMoment("CongratsCaptive"));
            LABS().m_bNewCaptive = false;
        }
        else if (LABS().m_bCaptiveDied)
        {
            Narrative(`XComNarrativeMoment("CaptiveDied"));
            LABS().m_bCaptiveDied = false;
        }
    }
    else if (m_iCurrentView == eDebriefView_Soldiers && !ISCONTROLLED())
    {
        if (BARRACKS().m_eLastResult != eLastResult_None && BARRACKS().m_eLastResultSpeaker == eSpeaker_Skyranger)
        {
            arrSpeakers.AddItem(eSpeaker_Alpha);
            arrSpeakers.AddItem(eSpeaker_Engineer);
            arrSpeakers.AddItem(eSpeaker_Science);

            BARRACKS().m_eLastResultSpeaker = arrSpeakers[Rand(arrSpeakers.Length)];
            bMeldWasPossible = kHQ.m_kLastResult.eType == eMission_Abduction || kHQ.m_kLastResult.eType == eMission_Crash || kHQ.m_kLastResult.eType == eMission_LandedUFO;
            bMeldWasRetrieved = kHQ.m_kHLLastCargoArtifacts.Get(`LW_ITEM_ID(Meld)).iQuantity > 0;

            switch (BARRACKS().m_eLastResultSpeaker)
            {
                case eSpeaker_Alpha:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("MCToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        Narrative(`XComNarrativeMoment("MCGreatMission"));
                    }

                    break;
                case eSpeaker_Engineer:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("EngineerToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        if (!bMeldWasRetrieved && bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMomentEW("EngineerGreatMission_GetMeld"));
                        }
                        else if (Rand(10) > 4 || !bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMoment("EngineerGreatMission"));
                        }
                        else
                        {
                            Narrative(`XComNarrativeMomentEW("EngineerGreatMission_GotMeld"));
                        }
                    }

                    break;
                case eSpeaker_Science:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("ScientistToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        if (!bMeldWasRetrieved && bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMomentEW("ScientistGreatMission_GetMeld"));
                        }
                        else if ((Rand(10) > 4) || !bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMoment("ScientistGreatMission"));
                        }
                        else
                        {
                            Narrative(`XComNarrativeMomentEW("ScientistGreatMission_GotMeld"));
                        }
                    }

                    break;
            }
        }
    }

    if (!kHQ.m_kLastResult.bSuccess)
    {
        Sound().PlayMusic(eMusic_YouLose);
    }
    else
    {
        Sound().PlayMusic(Game().GetActMusic());
    }

    PRES().m_kStrategyHUD.m_kEventList.Hide();
}