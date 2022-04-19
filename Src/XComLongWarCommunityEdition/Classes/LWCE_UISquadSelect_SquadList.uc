class LWCE_UISquadSelect_SquadList extends UISquadSelect_SquadList;

var const localized string m_strPromotionAvailable;

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