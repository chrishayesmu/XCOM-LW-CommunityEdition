class LWCE_UIShipList extends UIShipList
    dependson(LWCETypes, LWCE_XGFacility_Hangar);

var private LWCE_XGShip m_kCESelectedShip;
var bool m_bHideOnLoseFocus;

simulated function GoToView(int iView)
{
    if (!b_IsInitialized)
    {
        return;
    }

    m_iView = iView;

    switch (iView)
    {
        case eHangarView_MainMenu:
            `HQPRES.PopState();
            break;
        case eHangarView_ShipList:
            m_bTransferingShip = false;
            UpdateData();
            Show();
            break;
        case eHangarView_Hire:
            XComHQPresentationLayer(controllerRef.m_Pres).UIHangarHiring();
            break;
        case eHangarView_Transfer:
            m_bTransferingShip = true;
            m_iContinentTransferingTo = -1;
            LWCE_UpdateButtonHelpOnSelectedItem();

            if (manager.IsMouseActive())
            {
                AS_InitializeShipTransfer(m_strCancelTransferButtonHelp, m_strTransferShipHereButtonHelp);
            }
            else
            {
                AS_InitializeShipTransfer();
            }

            m_iContinentTransferingFrom = m_iSelectedContinent;
            LWCE_RealizeSelected();
            break;
        case eHangarView_ShipSummary:
            `LWCE_HQPRES.LWCE_UIHangarShipSummary(m_kCESelectedShip);
            Hide();
            break;
    }
}

