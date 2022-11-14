class LWCE_UIBuildFacilities extends UIBuildFacilities;

simulated function XGBuildUI GetMgr()
{
    m_kLocalMgr = XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBuildUI', self, 0));
    return m_kLocalMgr;
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGBuildUI');
    super(UI_FxsScreen).Destroyed();
}

simulated function UpdateResources()
{
    local LWCE_XGStorage kStorage;
    local UIStrategyHUD kHUD;

    kStorage = LWCE_XGStorage(GetMgr().STORAGE());
    kHUD = XComHQPresentationLayer(controllerRef.m_Pres).GetStrategyHUD();

    kHUD.AS_SetHumanResources();
    kHUD.ClearResources();
    kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().m_kHeader.txtCash.strLabel $ ":" @ GetMgr().m_kHeader.txtCash.StrValue, GetMgr().m_kHeader.txtCash.iState));
    kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().GetResourceLabel(eResource_MonthlyNet) $ ":" @ GetMgr().GetResourceString(eResource_MonthlyNet), GetMgr().GetResourceUIState(eResource_MonthlyNet)));

    if (kStorage.LWCE_EverHadItem('Item_Elerium'))
    {
        kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().m_kHeader.txtElerium.strLabel $ ":" @ GetMgr().m_kHeader.txtElerium.StrValue, GetMgr().m_kHeader.txtElerium.iState));
    }

    if (kStorage.LWCE_EverHadItem('Item_AlienAlloys'))
    {
        kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().m_kHeader.txtAlloys.strLabel $ ":" @ GetMgr().m_kHeader.txtAlloys.StrValue, GetMgr().m_kHeader.txtAlloys.iState));
    }

    kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().GetResourceLabel(eResource_Meld) $ ":" @ GetMgr().GetResourceString(eResource_Meld) @ "#MELDTAG", GetMgr().GetResourceUIState(eResource_Meld)));
    kHUD.AddResource(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().m_kHeader.txtPower.strLabel $ ":" @ GetMgr().m_kHeader.txtPower.StrValue, GetMgr().m_kHeader.txtPower.iState));
}