class LWCE_UIManufacturing extends UIManufacturing;

simulated function string GetImage()
{
    switch (m_iView)
    {
        case eManView_Foundry:
        case eManView_Item:
        case eManView_Facility:
            return GetMgr().m_kWidget.imgItem.strPath;
    }

    return "";
}

simulated function XGManufacturingUI GetMgr()
{
    return XGManufacturingUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGManufacturingUI', self, m_iView));
}

simulated function InitFacility(XComPlayerController _controllerRef, UIFxsMovie _manager, EFacilityType eFacility, int X, int Y, optional int iIndex = -1)
{
    `LWCE_LOG_DEPRECATED_CLS(InitFacility);
}

simulated function LWCE_InitFacility(XComPlayerController _controllerRef, UIFxsMovie _manager, name FacilityName, int iBaseId, int X, int Y, optional int iIndex = -1)
{
    local LWCE_XGManufacturingUI kMgr;

    Init(_controllerRef, _manager, eManView_Facility);

    kMgr = LWCE_XGManufacturingUI(GetMgr());

    kMgr.m_iTargetBaseId = iBaseId;
    kMgr.m_kCEFacilityProject.iBaseId = iBaseId;
    kMgr.m_kCEFacilityProject.FacilityName = FacilityName;
    kMgr.m_kCEFacilityProject.X = X;
    kMgr.m_kCEFacilityProject.Y = Y;
    kMgr.m_kCEFacilityProject.iIndex = iIndex;
    kMgr.DirectInitialize();
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