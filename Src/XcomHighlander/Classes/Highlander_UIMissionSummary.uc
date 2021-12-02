class Highlander_UIMissionSummary extends UIMissionSummary;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    BaseInit(_controllerRef, _manager);
    InitMgr(class'Highlander_XGSummaryUI');

    m_kFactors = Spawn(class'UIMissionSummary_Factors', self);
    m_kFactors.Init(controllerRef, manager, self, GetMgr());

    m_kArtifacts = Spawn(class'UIMissionSummary_Artifacts', self);
    m_kArtifacts.Init(controllerRef, manager, self, GetMgr());

    m_kPromotions = Spawn(class'UIMissionSummary_Promotions', self);
    m_kPromotions.Init(controllerRef, manager, self, GetMgr());

    m_kFocus = m_kFactors;

    m_kTicker = Spawn(class'UIMissionSummary_Ticker', self);
    m_kTicker.Init(controllerRef, manager, self, GetMgr());
}