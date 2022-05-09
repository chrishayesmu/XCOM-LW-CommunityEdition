class LWCE_XGPsiLabsUI extends XGPsiLabsUI
    dependson(LWCE_XGFacility_PsiLabs);

function Init(int iView)
{
    HQ().m_kBase.LookAtFacility(eFacility_PsiLabs);

    if (`LWCE_PSILABS.m_arrCECompleted.Length > 0)
    {
        iView = ePsiLabsView_Results;
    }
    else
    {
        iView = ePsiLabsView_Main;
    }

    super(XGScreenMgr).Init(iView);
    PlayOpenSound();
}

function TTableMenuOption BuildResultOption(TPsiTrainee kTrainee)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildResultOption);

    return kOption;
}

function TTableMenuOption LWCE_BuildResultOption(LWCE_TPsiTrainee kTrainee)
{
    local TTableMenuOption kOption;

    kOption.arrStrings.AddItem(kTrainee.kSoldier.GetName(eNameType_RankFull));
    kOption.arrStates.AddItem(eUIState_Normal);

    if (kTrainee.bTrainingSucceeded)
    {
        kOption.arrStrings.AddItem(m_strItemGifted);
        kOption.arrStates.AddItem(eUIState_Good);
        m_bGift = true;
    }
    else
    {
        kOption.arrStrings.AddItem(m_strItemNoGift);
        kOption.arrStates.AddItem(eUIState_Bad);
    }

    kOption.arrStrings.AddItem("");
    kOption.arrStates.AddItem(eUIState_Disabled);
    kOption.iState = eUIState_Disabled;

    return kOption;
}

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int iSoldierListIndex)
{
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    kOption.iState = kSoldier.IsReadyToPsiLevelUp() ? eUIState_Good : eUIState_Disabled;

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = 0;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 0:
                strCategory = string(kSoldier.m_kSoldier.iCountry);
                break;
            case 1:
                strCategory = string(kSoldier.GetRank());
                break;
            case 2:
                strCategory = string(kSoldier.GetEnergy());
                break;
            case 3:
                strCategory = kSoldier.GetClassName();
                break;
            case 4:
                strCategory = kSoldier.GetName(8);
                break;
            case 5:
                strCategory = kSoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kSoldier.GetName(eNameType_Nick);
                break;
            case 7:
                strCategory = kSoldier.GetStatusString();
                iState = kSoldier.GetStatusUIState();
                break;
            case 8:
                if (kSoldier.HasAvailablePerksToAssign())
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 9:
                if (kSoldier.HasAvailablePerksToAssign(true))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 10:
                if (kSoldier.m_kChar.bHasPsiGift)
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 11:
                if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(LWCE_XGStrategySoldier(kSoldier).m_kCEChar))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }
                break;
            case 13:
                iState = kSoldier.GetSHIVRank();
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kSoldier.m_arrMedals);
                break;
            case 14:
                strCategory = string(iSoldierListIndex);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function TPsiTraineeList BuildTrainees()
{
    local string strTime;
    local int iHours, iPerkId, iSlot, iTrainingChance;
    local TPsiTraineeList kList;
    local TTableMenuOption kOption;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGFacility_PsiLabs kPsiLabs;

    kPerksMgr = LWCE_XComPerkManager(perkMgr());
    kPsiLabs = `LWCE_PSILABS;

    for (iSlot = 0; iSlot < class'XGTacticalGameCore'.default.PSI_NUM_TRAINING_SLOTS; iSlot++)
    {
        if (kPsiLabs.m_arrCETraining.Length <= iSlot)
        {
            kOption.arrStrings.AddItem(m_strItemEmpty);
            kOption.arrStates.AddItem(eUIState_Highlight);

            kOption.arrStrings.AddItem("");
            kOption.arrStates.AddItem(eUIState_Warning);

            kOption.arrStrings.AddItem(m_strLabelAddSoldier);
            kOption.arrStates.AddItem(eUIState_Normal);
        }
        else
        {
            iPerkId = kPsiLabs.m_arrCETraining[iSlot].kPerk.iPerkId;
            iTrainingChance = kPsiLabs.RollForGift(kPsiLabs.m_arrCETraining[iSlot].kSoldier);
            kOption.arrStrings.AddItem(kPsiLabs.m_arrCETraining[iSlot].kSoldier.GetName(eNameType_FullNick) @ "(" $ kPerksMgr.GetPerkName(iPerkId) $ ") (" $ iTrainingChance $ "%)");
            kOption.arrStates.AddItem(eUIState_Normal);

            iHours = kPsiLabs.m_arrCETraining[iSlot].iHoursLeft;
            strTime = string(iHours / 24) @ m_strLabelDays @ string(iHours % 24) @ m_strLabelHours;
            kOption.arrStrings.AddItem(strTime);
            kOption.arrStates.AddItem(eUIState_Warning);

            kOption.arrStrings.AddItem(m_strLabelRemoveSoldier);
            kOption.arrStates.AddItem(eUIState_Normal);
        }

        kList.mnuSlots.arrOptions.AddItem(kOption);

        kOption.arrStrings.Length = 0;
        kOption.arrStates.Length = 0;
        kOption.iState = eUIState_Normal;
    }

    return kList;
}

function OnChooseSlot(int iSlot)
{
    if (PSILABS().IsSlotOccupied(iSlot))
    {
        m_iTraineeToBeRemoved = iSlot;
        OnConfirmRemoveTrainee();
    }
    else
    {
        m_iHighlightedSlot = iSlot;
        GoToView(ePsiLabsView_Add);
        `HQPRES.UISoldierList(class'LWCE_UISoldierList_PsiLabs');
    }

    PlayGoodSound();
}

function OnConfirmRemoveTrainee()
{
    local TDialogueBoxData kData;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = `LWCE_PSILABS.m_arrCETraining[m_iTraineeToBeRemoved].kSoldier.GetName(eNameType_Full);

    kData.strTitle = m_strConfirmRemovalDialogTitle;
    kData.strText = class'XComLocalizer'.static.ExpandString(m_strConfirmRemovalDialogText);
    kData.strAccept = m_strConfirmRemovalDialogAcceptText;
    kData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
    kData.fnCallback = OnRemoveTraineeDialogConfirm;

    `HQPRES.UIRaiseDialog(kData);
}

function OnLeaveFacility()
{
    local LWCE_XGFacility_PsiLabs kPsiLabs;

    kPsiLabs = `LWCE_PSILABS;

    kPsiLabs.m_arrCECompleted.Remove(0, kPsiLabs.m_arrCECompleted.Length);
    kPsiLabs.m_bAnnouncedResults = false;
    PRES().PopState();
    PlayCloseSound();
}

function OnLeaveResults()
{
    local LWCE_XGFacility_PsiLabs kPsiLabs;

    kPsiLabs = `LWCE_PSILABS;

    kPsiLabs.m_arrCECompleted.Remove(0, kPsiLabs.m_arrCECompleted.Length);
    kPsiLabs.m_bAnnouncedResults = false;
    GoToView(ePsiLabsView_Main);
    PlaySmallCloseSound();
}

function UpdatePsiResults()
{
    local LWCE_XGFacility_PsiLabs kPsiLabs;
    local TPsiResultsList kResults;
    local int iTrainee;

    kPsiLabs = `LWCE_PSILABS;

    kResults.txtTitle.StrValue = m_strLabelTestResults;
    kResults.txtTitle.iState = eUIState_Warning;

    kResults.mnuResults.bTakesNoInput = true;
    kResults.mnuResults.arrCategories.AddItem(14);
    kResults.mnuResults.arrCategories.AddItem(28);
    kResults.mnuResults.kHeader.arrStrings = GetHeaderStrings(kResults.mnuResults.arrCategories);
    kResults.mnuResults.kHeader.arrStates = GetHeaderStates(kResults.mnuResults.arrCategories);

    for (iTrainee = 0; iTrainee < kPsiLabs.m_arrCECompleted.Length; iTrainee++)
    {
        kResults.mnuResults.arrOptions.AddItem(LWCE_BuildResultOption(kPsiLabs.m_arrCECompleted[iTrainee]));
    }

    m_kResults = kResults;
}