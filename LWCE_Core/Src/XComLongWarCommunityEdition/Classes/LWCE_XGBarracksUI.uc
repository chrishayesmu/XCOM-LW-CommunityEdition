class LWCE_XGBarracksUI extends XGBarracksUI;

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int iSoldierListIndex)
{
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    if (m_iCurrentView == eBarracksView_SoldierListCovertOps && !kSoldier.IsAvailableForCovertOps())
    {
        kOption.iState = eUIState_Disabled;
    }
    else if (kSoldier.IsInjured())
    {
        kOption.iState = eUIState_Bad;
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
                strCategory = string(kSoldier.m_kSoldier.iCountry);
                break;
            case 1:
                strCategory = string(kSoldier.GetRank());
                break;
            case 2:
                strCategory = string(LWCE_XGStrategySoldier(kSoldier).m_kCEChar.iClassId);
                break;
            case 3:
                strCategory = kSoldier.GetClassName();
                break;
            case 4:
                if (kSoldier.GetRank() > 0)
                {
                    strCategory = kSoldier.GetName(ENameType(8));
                }
                else
                {
                    strCategory = kSoldier.GetName(ENameType(8));
                }
                break;
            case 5:
                strCategory = kSoldier.GetName(eNameType_First);
                break;
            case 6:
                strCategory = kSoldier.GetName(eNameType_Last);
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
                if (class'XComPerkManager'.static.HasAnyGeneMod(kSoldier.m_kChar.aUpgrades))
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

function UpdateView()
{
    local LWCE_XGFacility_PsiLabs kPsiLabs;

    kPsiLabs = `LWCE_PSILABS;

    switch (m_iCurrentView)
    {
        case eBarracksView_MainMenu:
            UpdateMainMenu();
            break;
        case eBarracksView_SoldierList:
            UpdateSoldierList(/* bHideTanks */ false);
            break;
        case eBarracksView_SoldierListCovertOps:
            UpdateSoldierList(/* bHideTanks */ true);
            break;
        case eBarracksView_Hire:
            UpdateHiring();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (kPsiLabs != none && kPsiLabs.m_arrCECompleted.Length > 0)
    {
        PRES().UIPsiLabs();
    }
    else if ((BARRACKS().GetNumAvailableSoldiers() + HQ().GetStaffOnOrder(eStaff_Soldier)) < 8)
    {
        if (BARRACKS().m_iMoreSoldiersCounter <= 0)
        {
            if (!ISCONTROLLED())
            {
                Narrative(`XComNarrativeMoment("BarracksNeedSoldiers"));
                BARRACKS().m_iMoreSoldiersCounter = 4;
            }
        }
    }

    if (m_iCurrentView == eBarracksView_MainMenu && BARRACKS().m_bNotifyPromotions && !PRES().m_bRecentlyPlayedPromotions)
    {
        Narrative(`XComNarrativeMoment("RoboHQ_NewPromotions"));
        BARRACKS().m_bNotifyPromotions = false;

        PRES().SetTimer(30.0, false, 'ClearPlayedPromotions');
        PRES().m_bRecentlyPlayedPromotions = true;
    }
}