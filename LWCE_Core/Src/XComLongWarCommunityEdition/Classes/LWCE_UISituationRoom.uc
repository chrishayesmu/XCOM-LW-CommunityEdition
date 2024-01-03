class LWCE_UISituationRoom extends UISituationRoom;

simulated function XGSatelliteSitRoomUI GetSatelliteMgr()
{
    if (m_kLocalSatelliteMgr == none)
    {
        m_kLocalSatelliteMgr = XGSatelliteSitRoomUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSatelliteSitRoomUI', self, m_iViewSatellite));
    }

    return m_kLocalSatelliteMgr;
}

simulated function LWCE_RealizeSelected()
{
}

state SatelliteState
{
    simulated event PushedState()
    {
        local UIStrategyHUD kStrategyHUD;
        local LWCE_XGFundingCouncil kFundingCouncil;
        local LWCE_XGSituationRoomUI kSitRoomUI;

        kStrategyHUD = XComHQPresentationLayer(controllerRef.m_Pres).GetStrategyHUD();
        kFundingCouncil = LWCE_XGFundingCouncil(`HQGAME.GetGameCore().GetWorld().m_kFundingCouncil);
        kSitRoomUI = LWCE_XGSituationRoomUI(GetSitRoomMgr());

        if (kFundingCouncil.m_nmPendingSatelliteRequestCountry != '')
        {
            m_iCurrentCountry = kSitRoomUI.LWCE_GetCountryUISlot(kFundingCouncil.m_nmPendingSatelliteRequestCountry);
            kFundingCouncil.m_nmPendingSatelliteRequestCountry = '';
        }

        // Note that m_iCurrentCountry is an index, not an ECountry value
        if (m_iCurrentCountry == INDEX_NONE)
        {
            m_iCurrentCountry = LWCE_XGSatelliteSitRoomUI(GetSatelliteMgr()).m_iCountry;
        }

        HideObjectives();
        AS_SetDisplayMode(DISPLAY_MODE_SATELLITE);
        RealizeSelected();
        UpdateHUD();

        kStrategyHUD.m_kMenu.Hide();
        kStrategyHUD.m_kMenu.m_kSubMenu.Hide();
        kStrategyHUD.ClearButtonHelp();
        kStrategyHUD.ShowBackButton(OnUCancel);

        m_kSitRoomHUD.AS_SetDisplayMode(DISPLAY_MODE_SATELLITE);
    }

    simulated function LWCE_RealizeSelected()
    {
        local ASValue myValue;
        local array<ASValue> myArray;
        local name nmCountry;

        if (GetSatelliteMgr() != none && m_iCurrentCountry != -1)
        {
            nmCountry = LWCE_XGSituationRoomUI(GetSitRoomMgr()).m_arrCECountriesUI[m_iCurrentCountry].nmCountry;
            LWCE_XGSatelliteSitRoomUI(GetSatelliteMgr()).LWCE_SetTargetCountry(nmCountry);
        }

        UpdateHUD();

        myValue.Type = AS_Number;
        myValue.N = m_iCurrentCountry;
        myArray.AddItem(myValue);

        Invoke("SetSelected", myArray);
    }

    simulated function UpdateHUD()
    {
        local XGSatelliteSitRoomUI kSatMgr;
        local string countryName, countryInfo, continentName, continentInfo, bonus;
        local int iBonus, iHTMLState, iSats;

        kSatMgr = GetSatelliteMgr();
        continentName = class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kContinentUI.txtContinent.StrValue, kSatMgr.m_kContinentUI.txtContinent.iState);
        continentInfo = "";

        for (iBonus = 0; iBonus < kSatMgr.m_kContinentUI.arrBonuses.Length; iBonus++)
        {
            iHTMLState = 0;
            bonus = "";

            if (kSatMgr.m_kContinentUI.arrBonusLabels.Length > iBonus)
            {
                bonus $= class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kContinentUI.arrBonusLabels[iBonus].StrValue, kSatMgr.m_kContinentUI.arrBonusLabels[iBonus].iState);
            }

            bonus $= class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kContinentUI.arrBonuses[iBonus].StrValue, kSatMgr.m_kContinentUI.arrBonuses[iBonus].iState);

            if (kSatMgr.m_kContinentUI.iHighlightedBonus == iBonus)
            {
                iHTMLState = eUIState_Warning;
            }

            continentInfo $= class'UIUtilities'.static.GetHTMLColoredText(bonus, iHTMLState) $ "\n";
        }

        m_kSitRoomHUD.SetContinentInfo(continentName, continentInfo, 0);
        countryName = class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kCountryUI.txtCountry.StrValue, kSatMgr.m_kCountryUI.txtCountry.iState);
        countryInfo = class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kCountryUI.txtFunding.StrValue, kSatMgr.m_kCountryUI.txtFunding.iState);
        countryInfo $= "\n";

        if (kSatMgr.m_kCursorUI.txtHelp.iButton == 1)
        {
            m_kSitRoomHUD.AS_SetLaunchButton(class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon(), class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kCursorUI.txtHelp.StrValue, kSatMgr.m_kCursorUI.txtHelp.iState), true);
        }
        else
        {
            m_kSitRoomHUD.AS_SetLaunchButton("", "", false);
            countryInfo $= class'UIUtilities'.static.GetHTMLColoredText(kSatMgr.m_kCursorUI.txtHelp.StrValue, kSatMgr.m_kCursorUI.txtHelp.iState);
        }

        m_kSitRoomHUD.AS_SetAccuseButton("", "", false);
        m_kSitRoomHUD.SetCountryInfo(class'UIUtilities'.static.CapsCheckForGermanScharfesS(countryName), countryInfo, kSatMgr.m_kCountryUI.iPanicLevel);
        m_kSitRoomHUD.AS_SetSatStatus(kSatMgr.m_kCountryUI.bHasSatCoverage);

        iSats = `LWCE_STORAGE.LWCE_GetNumItemsAvailable('Item_Satellite');
        AS_SetSatellites(iSats, m_strAvailable, kSatMgr.m_kUI.Current, kSatMgr.m_kUI.Max, m_strInOrbit);
    }
}