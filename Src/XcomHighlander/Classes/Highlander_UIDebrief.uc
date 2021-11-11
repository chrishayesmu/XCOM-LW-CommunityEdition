class Highlander_UIDebrief extends UIDebrief;

simulated function OnInit()
{
    super(UI_FxsScreen).OnInit();

    m_kMgr = XGDebriefUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGDebriefUI', self));
    m_kMgr.m_kSkyranger = m_kSkyranger;

    RealizeLabels();

    GoToView(m_kMgr.m_iCurrentView);
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'Highlander_XGDebriefUI');
    m_kMgr = none;
    super.Destroyed();
}