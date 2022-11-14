class LWCE_UIStrategyHUD_FSM_Engineering extends UIStrategyHUD_FSM_Engineering;

simulated function XGEngineeringUI GetMgr(optional int iStartView = -1)
{
    return XGEngineeringUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGEngineeringUI', self, iStartView));
}

simulated function OnDeactivate()
{
    `HQPRES.GetStrategyHUD().m_kBuildQueue.Hide();
    super.OnDeactivate();
    XComHQPresentationLayer(controllerRef.m_Pres).RemoveMgr(class'LWCE_XGEngineeringUI');
}

simulated function UpdateResources()
{
    local string strLabel;
    local LWCE_XGEngineeringUI kMgr;
    local LWCE_XGStorage kStorage;
    local TEngHeader kHeader;

    kMgr = LWCE_XGEngineeringUI(GetMgr());
    kStorage = `LWCE_STORAGE;
    kHeader = kMgr.m_kHeader;

    `HQPRES.GetStrategyHUD().AS_SetHumanResources(kMgr.m_kHeader.txtEngineers.strLabel, kMgr.m_kHeader.txtEngineers.StrValue);

    UIStrategyHUD(screen).ClearResources();

    strLabel = kHeader.txtCash.strLabel $ ":" @ kHeader.txtCash.StrValue;
    UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, kHeader.txtCash.iState));

    if (kHeader.txtElerium.strLabel != "")
    {
        strLabel = kHeader.txtElerium.strLabel $ ":" @ kHeader.txtElerium.StrValue;
        UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, kHeader.txtElerium.iState));
    }

    if (kHeader.txtAlloys.strLabel != "")
    {
        strLabel = kHeader.txtAlloys.strLabel $ ":" @ kHeader.txtAlloys.StrValue;
        UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, kHeader.txtAlloys.iState));
    }

    strLabel = Repl(Caps(`LWCE_ITEM('Item_WeaponFragment').strName), "WEAPON ", "", false);
    strLabel $= ": " $ kStorage.LWCE_GetNumItemsAvailable('Item_WeaponFragment');
    UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, eUIState_Alloys));

    strLabel = kMgr.GetResourceLabel(eResource_Meld) $ ":" @ kMgr.GetResourceString(eResource_Meld) @ "#MELDTAG";
    UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, kMgr.GetResourceUIState(eResource_Meld)));

    strLabel = kMgr.GetResourceLabel(eResource_Power) $ ":" @ kMgr.GetResourceString(eResource_Power);
    UIStrategyHUD(screen).AddResource(class'UIUtilities'.static.GetHTMLColoredText(strLabel, kMgr.GetResourceUIState(eResource_Power)));
}