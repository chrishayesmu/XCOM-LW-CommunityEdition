class LWCE_XGResearchUI extends XGResearchUI;

var int m_iCEReportTech;
var LWCE_TLabArchivesUI m_kCEArchives;

function Init(int iView)
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;

    if (ISCONTROLLED())
    {
        m_iCEReportTech = kLabs.m_iCELastResearched;

        if (kLabs.m_iCELastResearched != 0)
        {
            if (kLabs.m_iCELastResearched != `LW_TECH_ID(Xenobiology) && kLabs.m_iCELastResearched != `LW_TECH_ID(Xenoneurology))
            {
                GoToView(eLabView_ChooseTech);
            }
            else
            {
                GoToView(eLabView_Report);
            }
        }
        else
        {
            GoToView(iView);
        }

        return;
    }

    if (kLabs.m_iCELastResearched != 0)
    {
        m_iCEReportTech = kLabs.m_iCELastResearched;
        GoToView(eLabView_Report);
    }
    else
    {
        GoToView(iView);
    }
}

function TTableMenuOption LWCE_BuildTechOption(LWCE_TTech kTech, array<int> arrCategories, bool bPriority)
{
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        if (arrCategories[iCategory] == 1)
        {
            strCategory = kTech.strName;

            if (bPriority)
            {
                strCategory @= "-" @ m_strLabelPriority;
            }
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    if (bPriority)
    {
        kOption.iState = eUIState_Good;
    }

    return kOption;
}

function TTechSummary LWCE_BuildTechSummary(LWCE_TTech kTech)
{
    local LWCE_XGTechTree kTechTree;
    local TResearchCost kCost;
    local TTechSummary kSummary;
    local XGParamTag kTag;
    local int I;

    kTechTree = `LWCE_TECHTREE;

    kSummary.imgItem.strPath = kTech.ImagePath;
    kSummary.txtTitle.StrValue = "<b>" $ kTech.strName $ "</b>";
    kSummary.txtTitle.iState = eUIState_Highlight;
    kSummary.txtSummary.StrValue = kTech.strSummary;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    for (I = 0; I < 10; I++)
    {
        if (LABS().HasResearchCredit(EResearchCredits(I)) && kTechTree.LWCE_CreditAppliesToTech(I, kTech.iTechId))
        {
            kTag.StrValue0 = class'XGLocalizedData'.default.ResearchCreditNames[I];
            kTag.IntValue0 = kTechTree.GetResearchCredit(EResearchCredits(I)).iBonus;
            kSummary.txtSummary.StrValue $= "\n" $ class'XComLocalizer'.static.ExpandString(m_strResearchCreditApplies);
        }
    }

    kSummary.txtProgress = LABS().GetProgressText(LABS().GetProgress(kTech.iTechId));
    kSummary.txtProgress.strLabel = m_strProgressLabel;
    kSummary.txtProgress.StrValue $= " (" $ LABS().GetEstimateString(kTech.iTechId) $ ")";

    kSummary.txtRequirementsLabel.StrValue = m_strCostLabel;
    kSummary.txtRequirementsLabel.iState = eUIState_Warning;

    kCost = class'LWCETypes'.static.ConvertTCostToTResearchCost(kTech.kCost);
    kSummary.bCanAfford = LABS().GetCostSummary(kSummary.kCost, kCost);

    return kSummary;
}

function OnChooseArchive(int iArchive)
{
    m_bViewingArchives = true;
    m_iCEReportTech = m_kCEArchives.arrTechs[iArchive];
    UpdateReport();
}

function OnLeaveLabs()
{
    PRES().PopState();
    `LWCE_LABS.m_iCELastResearched = 0;
}

function OnLeaveReport(bool bJumpToChooseTech)
{
    local LWCE_XGFacility_Labs kLabs;
    local int iUnlock;

    kLabs = `LWCE_LABS;
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
            if (kLabs.m_arrUnlockedItems[iUnlock] == 255)
            {
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

        for (iUnlock = 0; iUnlock < kLabs.m_arrCEUnlockedFoundryProjects.Length; iUnlock++)
        {
            LWCE_UnlockFoundryProject(kLabs.m_arrCEUnlockedFoundryProjects[iUnlock]);
        }

        kLabs.m_arrCEUnlockedFoundryProjects.Remove(0, kLabs.m_arrCEUnlockedFoundryProjects.Length);
    }
    else
    {
        GoToView(eLabView_Archives);
    }
}

function bool OnTechTableOption(int iOption)
{
    local array<LWCE_TTech> arrTechs;

    if (m_iCurrentView == eLabView_CreditArchives)
    {
        return false;
    }

    if (m_kTechTable.mnuTechs.arrOptions[iOption].iState == eUIState_Disabled)
    {
        Sound().PlaySFX(SNDLIB().SFX_UI_No);
        return false;
    }

    `LWCE_LABS.LWCE_GetAvailableTechs(arrTechs);
    arrTechs.Sort(LWCE_SortTechs);

    GoToView(eLabView_MainMenu);

    LABS().SetNewProject(arrTechs[iOption].iTechId);
    Sound().PlaySFX(SNDLIB().SFX_UI_TechStarted);

    UpdateHeader();
    UpdateMainMenu();

    return true;
}

function int LWCE_SortTechs(LWCE_TTech kTech1, LWCE_TTech kTech2)
{
    local int iTech1, iTech2;
    local bool bBioTech1, bBioTech2, bPriority1, bPriority2;
    local XGFacility_Labs kLabs;

    kLabs = LABS();
    iTech1 = kTech1.iTechId;
    iTech2 = kTech2.iTechId;
    bPriority1 = kLabs.IsPriorityTech(iTech1);
    bPriority2 = kLabs.IsPriorityTech(iTech2);
    bBioTech1 = kLabs.IsAutopsyTech(iTech1) || kLabs.IsInterrogationTech(iTech1);
    bBioTech2 = kLabs.IsAutopsyTech(iTech2) || kLabs.IsInterrogationTech(iTech2);

    if (bPriority1)
    {
        if (bPriority2)
        {
            if (iTech2 < iTech1)
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (bPriority2)
        {
            return -1;
        }
        else
        {
            if (bBioTech1)
            {
                if (bBioTech2)
                {
                    if (iTech1 < iTech2)
                    {
                        return 0;
                    }
                    else
                    {
                        return -1;
                    }
                }
                else
                {
                    return -1;
                }
            }
            else
            {
                if (bBioTech2)
                {
                    return 0;
                }
                else
                {
                    if (kTech1.iHours < kTech2.iHours)
                    {
                        return 0;
                    }
                    else
                    {
                        if (kTech1.iHours > kTech2.iHours)
                        {
                            return -1;
                        }
                        else
                        {
                            if (iTech1 < iTech2)
                            {
                                return 0;
                            }
                            else
                            {
                                return -1;
                            }
                        }
                    }
                }
            }
        }
    }
}

function bool LWCE_UnlockFoundryProject(int iProject)
{
    local TItemUnlock kUnlock;

    if (!LWCE_XGStrategy(Game()).LWCE_UnlockFoundryProject(iProject, kUnlock))
    {
        return false;
    }
    else
    {
        PRES().UIItemUnlock(kUnlock);
    }

    return true;
}

function UpdateArchives()
{
    local int Index;
    local LWCE_TTech kTech;
    local LWCE_TLabArchivesUI kUI;
    local TMenuOption kOption;
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;
    kUI.mnuArchives.strLabel = m_strLabelArchives;

    for (Index = 0; Index < kLabs.m_arrResearched.Length; Index++)
    {
        kTech = `LWCE_TECH(kLabs.m_arrResearched[Index]);

        // Skip the Sectoid Commander Autopsy until the Sectoid Autopsy research comes up; this is a hack used in
        // the base game to make the autopsies appear next to each other in the list, since their IDs aren't consecutive
        if (kTech.iTechId == `LW_TECH_ID(SectoidCommanderAutopsy))
        {
            continue;
        }

        kUI.arrTechs.AddItem(kTech.iTechId);

        kOption.strText = kTech.strName;
        kUI.mnuArchives.arrOptions.AddItem(kOption);

        if (kTech.iTechId == `LW_TECH_ID(SectoidAutopsy) && LABS().IsResearched(`LW_TECH_ID(SectoidCommanderAutopsy)))
        {
            kUI.arrTechs.AddItem(`LW_TECH_ID(SectoidCommanderAutopsy));

            kOption.strText = `LWCE_TECH(`LW_TECH_ID(SectoidCommanderAutopsy)).strName;
            kUI.mnuArchives.arrOptions.AddItem(kOption);
        }
    }

    m_kCEArchives = kUI;
}

function UpdateHeader()
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_TTech kTech;
    local TLabHeader kHeader;

    kLabs = `LWCE_LABS;

    kHeader.arrResources.AddItem(GetResourceText(eResource_Scientists));
    kHeader.bDrawTech = kLabs.m_kProject.iTech != 0;
    kHeader.txtTitle.StrValue = m_strCurrentResearchTitle;

    if (kHeader.bDrawTech)
    {
        kTech = kLabs.LWCE_GetCurrentTechTemplate();

        kHeader.imgTech.strPath = kTech.ImagePath;
        kHeader.fProgress = float(kTech.iHours - kLabs.m_kProject.iActualHoursLeft) / float(kTech.iHours);
        kHeader.txtProject.StrValue = kTech.strName;
        kHeader.txtProject.iState = eUIState_Highlight;
        kHeader.txtETA = kLabs.GetCurrentProgressText();
    }
    else
    {
        kHeader.txtTitle.StrValue = m_strNoCurrentResearchTitle;
        kHeader.imgTech.iImage = 0;
    }

    m_kHeader = kHeader;
}

function UpdateMainMenu()
{
    local LWCE_XGFacility_Labs kLabs;
    local TMenuOption kOption;
    local TMenu kMainMenu;
    local int iMenuOption;

    kLabs = `LWCE_LABS;

    m_kMainMenu.arrViews.Remove(0, m_kMainMenu.arrViews.Length);
    m_kMainMenu.arrViews.AddItem(eLabView_ChooseTech);
    m_kMainMenu.arrViews.AddItem(eLabView_Archives);

    if (HQ().HasFacility(eFacility_GeneticsLab))
    {
        m_kMainMenu.arrViews.AddItem(eLabView_GeneLab);
    }

    if (kLabs.NumKnownResearchCredits() > 0)
    {
        m_kMainMenu.arrViews.AddItem(eLabView_CreditArchives);
    }

    for (iMenuOption = 0; iMenuOption < m_kMainMenu.arrViews.Length; iMenuOption++)
    {
        if (m_kMainMenu.arrViews[iMenuOption] == eLabView_ChooseTech)
        {
            kOption.iState = eUIState_Normal;

            if (kLabs.LWCE_GetCurrentTech().iTechId != 0)
            {
                if (ISCONTROLLED() && !kLabs.IsResearched(`LW_TECH_ID(Xenobiology)))
                {
                    kOption.iState = eUIState_Disabled;
                }

                kOption.strText = m_strLabelChangeProject;
                kOption.strHelp = m_strHelpChangeProject;
            }
            else
            {
                kOption.strText = m_strLabelNewProject;
                kOption.strHelp = m_strHelpNewProject;
            }

            if (!kLabs.HasTechsAvailable())
            {
                kOption.iState = eUIState_Disabled;
                kOption.strHelp = m_strHelpNoProjects;
            }
        }
        else if (m_kMainMenu.arrViews[iMenuOption] == eLabView_Archives)
        {
            // LWCE issue #6: in the base game this conditional is "> 1", meaning you can't view the archives
            // until you've done multiple researches
            kOption.iState = kLabs.GetNumTechsResearched() > 0 ? eUIState_Normal : eUIState_Disabled;
            kOption.strText = m_strLabelResearchArchives;
            kOption.strHelp = m_strHelpResearchArchives;
        }
        else if (m_kMainMenu.arrViews[iMenuOption] == eLabView_CreditArchives)
        {
            kOption.iState = eUIState_Normal;
            kOption.strText = m_strLabelCreditArchives;
            kOption.strHelp = m_strHelpCreditArchives;
        }
        else if (m_kMainMenu.arrViews[iMenuOption] == eLabView_GeneLab)
        {
            kOption.iState = eUIState_Normal;
            kOption.strText = m_strLabelGeneLab;
            kOption.strHelp = m_strHelpGeneLab;
        }
        else
        {
            continue;
        }

        kMainMenu.arrOptions.AddItem(kOption);
    }

    m_kMainMenu.mnuOptions = kMainMenu;
}

