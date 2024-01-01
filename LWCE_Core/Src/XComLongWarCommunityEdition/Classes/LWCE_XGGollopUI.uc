class LWCE_XGGollopUI extends XGGollopUI;

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (kCESoldier.GetStatus() != eStatus_Active)
    {
        kOption.iState = eUIState_Disabled;
    }

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 0:
                strCategory = string(kCESoldier.m_kCESoldier.nmCountry);
                break;
            case 1:
                strCategory = string(kCESoldier.GetRank());
                break;
            case 2:
                strCategory = string(kCESoldier.GetEnergy());
                break;
            case 3:
                strCategory = kCESoldier.GetClassName();
                break;
            case 4:
                strCategory = kCESoldier.GetName(eNameType_Full);
                break;
            case 5:
                strCategory = kCESoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kCESoldier.GetName(eNameType_Nick);
                break;
            case 7:
                strCategory = kCESoldier.GetStatusString();
                iState = kCESoldier.GetStatusUIState();
                break;
            case 8:
                if (kCESoldier.HasAvailablePerksToAssign())
                {
                    iState = eUIState_Disabled;
                }

                break;
            case 9:
                if (kCESoldier.HasAvailablePerksToAssign(true))
                {
                    iState = eUIState_Disabled;
                }

                break;
            case 10:
                if (kCESoldier.m_kCEChar.bHasPsiGift)
                {
                    iState = eUIState_Disabled;
                }

                break;
            case 11:
                if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar))
                {
                    iState = eUIState_Disabled;
                }

                break;
            case 13:
                iState = -1;
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kCESoldier.m_arrMedals);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function GollopWarningCallback(EUIAction eAction)
{
    if (eAction == eUIAction_Accept)
    {
        GoToView(eGollopView_Choose);
        PRES().UISoldierList(class'LWCE_UISoldierList_Gollop');
    }

    UpdateView();
}