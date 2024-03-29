class LWCE_UISquadSelect_SquadList extends UISquadSelect_SquadList
    dependson(LWCE_XGChooseSquadUI);

var const localized string m_strPromotionAvailable;

simulated function UpdateData()
{
    local LWCE_XGChooseSquadUI kMgr;
    local UISquadList_UnitBox kOption;
    local int iSoldier, iOption, iDropShipIdx;
    local LWCE_TSoldierLoadout kLoadout;

    kMgr = LWCE_XGChooseSquadUI(UISquadSelect(screen).GetMgr());

    for (iOption = 0;iOption < m_arrUIOptions.Length; iOption++)
    {
        m_arrUIOptions[iOption].bEmpty = true;

        iDropShipIdx = m_arrFillOrderIndex.Find(iOption);
        m_arrUIOptions[iOption].bUnavailable = iDropShipIdx >= m_iMaxSlots;
    }

    if (LWCE_XGItemTree(kMgr.ITEMTREE()).LWCE_CanFacilityBeBuilt('Facility_OfficerTrainingSchool'))
    {
        m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots + 1]].bHint = true;
    }
    else if (LWCE_XGHeadquarters(kMgr.HQ()).LWCE_HasFacility('Facility_OfficerTrainingSchool'))
    {
        if (!kMgr.BARRACKS().HasOTSUpgrade(eOTS_SquadSize_I))
        {
            m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots + 1]].bHint = true;
        }

        if (!kMgr.BARRACKS().HasOTSUpgrade(eOTS_SquadSize_II))
        {
            m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots]].bHint = true;
        }
    }

    for (iSoldier = 0; iSoldier < kMgr.m_arrCESoldiers.Length; iSoldier++)
    {
        kLoadout = kMgr.m_arrCESoldiers[iSoldier];
        m_arrUIOptions[m_arrFillOrderIndex[kLoadout.iDropshipIndex]] = LWCE_CreateSoldierOption(kLoadout);
    }

    for (iOption = 0; iOption < m_arrUIOptions.Length; iOption++)
    {
        kOption = m_arrUIOptions[iOption];

        if (kOption.bEmpty)
        {
            kOption.iIndex = -1;
            kOption.iStatus = -1;
            kOption.strName = "";
            kOption.strNickName = "";
            kOption.classDesc = "";
            kOption.classLabel = "";
            kOption.item1 = "";
            kOption.item2 = "";
            kOption.bEmpty = true;
            m_arrUIOptions[iOption] = kOption;
        }
    }

    UpdateDisplay();
}

protected simulated function UISquadList_UnitBox LWCE_CreateSoldierOption(LWCE_TSoldierLoadout kLoadout)
{
    local int Index;
    local LWCE_XGFacility_Barracks kBarracks;
    local UISquadList_UnitBox kOption;

    kBarracks = LWCE_XGFacility_Barracks(UISquadSelect(screen).GetMgr().BARRACKS());

    kOption.iIndex = kLoadout.iDropshipIndex;
    kOption.strName = Caps(kLoadout.txtName.StrValue);
    kOption.strNickName = kLoadout.txtNickname.StrValue;
    kOption.iStatus = kLoadout.iUIStatus;
    kOption.classDesc = kLoadout.txtClass.StrValue;
    kOption.classLabel = kBarracks.GetClassIcon(kLoadout.ClassType, kLoadout.bHasGeneMod, kLoadout.bIsPsiSoldier);

    for (Index = 0; Index < kLoadout.arrLargeItems.Length; Index++)
    {
        if (kOption.item1 != "")
        {
            kOption.item1 $= "\n";
        }

        kOption.item1 $= `LWCE_ITEM(kLoadout.arrLargeItems[Index]).ImagePath;
    }

    for (Index = 0; Index < kLoadout.arrSmallItems.Length; Index++)
    {
        if (kOption.item1 != "")
        {
            kOption.item1 $= "\n";
        }

        kOption.item1 $= `LWCE_ITEM(kLoadout.arrSmallItems[Index]).ImagePath;
    }

    kOption.bPromote = kLoadout.bPromotable;
    kOption.bEmpty = false;
    return kOption;
}

simulated function UpdateDisplay()
{
    local int iCommanderIndex, iSlot;
    local string strDisplay;
    local XGShip_Dropship kSkyranger;
    local XGChooseSquadUI kMgr;

    Invoke("clear");

    kMgr = UISquadSelect(screen).GetMgr();
    kSkyranger = kMgr.m_kMission.GetAssignedSkyranger();
    iCommanderIndex = `LWCE_BARRACKS.GetCommandingSoldierIndex(kSkyranger);

    for (iSlot = 0; iSlot < m_arrUIOptions.Length; iSlot++)
    {
        if (!m_arrUIOptions[iSlot].bUnavailable)
        {
            if (!m_arrUIOptions[iSlot].bEmpty)
            {
                strDisplay = "<img src='img://Deployment.images." $ Mid("posdPos2pos8pos3pos5posspos7Pos1pos9pos4pos0pos6", iSlot * 4, 4) $ "' width='20' height='24' vspace='-5'>" $ m_arrUIOptions[iSlot].strName;

                AS_SetAddUnitText(iSlot, "", "", "");

                if (iCommanderIndex == m_arrFillOrderIndex.Find(iSlot))
                {
                    AS_SetUnitInfo(iSlot, 3, strDisplay, m_arrUIOptions[iSlot].strNickName, m_arrUIOptions[iSlot].classDesc, m_arrUIOptions[iSlot].classLabel, m_arrUIOptions[iSlot].item1, m_arrUIOptions[iSlot].item2, m_strPromote);
                }
                else if (m_arrUIOptions[iSlot].bPromote)
                {
                    AS_SetUnitInfo(iSlot, 3, strDisplay, m_arrUIOptions[iSlot].strNickName, m_arrUIOptions[iSlot].classDesc, m_arrUIOptions[iSlot].classLabel, m_arrUIOptions[iSlot].item1, m_arrUIOptions[iSlot].item2, m_strPromotionAvailable);
                }
                else
                {
                    AS_SetUnitInfo(iSlot, 0, strDisplay, m_arrUIOptions[iSlot].strNickName, m_arrUIOptions[iSlot].classDesc, m_arrUIOptions[iSlot].classLabel, m_arrUIOptions[iSlot].item1, m_arrUIOptions[iSlot].item2, "");
                }
            }
            else
            {
                strDisplay = "<img src='img://Deployment.images." $ Mid("posdPos2pos8pos3pos5posspos7Pos1pos9pos4pos0pos6", iSlot * 4, 4) $ "' width='20' height='24' vspace='-5'>" $ m_strAddUnit;

                AS_SetUnitInfo(iSlot, -1, "", "", "", "", "", "", "");
                AS_SetAddUnitText(iSlot, strDisplay, "+", class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon());
            }
        }
        else if (m_arrUIOptions[iSlot].bHint)
        {
            AS_SetUnitInfo(iSlot, -1, "", "", "", "", "", "", "");

            if (LWCE_XGHeadquarters(kMgr.HQ()).LWCE_HasFacility('Facility_OfficerTrainingSchool'))
            {
                AS_SetAddUnitText(iSlot, kMgr.m_strOTSHelp1, "", "");
            }
            else
            {
                AS_SetAddUnitText(iSlot, kMgr.m_strOTSHelp2, "", "");
            }
        }
    }

    RealizeSelected();
    Show();
}