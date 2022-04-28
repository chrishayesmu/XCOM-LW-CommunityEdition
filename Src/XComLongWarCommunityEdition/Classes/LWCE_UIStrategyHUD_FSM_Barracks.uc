class LWCE_UIStrategyHUD_FSM_Barracks extends UIStrategyHUD_FSM_Barracks;

simulated function XGBarracksUI GetMgr(optional int iStartView = -1)
{
    return XGBarracksUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBarracksUI', self, iStartView));
}

simulated function GoToView(int iView)
{
    m_iView = iView;

    switch (m_iView)
    {
        case eBarracksView_MainMenu:
            CreateMenuOptions(GetMgr().m_kMainMenu.mnuOptions);
            break;
        case eBarracksView_SoldierList:
            `HQPRES.UISoldierList(class'LWCE_UISoldierList_Barracks');
            break;
        case eBarracksView_Hire:
            XComHQPresentationLayer(controllerRef.m_Pres).UIBarracksHiring();
            break;
    }
}