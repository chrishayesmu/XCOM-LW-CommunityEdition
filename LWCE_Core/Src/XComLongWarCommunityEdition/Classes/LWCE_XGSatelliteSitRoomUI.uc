class LWCE_XGSatelliteSitRoomUI extends XGSatelliteSitRoomUI
    implements(LWCE_IFCRequestInterface)
    dependson(LWCE_XGFundingCouncil);

simulated function GetRequestData(out TFCRequest kRequestRef)
{
    // This doesn't seem to ever have real data populated, so we don't bother with it
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRequestData);
}

simulated function LWCE_GetRequestData(out LWCE_TFCRequest kRequestRef)
{
    // This is added just to meet the interface requirements and avoid log errors
}

function UpdateMain()
{
    local string strSatellite;
    local int iSatellite;
    local TMenu mnuSatellites;
    local TMenuOption txtOption;

    m_kUI.Current = HQ().m_arrSatellites.Length;
    m_kUI.Max = HQ().GetSatelliteLimit();
    m_kUI.ltxtCapacity.strLabel = m_strLabelUplinkCapacity;
    m_kUI.ltxtCapacity.StrValue = HQ().m_arrSatellites.Length $ "/" $ HQ().GetSatelliteLimit();

    if (!HasUplinkCapacity())
    {
        m_kUI.ltxtCapacity.iState = eUIState_Bad;
    }
    else
    {
        m_kUI.ltxtCapacity.iState = eUIState_Good;
    }

    if (STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Satellite)) == 0)
    {
        mnuSatellites.strLabel = m_strLabelNoSatellitesToLaunch;
    }
    else
    {
        strSatellite = `LWCE_ITEM(`LW_ITEM_ID(Satellite)).strName;

        for (iSatellite = 0; iSatellite < STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Satellite)); iSatellite++)
        {
            txtOption.strText = strSatellite $ "-" $ iSatellite;
            mnuSatellites.arrOptions.AddItem(txtOption);
        }
    }

    m_kUI.mnuSatellites = mnuSatellites;
}