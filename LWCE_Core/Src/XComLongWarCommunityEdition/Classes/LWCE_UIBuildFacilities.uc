class LWCE_UIBuildFacilities extends UIBuildFacilities
    dependson(LWCE_XGBuildUI);

var int m_iBaseId;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

simulated function LWCE_Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iBaseId)
{
    BaseInit(_controllerRef, _manager);

    m_iView = -1;
    m_iBaseId = iBaseId;

    manager.LoadScreen(self);
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ClearButtonHelp();
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ShowBackButton(OnUCancel);
    Show();
}

simulated function XGBuildUI GetMgr()
{
    m_kLocalMgr = XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBuildUI', self, 0));
    return m_kLocalMgr;
}

simulated function OnInit()
{
    local bool bMultipleBasesExist;
    local LWCE_XGBuildUI kMgr;

    super(UI_FxsShellScreen).OnInit();

    kMgr = LWCE_XGBuildUI(GetMgr());
    kMgr.SetTargetBaseId(m_iBaseId);

    bMultipleBasesExist = LWCE_XGHeadquarters(kMgr.HQ()).m_arrBases.Length > 1;

    if (bMultipleBasesExist)
    {
        AS_SetTitle(kMgr.GetTargetBase().m_strName);
    }
    else
    {
        AS_SetTitle(m_strBuildFacilityTitle);
    }

    UpdateCursor();
    UpdateResources();
    Show();

    // Something about the way we're re-ordering operations causes the back button to disappear, so just put it back
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ClearButtonHelp();
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ShowBackButton(OnUCancel);
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGBuildUI');
    super(UI_FxsScreen).Destroyed();
}

simulated function UpdateData()
{
    local LWCE_XGBase kBase;
    local LWCE_XGBuildUI kMgr;
    local LWCE_TUIBaseTile kBaseTile;
    local LWCE_TUIFacilityTile kFacilityTile;
    local int I;
    local string strFacilityLabel;

    kMgr = LWCE_XGBuildUI(GetMgr());
    kBase = kMgr.GetTargetBase();

    for (I = 0; I < kMgr.m_arrCETiles.Length; I++)
    {
        kBaseTile = kMgr.m_arrCETiles[I];

        if (kBaseTile.kTile.Y != 0)
        {
            AS_UpdateFacilityCard(TileXToUI(kBase, kBaseTile.kTile.X), TileYToUI(kBase, kBaseTile.kTile.Y), kBaseTile.txtLabel.StrValue $ "<br>" $ kBaseTile.txtCounter.StrValue, kBaseTile.imgTile.strLabel, kBaseTile.bDisabled, false, false);
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

            AS_UpdateFacilityCard(TileXToUI(kBase, kFacilityTile.kTile.X), TileYToUI(kBase, kFacilityTile.kTile.Y), strFacilityLabel, kFacilityTile.imgTile.strLabel, false, kFacilityTile.bAdjacencyBonusLeft, kFacilityTile.bAdjacencyBonusTop);
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

protected function int TileXToUI(LWCE_XGBase kBase, int X)
{
    local int iOffset;

    if (X < 0 || X > 6)
    {
        `LWCE_LOG_CLS("ERROR: tile's X coord " $ X $ " is out of range [0, 6]");
        return X;
    }

    iOffset = (class'XGStrategyActorNativeBase'.const.NUM_TERRAIN_WIDE - kBase.m_iNumTilesWide) / 2;
    return X + iOffset;
}

protected function int TileYToUI(LWCE_XGBase kBase, int Y)
{
    local int iOffset;

    if (Y < 0 || Y > 4)
    {
        `LWCE_LOG_CLS("ERROR: tile's Y coord " $ Y $ " is out of range [0, 4]");
        return Y;
    }

    iOffset = (class'XGStrategyActorNativeBase'.const.NUM_TERRAIN_HIGH - kBase.m_iNumTilesHigh) / 2;
    return Y + iOffset;
}