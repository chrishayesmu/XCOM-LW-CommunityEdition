class LWCE_XGResearchUI extends XGResearchUI;

struct LWCE_TLabArchivesUI
{
    var TMenu mnuArchives;
    var array<name> arrTechs;
};

var name m_nmCEReportTech;
var LWCE_TLabArchivesUI m_kCEArchives;

function Init(int iView)
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;

    if (kLabs.m_nmLastResearchedTech != '')
    {
        m_nmCEReportTech = kLabs.m_nmLastResearchedTech;
        GoToView(eLabView_Report);
    }
    else
    {
        GoToView(iView);
    }
}

function TTableMenuOption LWCE_BuildTechOption(LWCETechTemplate kTech, array<int> arrCategories, bool bPriority)
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

function TTechSummary LWCE_BuildTechSummary(LWCETechTemplate kTech)
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;
    local LWCE_TProjectCost kProjectCost;
    local TTechSummary kSummary;
    local XGParamTag kTag;
    local int Index;
    local name CreditName;

    kLabs = `LWCE_LABS;
    kTechTree = `LWCE_TECHTREE;

    kSummary.imgItem.strPath = kTech.ImagePath;
    kSummary.txtTitle.StrValue = "<b>" $ kTech.strName $ "</b>";
    kSummary.txtTitle.iState = eUIState_Highlight;
    kSummary.txtSummary.StrValue = kTech.strSummary;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    for (Index = 0; Index < kTech.arrCreditsApplied.Length; Index++)
    {
        CreditName = kTech.arrCreditsApplied[Index];

        if (kLabs.LWCE_HasResearchCredit(CreditName))
        {
            kTag.StrValue0 = `LWCE_UTILS.GetResearchCreditFriendlyName(CreditName);
            kTag.IntValue0 = kTechTree.LWCE_GetResearchCredit(CreditName).iBonus;
            kSummary.txtSummary.StrValue $= "\n" $ class'XComLocalizer'.static.ExpandString(m_strResearchCreditApplies);
        }
    }

    kSummary.txtProgress = kLabs.GetProgressText(kLabs.LWCE_GetProgress(kTech.GetTechName()));
    kSummary.txtProgress.strLabel = m_strProgressLabel;
    kSummary.txtProgress.StrValue $= " (" $ KLabs.LWCE_GetEstimateString(kTech.GetTechName()) $ ")";

    kSummary.txtRequirementsLabel.StrValue = m_strCostLabel;
    kSummary.txtRequirementsLabel.iState = eUIState_Warning;

    kProjectCost.kCost = kTech.GetCost();
    kSummary.bCanAfford = kLabs.LWCE_GetCostSummary(kSummary.kCost, kProjectCost);

    return kSummary;
}

function OnChooseArchive(int iArchive)
{
    m_bViewingArchives = true;
    m_nmCEReportTech = m_kCEArchives.arrTechs[iArchive];
    UpdateReport();
}

function OnLeaveLabs()
{
    PRES().PopState();
    `LWCE_LABS.m_nmLastResearchedTech = '';
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

        for (iUnlock = 0; iUnlock < kLabs.m_arrUnlockedGeneMods.Length; iUnlock++)
        {
            UnlockGeneMod(kLabs.m_arrUnlockedGeneMods[iUnlock]);
        }

        kLabs.m_arrUnlockedGeneMods.Remove(0, kLabs.m_arrUnlockedGeneMods.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrCEUnlockedItems.Length; iUnlock++)
        {
            class'LWCE_XGScreenMgr_Extensions'.static.UnlockItem(kLabs.m_arrCEUnlockedItems[iUnlock]);
        }

        kLabs.m_arrCEUnlockedItems.Remove(0, kLabs.m_arrCEUnlockedItems.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrCEUnlockedFacilities.Length; iUnlock++)
        {
            class'LWCE_XGScreenMgr_Extensions'.static.UnlockFacility(kLabs.m_arrCEUnlockedFacilities[iUnlock]);
        }

        kLabs.m_arrCEUnlockedFacilities.Remove(0, kLabs.m_arrCEUnlockedFacilities.Length);

        for (iUnlock = 0; iUnlock < kLabs.m_arrCEUnlockedFoundryProjects.Length; iUnlock++)
        {
            class'LWCE_XGScreenMgr_Extensions'.static.UnlockFoundryProject(kLabs.m_arrCEUnlockedFoundryProjects[iUnlock]);
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
    local array<LWCETechTemplate> arrTechs;

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

    `LWCE_LABS.LWCE_SetNewProject(arrTechs[iOption].GetTechName());
    Sound().PlaySFX(SNDLIB().SFX_UI_TechStarted);

    UpdateHeader();
    UpdateMainMenu();

    return true;
}

function int LWCE_SortTechs(LWCETechTemplate kTech1, LWCETechTemplate kTech2)
{
    local int iPoints1, iPoints2;
    local string strTech1, strTech2;
    local bool bBioTech1, bBioTech2, bPriority1, bPriority2;
    local LWCE_XGFacility_Labs kLabs;

    kLabs = LWCE_XGFacility_Labs(LABS());
    iPoints1 = kTech1.GetPointsToComplete();
    iPoints2 = kTech2.GetPointsToComplete();
    strTech1 = kTech1.strName;
    strTech2 = kTech2.strName;
    bPriority1 = kLabs.LWCE_IsPriorityTech(kTech1.DataName);
    bPriority2 = kLabs.LWCE_IsPriorityTech(kTech2.DataName);
    bBioTech1 = kLabs.LWCE_IsAutopsyTech(kTech1.DataName) || kLabs.LWCE_IsInterrogationTech(kTech1.DataName);
    bBioTech2 = kLabs.LWCE_IsAutopsyTech(kTech2.DataName) || kLabs.LWCE_IsInterrogationTech(kTech2.DataName);

    if (bPriority1)
    {
        if (bPriority2)
        {
            if (strTech2 < strTech1)
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
                    if (strTech1 < strTech2)
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
                    if (iPoints1 < iPoints2)
                    {
                        return 0;
                    }
                    else
                    {
                        if (iPoints1 > iPoints2)
                        {
                            return -1;
                        }
                        else
                        {
                            if (strTech1 < strTech2)
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

function UpdateArchives()
{
    local int Index;
    local LWCETechTemplate kTech;
    local LWCE_TLabArchivesUI kUI;
    local TMenuOption kOption;
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;
    kUI.mnuArchives.strLabel = m_strLabelArchives;

    for (Index = 0; Index < kLabs.m_arrCEResearched.Length; Index++)
    {
        kTech = `LWCE_TECH(kLabs.m_arrCEResearched[Index]);

        kUI.arrTechs.AddItem(kTech.GetTechName());

        kOption.strText = kTech.strName;
        kUI.mnuArchives.arrOptions.AddItem(kOption);
    }

    m_kCEArchives = kUI;
}

function UpdateHeader()
{
    local int iBasePointsToComplete;
    local LWCE_XGFacility_Labs kLabs;
    local LWCETechTemplate kTech;
    local TLabHeader kHeader;

    kLabs = `LWCE_LABS;

    kHeader.arrResources.AddItem(GetResourceText(eResource_Scientists));
    kHeader.bDrawTech = kLabs.m_kCEProject.TechName != '';
    kHeader.txtTitle.StrValue = m_strCurrentResearchTitle;

    if (kHeader.bDrawTech)
    {
        kTech = kLabs.LWCE_GetCurrentTech();

        iBasePointsToComplete = kTech.GetPointsToComplete(/* bIncludeTimeSpent */ false);

        kHeader.imgTech.strPath = kTech.ImagePath;
        kHeader.fProgress = float(iBasePointsToComplete - kLabs.m_kCEProject.iActualHoursLeft) / float(iBasePointsToComplete);
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

    if (LWCE_XGHeadquarters(HQ()).LWCE_HasFacility('Facility_GeneticsLab'))
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

            if (kLabs.LWCE_GetCurrentTech() != none && kLabs.LWCE_GetCurrentTech().GetTechName() != '')
            {
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
    local LWCEItemTemplate kItem;
    local LWCETechTemplate kTech;
    local array<name> arrNameResults;
    local array<int> arrResults;
    local name SampleItemName;
    local int iProgressIndex, Index;
    local XGParamTag kTag;
    local XGDateTime kDateTime;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;

    // This function is largely similar to the original version, with LWCE-incompatible functions replaced
    // with their LWCE equivalents, but note that the kReport.eItemCard and kReport.eCharCard fields are not
    // populated. This is because they are never read, and would need to be replaced with int types.

    kLabs = `LWCE_LABS;
    kTechTree = LWCE_XGTechTree(TECHTREE());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTech = `LWCE_TECH(m_nmCEReportTech);

    if (KTech == none)
    {
        return;
    }

    iProgressIndex = kLabs.m_arrCEProgress.Find('TechName', m_nmCEReportTech);

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

    arrNameResults = kTechTree.LWCE_GetFacilityResults(m_nmCEReportTech);

    if (arrNameResults.Length > 0)
    {
        for (Index = 0; Index < arrNameResults.Length; Index++)
        {
            kTag.StrValue0 = `LWCE_FACILITY(arrNameResults[Index]).strName;
            kReport.txtResults.Add(1);
            kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strFacilityBuildAvailable);
            kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;

            kLabs.m_arrCEUnlockedFacilities.AddItem(arrNameResults[Index]);
        }
    }

    arrNameResults = kTechTree.LWCE_GetItemResults(m_nmCEReportTech);

    if (arrNameResults.Length > 0)
    {
        for (Index = 0; Index < arrNameResults.Length; Index++)
        {
            kItem = `LWCE_ITEM(arrNameResults[Index]);

            if (kItem.CanBeBuilt() || kItem.IsMecArmor())
            {
                kTag.StrValue0 = kItem.strName;

                kReport.txtResults.Add(1);
                kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strItemBuildAvailable);
                kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;

                kLabs.m_arrCEUnlockedItems.AddItem(arrNameResults[Index]);
            }
        }

        SampleItemName = arrNameResults[0];
    }

    arrResults = kTechTree.LWCE_GetGeneResults(m_nmCEReportTech);

    for (Index = 0; Index < arrResults.Length; Index++)
    {
        kTag.StrValue0 = TECHTREE().GetGeneTech(EGeneModTech(arrResults[Index])).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strGeneModAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrUnlockedGeneMods.AddItem(EGeneModTech(arrResults[Index]));
    }

    if (kTech.GetTechName() == 'Tech_Xenogenetics')
    {
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = m_strBonusMeld;
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
    }

    arrNameResults = kTechTree.LWCE_GetFoundryResults(m_nmCEReportTech);

    for (Index = 0; Index < arrNameResults.Length; Index++)
    {
        kTag.StrValue0 = `LWCE_FTECH(arrNameResults[Index]).strName;
        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strFoundryBuildAvailable);
        kReport.txtResults[kReport.txtResults.Length - 1].iState = eUIState_Warning;
        kLabs.m_arrCEUnlockedFoundryProjects.AddItem(arrNameResults[Index]);
    }

    arrNameResults = `LWCE_TECH(m_nmCEReportTech).arrCreditsGranted;

    if (arrNameResults.Length > 0)
    {
        kTag.StrValue0 = "";

        for (Index = 0; Index < arrNameResults.Length; Index++)
        {
            kTag.StrValue0 $= `LWCE_UTILS.GetResearchCreditFriendlyName(arrNameResults[Index]);

            if (Index != arrNameResults.Length - 1)
            {
                kTag.StrValue0 $= ", ";
            }
        }

        kReport.txtResults.Add(1);
        kReport.txtResults[kReport.txtResults.Length - 1].StrValue = class'XComLocalizer'.static.ExpandString(m_strResearchCreditEarned);
        kReport.txtResults[0].iState = eUIState_Good;
    }

    if (kLabs.LWCE_IsAutopsyTech(m_nmCEReportTech))
    {
        kReport.btxtInfo.iButton = 3;
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ TACTICAL().GetTCharacter(kTech.iSubjectCharacterId).strName;
    }
    else if (SampleItemName != '')
    {
        kReport.btxtInfo.StrValue = m_strLabelTacticalSummary @ `LWCE_ITEM(SampleItemName).strName;
    }

    m_kReport = kReport;
}

function UpdateTechTable()
{
    local LWCE_XGFacility_Labs kLabs;
    local array<LWCETechTemplate> arrTechs;
    local LWCETechTemplate kTech;
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
        kOption = LWCE_BuildTechOption(kTech, kTable.mnuTechs.arrCategories, kLabs.LWCE_IsPriorityTech(kTech.GetTechName()));
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
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;

    kHQ = LWCE_XGHeadquarters(HQ());
    kLabs = LWCE_XGFacility_Labs(LABS());
    kStorage = LWCE_XGStorage(STORAGE());

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

    if (m_iCurrentView == eLabView_MainMenu)
    {
        if (Narrative(`XComNarrativeMoment("FirstLabs")))
        {
            return;
        }

        if (!kHQ.LWCE_HasFacility('Facility_AlienContainment') && kLabs.LWCE_IsResearched('Tech_Xenoneurology') && kLabs.m_nmLastResearchedTech != 'Tech_Xenoneurology' && !ENGINEERING().IsBuildingFacility(eFacility_AlienContain))
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

        if (kHQ.LWCE_HasFacility('Facility_AlienContainment') && kStorage.LWCE_GetNumItemsAvailable('Item_ArcThrower') > 0 && !kStorage.HasAlienCaptive())
        {
            if (Narrative(`XComNarrativeMoment("UrgeCaptive")))
            {
                return;
            }
        }

        if (kLabs.LWCE_IsResearched('Tech_AlienOperations') && !kStorage.LWCE_EverHadItem('Item_HyperwaveBeacon'))
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

        if (kHQ.LWCE_HasFacility('Facility_HyperwaveRelay') && !HQ().m_kMC.m_bDetectedOverseer)
        {
            if (Narrative(`XComNarrativeMoment("HyperwaveBeaconConstructed")))
            {
                return;
            }
        }

        if (kLabs.HasInterrogatedCaptive() && !kStorage.LWCE_EverHadItem('Item_OutsiderShard'))
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

        if (kStorage.GetResource(eResource_Meld) > 150 && !HQ().m_bUrgedEWFacility)
        {
            if (!kHQ.LWCE_HasFacility('Facility_RepairBay') && !kHQ.LWCE_HasFacility('Facility_GeneticsLab') && !ENGINEERING().IsBuildingFacility(eFacility_CyberneticsLab) && !ENGINEERING().IsBuildingFacility(eFacility_GeneticsLab))
            {
                if (Narrative(`XComNarrativeMomentEW("Urge_LabFacility")))
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
        if (kLabs.m_nmLastResearchedTech == 'Tech_Xenobiology')
        {
            PRES().UIObjectiveDisplay(eObj_CaptureAlien);
        }
        else if (kLabs.LWCE_IsInterrogationTech(kLabs.m_nmLastResearchedTech) && OBJECTIVES().m_eObjective == eObj_CaptureAlien)
        {
            PRES().UIObjectiveDisplay(eObj_CaptureOutsider);
        }
        else if (kLabs.m_nmLastResearchedTech == 'Tech_AlienOperations')
        {
            PRES().UIObjectiveDisplay(eObj_ObtainShards);
        }

        if (kLabs.m_nmLastResearchedTech == 'Tech_AlienOperations')
        {
            Narrative(`XComNarrativeMoment("AlienCodeRevealed_LeadOut_CS"));
        }
    }
}