class LWCE_XGFoundryUI extends XGFoundryUI
    dependson(LWCETypes);

var array<LWCEFoundryProjectTemplate> m_arrCEAvailableTechs;

function TObjectSummary LWCE_BuildSummary(LWCEFoundryProjectTemplate kFoundryTech)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;
    local TObjectSummary kSummary;
    local XGParamTag kTag;
    local int Index;
    local name CreditName;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kLabs = LWCE_XGFacility_Labs(LABS());
    kTechTree = LWCE_XGTechTree(TECHTREE());

    kSummary.imgObject.iImage = 0;
    kSummary.imgObject.strPath = kFoundryTech.ImagePath;
    kSummary.txtSummary.StrValue = kFoundryTech.strSummary;
    kSummary.txtRequirementsLabel.StrValue = m_strLabelProjectCost;

    if (kEngineering.LWCE_IsFoundryTechResearched(kFoundryTech.GetProjectName()))
    {
        kSummary.txtRequirementsLabel.StrValue = m_strLabelProjectCompleted;
        kSummary.txtRequirementsLabel.iState = eUIState_Good;
    }
    else
    {
        kSummary.bCanAfford = kEngineering.LWCE_GetFoundryCostSummary(kSummary.kCost, kFoundryTech.GetProjectName(), false, false);
        kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

        for (Index = 0; Index < kFoundryTech.arrCreditsApplied.Length; Index++)
        {
            CreditName = kFoundryTech.arrCreditsApplied[Index];

            if (kLabs.LWCE_HasResearchCredit(CreditName))
            {
                kTag.StrValue0 = `LWCE_UTILS.GetResearchCreditFriendlyName(CreditName);
                kTag.IntValue0 = kTechTree.LWCE_GetResearchCredit(CreditName).iBonus;
                kSummary.txtSummary.StrValue $= "\n" $ class'XComLocalizer'.static.ExpandString(m_strResearchCreditApplies);
            }
        }
    }

    return kSummary;
}

function TTableMenuOption LWCE_BuildTableItem(LWCEFoundryProjectTemplate kFoundryTech)
{
    local TTableMenuOption kOption;

    kOption.arrStrings[0] = kFoundryTech.strName;
    kOption.arrStates[0] = eUIState_Normal;
    return kOption;
}

function UpdateTableMenu()
{
    local array<LWCEFoundryProjectTemplate> arrCompletedTech;
    local LWCEFoundryProjectTemplate kTemplate;
    local TFoundryTable kTable;
    local TTableMenu kTableMenu;
    local TTableMenuOption kOption;
    local TObjectSummary kSummary;
    local int iMenuItem;

    m_arrCEAvailableTechs = LWCE_XGTechTree(TECHTREE()).LWCE_GetAvailableFoundryTechs();

    kTableMenu.arrCategories.AddItem(2);

    for (iMenuItem = 0; iMenuItem < m_arrCEAvailableTechs.Length; iMenuItem++)
    {
        kTemplate = m_arrCEAvailableTechs[iMenuItem];
        kOption = LWCE_BuildTableItem(kTemplate);
        kSummary = LWCE_BuildSummary(kTemplate);

        if (!kSummary.bCanAfford)
        {
            kOption.strHelp = kSummary.kCost.strHelp;
            kOption.iState = eUIState_Bad;
        }

        kTableMenu.arrOptions.AddItem(kOption);
        kTable.arrSummaries.AddItem(kSummary);
    }

    arrCompletedTech = LWCE_XGTechTree(TECHTREE()).LWCE_GetCompletedFoundryTechs();

    for (iMenuItem = 0; iMenuItem < arrCompletedTech.Length; iMenuItem++)
    {
        kOption = LWCE_BuildTableItem(arrCompletedTech[iMenuItem]);
        kSummary = LWCE_BuildSummary(arrCompletedTech[iMenuItem]);

        kOption.iState = eUIState_Disabled;
        kTableMenu.arrOptions.AddItem(kOption);

        kTable.arrSummaries.AddItem(kSummary);
    }

    kTableMenu.kHeader.arrStrings = GetHeaderStrings(kTableMenu.arrCategories);
    kTableMenu.kHeader.arrStates = GetHeaderStates(kTableMenu.arrCategories);
    kTableMenu.bTakesNoInput = false;
    kTable.mnuOptions = kTableMenu;
    m_kTable = kTable;
}

function PerformTableTransaction(int iTableOption)
{
    if (m_kTable.mnuOptions.arrOptions[iTableOption].iState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }

    if (iTableOption < m_arrCEAvailableTechs.Length)
    {
        `LWCE_HQPRES.LWCE_UIManufactureFoundry(m_arrCEAvailableTechs[iTableOption].GetProjectName(), -1);
        UpdateView();
    }
}