function UpdateReport()
{
    local TResearchReport kReport;
    local LWCE_TTech kTech;
    local array<int> arrResults;
    local int iCredit, iProgressIndex, iResult, iSampleItemid;
    local XGParamTag kTag;
    local XGDateTime kDateTime;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;

    // This function is largely similar to the original version, with LWCE-incompatible functions replaced
    // with their LWCE equivalents, but note that the kReport.eItemCard and kReport.eCharCard fields are not
    // populated. This is because they are never read, and would need to be replaced with int types.

    kLabs = `LWCE_LABS;
    kTechTree = `LWCE_TECHTREE;
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTech = `LWCE_TECH(m_iCEReportTech);

    iProgressIndex = kLabs.m_arrCEProgress.Find('iTechId', m_iCEReportTech);
    if (iProgressIndex >= 0 && kLabs.m_arrCEProgress[iProgressIndex].kCompletionTime != none)
    {
        kDateTime = kLabs.m_arrCEProgress[iProgressIndex].kCompletionTime;
    }
    else
    {
        kDateTime = GEOSCAPE().m_kDateTime;
    }

    kReport.imgBG.iImage = eImage_OldResearch;
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
    kReport.imgProject.strPath = kTech.ImagePath;
    kReport.txtNotesLabel.StrValue = m_strLabelProjectNotes;
    kReport.txtNotesLabel.iState = eUIState_Highlight;
    kReport.txtNotes.StrValue = kTech.strReport;

    if (kTech.strCustom != "")
    {
        kReport.txtResults.Add(1);
        kReport.txtResults[0].StrValue = kTech.strCustom;
        kReport.txtResults[0].iState = eUIState_Warning;
    }

    arrResults = kTechTree.GetFacilityResults(m_iCEReportTech);

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

    arrResults = kTechTree.GetItemResults(m_iCEReportTech);

    if (arrResults.Length > 0)
    {
        for (iResult = 0; iResult < arrResults.Length; iResult++)
        {
            if (ITEMTREE().CanBeBuilt(arrResults[iResult]) || ITEMTREE().IsMecArmor(arrResults[iResult]))
            {
                kTag.StrValue0 = `LWCE_ITEM(arrResults[iResult]).strName;
                kReport.txtResults.Add(1);
                kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strItemBuildAvailable);
                kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
                kLabs.m_arrCEUnlockedItems.AddItem(arrResults[iResult]);
            }
        }

        iSampleItemid = arrResults[0];
    }

    arrResults = kTechTree.LWCE_GetGeneResults(m_iCEReportTech);

    for (iResult = 0; iResult < arrResults.Length; iResult++)
    {
        kTag.StrValue0 = TECHTREE().GetGeneTech(EGeneModTech(arrResults[iResult])).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strGeneModAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrUnlockedGeneMods.AddItem(EGeneModTech(arrResults[iResult]));
    }

    if (kTech.iTechId == `LW_TECH_ID(Xenogenetics))
    {
        kTag.StrValue0 = string(40);
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strBonusMeld);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
    }

    arrResults = kTechTree.LWCE_GetFoundryResults(m_iCEReportTech);

    for (iResult = 0; iResult < arrResults.Length; iResult++)
    {
        kTag.StrValue0 = `LWCE_FTECH(arrResults[iResult]).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strFoundryBuildAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrCEUnlockedFoundryProjects.AddItem(arrResults[iResult]);
    }

    iCredit = kTechTree.LWCE_GetTech(m_iCEReportTech).iCreditGranted;

    if (iCredit != 0)
    {
        kTag.StrValue0 = class'XGLocalizedData'.default.ResearchCreditNames[iCredit];
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strResearchCreditEarned);
        kReport.txtResults[0].iState = eUIState_Good;
    }

    if (kLabs.IsAutopsyTech(m_iCEReportTech))
    {
        kReport.btxtInfo.iButton = 3;
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ TACTICAL().GetTCharacter(kTech.iSubjectCharacterId).strName;
    }
    else if (iSampleItemid != 0)
    {
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ `LWCE_ITEM(iSampleItemid).strName;
    }

    m_kReport = kReport;
}

function UpdateTechTable()
{
    local LWCE_XGFacility_Labs kLabs;
    local array<LWCE_TTech> arrTechs;
    local LWCE_TTech kTech;
    local TTechTable kTable;
    local TTableMenuOption kOption;
    local TTechSummary kSummary;

    kLabs = `LWCE_LABS;

    kTable.mnuTechs.arrCategories.AddItem(1);
    kTable.mnuTechs.kHeader.arrStrings = GetHeaderStrings(kTable.mnuTechs.arrCategories);
    kTable.mnuTechs.kHeader.arrStates = GetHeaderStates(kTable.mnuTechs.arrCategories);
    kTable.iRecommendedTech = -1;

    kLabs.LWCE_GetAvailableTechs(arrTechs);
    arrTechs.Sort(LWCE_SortTechs);

    foreach arrTechs(kTech)
    {
        kOption = LWCE_BuildTechOption(kTech, kTable.mnuTechs.arrCategories, kLabs.IsPriorityTech(kTech.iTechId));
        kSummary = LWCE_BuildTechSummary(kTech);

        if (!kSummary.bCanAfford)
        {
            kOption.strHelp = kSummary.kCost.strHelp;
            kOption.iState = eUIState_Disabled;
        }

        kTable.mnuTechs.arrOptions.AddItem(kOption);
        kTable.arrTechSummaries.AddItem(kSummary);
    }

    m_kTechTable = kTable;
}

