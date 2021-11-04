class Highlander_XGResearchUI extends XGResearchUI;

function OnLeaveReport(bool bJumpToChooseTech)
{
    local Highlander_XGFacility_Labs kLabs;
    local int iUnlock;

    kLabs = `HL_LABS;
    kLabs.m_bRequiresAttention = false;

    PlaySmallCloseSound();

    if (bJumpToChooseTech)
    {
        if (!kLabs.HasTechsAvailable())
        {
            GoToView(eLabView_MainMenu);
        }
        else
        {
            GoToView(eLabView_ChooseTech);
        }

        for (iUnlock = 0; iUnlock < kLabs.m_arrUnlockedItems.Length; iUnlock++)
        {
            switch (kLabs.m_arrUnlockedItems[iUnlock])
            {
                case 255:
                    UnlockMecArmor(kLabs.m_arrUnlockedItems[iUnlock]);
            }
        }

        for (iUnlock = 0; iUnlock < kLabs.m_arrUnlockedGeneMods.Length; iUnlock++)
        {
            UnlockGeneMod(kLabs.m_arrUnlockedGeneMods[iUnlock]);
        }

        kLabs.m_arrUnlockedGeneMods.Remove(0, kLabs.m_arrUnlockedGeneMods.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrUnlockedItems.Length; iUnlock++)
        {
            switch (kLabs.m_arrUnlockedItems[iUnlock])
            {
                case 193:
                case 194:
                case 195:
                default:
                    UnlockItem(kLabs.m_arrUnlockedItems[iUnlock]);
            }
        }

        kLabs.m_arrUnlockedItems.Remove(0, kLabs.m_arrUnlockedItems.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrUnlockedFacilities.Length; iUnlock++)
        {
            UnlockFacility(kLabs.m_arrUnlockedFacilities[iUnlock]);
        }

        kLabs.m_arrUnlockedFacilities.Remove(0, kLabs.m_arrUnlockedFacilities.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrHLUnlockedFoundryProjects.Length; iUnlock++)
        {
            HL_UnlockFoundryProject(kLabs.m_arrHLUnlockedFoundryProjects[iUnlock]);
        }

        kLabs.m_arrHLUnlockedFoundryProjects.Remove(0, kLabs.m_arrHLUnlockedFoundryProjects.Length);
    }
}

function bool HL_UnlockFoundryProject(int iProject)
{
    local TItemUnlock kUnlock;

    if (!Highlander_XGStrategy(Game()).HL_UnlockFoundryProject(iProject, kUnlock))
    {
        return false;
    }
    else
    {
        PRES().UIItemUnlock(kUnlock);
    }

    return true;
}

function UpdateReport()
{
    local TResearchReport kReport;
    local TTech kTech;
    local array<int> arrResults;
    local int iResult;
    local XGParamTag kTag;
    local EResearchCredits eCredit;
    local XGDateTime kDateTime;
    local Highlander_XGFacility_Labs kLabs;

    kLabs = `HL_LABS;
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    if (kLabs.m_arrResearchedTimes[m_eReportTech] != none)
    {
        kDateTime = kLabs.m_arrResearchedTimes[m_eReportTech];
    }
    else
    {
        kDateTime = GEOSCAPE().m_kDateTime;
    }

    kReport.imgBG.iImage = eImage_OldResearch;
    kTech = TECH(m_eReportTech);
    kReport.txtTitle.StrValue = m_strLabelResearchReport;
    kReport.txtTitle.iState = eUIState_Warning;
    kReport.txtTopSecret.StrValue = m_strLabelTopSecret;
    kReport.txtTopSecret.iState = eUIState_Bad;
    kReport.txtCodename.StrValue = m_strLabelCodeName @ kTech.strCodename;
    kReport.txtCodename.iState = eUIState_Warning;
    kReport.txtMonthNum.StrValue = string(kDateTime.m_iMonth);
    kReport.txtMonthNum.iState = eUIState_Good;

    if (GetLanguage() == "FRA" || GetLanguage() == "ITA" || GetLanguage() == "ESN")
    {
        kReport.txtMonth.StrValue = kDateTime.GetMonthString(, true);
    }
    else
    {
        kReport.txtMonth.StrValue = kDateTime.GetMonthString();
    }

    kReport.txtMonth.iState = eUIState_Good;
    kReport.txtYear.StrValue = string(kDateTime.m_iYear);
    kReport.txtYear.iState = eUIState_Good;
    kReport.txtSubject.strLabel = m_strLabelSubject;
    kReport.txtSubject.StrValue = kTech.strName;
    kReport.txtSubject.iState = eUIState_Highlight;
    kReport.imgProject.iImage = kTech.iImage;
    kReport.txtNotesLabel.StrValue = m_strLabelProjectNotes;
    kReport.txtNotesLabel.iState = eUIState_Highlight;
    kReport.txtNotes.StrValue = kTech.strReport;

    if (kTech.strCustom != "")
    {
        kReport.txtResults.Add(1);
        kReport.txtResults[0].StrValue = kTech.strCustom;
        kReport.txtResults[0].iState = eUIState_Warning;
    }

    arrResults = TECHTREE().GetFacilityResults(m_eReportTech);

    if (arrResults.Length > 0)
    {
        for (iResult = 0; iResult < arrResults.Length; iResult++)
        {
            kTag.StrValue0 = Facility(arrResults[iResult]).strName;
            kReport.txtResults.Add(1);
            kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strFacilityBuildAvailable);
            kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;

            kLabs.m_arrUnlockedFacilities.AddItem(EFacilityType(arrResults[iResult]));
        }
    }

    arrResults = TECHTREE().GetItemResults(m_eReportTech);

    if (arrResults.Length > 0)
    {
        for (iResult = 0; iResult < arrResults.Length; iResult++)
        {
            if (ITEMTREE().CanBeBuilt(arrResults[iResult]) || ITEMTREE().IsMecArmor(arrResults[iResult]))
            {
                kTag.StrValue0 = Item(arrResults[iResult]).strName;
                kReport.txtResults.Add(1);
                kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strItemBuildAvailable);
                kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
                kLabs.m_arrUnlockedItems.AddItem(EItemType(arrResults[iResult]));
            }
        }

        kReport.EItemCard = EItemType(arrResults[0]);
    }

    arrResults = TECHTREE().GetGeneResults(m_eReportTech);

    for (iResult = 0; iResult < arrResults.Length; iResult++)
    {
        kTag.StrValue0 = TECHTREE().GetGeneTech(EGeneModTech(arrResults[iResult])).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strGeneModAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrUnlockedGeneMods.AddItem(EGeneModTech(arrResults[iResult]));
    }

    if (kTech.iTech == eTech_Meld) // Xenogenetics
    {
        kTag.StrValue0 = string(40);
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strBonusMeld);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
    }

    arrResults = TECHTREE().GetFoundryResults(m_eReportTech);

    for (iResult = 0; iResult < arrResults.Length; iResult++)
    {
        kTag.StrValue0 = FTECH(arrResults[iResult]).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strFoundryBuildAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrHLUnlockedFoundryProjects.AddItem(arrResults[iResult]);
    }

    eCredit = TECHTREE().GetTech(m_eReportTech).eCreditGranted;

    if (eCredit != 0)
    {
        kTag.StrValue0 = class'XGLocalizedData'.default.ResearchCreditNames[eCredit];
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strResearchCreditEarned);
        kReport.txtResults[0].iState = eUIState_Good;
    }

    if (kLabs.IsAutopsyTech(m_eReportTech))
    {
        kReport.eCharCard = class'XGGameData'.static.CorpseToChar(TECH(m_eReportTech).iItemReq);
        kReport.btxtInfo.iButton = 3;
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ TACTICAL().GetTCharacter(kReport.eCharCard).strName;
    }
    else if (kReport.EItemCard != 0)
    {
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ Item(kReport.EItemCard).strName;
    }

    m_kReport = kReport;
}