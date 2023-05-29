class LWCE_UIChooseFacility extends UIChooseFacility;

simulated function XGBuildUI GetMgr()
{
    return XGBuildUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGBuildUI', (self), 1));
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP_DELAYED:
            if (args[args.Length - 1] == "theBackButton")
            {
                OnCancel();
                return true;
            }

            if (args[args.Length - 1] == "theStartButton")
            {
                OnAccept();
                return true;
            }
            else
            {
                m_iCurrentSelection = int(Split(args[args.Length - 1], "option", true));
                LWCE_RealizeSelected();
                PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            }

            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_DOUBLE_UP:
            if (args[args.Length - 1] == "theBackButton")
            {
                OnCancel();
                return true;
            }

            if (args[args.Length - 1] == "theStartButton")
            {
                OnAccept();
                return true;
            }
            else
            {
                m_iCurrentSelection = int(Split(args[args.Length - 1], "option", true));
                LWCE_RealizeSelected();
                OnAccept();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
    }

    return true;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return false;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            m_iCurrentSelection--;

            if (m_iCurrentSelection < 0)
            {
                m_iCurrentSelection = m_arrUIOptions.Length - 1;
            }

            LWCE_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            m_iCurrentSelection++;

            if (m_iCurrentSelection >= m_arrUIOptions.Length)
            {
                m_iCurrentSelection = 0;
            }

            LWCE_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            OnAccept("");
            PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            OnCancel("");
            PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            break;
        default:
            break;
    }

    return true;
}

protected simulated function UpdateData()
{
    local UIBuildItem.UIOption kOption;
    local TTableMenuOption tMnuOption;
    local TTableMenu tMnu;
    local int I;

    m_arrUIOptions.Length = 0;
    tMnu = LWCE_XGBuildUI(GetMgr()).m_kCETable.mnuOptions;

    for (I = 0; I < tMnu.arrOptions.Length; I++)
    {
        tMnuOption = tMnu.arrOptions[I];
        kOption.iIndex = I;
        kOption.strLabel = tMnuOption.arrStrings[0];
        kOption.iState = tMnuOption.iState;
        kOption.strHelp = tMnuOption.strHelp;
        m_arrUIOptions.AddItem(kOption);
    }

    UpdateLayout();
}

protected simulated function UpdateLayout()
{
    local int I;
    local string optionText;
    local UIBuildItem.UIOption kOption;

    Invoke("clear");

    for (I = 0; I < m_arrUIOptions.Length; I++)
    {
        kOption = m_arrUIOptions[I];
        optionText = class'UIUtilities'.static.GetHTMLColoredText(kOption.strLabel, kOption.iState);
        AS_AddOption(kOption.iIndex, optionText, 0);
    }

    LWCE_RealizeSelected();
    Show();
}

protected simulated function LWCE_RealizeSelected()
{
    local ASValue myValue;
    local array<ASValue> myArray;

    LWCE_UpdateInfoPanelData(m_iCurrentSelection);

    myValue.Type = AS_String;
    myValue.S = string(m_arrUIOptions[m_iCurrentSelection].iIndex);
    myArray.AddItem(myValue);

    Invoke("setFocus", myArray);
}

protected simulated function LWCE_UpdateInfoPanelData(int iMenuItem)
{
    local TObjectSummary kSummary;
    local int iReq, iOptionState;
    local string techName, descText, prereqs;

    kSummary = LWCE_XGBuildUI(GetMgr()).m_kCETable.arrSummaries[iMenuItem];
    iOptionState = m_arrUIOptions[m_iCurrentSelection].iState;
    techName = class'UIUtilities'.static.GetHTMLColoredText(Caps(m_arrUIOptions[m_iCurrentSelection].strLabel), iOptionState);

    if (kSummary.kCost.strHelp != "")
    {
        descText = class'UIUtilities'.static.GetHTMLColoredText(kSummary.kCost.strHelp, eUIState_Bad) $ "\n";
    }

    descText $= class'UIUtilities'.static.GetHTMLColoredText(kSummary.txtSummary.StrValue, m_arrUIOptions[m_iCurrentSelection].iState);
    prereqs = "";

    if (kSummary.kCost.arrRequirements.Length > 0)
    {
        prereqs = kSummary.txtRequirementsLabel.StrValue;

        for (iReq = 0; iReq < kSummary.kCost.arrRequirements.Length; iReq++)
        {
            prereqs @= class'UIUtilities'.static.GetHTMLColoredText(kSummary.kCost.arrRequirements[iReq].StrValue, kSummary.kCost.arrRequirements[iReq].iState);

            if (iReq != kSummary.kCost.arrRequirements.Length - 1)
            {
                prereqs $= ",";
            }
        }
    }
    else
    {
        prereqs = m_strNoReqLabel;

        if (XComCheatManager(GetALocalPlayerController().CheatManager).m_bStrategyAllFacilitiesFree)
        {
            prereqs = prereqs @ m_strSuperSpreeLabel;
        }
    }

    myHUD.ShowFacilityTexture(EFacilityType(kSummary.ItemType)); // TODO fix
    AS_UpdateInfo(techName, prereqs, descText, class'UIUtilities'.static.GetFacilityLabel(kSummary.imgObject.iImage));
}