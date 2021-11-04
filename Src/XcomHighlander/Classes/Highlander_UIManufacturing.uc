class Highlander_UIManufacturing extends UIManufacturing;

simulated function string GetImage()
{
    switch (m_iView)
    {
        case eManView_Foundry:
            return GetMgr().m_kWidget.imgItem.strPath;
        case eManView_Item:
            return class'UIUtilities'.static.GetInventoryImagePath(GetMgr().m_kWidget.imgItem.iImage);
        case eManView_Facility:
            return class'UIUtilities'.static.GetStrategyImagePath(GetMgr().m_kWidget.imgItem.iImage);
    }

    return "";
}

simulated function XGManufacturingUI GetMgr()
{
    return XGManufacturingUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGManufacturingUI', (self), m_iView));
}

simulated function Remove()
{
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'Highlander_XGManufacturingUI');
    super(UI_FxsScreen).Remove();
}