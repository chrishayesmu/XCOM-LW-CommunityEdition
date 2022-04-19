class LWCE_UISquadSelect extends UISquadSelect;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGMission kMission, bool _bCanNavigate)
{
    local XGChooseSquadUI kMgr;

    m_bExiting = false;
    BaseInit(_controllerRef, _manager);
    m_iView = 0;

    kMgr = Spawn(class'LWCE_XGChooseSquadUI', XComHQPresentationLayer(controllerRef.m_Pres));
    kMgr.m_kInterface = self;
    kMgr.m_kMission = kMission;
    kMgr.Init(0);

    XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);

    m_kSquadList = Spawn(class'LWCE_UISquadSelect_SquadList', self);
    m_kSquadList.Init(controllerRef, manager, self, kMission, _bCanNavigate);

    m_kHelpBar = Spawn(class'UINavigationHelp', self);
    m_kHelpBar.Init(controllerRef, manager, self, UpdateButtonHelp);

    m_strLaunch = GetMgr().m_txtLaunch.StrValue;
    manager.LoadScreen(self);
}

simulated function XGChooseSquadUI GetMgr()
{
    return XGChooseSquadUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGChooseSquadUI', self, 0));
}

simulated function Remove()
{
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'LWCE_XGChooseSquadUI');
    super.Remove();
}