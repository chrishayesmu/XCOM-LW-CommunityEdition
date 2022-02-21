class LWCE_UIDebrief extends UIDebrief;

simulated function OnInit()
{
    super(UI_FxsScreen).OnInit();

    m_kMgr = XGDebriefUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGDebriefUI', self));
    m_kMgr.m_kSkyranger = m_kSkyranger;

    RealizeLabels();

    GoToView(m_kMgr.m_iCurrentView);
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGDebriefUI');
    m_kMgr = none;
    super.Destroyed();
}

simulated function ShowScienceDebrief()
{
    local int iListId, iLoot, iItem, Len, Amount;
    local string Description, Title, imagePath;

    if (m_iView == eDebriefView_Science)
    {
        iListId = 0;
        Len = m_kMgr.m_kScienceDebrief.arrItems.Length;

        for (iItem = 0; iItem < Len; iItem++)
        {
            if (iItem == 0)
            {
                AS_AddListHeader(iListId++, m_kMgr.m_kScienceDebrief.arrItems[iItem].txtTitle.StrValue);
            }

            Title = m_kMgr.m_kScienceDebrief.arrItems[iItem].txtTech.StrValue;
            Description = m_kMgr.m_kScienceDebrief.arrItems[iItem].txtBody.StrValue;
            imagePath = m_kMgr.m_kScienceDebrief.arrItems[iItem].imgTech.strPath;
            AS_AddScienceResearch(iListId++, Title, Description, imagePath);
        }

        AS_AddListHeader(iListId++, m_kMgr.m_kScienceDebrief.txtLootTitle.StrValue);
        Len = m_kMgr.m_kScienceDebrief.arrLoot.Length;

        for (iLoot = 0; iLoot < Len; iLoot++)
        {
            Description = m_kMgr.m_kScienceDebrief.arrLoot[iLoot].txtItem.StrValue;
            Amount = int(m_kMgr.m_kScienceDebrief.arrLoot[iLoot].txtQuantity.StrValue);
            imagePath = m_kMgr.m_kScienceDebrief.arrLoot[iLoot].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);
        }
    }
    else
    {
        Invoke("ClearScienceDebrief");
        iListId = 0;
        Len = m_kMgr.m_kEngineeringDebrief.arrItems.Length;

        if (m_kMgr.m_kEngineeringDebrief.iHighlighted > 0)
        {
            AS_AddListHeader(iListId++, m_kMgr.m_kEngineeringDebrief.txtAdvisor.StrValue);
        }

        for (iItem = 0; iItem < m_kMgr.m_kEngineeringDebrief.iHighlighted; iItem++)
        {
            Description = m_kMgr.m_kEngineeringDebrief.arrItems[iItem].txtItem.StrValue;
            Amount = int(m_kMgr.m_kEngineeringDebrief.arrItems[iItem].txtBody.StrValue);
            imagePath = m_kMgr.m_kEngineeringDebrief.arrItems[iItem].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);
        }

        if (iItem < Len)
        {
            AS_AddListHeader(iListId++, m_kMgr.m_kEngineeringDebrief.txtTitle.StrValue);
        }

        while (iItem < Len)
        {
            Description = m_kMgr.m_kEngineeringDebrief.arrItems[iItem].txtItem.StrValue;
            Amount = int(m_kMgr.m_kEngineeringDebrief.arrItems[iItem].txtBody.StrValue);
            imagePath = m_kMgr.m_kEngineeringDebrief.arrItems[iItem].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);

            iItem++;
        }
    }

    if (Len == 0)
    {
        m_kMgr.OnAdvance();
    }
    else
    {
        AS_ShowScienceDebrief();
    }
}