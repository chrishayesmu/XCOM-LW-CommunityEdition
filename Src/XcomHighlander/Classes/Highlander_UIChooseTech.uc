class Highlander_UIChooseTech extends UIChooseTech;

simulated function XGResearchUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGResearchUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGResearchUI', (self), m_iView));
    }

    return m_kLocalMgr;
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            if (args[args.Length - 1] == "theConfirmButton" && m_iView != eLabView_CreditArchives)
            {
                OnAccept();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP_DELAYED:
            if (args[args.Length - 1] != "theConfirmButton" && m_iView != eLabView_CreditArchives)
            {
                m_iCurrentSelection = int(Split(args[args.Length - 1], "option", true));
                HL_RealizeSelected();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_DOUBLE_UP:
            if (args[args.Length - 1] != "theConfirmButton" && m_iView != eLabView_CreditArchives)
            {
                m_iCurrentSelection = int(Split(args[args.Length - 1], "option", true));
                HL_RealizeSelected();
                OnAccept("");
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
        default:
            break;
    }

    return true;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local bool bHandled;

    bHandled = true;

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return false;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);

            -- m_iCurrentSelection;
            if (m_iCurrentSelection < 0)
            {
                m_iCurrentSelection = m_arrUIOptions.Length - 1;
            }

            HL_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);

            ++ m_iCurrentSelection;
            if (m_iCurrentSelection >= m_arrUIOptions.Length)
            {
                m_iCurrentSelection = 0;
            }

            HL_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_A:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            if (m_iView == eLabView_CreditArchives)
            {
                OnCancel("");
                PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            }
            else
            {
                OnAccept("");
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
            OnCancel("");
            PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

protected simulated function HL_RealizeSelected()
{
    local ASValue myValue;
    local array<ASValue> myArray;

    HL_UpdateInfoPanelData(m_iCurrentSelection);

    myValue.Type = AS_String;
    myValue.S = string(m_arrUIOptions[m_iCurrentSelection].iIndex);
    myArray.AddItem(myValue);

    Invoke("setFocus", myArray);
}

protected simulated function HL_UpdateInfoPanelData(int iTechIndex)
{
    local TTechSummary kSummary;
    local int iReq;
    local string techName, infoText, descText, prereqs;

    kSummary = GetMgr().m_kTechTable.arrTechSummaries[iTechIndex];
    techName = class'UIUtilities'.static.CapsCheckForGermanScharfesS(kSummary.txtTitle.StrValue);
    infoText = class'UIUtilities'.static.GetHTMLColoredText(kSummary.txtProgress.StrValue, kSummary.txtProgress.iState);

    if (kSummary.kCost.strHelp != "")
    {
        descText = class'UIUtilities'.static.GetHTMLColoredText(kSummary.kCost.strHelp, eUIState_Bad) $ "\n";
    }

    descText $= kSummary.txtSummary.StrValue;
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

    infoText $= ("\n" $ prereqs);

    if (GetMgr().m_iCurrentView == eLabView_CreditArchives)
    {
        AS_UpdateInfo(techName, infoText, descText, class'UIUtilities'.static.GetResearchCreditImagePath(kSummary.imgItem.iImage));
    }
    else
    {
        AS_UpdateInfo(techName, infoText, descText, kSummary.imgItem.strPath);
    }
}

simulated function UpdateLayout()
{
    local int I;
    local string optionText;
    local UIChooseTech.UIOption kOption;

    Invoke("clear");

    for (I = 0; I < m_arrUIOptions.Length; I++)
    {
        kOption = m_arrUIOptions[I];

        if (kOption.iState == eUIState_Disabled)
        {
            optionText = class'UIUtilities'.static.GetHTMLColoredText(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kOption.strLabel), eUIState_Bad);
        }
        else
        {
            optionText = class'UIUtilities'.static.GetHTMLColoredText(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kOption.strLabel), kOption.iState);
        }

        if (optionText == "")
        {
            optionText = "PROBLEM:" @ I;
        }

        AS_AddOption(kOption.iIndex, optionText, eUIState_Normal);
    }

    HL_RealizeSelected();
}