function UpdateView()
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;

    switch (m_iCurrentView)
    {
        case eLabView_MainMenu:
            UpdateHeader();
            UpdateMainMenu();
            break;
        case eLabView_ChooseTech:
            UpdateHeader();
            UpdateTechTable();
            break;
        case eLabView_Archives:
        case eLabView_Report:
            UpdateArchives();
            UpdateReport();
            break;
        case eLabView_CreditArchives:
            UpdateCreditArchives();
            break;
        case eLabView_GeneLab:
            Narrative(`XComNarrativeMomentEW("GeneticsLabComplete"));
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (`HQPRES.m_bIsShuttling)
    {
        return;
    }

    if (!ISCONTROLLED() && m_iCurrentView == eLabView_MainMenu)
    {
        if (Narrative(`XComNarrativeMoment("FirstLabs")))
        {
            return;
        }

        if (!HQ().HasFacility(eFacility_AlienContain) && kLabs.IsResearched(`LW_TECH_ID(Xenoneurology)) && kLabs.m_iCELastResearched != `LW_TECH_ID(Xenoneurology) && !ENGINEERING().IsBuildingFacility(eFacility_AlienContain))
        {
            if (Narrative(`XComNarrativeMoment("UrgeContainment")))
            {
                return;
            }
        }

        if (kLabs.IsInterrogationTechAvailable() && !kLabs.HasInterrogatedCaptive())
        {
            if (Narrative(`XComNarrativeMoment("UrgeInterrogation")))
            {
                return;
            }
        }

        if (HQ().HasFacility(eFacility_AlienContain) && `LWCE_STORAGE.GetNumItemsAvailable(`LW_ITEM_ID(ArcThrower)) > 0 && !STORAGE().HasAlienCaptive())
        {
            if (Narrative(`XComNarrativeMoment("UrgeCaptive")))
            {
                return;
            }
        }

        if (kLabs.IsResearched(`LW_TECH_ID(AlienOperations)) && !STORAGE().EverHadItem(`LW_ITEM_ID(HyperwaveBeacon)))
        {
            if (Narrative(`XComNarrativeMoment("AlienBaseDetected_LeadOut_CS")))
            {
                return;
            }
        }

        if (Game().GetNumMissionsTaken(eMission_TerrorSite) > 0)
        {
            if (Narrative(`XComNarrativeMoment("FirstTerrorMission_LeadOut_CS")))
            {
                return;
            }
        }

        if (HQ().HasFacility(eFacility_HyperwaveRadar) && !HQ().m_kMC.m_bDetectedOverseer)
        {
            if (Narrative(`XComNarrativeMoment("HyperwaveBeaconConstructed")))
            {
                return;
            }
        }

        if (kLabs.HasInterrogatedCaptive() && !STORAGE().EverHadItem(`LW_ITEM_ID(OutsiderShard)))
        {
            if (Narrative(`XComNarrativeMoment("PostInterrogation_LeadOut_CS")))
            {
                return;
            }
        }

        if (BARRACKS().GetNumPsiSoldiers() > 0)
        {
            if (Narrative(`XComNarrativeMoment("PsionicsDiscovered_LeadOut_CS")))
            {
                return;
            }
        }

        if (kLabs.m_bNagExplosives && --kLabs.m_iExplosiveNags > 0)
        {
            kLabs.m_bNagExplosives = false;

            if (Narrative(`XComNarrativeMoment("NagExplosives")))
            {
                return;
            }
        }

        if (kLabs.m_bGivenScientists)
        {
            kLabs.m_bGivenScientists = false;
            kLabs.ResetRequestCounter();

            if (Narrative(`XComNarrativeMoment("LabsHasScientists")))
            {
                return;
            }
        }

        if (kLabs.NeedsScientists())
        {
            kLabs.m_bNeedsScientists = false;

            if (Narrative(`XComNarrativeMoment("LabsNeedScientists")))
            {
                return;
            }
        }

        if (STORAGE().GetResource(eResource_Meld) > 150 && !HQ().m_bUrgedEWFacility)
        {
            if (!HQ().HasFacility(eFacility_CyberneticsLab) && !HQ().HasFacility(eFacility_GeneticsLab) && !ENGINEERING().IsBuildingFacility(eFacility_CyberneticsLab) && !ENGINEERING().IsBuildingFacility(eFacility_GeneticsLab))
            {
                if (Narrative(`XComNarrativeMoment("Urge_LabFacility")))
                {
                    HQ().m_bUrgedEWFacility = true;
                    return;
                }
            }
        }

        if (GENELABS() != none && GENELABS().UrgeGeneMod())
        {
            if (Narrative(`XComNarrativeMomentEW("Urge_GeneMod")))
            {
                return;
            }
        }
    }
    else if (m_iCurrentView == eLabView_Report && !m_bViewingArchives)
    {
        if (kLabs.m_iCELastResearched == `LW_TECH_ID(Xenobiology))
        {
            PRES().UIObjectiveDisplay(eObj_CaptureAlien);
        }
        else if (kLabs.IsInterrogationTech(kLabs.m_iCELastResearched) && OBJECTIVES().m_eObjective == eObj_CaptureAlien)
        {
            PRES().UIObjectiveDisplay(eObj_CaptureOutsider);
        }
        else if (kLabs.m_iCELastResearched == `LW_TECH_ID(AlienOperations))
        {
            PRES().UIObjectiveDisplay(eObj_ObtainShards);
        }

        if (kLabs.m_iCELastResearched == `LW_TECH_ID(AlienOperations))
        {
            Narrative(`XComNarrativeMoment("AlienCodeRevealed_LeadOut_CS"));
        }
    }
}