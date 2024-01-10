class LWCE_UISituationRoom extends UISituationRoom
    dependson(LWCE_XGSituationRoomUI);

simulated function XGSatelliteSitRoomUI GetSatelliteMgr()
{
    if (m_kLocalSatelliteMgr == none)
    {
        m_kLocalSatelliteMgr = XGSatelliteSitRoomUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSatelliteSitRoomUI', self, m_iViewSatellite));
    }

    return m_kLocalSatelliteMgr;
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            if (args[args.Length - 1] == "launchButtonMC")
            {
                OnAccept("");
            }
            else if (args[args.Length - 1] == "accuseButtonMC")
            {
                if (GetInfiltratorMgr().m_kCursorUI.txtAccuse.iState == eUIState_Good)
                {
                    OnAccuse();
                }
            }
            else if (args[args.Length - 1] == "okButtonMC")
            {
                OnAccept("");
            }
            else if (args[args.Length - 1] == "cancelButtonMC")
            {
                OnUCancel();
            }
            else if (args[args.Length - 1] == "transitionButtonMC")
            {
                OnAccept();
            }
            else if (args[args.Length - 1] == "theSweepButton")
            {
                OnSweepDialogue();
            }
            else
            {
                if (!m_bAcceptsInput)
                {
                    return false;
                }

                m_iCurrentCountry = int(Split(args[args.Length - 1], "country", true));
                LWCE_RealizeSelected();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
    }

    return true;
}


simulated function LWCE_RealizeSelected()
{
}

simulated function UpdateCountries()
{
    local int Index;
    local LWCE_TSitCountry kCountry;
    local LWCE_XGSituationRoomUI kMgr;

    kMgr = LWCE_XGSituationRoomUI(GetSitRoomMgr());

    kMgr.UpdateCountries();

    for (Index = 0; Index < kMgr.m_arrCECountriesUI.Length; Index++)
    {
        kCountry = kMgr.m_arrCECountriesUI[Index];
        AS_LWCE_SetCountryInfo(Index, class'UIUtilities'.static.CapsCheckForGermanScharfesS(kCountry.txtName.StrValue), kCountry.txtFunding.StrValue, kCountry.iPanic, kCountry.eState == eSitCountry_Normal);

        if (m_iCurrentCountry == -1 && kCountry.txtFunding.StrValue == "")
        {
            m_iCurrentCountry = Index;
        }
    }

    if (m_iCurrentCountry == -1)
    {
        m_iCurrentCountry = 0;
    }
}

protected simulated function AS_LWCE_SetCountryInfo(int iIndex, string countryName, string cash, int panicLevel, bool bIsActive)
{
    local int iShields;
    local LWCE_XGSituationRoomUI kMgr;

    kMgr = LWCE_XGSituationRoomUI(GetSitRoomMgr());
    iShields = `LWCE_XGCOUNTRY(kMgr.m_arrCECountriesUI[iIndex].nmCountry).m_iShields;

    panicLevel = (iShields << 8) | panicLevel;
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetCountryInfo");
}

protected simulated function AS_LWCE_SetCountryInfoInfiltrator(int iIndex, string countryName, int panicLevel, bool bIsActive, bool bHasCell, XGSituationRoomUI.EUICellState cellState, bool bClearedByClues, bool bShowExaltBase)
{
    local int iShields;
    local LWCE_XGSituationRoomUI kMgr;

    kMgr = LWCE_XGSituationRoomUI(GetSitRoomMgr());
    iShields = `LWCE_XGCOUNTRY(kMgr.m_arrCECountriesUI[iIndex].nmCountry).m_iShields;

    panicLevel = (iShields << 8) | panicLevel;
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetCountryInfoInfiltrator");
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

        // TODO: m_iCurrentCountry is an index, not an ECountry value, but it's being mixed with
        // XGSatelliteSitRoomUI.m_iCountry which is definitely an enum? Not sure what's happening
        if (m_iCurrentCountry == INDEX_NONE)
        {
            m_iCurrentCountry = LWCE_XGSatelliteSitRoomUI(GetSatelliteMgr()).m_iCountry;
        }

        HideObjectives();
        AS_SetDisplayMode(DISPLAY_MODE_SATELLITE);
        LWCE_RealizeSelected();
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
            iHTMLState = eUIState_Normal;
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