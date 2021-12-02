class Highlander_UIBuildItem extends UIBuildItem
    dependson(HighlanderTypes);

simulated function XGEngineeringUI GetMgr()
{
    return XGEngineeringUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGEngineeringUI', self, 1));
}

simulated function OnMouseAccept()
{
    local HL_TItemCard kCardData;

    kCardData = Highlander_XGEngineeringUI(GetMgr()).HL_ENGINEERINGUIGetItemCard();

    if (kCardData.iCardType != 0)
    {
        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
        `HL_HQPRES.HL_UIItemCard(kCardData);
    }
    else
    {
        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
    }
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local int iCat, iSel;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_DOUBLE_UP:
            iSel = int(Split(args[args.Length - 1], "option", true));

            if (m_iCurrentSelection != -1)
            {
                m_iCurrentSelection = iSel;
                HL_RealizeSelected();
                OnAccept();
            }

            return true;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            if (args[args.Length - 1] == "theConfirmButton")
            {
                OnAccept();
                return true;
            }

            if (args.Length >= 6 && args[5] == "theItems")
            {
                iSel = int(Split(args[args.Length - 1], "option", true));

                if (iSel != -1)
                {
                    m_iCurrentSelection = iSel;
                    HL_RealizeSelected();
                    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                    return true;
                }
            }

            iCat = int(Split(args[args.Length - 1], "cat", true));

            if (iCat != -1)
            {
                if (GetMgr().ISCONTROLLED() && iCat != 0 && GetMgr().Game().GetNumMissionsTaken() > 3)
                {
                    GetMgr().PlayBadSound();
                    return true;
                }

                m_iCurrentSelection = 0;
                GetMgr().OnTab(iCat);
                HL_RealizeSelected();

                return true;
            }

            break;
        default:
            break;
    }

    return true;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local TItemCard cardData;

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg)
     || (Cmd == class'UI_FxsInput'.const.FXS_DPAD_LEFT
     || Cmd == class'UI_FxsInput'.const.FXS_DPAD_RIGHT
     || Cmd == class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_LEFT
     || Cmd == class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_RIGHT
     || Cmd == class'UI_FxsInput'.const.FXS_BUTTON_LBUMPER
     || Cmd == class'UI_FxsInput'.const.FXS_BUTTON_RBUMPER)
     && Arg == class'UI_FxsInput'.const.FXS_ACTION_POSTHOLD_REPEAT)
    {
        return false;
    }

    if (!IsVisible())
    {
        return false;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            if (m_arrUIOptions.Length > 1)
            {
                PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            }

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
            if (m_arrUIOptions.Length > 1)
            {
                PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            }

            ++ m_iCurrentSelection;
            if (m_iCurrentSelection >= m_arrUIOptions.Length)
            {
                m_iCurrentSelection = 0;
            }

            HL_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_LBUMPER:
        case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_LEFT:
        case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
        case class'UI_FxsInput'.const.FXS_KEY_A:
            m_iCurrentSelection = 0;
            GetMgr().OnPreviousTab();
            HL_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_RBUMPER:
        case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_RIGHT:
        case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
        case class'UI_FxsInput'.const.FXS_KEY_D:
            m_iCurrentSelection = 0;
            GetMgr().OnNextTab();
            HL_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            cardData = GetMgr().ENGINEERINGUIGetItemCard();

            if (cardData.m_type != 0)
            {
                if (GetMgr().ISCONTROLLED() && GetMgr().SETUPMGR().IsInState('Base2_Engineering'))
                {
                    m_bSetCancelDisabled = true;
                    XComHeadquartersInput(`HQGAME.PlayerController.PlayerInput).m_bDisableCancel = false;
                }

                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                `HQPRES.UIItemCard(cardData);
            }
            else
            {
                PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            OnAccept("");
            PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_B:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
            OnCancel("");
            PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_START:
            return false;
        default:
            break;
    }

    return true;
}

function HL_RealizeSelected()
{
    GetMgr().m_iCurrentSelection = m_iCurrentSelection;
    HL_UpdateItemDesc(GetMgr().m_kTable.arrSummaries[m_iCurrentSelection]);
    AS_SetFocus(string(m_arrUIOptions[m_iCurrentSelection].iIndex));
}

function HL_UpdateItemDesc(TObjectSummary kSummary)
{
    local string infoText, Desc, ItemName;
    local HL_TItem kItem;
    local TText tTextItem;
    local int iReq, iSelectedItemState;

    kItem = `HL_ITEM(kSummary.ItemType);
    ItemName = "";
    infoText = "";
    Desc = "";

    iSelectedItemState = m_arrUIOptions[m_iCurrentSelection].iState;
    ItemName = class'UIUtilities'.static.GetHTMLColoredText(m_arrUIOptions[m_iCurrentSelection].strLabel, iSelectedItemState);

    if (kSummary.kCost.arrRequirements.Length > 0)
    {
        infoText $= class'UIUtilities'.static.GetHTMLColoredText(kSummary.txtRequirementsLabel.StrValue, kSummary.txtRequirementsLabel.iState) $ " ";

        for (iReq = 0; iReq < kSummary.kCost.arrRequirements.Length; iReq++)
        {
            tTextItem = kSummary.kCost.arrRequirements[iReq];
            infoText $= class'UIUtilities'.static.GetHTMLColoredText(tTextItem.StrValue, tTextItem.iState) $ "<br>";
        }
    }

    if (kSummary.txtSummary.StrValue != "")
    {
        if (iSelectedItemState == eUIState_Disabled)
        {
            Desc $= class'UIUtilities'.static.GetHTMLColoredText(kSummary.txtSummary.StrValue, eUIState_Disabled) $ "<br>";
        }
        else
        {
            Desc $= class'UIUtilities'.static.GetHTMLColoredText(kSummary.txtSummary.StrValue, kSummary.txtSummary.iState) $ "<br>";
        }
    }

    AS_UpdateInfo(ItemName, infoText, Desc, kItem.imagePath);
}

simulated function UpdateLayout()
{
    local int I;
    local ASValue kVal;
    local array<ASValue> arrData;
    local string optionText;
    local UIBuildItem.UIOption kOption;
    local int iTab;

    AS_SetLabels(GetMgr().m_kHeader.txtTitle.StrValue, m_strItemLabel, m_strQuantityLabel);

    for (iTab = 0; iTab < GetMgr().m_kTable.arrTabs.Length; iTab++)
    {
        AS_SetTabState(iTab, GetMgr().m_kTable.arrTabText[iTab].iState);
    }

    AS_SetSelectedCategory(GetMgr().m_kTable.m_iCurrentTab);
    Invoke("clear");

    for (I = 0; I < m_arrUIOptions.Length; I++)
    {
        kOption = m_arrUIOptions[I];

        if (kOption.iState == eUIState_Disabled)
        {
            optionText = class'UIUtilities'.static.GetHTMLColoredText(Caps(kOption.strLabel), eUIState_Bad);
        }
        else
        {
            optionText = class'UIUtilities'.static.GetHTMLColoredText(Caps(kOption.strLabel), kOption.iState);
        }

        kVal.Type = AS_String;
        kVal.S = optionText;
        arrData.AddItem(kVal);

        kVal.Type = AS_Number;
        kVal.N = float(kOption.iQuantity);
        arrData.AddItem(kVal);
    }

    Invoke("BatchAddOptions", arrData);
    HL_RealizeSelected();
    Show();
}