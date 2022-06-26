class LWCE_XGSituationRoomUI extends XGSituationRoomUI;

function UpdateMainMenu()
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local TMenu mnuMain;
    local TMenuOption kOption;
    local array<ESitView> arrViews;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);

    kOption.strText = m_strLabelLaunchSatellite;
    kOption.strHelp = m_strLabelMonitorUFO;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_Satellites);

    kOption.strText = m_strLabelCodeDecryption;
    kOption.strHelp = m_strLabelCodeDecrypted;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_NewObjective);

    if (EXALT().IsExaltActive())
    {
        kOption.strText = m_strLabelInfiltratorMode;
        kOption.strHelp = m_strLabelInfiltratorHelp;
        kOption.iState = eUIState_Normal;
        mnuMain.arrOptions.AddItem(kOption);
        arrViews.AddItem(eSitView_Exalt);
    }

    kOption.strText = m_strLabelViewFinances;
    kOption.strHelp = m_strLabelViewExpenditures;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_Finances);

    if (SITROOM().IsGreyMarketUnlocked())
    {
        kOption.strText = m_stdLabelVisitGreyMarket;
        kOption.strHelp = m_stdLabelVisitGreyMarketHelp;
        kOption.iState = eUIState_Normal;
        mnuMain.arrOptions.AddItem(kOption);
        arrViews.AddItem(eSitView_GreyMarket);
    }

    kOption.strText = m_strLabelPendingRequests $ " (" $ kFundingCouncil.m_arrCECurrentRequests.Length $ ")";
    kOption.strHelp = m_strLabelPendingRequestsHelp;
    kOption.iState = eUIState_Normal;

    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_PendingRequests);

    m_mnuMain = mnuMain;
    m_arrOptions = arrViews;
}

function UpdateRequest()
{
    // This doesn't appear to ever be used
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(UpdateRequest);
}