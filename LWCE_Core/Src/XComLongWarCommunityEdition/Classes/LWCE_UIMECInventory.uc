class LWCE_UIMECInventory extends UIMECInventory
    dependson(LWCE_XGCyberneticsUI);

simulated function XGCyberneticsUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGCyberneticsUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGCyberneticsUI', self, 3));
    }
    else
    {
        m_kLocalMgr.m_kInterface = self;
    }

    return m_kLocalMgr;
}

simulated function OnBuildNewMec()
{
    LWCE_XGCyberneticsUI(GetMgr()).RepairAll();
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local bool bHandled;
    local int iTargetCallback, iTargetOption;

    bHandled = true;
    iTargetOption = -1;
    iTargetCallback = -1;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_IN:
            iTargetCallback = int(Split(args[4], "option", true));

            if (iTargetCallback != m_hWidgetHelper.m_iCurrentWidget)
            {
                m_hWidgetHelper.SetSelected(iTargetCallback);
                LWCE_UpdateWidgetSelection(iTargetCallback != 1);
            }

            if (iTargetCallback == 1)
            {
                m_hWidgetHelper.SetListSelection(1, int(args[6]));
            }

            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
        case class'UI_FxsInput'.const.FXS_L_MOUSE_DOUBLE_UP:
            iTargetCallback = int(Split(args[4], "option", true));

            if (iTargetCallback == 1)
            {
                iTargetOption = int(args[6]);
            }

            m_hWidgetHelper.ProcessMouseEvent(iTargetCallback, iTargetOption);
            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

simulated function OnListSelection()
{
    if (LWCE_XGCyberneticsUI(GetMgr()).OnItemAccept(UIWidget_List(m_hWidgetHelper.GetWidget(1)).iCurrentSelection + 1))
    {
        Hide();
    }
}

simulated function OnListSelectionChanged(int NewIndex)
{
    LWCE_UpdateWidgetSelection();
}

simulated function ResetSelection(optional bool bSelectMecList)
{
    local UIWidget_List kMecList;

    bSelectMecList = false;
    kMecList = UIWidget_List(m_hWidgetHelper.GetWidget(1));

    if (bSelectMecList)
    {
        kMecList.m_bHasFocus = true;
        kMecList.iCurrentSelection = 0;
        m_hWidgetHelper.SetSelected(1);
    }
    else
    {
        if (!manager.IsMouseActive())
        {
            m_hWidgetHelper.SetSelected(0);
        }

        kMecList.iCurrentSelection = -1;
        m_hWidgetHelper.RefreshWidget(1);
        kMecList.m_bHasFocus = false;
    }

    LWCE_UpdateWidgetSelection();
}

protected simulated function UpdateData()
{
    local int Index;
    local string tmpStr;
    local LWCE_XGCyberneticsUI kMgr;
    local LWCE_TUIDamagedInventoryItem kDamagedItem;
    local UIWidget_Button kBuildMecButton;
    local UIWidget_List kMecList;

    kMgr = LWCE_XGCyberneticsUI(GetMgr());

    `HQPRES.GetStrategyHUD().AS_SetHumanResources(kMgr.m_kHeader.txtEngineers.strLabel, kMgr.m_kHeader.txtEngineers.StrValue);
    kDamagedItem = kMgr.m_arrRepairingItems[Index++];
    tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kMgr.m_strBuildNewMEC), kDamagedItem.iState);
    AS_SetBuildButtonHelp(tmpStr, LWCE_GetCosts(kDamagedItem));

    if (m_hWidgetHelper.GetWidget(0) == none)
    {
        kBuildMecButton = m_hWidgetHelper.NewButton();
    }
    else
    {
        kBuildMecButton = UIWidget_Button(m_hWidgetHelper.GetWidget(0));
    }

    if (kDamagedItem.iState == eUIState_Normal)
    {
        m_hWidgetHelper.EnableButton(0);
    }
    else
    {
        m_hWidgetHelper.DisableButton(0);
    }

    kBuildMecButton.__del_OnValueChanged__Delegate = OnBuildNewMec;
    m_hWidgetHelper.ClearWidget(1);

    if (m_hWidgetHelper.GetWidget(1) == none)
    {
        kMecList = m_hWidgetHelper.NewList();
    }
    else
    {
        kMecList = UIWidget_List(m_hWidgetHelper.GetWidget(1));
    }

    kMecList.del_OnValueChanged = OnListSelection;
    kMecList.del_OnSelectionChanged = OnListSelectionChanged;

    while (Index < kMgr.m_arrRepairingItems.Length)
    {
        kDamagedItem = kMgr.m_arrRepairingItems[Index++];
        tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kDamagedItem.strName), kDamagedItem.iState);
        kMecList.arrLabels.AddItem(tmpStr);
    }

    m_hWidgetHelper.RefreshAllWidgets();
    LWCE_UpdateWidgetSelection();
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local bool bHandled;

    bHandled = true;

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return false;
    }

    if (m_hWidgetHelper.OnUnrealCommand(Cmd, Arg))
    {
        if (b_IsFocused)
        {
            LWCE_UpdateWidgetSelection();
        }

        return true;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            OnCancel("");
            PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

protected function string LWCE_GetCosts(LWCE_TUIDamagedInventoryItem kDamagedItem)
{
    local int iCost;
    local string strCost;

    for (iCost = 0; iCost < kDamagedItem.arrCost.Length; iCost++)
    {
        if (kDamagedItem.arrCost[iCost].strLabel == "")
        {
            if (strCost == "")
            {
                strCost = kDamagedItem.strCostLabel @ class'UIUtilities'.static.GetHTMLColoredText(kDamagedItem.arrCost[iCost].StrValue, kDamagedItem.arrCost[iCost].iState);
            }
            else
            {
                strCost = strCost $ ", " $ class'UIUtilities'.static.GetHTMLColoredText(kDamagedItem.arrCost[iCost].StrValue, kDamagedItem.arrCost[iCost].iState);
            }
        }
        else
        {
            if (strCost == "")
            {
                strCost = kDamagedItem.strCostLabel @ class'UIUtilities'.static.GetHTMLColoredText(kDamagedItem.arrCost[iCost].StrValue @ kDamagedItem.arrCost[iCost].strLabel, kDamagedItem.arrCost[iCost].iState);
            }
            else
            {
                strCost = strCost $ ", " $ class'UIUtilities'.static.GetHTMLColoredText(kDamagedItem.arrCost[iCost].StrValue @ kDamagedItem.arrCost[iCost].strLabel, kDamagedItem.arrCost[iCost].iState);
            }
        }
    }

    return strCost;
}

protected simulated function LWCE_UpdateInfoPanelData()
{
    local int iMECIndex;
    local LWCE_TUIDamagedInventoryItem kDamagedItem;
    local string sName, strCost;

    if (m_hWidgetHelper.m_iCurrentWidget == 0)
    {
        iMECIndex = 0;
    }
    else
    {
        iMECIndex = UIWidget_List(m_hWidgetHelper.GetWidget(1)).iCurrentSelection + 1;
    }

    kDamagedItem = LWCE_XGCyberneticsUI(GetMgr()).m_arrRepairingItems[iMECIndex];
    sName = class'UIUtilities'.static.CapsCheckForGermanScharfesS(kDamagedItem.strName);
    strCost = LWCE_GetCosts(kDamagedItem);

    AS_SetBuildInfo("");

    if (iMECIndex == 0)
    {
        AS_UpdateInfo(sName, m_strDescBuildNewMec, "", "", "");
        AS_SetSoldier("", "");
    }
    else
    {
        AS_UpdateInfo(sName, strCost, "", "", "");
        AS_SetSoldier("", m_strMECUnequipped);
    }

    if (kDamagedItem.bCanRepair)
    {
        AS_SetConfirmButtonHelp(m_strButtonRepair);
    }
    else
    {
        AS_SetConfirmButtonHelp("");
    }
}

protected simulated function LWCE_UpdateWidgetSelection(optional bool bUpdateInfoPanel = true)
{
    if (m_hWidgetHelper.m_iCurrentWidget == 0)
    {
        Invoke("NewMecButtonSelected");
    }
    else
    {
        Invoke("NewMecButtonDeselected");
    }

    if (bUpdateInfoPanel)
    {
        LWCE_UpdateInfoPanelData();
    }
}