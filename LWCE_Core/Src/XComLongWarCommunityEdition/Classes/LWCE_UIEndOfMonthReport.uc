class LWCE_UIEndOfMonthReport extends UIEndOfMonthReport;

simulated function XGWorldReportUI GetMgr(optional int iStaringView)
{
    iStaringView = -1;
    return XGWorldReportUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGWorldReportUI', (self), m_iView));
}