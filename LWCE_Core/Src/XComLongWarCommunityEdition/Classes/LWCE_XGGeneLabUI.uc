class LWCE_XGGeneLabUI extends XGGeneLabUI;

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int soldierListIndex)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (kCESoldier.GetStatus() != eStatus_Active || kCESoldier.IsAugmented() || kCESoldier.GetPsiRank() == 7)
    {
        kOption.iState = eUIState_Disabled;
    }
    else
    {
        kOption.iState = eUIState_Good;
    }

    if (IsOptionEnabled(eGO_MindHatesMatter) && kCESoldier.HasPsiGift())
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
                strCategory = kCESoldier.GetName(8);
                break;
            case 5:
                strCategory = kCESoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kCESoldier.GetName(eNameType_Nick);
                break;
            case 7:
                if (IsOptionEnabled(eGO_MindHatesMatter) && kCESoldier.HasPsiGift())
                {
                    strCategory = m_strPsiGiftedStatus;
                    iState = eUIState_Disabled;
                }
                else
                {
                    strCategory = kCESoldier.GetStatusString();
                    iState = kCESoldier.GetStatusUIState();
                }

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
                strCategory = string(soldierListIndex);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function OnChooseSlot(int iSlot)
{
    if (iSlot < GENELABS().m_arrPatients.Length)
    {
        PlayBadSound();
    }
    else
    {
        GoToView(eGeneLabView_Add);
        `HQPRES.UISoldierList(class'LWCE_UISoldierList_GeneLab');
        PlayGoodSound();
    }
}