/// <summary>
/// Checks if any continent (other than the currently selected one) has hangar space for a ship.
/// </summary>
simulated function bool HangarSlotAvailable()
{
    local int I;
    local LWCE_XGHangarUI kMgr;

    kMgr = LWCE_XGHangarUI(GetMgr());

    for (I = 0; I < kMgr.m_arrCEContinents.Length; I++)
    {
        if (I == m_iSelectedContinent)
        {
            continue;
        }

        if (kMgr.m_arrCEContinents[I].iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
        {
            return true;
        }
    }

    return false;
}

simulated function bool OnAccept(optional string selectedOption = "")
{
    local LWCE_XGHangarUI kMgr;
    local int selectedContinentNumShips;

    kMgr = LWCE_XGHangarUI(GetMgr());
    selectedContinentNumShips = kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips;

    if (m_bTransferingShip)
    {
        if (m_iContinentTransferingTo != -1)
        {
            TransferShip();
        }
        else
        {
            kMgr.PlayBadSound();
        }
    }
    else
    {
        kMgr.OnChooseCraft(m_iSelectedContinent, m_iSelectedShip);
    }

    if (kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips != selectedContinentNumShips)
    {
        UpdateData();
    }

    return true;
}

simulated function OnCommand(string Cmd, string Arg)
{
    if (Cmd == "HangarsLoaded")
    {
        LWCE_RealizeSelected();
    }
}

function OnDeactivate()
{
    m_kLocalMgr.OnDeactivate();
    m_kCESelectedShip = none;
    `HQPRES.GetStrategyHUD().ClearFacilityPanels();
}

simulated function OnLoseFocus()
{
    if (m_bHideOnLoseFocus)
    {
        m_bHideOnLoseFocus = false;

        // LWCE issue #75: hide the ship list screen while a ship card is open, so it's not interactable
        super(UI_FxsPanel).OnLoseFocus();
        XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ClearButtonHelp();
        Hide();
    }
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local LWCE_XGHangarUI kMgr;
    local LWCE_TContinentInfo kContinentInfo;
    local int I;
    local string S, callbackObj;
    local bool bHandled, bIsSelectingEmptySlot, bClickingOnShipBeingTransferred, bClickingOnPendingShip;

    if (Cmd != class'UI_FxsInput'.const.FXS_L_MOUSE_UP)
    {
        return false;
    }

    kMgr = LWCE_XGHangarUI(GetMgr());

    bHandled = true;

    for (I = 0; I < args.Length; I++)
    {
        S = args[I];

        if (InStr(S, "option") != INDEX_NONE)
        {
            S -= "option";
            m_iSelectedContinent = int(S);
        }
        else if (InStr(S, "theItems") != INDEX_NONE)
        {
            S = args[I + 1];
            m_iSelectedShip = int(S);
        }
    }

    LWCE_RealizeSelected();
    callbackObj = args[args.Length - 1];
    kContinentInfo = kMgr.m_arrCEContinents[m_iSelectedContinent];
    bClickingOnPendingShip = m_iSelectedShip >= kContinentInfo.arrShips.Length;
    bIsSelectingEmptySlot = kContinentInfo.iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent && m_iSelectedShip == kContinentInfo.iNumShips;

    if (!bIsSelectingEmptySlot && !bClickingOnPendingShip)
    {
        m_kCESelectedShip = kContinentInfo.arrShips[m_iSelectedShip];
    }

    switch (callbackObj)
    {
        case "theButton":
            if (m_bTransferingShip)
            {
                if (bIsSelectingEmptySlot && m_iSelectedContinent != m_iContinentTransferingFrom)
                {
                    m_iContinentTransferingTo = m_iSelectedContinent;
                    TransferShip();
                }
                else
                {
                    kMgr.PlayBadSound();
                }
            }
            else
            {
                OnAccept();
                kMgr.PlayGoodSound();
            }

            break;
        case "clickableButton":
            if (m_bTransferingShip)
            {
                bClickingOnShipBeingTransferred = m_iContinentTransferingFrom == m_iSelectedContinent;

                if (bClickingOnShipBeingTransferred)
                {
                    OnCancel();
                }
                else if (bIsSelectingEmptySlot && m_iSelectedContinent != m_iContinentTransferingFrom)
                {
                    m_iContinentTransferingTo = m_iSelectedContinent;
                    TransferShip();
                    kMgr.PlayGoodSound();
                }
            }
            else if (bIsSelectingEmptySlot || bClickingOnPendingShip)
            {
                OnAccept();
                kMgr.PlayGoodSound();
            }
            else
            {
                OnTransferInterceptor();
            }

            break;
        default:
            bHandled = false;
    }

    return bHandled;
}

simulated function OnTransferDialogConfirm(EUIAction eAction)
{
    local LWCE_XGHangarUI kMgr;

    kMgr = LWCE_XGHangarUI(GetMgr());

    if (eAction == eUIAction_Accept)
    {
        m_iSelectedContinent = m_iContinentTransferingTo;
        m_iSelectedShip = kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips;
        kMgr.OnChooseTransferInterceptor(m_iContinentTransferingTo);
    }
    else
    {
        kMgr.OnLeaveTransferInterceptor();
    }
}

/// <summary>
/// Called when the player first indicates that they want to transfer a ship.
/// </summary>
simulated function OnTransferInterceptor()
{
    local int I;
    local bool bCanTransfer, bIsXComAttackImminent;
    local TDialogueBoxData kData;
    local LWCE_XGHangarUI kMgr;
    local LWCE_XGStrategyAI kAI;

    kMgr = LWCE_XGHangarUI(GetMgr());
    kAI = LWCE_XGStrategyAI(kMgr.AI());

    if (m_kCESelectedShip == none)
    {
        return;
    }

    bIsXComAttackImminent = kAI.IsXComBeingAttacked();

    if (bIsXComAttackImminent)
    {
        bCanTransfer = false;
    }
    else
    {
        // Just check if there's any other continent with open hangar space
        for (I = 0; I < kMgr.m_arrCEContinents.Length; I++)
        {
            if (I == m_iSelectedContinent)
            {
                continue;
            }

            if (kMgr.m_arrCEContinents[I].iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
            {
                bCanTransfer = true;
                break;
            }
        }
    }

    if (bCanTransfer)
    {
        kMgr.m_kShip = m_kCESelectedShip;
        kMgr.OnTransferInterceptor();
    }
    else
    {
        kData.strTitle = "";
        kData.strText = bIsXComAttackImminent ? m_strHangarsFullDialogTitle : m_strHangarsFullDialogText;
        kData.strCancel = "";
        `HQPRES.UIRaiseDialog(kData);
    }
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local bool bHandled;
    local LWCE_TItemCard cardData;
    local LWCE_XGHangarUI kMgr;

    kMgr = LWCE_XGHangarUI(GetMgr());

    if (m_iView != eHangarView_ShipList && m_iView != eHangarView_Transfer)
    {
        return false;
    }

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return false;
    }

    bHandled = true;

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            LWCE_AlterSelection(-1);
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            LWCE_AlterSelection(1);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            OnAccept();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            OnCancel();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_SQUARE:
        case class'UI_FxsInput'.const.FXS_KEY_X:
            if (!m_bTransferingShip)
            {
                OnTransferInterceptor();
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_TRIANGLE:
        case class'UI_FxsInput'.const.FXS_KEY_Y:
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            if (!m_bTransferingShip || m_iContinentTransferingTo == -1)
            {
                cardData = kMgr.LWCE_HANGARUIGetItemCard(kMgr.m_arrCEContinents[m_iSelectedContinent].nmContinent, m_iSelectedShip);

                if (cardData.iCardType != 0)
                {
                    m_bHideOnLoseFocus = true;

                    kMgr.PlayGoodSound();
                    `LWCE_HQPRES.LWCE_UIItemCard(cardData);
                }
                else
                {
                    kMgr.PlayBadSound();
                }
            }
            else
            {
                kMgr.PlayBadSound();
            }

            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

/// <summary>
/// Displays a dialog asking the player to confirm that they wish to transfer a ship.
/// </summary>
simulated function TransferShip()
{
    local LWCE_XGHangarUI kMgr;
    local XGParamTag kTag;
    local TDialogueBoxData kData;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    kTag.StrValue0 = m_kCESelectedShip.GetCallsign();
    kTag.StrValue1 = kMgr.m_arrCEContinents[m_iContinentTransferingFrom].strContinentName.StrValue;
    kTag.StrValue2 = kMgr.m_arrCEContinents[m_iContinentTransferingTo].strContinentName.StrValue;
    kTag.IntValue0 = class'XGTacticalGameCore'.default.INTERCEPTOR_TRANSFER_TIME / 1;

    kData.strTitle = m_strConfirmTransferDialogTitle;
    kData.strText = class'XComLocalizer'.static.ExpandString(m_strConfirmTransferDialogText);
    kData.strAccept = m_strConfirmTransferDialogAcceptText;
    kData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;

    kData.fnCallback = OnTransferDialogConfirm;

    `HQPRES.UIRaiseDialog(kData);
}

protected simulated function LWCE_AlterSelection(int Direction)
{
    local bool bFound;
    local int iCurrContinent, iCurrShip;
    local LWCE_XGHangarUI kMgr;

    kMgr = LWCE_XGHangarUI(GetMgr());

    if (m_bTransferingShip)
    {
        bFound = false;

        if (m_iContinentTransferingTo == -1)
        {
            m_iContinentTransferingTo = m_iSelectedContinent;
        }

        iCurrContinent = m_iContinentTransferingTo;
        iCurrContinent += Direction;
        class'UIUtilities'.static.ClampIndexToArrayRange(kMgr.m_arrCEContinents.Length, iCurrContinent);

        if (iCurrContinent == m_iSelectedContinent)
        {
            m_iContinentTransferingTo = -1;
            bFound = true;
        }
        else if (kMgr.m_arrCEContinents[iCurrContinent].iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
        {
            m_iContinentTransferingTo = iCurrContinent;
            iCurrShip = kMgr.m_arrCEContinents[iCurrContinent].iNumShips;
            bFound = true;
        }

        if (bFound)
        {
            kMgr.PlayScrollSound();

            if (m_iContinentTransferingTo == -1)
            {
                LWCE_RealizeSelected();
            }
            else
            {
                LWCE_RealizeSelected(m_iContinentTransferingTo, iCurrShip);
            }
        }
        else
        {
            kMgr.PlayBadSound();
        }
    }
    else
    {
        m_iSelectedShip += Direction;

        if (m_iSelectedShip == class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent || m_iSelectedShip > kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips)
        {
            m_iSelectedContinent++;
            class'UIUtilities'.static.ClampIndexToArrayRange(kMgr.m_arrCEContinents.Length, m_iSelectedContinent);
            m_iSelectedShip = 0;
        }
        else if (m_iSelectedShip < 0)
        {
            m_iSelectedContinent--;
            class'UIUtilities'.static.ClampIndexToArrayRange(kMgr.m_arrCEContinents.Length, m_iSelectedContinent);

            if (kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips == class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
            {
                m_iSelectedShip = kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips - 1;
            }
            else
            {
                m_iSelectedShip = kMgr.m_arrCEContinents[m_iSelectedContinent].iNumShips;
            }
        }

        kMgr.PlayScrollSound();
        LWCE_RealizeSelected();
    }
}

protected function LWCE_RealizeSelected(optional int iContinentOverride = -1, optional int iShipOverride = -1)
{
    AS_SetSelection(iContinentOverride != -1 ? iContinentOverride : m_iSelectedContinent, iShipOverride != -1 ? iShipOverride : m_iSelectedShip);
    LWCE_UpdateButtonHelpOnSelectedItem();
}

protected simulated function LWCE_UpdateButtonHelpOnSelectedItem()
{
    local LWCE_XGHangarUI kMgr;
    local LWCE_TContinentInfo kContinentInfo;
    local string strHelpTxt;
    local bool bCanSelect, bCanTransfer;
    local int iShipIndex;

    kMgr = LWCE_XGHangarUI(GetMgr());

    AS_SetMoreInfoHotlink();

    if (m_bTransferingShip)
    {
        strHelpTxt = class'UI_FxsGamepadIcons'.static.HTML_BODYFONT("Icon_DPAD_VERTICAL") $ m_strTransferShipUpDownNavigationHelp;

        if (m_iContinentTransferingTo == -1)
        {
            if (!manager.IsMouseActive())
            {
                AS_UpdateShipHelp(m_iSelectedContinent, m_iSelectedShip, strHelpTxt);
                AS_SetMoreInfoHotlink(m_strMoreInfoHotlinkLabel, "Icon_LSCLICK_L3");
            }
        }
        else
        {
            iShipIndex = kMgr.m_arrCEContinents[m_iContinentTransferingTo].iNumShips;

            if (!manager.IsMouseActive())
            {
                AS_UpdateShipHelp(m_iContinentTransferingTo, iShipIndex, strHelpTxt);
                strHelpTxt = class'UI_FxsGamepadIcons'.static.HTML_BODYFONT(class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon()) $ class'UIUtilities'.static.GetHTMLColoredText(m_strTransferShipHereButtonHelp, 0) $ " ";
                AS_UpdateShipStatusHelp(m_iContinentTransferingTo, iShipIndex, strHelpTxt);
            }
        }

        `HQPRES.GetStrategyHUD().ShowBackButton(OnMouseCancel, m_strCancelTransferButtonHelp);
        return;
    }

    `HQPRES.GetStrategyHUD().ShowBackButton(OnMouseCancel);
    kContinentInfo = kMgr.m_arrCEContinents[m_iSelectedContinent];

    if (kContinentInfo.iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent && m_iSelectedShip == kContinentInfo.iNumShips)
    {
        m_kCESelectedShip = none;
        strHelpTxt = class'UI_FxsGamepadIcons'.static.HTML_BODYFONT(class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon()) $ m_strHireShipButtonHelp;

        if (!manager.IsMouseActive())
        {
            AS_UpdateShipHelp(m_iSelectedContinent, m_iSelectedShip, strHelpTxt);
        }

        return;
    }
    else if (m_iSelectedShip >= kContinentInfo.arrShips.Length)
    {
        m_kCESelectedShip = none;

        if (!manager.IsMouseActive())
        {
            if (m_iSelectedShip >= (kContinentInfo.arrShips.Length + kContinentInfo.m_arrShipOrderIndexes.Length))
            {
                strHelpTxt = "";
                AS_UpdateShipHelp(m_iSelectedContinent, m_iSelectedShip, strHelpTxt);
            }
            else
            {
                strHelpTxt = class'UI_FxsGamepadIcons'.static.HTML_BODYFONT(class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon()) $ class'UIUtilities'.static.GetHTMLColoredText(m_strCancelHireButtonHelp, eUIState_Bad);
                AS_UpdateShipHelp(m_iSelectedContinent, m_iSelectedShip, strHelpTxt);
            }
        }
    }
    else
    {
        m_kCESelectedShip = kContinentInfo.arrShips[m_iSelectedShip];
        bCanSelect = true;
        bCanTransfer = true;
        strHelpTxt = "";

        // TODO why would this ever be < 0? is this enforcing damaged/refueling ships somehow or is that elsewhere?
        if (m_kCESelectedShip.GetStatus() < 0 || !HangarSlotAvailable())
        {
            bCanTransfer = false;
        }

        if (bCanSelect)
        {
            strHelpTxt $= class'UI_FxsGamepadIcons'.static.HTML_BODYFONT(class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon()) $ class'UIUtilities'.static.GetHTMLColoredText(m_strViewShipButtonHelp, eUIState_Normal) $ " ";
        }

        if (bCanTransfer)
        {
            strHelpTxt $= class'UI_FxsGamepadIcons'.static.HTML_BODYFONT("Icon_X_SQUARE") $ class'UIUtilities'.static.GetHTMLColoredText(m_strTransferShipButtonHelp, eUIState_Normal);
        }

        if (!manager.IsMouseActive())
        {
            AS_UpdateShipHelp(m_iSelectedContinent, m_iSelectedShip, strHelpTxt);
            AS_SetMoreInfoHotlink(m_strMoreInfoHotlinkLabel, "Icon_LSCLICK_L3");
        }
    }
}

protected simulated function UpdateData()
{
    local int iContinentIndex, iOrderIndex, I, iDays, iStatusState, iShipState, iShipType;
    local string strContinentCapacity, tmpStr;
    local name nmResultingShip;
    local XGParamTag kTag;
    local LWCEItemTemplateManager kItemTemplateMgr;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGHangarUI kMgr;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;
    local LWCE_TContinentInfo kContinentInfo;
    local LWCE_TShipOrder kOrderInfo;
    local LWCE_TItemProject kProject;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kItemTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;
    kMgr = LWCE_XGHangarUI(GetMgr());
    kHQ = LWCE_XGHeadquarters(kMgr.HQ());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    Invoke("ClearAll");

    for (iContinentIndex = 0; iContinentIndex < kMgr.m_arrCEContinents.Length; iContinentIndex++)
    {
        kContinentInfo = kMgr.m_arrCEContinents[iContinentIndex];
        strContinentCapacity = "(" $ kContinentInfo.iNumShips $ "/" $ class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent $ ")";

        for (I = 0; I < kContinentInfo.arrShips.Length; I++)
        {
            kShip = kContinentInfo.arrShips[I];
            iShipState = eUIState_Normal;
            iStatusState = eUIState_Good;

            switch (kShip.GetStatus())
            {
                case eShipStatus_Damaged:
                case eShipStatus_Repairing:
                case eShipStatus_Destroyed:
                    iShipState = eUIState_Disabled;
                    iStatusState = eUIState_Bad;
                    break;
                case eShipStatus_Transfer:
                case eShipStatus_Rearming:
                case eShipStatus_Refuelling:
                    iShipState = eUIState_Disabled;
                    iStatusState = eUIState_Warning;
                    break;
            }

            if (manager.IsMouseActive() && (kShip.GetStatus() == eShipStatus_Ready || kShip.GetStatus() == eShipStatus_Repairing))
            {
                AS_AddShip(iContinentIndex, "<img src='img:///" $ (kShip.IsType('Interceptor') ? "LongWar.Icons.IC_Raven" : "LongWar.Icons.IC_Firestorm") $ "' height='16' width='16'>" $ kShip.m_strCallsign, "          " $ kShip.GetWeaponString(), class'UIUtilities'.static.GetHTMLColoredText(kShip.GetStatusString(), iStatusState), m_bTransferingShip ? m_strCancelTransferButtonHelp : m_strTransferShipButtonHelp, iShipState);
            }
            else
            {
                AS_AddShip(iContinentIndex, "<img src='img:///" $ (kShip.IsType('Interceptor') ? "LongWar.Icons.IC_Raven" : "LongWar.Icons.IC_Firestorm") $ "' height='16' width='16'>" $ kShip.m_strCallsign, "          " $ kShip.GetWeaponString(), class'UIUtilities'.static.GetHTMLColoredText(kShip.GetStatusString(), iStatusState), "", iShipState);
            }
        }

        foreach kContinentInfo.m_arrShipOrderIndexes(iOrderIndex)
        {
            kOrderInfo = kHQ.m_arrCEShipOrders[iOrderIndex];
            iDays = kOrderInfo.iHours / 24;

            if ((kOrderInfo.iHours % 24) > 0)
            {
                iDays += 1;
            }

            kTag.StrValue0 = string(iDays);
            tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strPendingOrderRemainingDays), eUIState_Warning);

            for (I = 0; I < kOrderInfo.iNumShips; I++)
            {
                // The Flash layer apparently expects a ship type, so for now, everything is interceptors or firestorms. It's not clear what the
                // ship type actually does, if anything.
                iShipType = kOrderInfo.nmShipType == 'Interceptor' ? eShip_Interceptor : eShip_Firestorm;

                if (manager.IsMouseActive())
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingInterceptorInfo, tmpStr, I == 0 ? m_strCancelHireButtonHelp : "", iShipType);
                }
                else
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingInterceptorInfo, tmpStr, "", iShipType);
                }
            }
        }

        if (kContinentInfo.nmContinent == kHQ.m_nmContinent)
        {
            kMgr.m_arrCEShipProjects.Length = 0;

            foreach kEngineering.m_arrCEItemProjects(kProject)
            {
                nmResultingShip = kItemTemplateMgr.FindItemTemplate(kProject.ItemName).nmResultingShip;

                if (nmResultingShip == '')
                {
                    continue;
                }

                iDays = kEngineering.LWCE_GetItemProjectHoursRemaining(kProject) / 24;

                if ((kProject.iHoursLeft % 24) > 0)
                {
                    iDays += 1;
                }

                kTag.StrValue0 = string(iDays);
                tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strPendingOrderRemainingDays), eUIState_Warning);

                kMgr.m_arrCEShipProjects.AddItem(kProject);

                for (I = 0; I < kProject.iQuantity; I++)
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingFirestormInfo, tmpStr, "", eShip_Firestorm);
                }
            }
        }

        if (kContinentInfo.iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
        {
            if (manager.IsMouseActive())
            {
                AS_AddShip(iContinentIndex, m_strEmptySlotLabel, "", "", m_bTransferingShip ? m_strTransferShipHereButtonHelp : m_strHireShipButtonHelp, -1);
            }
            else
            {
                AS_AddShip(iContinentIndex, m_strEmptySlotLabel, "", "", "", -1);
            }

            AS_SetContinentTitle(iContinentIndex, kContinentInfo.strContinentName.StrValue @ strContinentCapacity);
        }
        else
        {
            tmpStr = class'UIUtilities'.static.GetHTMLColoredText(strContinentCapacity @ m_strFullContinentLabel, eUIState_Bad);
            AS_SetContinentTitle(iContinentIndex, kContinentInfo.strContinentName.StrValue @ tmpStr);
        }
    }
}