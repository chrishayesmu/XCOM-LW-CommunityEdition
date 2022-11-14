class LWCE_UIManufacturing extends UIManufacturing;

simulated function string GetImage()
{
    switch (m_iView)
    {
        case eManView_Foundry:
            return GetMgr().m_kWidget.imgItem.strPath;
        case eManView_Item:
            return GetMgr().m_kWidget.imgItem.strPath;
        case eManView_Facility:
            return class'UIUtilities'.static.GetStrategyImagePath(GetMgr().m_kWidget.imgItem.iImage);
    }

    return "";
}

simulated function XGManufacturingUI GetMgr()
{
    return XGManufacturingUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGManufacturingUI', self, m_iView));
}

simulated function InitFoundry(XComPlayerController _controllerRef, UIFxsMovie _manager, int iTech, int iIndex)
{
    `LWCE_LOG_DEPRECATED_CLS(InitFoundry);
}

simulated function LWCE_InitFoundry(XComPlayerController _controllerRef, UIFxsMovie _manager, name ProjectName, int iIndex)
{
    local LWCE_XGManufacturingUI kManufacturing;

    Init(_controllerRef, _manager, eManView_Foundry);

    kManufacturing = LWCE_XGManufacturingUI(GetMgr());
    kManufacturing.m_kCEFoundryProject.ProjectName = ProjectName;
    kManufacturing.m_kCEFoundryProject.iIndex = iIndex;
    kManufacturing.DirectInitialize();
}

simulated function InitItem(XComPlayerController _controllerRef, UIFxsMovie _manager, EItemType iItemId, int iIndex)
{
    `LWCE_LOG_DEPRECATED_CLS(InitItem);
}

simulated function LWCE_InitItem(XComPlayerController _controllerRef, UIFxsMovie _manager, name ItemName, int iIndex)
{
    local LWCE_XGManufacturingUI kManufacturing;

    Init(_controllerRef, _manager, eManView_Item);

    kManufacturing = LWCE_XGManufacturingUI(GetMgr());
    kManufacturing.m_kCEItemProject.ItemName = ItemName;
    kManufacturing.m_kCEItemProject.iIndex = iIndex;
    kManufacturing.DirectInitialize();
}

simulated function Remove()
{
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'LWCE_XGManufacturingUI');
    super(UI_FxsScreen).Remove();
}