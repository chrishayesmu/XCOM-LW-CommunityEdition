class Highlander_XGFoundryUI extends XGFoundryUI
    dependson(HighlanderTypes);

var array<HL_TFoundryTech> m_arrHLTechs;

function TObjectSummary HL_BuildSummary(HL_TFoundryTech kFoundryTech)
{
    local TObjectSummary kSummary;
    local XGParamTag kTag;
    local int I;

    kSummary.imgObject.iImage = 0;
    kSummary.imgObject.strPath = kFoundryTech.ImagePath;
    kSummary.txtSummary.StrValue = kFoundryTech.strSummary;
    kSummary.txtRequirementsLabel.StrValue = m_strLabelProjectCost;

    if (ENGINEERING().IsFoundryTechResearched(kFoundryTech.iTechId))
    {
        kSummary.txtRequirementsLabel.StrValue = m_strLabelProjectCompleted;
        kSummary.txtRequirementsLabel.iState = eUIState_Good;
    }
    else
    {
        kSummary.bCanAfford = ENGINEERING().GetFoundryCostSummary(kSummary.kCost, kFoundryTech.iTechId, false, false);
        kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

        for (I = 0; I < 10; I++)
        {
            if (LABS().HasResearchCredit(EResearchCredits(I)) && Highlander_XGTechTree(TECHTREE()).HL_CreditAppliesToFoundryTech(I, kFoundryTech.iTechId))
            {
                kTag.StrValue0 = class'XGLocalizedData'.default.ResearchCreditNames[I];
                kTag.IntValue0 = TECHTREE().GetResearchCredit(EResearchCredits(I)).iBonus;
                kSummary.txtSummary.StrValue $= ("\\n" $ class'XComLocalizer'.static.ExpandString(m_strResearchCreditApplies));
            }
        }
    }

    return kSummary;
}

function TTableMenuOption HL_BuildTableItem(HL_TFoundryTech kFoundryTech)
{
    local TTableMenuOption kOption;

    kOption.arrStrings[0] = kFoundryTech.strName;
    kOption.arrStates[0] = eUIState_Normal;
    return kOption;
}

function UpdateTableMenu()
{
    local array<HL_TFoundryTech> arrCompletedTech;
    local TFoundryTable kTable;
    local TTableMenu kTableMenu;
    local TTableMenuOption kOption;
    local TObjectSummary kSummary;
    local int iMenuItem;

    kTableMenu.arrCategories.AddItem(2);
    m_arrHLTechs = Highlander_XGTechTree(TECHTREE()).HL_GetAvailableFoundryTechs();

    for (iMenuItem = 0; iMenuItem < m_arrHLTechs.Length; iMenuItem++)
    {
        kOption = HL_BuildTableItem(m_arrHLTechs[iMenuItem]);
        kSummary = HL_BuildSummary(m_arrHLTechs[iMenuItem]);

        if (!kSummary.bCanAfford)
        {
            kOption.strHelp = kSummary.kCost.strHelp;
            kOption.iState = eUIState_Bad;
        }

        kTableMenu.arrOptions.AddItem(kOption);
        kTable.arrSummaries.AddItem(kSummary);
    }

    arrCompletedTech = Highlander_XGTechTree(TECHTREE()).HL_GetCompletedFoundryTechs();

    for (iMenuItem = 0; iMenuItem < arrCompletedTech.Length; iMenuItem++)
    {
        kOption = HL_BuildTableItem(arrCompletedTech[iMenuItem]);
        kSummary = HL_BuildSummary(arrCompletedTech[iMenuItem]);

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

    if (iTableOption < m_arrHLTechs.Length)
    {
        PRES().UIManufactureFoundry(m_arrHLTechs[iTableOption].iTechId, -1);
        UpdateView();
    }
}