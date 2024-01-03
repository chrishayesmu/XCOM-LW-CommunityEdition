class LWCE_UIShipSummary extends UIShipSummary
    dependson(LWCETypes);

var LWCE_XGShip m_kCEShip;

var const localized string m_strManualRenameDialogTitle;
var const localized string m_strRenameDialogAccept;
var const localized string m_strRenameDialogCancel;
var const localized string m_strRenameDialogText;
var const localized string m_strRenameDialogTitle;

simulated function XGHangarUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGHangarUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGHangarUI', self, 1));
    }

    return m_kLocalMgr;
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local string callbackObj;

    if (Cmd == class'UI_FxsInput'.const.FXS_L_MOUSE_UP)
    {
        callbackObj = args[args.Length - 1];

        if (callbackObj == "weaponButton_0")
        {
            OnEditLoadout();
        }
        else if (callbackObj == "weaponButton_1")
        {
            OnDismissShip();
        }
        else if (callbackObj == "weaponButton_2")
        {
            OnRenameShip();
        }
    }

    return true;
}

simulated function OnRenameShip()
{
    local TDialogueBoxData kDialogData;

    kDialogData.eType = eDialog_Normal;
    kDialogData.strTitle = m_strRenameDialogTitle;
    kDialogData.strText = m_strRenameDialogText;
    kDialogData.strAccept = m_strRenameDialogAccept;
    kDialogData.strCancel = m_strRenameDialogCancel;
    kDialogData.fnCallback = OnRenameShipDialogueCallback;
    XComPresentationLayerBase(Owner).UIRaiseDialog(kDialogData);
}

function OnRenameShipDialogueCallback(EUIAction eAction)
{
    local TInputDialogData kData;

    if (eAction == eUIAction_Accept) // Manual rename
    {
        kData.fnCallback = OnKeyboardInputComplete;

        kData.strTitle = m_strManualRenameDialogTitle;
        kData.iMaxChars = 25;
        kData.strInputBoxText = m_kCEShip.GetCallsign();
        XComPresentationLayerBase(Owner).UIInputDialog(kData);
    }
    else if (eAction == eUIAction_Cancel) // Random name
    {
        `LWCE_HANGAR.AssignRandomCallsign(m_kCEShip);
        AS_SetShipName(m_kCEShip.m_strCallsign);
        `HQPRES.m_kShipList.m_bUpdateDataOnReceiveFocus = true;
    }
}

function OnKeyboardInputComplete(string Text)
{
    if (Text != "" && Text != m_kCEShip.GetCallsign())
    {
        m_kCEShip.SetCallsign(Text);
        AS_SetShipName(m_kCEShip.m_strCallsign);
        GetMgr().PlayGoodSound();
        `HQPRES.m_kShipList.m_bUpdateDataOnReceiveFocus = true;
    }
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local int newSelection;

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
            newSelection = m_iSelectedOption - 1;

            if (newSelection < 0)
            {
                newSelection = 2;
            }

            RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            newSelection = m_iSelectedOption + 1;

            if (newSelection > 2)
            {
                newSelection = 0;
            }

            RealizeSelected(newSelection);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            if (m_iSelectedOption == 0)
            {
                OnEditLoadout();
            }
            else if (m_iSelectedOption == 1)
            {
                OnDismissShip();
            }
            else
            {
                OnRenameShip();
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            OnCancel();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            OnWeaponItemCard();
            break;
        default:
            return false;
    }

    return true;
}

simulated function OnShipItemCard()
{
    local LWCE_TItemCard kCardData;

    if (`HQPRES.m_kItemCard != none)
    {
        return;
    }

    kCardData = LWCE_XGHangarUI(GetMgr()).LWCE_HANGARUIGetItemCard('', -1, eHangarView_ShipList);

    if (kCardData.iCardType != 0)
    {
        GetMgr().PlayGoodSound();

        if (`HQPRES.m_kItemCard == none)
        {
            `LWCE_HQPRES.LWCE_UIItemCard(kCardData);
        }
    }
    else
    {
        GetMgr().PlayBadSound();
    }
}

simulated function OnWeaponItemCard()
{
    local LWCE_TItemCard kCardData;

    if (`HQPRES.m_kItemCard != none)
    {
        return;
    }

    kCardData = LWCE_XGHangarUI(GetMgr()).LWCE_HANGARUIGetItemCard();

    if (kCardData.iCardType != 0)
    {
        GetMgr().PlayGoodSound();
        `LWCE_HQPRES.LWCE_UIItemCard(kCardData);
    }
    else
    {
        GetMgr().PlayBadSound();
    }
}

function UpdateData()
{
    local LWCEShipWeaponTemplate kPrimaryWeapon;
    local int shipStatusID;

    kPrimaryWeapon = `LWCE_SHIP_WEAPON(m_kCEShip.GetWeaponAtIndex(0));

    shipStatusID = eUIState_Normal;

    switch (m_kCEShip.GetStatus())
    {
        case eShipStatus_Ready:
            shipStatusID = eUIState_Good;
            break;
        case eShipStatus_Damaged:
        case eShipStatus_Repairing:
        case eShipStatus_Destroyed:
            shipStatusID = eUIState_Bad;
            break;
        case eShipStatus_Transfer:
        case eShipStatus_Rearming:
        case eShipStatus_Refuelling:
            shipStatusID = eUIState_Warning;
            break;
    }

    AS_SetShipName(m_kCEShip.m_strCallsign);
    AS_SetWeaponLabel(m_strWeaponLabel);
    AS_SetWeaponName(kPrimaryWeapon.strName);
    AS_SetShipStatus(class'UIUtilities'.static.GetHTMLColoredText(m_kCEShip.GetStatusString(), shipStatusID), shipStatusID);
    AS_SetKills(m_strKillsLabel @ m_kCEShip.m_iConfirmedKills);
    AS_SetWeaponImage(kPrimaryWeapon.ImagePath);
}