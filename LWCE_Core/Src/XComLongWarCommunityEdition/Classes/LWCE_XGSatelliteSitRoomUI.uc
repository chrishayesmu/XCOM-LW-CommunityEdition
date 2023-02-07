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

function UpdateCountryHelp()
{
    local TSatCursorUI kUI;

    kUI.txtHelp.StrValue = "";
    kUI.txtHelp.iState = eUIState_Bad;

    if (m_iCountry == -1)
    {
        kUI.bEnabled = false;
    }
    else
    {
        if (Country(m_iCountry).LeftXCom())
        {
            kUI.txtHelp.StrValue = m_strLabelLeftXCom;
            kUI.txtHelp.iState = eUIState_Bad;
        }

        if (Country(m_iCountry).HasSatelliteCoverage())
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelHasSatellite;
            kUI.txtHelp.iState = eUIState_Disabled;
        }
        else if (!HasUplinkCapacity())
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelNoCapacity;
            kUI.txtHelp.iState = eUIState_Bad;
        }
        else if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_Satellite') == 0)
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelNoSatellites;
            kUI.txtHelp.iState = eUIState_Bad;
        }
        else
        {
            kUI.bEnabled = true;
            kUI.txtHelp.iButton = 1;
            kUI.txtHelp.StrValue = m_strLabelLaunchSatellite;
            kUI.txtHelp.iState = eUIState_Good;
        }
    }

    m_kCursorUI = kUI;
}

function UpdateMain()
{
    local string strSatellite;
    local int iSatellite;
    local TMenu mnuSatellites;
    local TMenuOption txtOption;
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

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

    if (kStorage.LWCE_GetNumItemsAvailable('Item_Satellite') == 0)
    {
        mnuSatellites.strLabel = m_strLabelNoSatellitesToLaunch;
    }
    else
    {
        strSatellite = `LWCE_ITEM('Item_Satellite').strName;

        for (iSatellite = 0; iSatellite < kStorage.LWCE_GetNumItemsAvailable('Item_Satellite'); iSatellite++)
        {
            txtOption.strText = strSatellite $ "-" $ iSatellite;
            mnuSatellites.arrOptions.AddItem(txtOption);
        }
    }

    m_kUI.mnuSatellites = mnuSatellites;
}