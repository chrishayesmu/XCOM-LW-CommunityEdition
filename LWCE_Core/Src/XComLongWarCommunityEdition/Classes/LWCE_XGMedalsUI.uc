class LWCE_XGMedalsUI extends XGMedalsUI;

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int iSoldierListIndex)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (!BARRACKS().CanAwardMedalToSoldier(m_arrMainMenu[m_iCurrentMedal].Type, kCESoldier))
    {
        kOption.iState = eUIState_Disabled;
    }
    else
    {
        kOption.iState = eUIState_Good;
    }

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = 0;
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
                strCategory = kCESoldier.GetName(8);
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
                iState = kCESoldier.GetSHIVRank();
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kCESoldier.m_arrMedals);
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