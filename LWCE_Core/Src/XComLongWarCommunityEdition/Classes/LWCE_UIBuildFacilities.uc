class LWCE_UIBuildFacilities extends UIBuildFacilities
    dependson(LWCE_XGBuildUI);

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

simulated function UpdateData()
{
    local LWCE_XGBuildUI kMgr;
    local LWCE_TUIBaseTile kBaseTile;
    local LWCE_TUIFacilityTile kFacilityTile;
    local int I;
    local string strFacilityLabel;

    kMgr = LWCE_XGBuildUI(GetMgr());

    for (I = 0; I < kMgr.m_arrCETiles.Length; I++)
    {
        kBaseTile = kMgr.m_arrCETiles[I];

        if (kBaseTile.kTile.Y != 0)
        {
            AS_UpdateFacilityCard(float(kBaseTile.kTile.X), float(kBaseTile.kTile.Y), kBaseTile.txtLabel.StrValue $ "<br>" $ kBaseTile.txtCounter.StrValue, kBaseTile.imgTile.strLabel, kBaseTile.bDisabled, false, false);
        }
    }

    for (I = 0; I < kMgr.m_arrCEFacilityTiles.Length; I++)
    {
        kFacilityTile = kMgr.m_arrCEFacilityTiles[I];

        if (kFacilityTile.kTile.Y != 0)
        {
            strFacilityLabel = kFacilityTile.txtLabel.StrValue;

            if (kFacilityTile.txtLabel.iState != eUIState_Normal)
            {
                strFacilityLabel = class'UIUtilities'.static.GetHTMLColoredText(strFacilityLabel, kFacilityTile.txtLabel.iState);
            }

            AS_UpdateFacilityCard(float(kFacilityTile.kTile.X), float(kFacilityTile.kTile.Y), strFacilityLabel, kFacilityTile.imgTile.strLabel, false, kFacilityTile.bAdjacencyBonusLeft, kFacilityTile.bAdjacencyBonusTop);
        }
    }
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