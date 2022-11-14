class LWCE_UIBuildItem extends UIBuildItem
    dependson(LWCETypes);

simulated function XGEngineeringUI GetMgr()
{
    return XGEngineeringUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGEngineeringUI', self, 1));
}

simulated function OnMouseAccept()
{
    local LWCE_TItemCard kCardData;

    kCardData = LWCE_XGEngineeringUI(GetMgr()).LWCE_ENGINEERINGUIGetItemCard();

    if (kCardData.iCardType != 0)
    {
        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
        `LWCE_HQPRES.LWCE_UIItemCard(kCardData);
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
                LWCE_RealizeSelected();
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
                    LWCE_RealizeSelected();
                    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                    return true;
                }
            }

            iCat = int(Split(args[args.Length - 1], "cat", true));

            if (iCat != -1)
            {
                m_iCurrentSelection = 0;
                GetMgr().OnTab(iCat);
                LWCE_RealizeSelected();

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

            LWCE_RealizeSelected();

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

            LWCE_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_LBUMPER:
        case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_LEFT:
        case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
        case class'UI_FxsInput'.const.FXS_KEY_A:
            m_iCurrentSelection = 0;
            GetMgr().OnPreviousTab();
            LWCE_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_RBUMPER:
        case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_RIGHT:
        case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
        case class'UI_FxsInput'.const.FXS_KEY_D:
            m_iCurrentSelection = 0;
            GetMgr().OnNextTab();
            LWCE_RealizeSelected();

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            cardData = GetMgr().ENGINEERINGUIGetItemCard();

            if (cardData.m_type != 0)
            {
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

function LWCE_RealizeSelected()
{
    local LWCE_XGEngineeringUI kMgr;

    kMgr = LWCE_XGEngineeringUI(GetMgr());

    kMgr.m_iCurrentSelection = m_iCurrentSelection;
    LWCE_UpdateItemDesc(kMgr.m_kCETable.arrSummaries[m_iCurrentSelection]);
    AS_SetFocus(string(m_arrUIOptions[m_iCurrentSelection].iIndex));
}

simulated function UpdateData()
{
    local LWCE_XGEngineeringUI kMgr;
    local UIBuildItem.UIOption kOption;
    local TTableMenuOption tMnuOption;
    local TTableMenu tMnu;
    local TEngHeader kHeader;
    local int I;

    m_arrUIOptions.Length = 0;

    kMgr = LWCE_XGEngineeringUI(GetMgr());
    tMnu = kMgr.m_kCETable.mnuItems;

    for (I = 0; I < tMnu.arrOptions.Length; I++)
    {
        tMnuOption = tMnu.arrOptions[I];
        kOption.iIndex = I;
        kOption.strLabel = Caps(tMnuOption.arrStrings[0]);
        kOption.iQuantity = int(tMnuOption.arrStrings[1]);
        kOption.iState = tMnuOption.iState;
        kOption.strHelp = tMnuOption.strHelp;
        m_arrUIOptions.AddItem(kOption);
    }

    kHeader = kMgr.m_kHeader;
    XComHQPresentationLayer(controllerRef.m_Pres).GetStrategyHUD().AS_SetHumanResources(kHeader.txtEngineers.strLabel, kHeader.txtEngineers.StrValue);
    UpdateLayout();
}

function LWCE_UpdateItemDesc(LWCE_TObjectSummary kSummary)
{
    local string infoText, Desc, ItemName;
    local LWCEItemTemplate kItem;
    local TText tTextItem;
    local int iReq, iSelectedItemState;

    kItem = `LWCE_ITEM(kSummary.ItemType);
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

    AS_UpdateInfo(ItemName, infoText, Desc, kItem.ImagePath);
}

simulated function UpdateLayout()
{
    local LWCE_XGEngineeringUI kMgr;
    local ASValue kVal;
    local UIBuildItem.UIOption kOption;
    local array<ASValue> arrData;
    local string optionText;
    local int Index;

    kMgr = LWCE_XGEngineeringUI(GetMgr());

    AS_SetLabels(kMgr.m_kHeader.txtTitle.StrValue, m_strItemLabel, m_strQuantityLabel);

    for (Index = 0; Index < kMgr.m_kCETable.arrTabs.Length; Index++)
    {
        AS_SetTabState(Index, kMgr.m_kCETable.arrTabText[Index].iState);
    }

    AS_SetSelectedCategory(kMgr.m_kCETable.m_iCurrentTab);
    Invoke("clear");

    for (Index = 0; Index < m_arrUIOptions.Length; Index++)
    {
        kOption = m_arrUIOptions[Index];

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
    LWCE_RealizeSelected();
    Show();
}