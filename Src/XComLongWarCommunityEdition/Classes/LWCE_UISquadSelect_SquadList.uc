class LWCE_UISquadSelect_SquadList extends UISquadSelect_SquadList;

var const localized string m_strPromotionAvailable;

simulated function UpdateData()
{
    local UISquadList_UnitBox kOption;
    local int iSoldier, iOption, iDropShipIdx;
    local TSoldierLoadout kLoadout;

    for (iOption = 0;iOption < m_arrUIOptions.Length; iOption++)
    {
        m_arrUIOptions[iOption].bEmpty = true;

        iDropShipIdx = m_arrFillOrderIndex.Find(iOption);
        m_arrUIOptions[iOption].bUnavailable = iDropShipIdx >= m_iMaxSlots;
    }

    if (UISquadSelect(screen).GetMgr().ITEMTREE().CanFacilityBeBuilt(eFacility_OTS))
    {
        m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots + 1]].bHint = true;
    }
    else if (UISquadSelect(screen).GetMgr().HQ().HasFacility(eFacility_OTS))
    {
        if (!UISquadSelect(screen).GetMgr().BARRACKS().HasOTSUpgrade(eOTS_SquadSize_I))
        {
            m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots + 1]].bHint = true;
        }

        if (!UISquadSelect(screen).GetMgr().BARRACKS().HasOTSUpgrade(eOTS_SquadSize_II))
        {
            m_arrUIOptions[m_arrFillOrderIndex[m_iMaxSlots]].bHint = true;
        }
    }

    for (iSoldier = 0; iSoldier < UISquadSelect(screen).GetMgr().m_arrSoldiers.Length; iSoldier++)
    {
        kLoadout = UISquadSelect(screen).GetMgr().m_arrSoldiers[iSoldier];
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

protected simulated function UISquadList_UnitBox LWCE_CreateSoldierOption(TSoldierLoadout kLoadout)
{
    local int iItemId;
    local LWCE_XGFacility_Barracks kBarracks;
    local UISquadList_UnitBox kOption;

    kBarracks = LWCE_XGFacility_Barracks(UISquadSelect(screen).GetMgr().BARRACKS());

    kOption.iIndex = kLoadout.iDropshipIndex;
    kOption.strName = Caps(kLoadout.txtName.StrValue);
    kOption.strNickName = kLoadout.txtNickname.StrValue;
    kOption.iStatus = kLoadout.iUIStatus;
    kOption.classDesc = kLoadout.txtClass.StrValue;
    kOption.classLabel = kBarracks.GetClassIcon(kLoadout.ClassType, kLoadout.bHasGeneMod, kLoadout.bIsPsiSoldier);

    if ((kLoadout.item1 & 255) > 0)
    {
        iItemId = kLoadout.item1 & 255;
        kOption.item1 = `LWCE_ITEM(iItemId).ImagePath;
    }

    if ((kLoadout.item2 & 255) > 0)
    {
        iItemId = kLoadout.item2 & 255;
        kOption.item1 = kOption.item1 $ "\n" $ `LWCE_ITEM(iItemId).ImagePath;
    }

    if ((kLoadout.item1 >> 8) > 0)
    {
        iItemId = (kLoadout.item1 >> 8) & 255;
        kOption.item1 = kOption.item1 $ "\n" $ `LWCE_ITEM(iItemId).ImagePath;
    }

    if ((kLoadout.item2 >> 8) > 0)
    {
        iItemId = (kLoadout.item2 >> 8) & 255;
        kOption.item1 = kOption.item1 $ "\n" $ `LWCE_ITEM(iItemId).ImagePath;
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

            if (kMgr.HQ().HasFacility(eFacility_OTS))
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