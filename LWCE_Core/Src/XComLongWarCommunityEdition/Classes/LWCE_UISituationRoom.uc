class LWCE_UISituationRoom extends UISituationRoom;

simulated function XGSatelliteSitRoomUI GetSatelliteMgr()
{
    if (m_kLocalSatelliteMgr == none)
    {
        m_kLocalSatelliteMgr = XGSatelliteSitRoomUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSatelliteSitRoomUI', self, m_iViewSatellite));
    }

    return m_kLocalSatelliteMgr;
}

state SatelliteState
{
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