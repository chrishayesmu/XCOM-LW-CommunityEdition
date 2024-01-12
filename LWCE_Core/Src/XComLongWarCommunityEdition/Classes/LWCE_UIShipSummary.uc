class LWCE_UIShipSummary extends UIShipSummary
    dependson(LWCETypes);

var LWCE_XGShip m_kCEShip;

var const localized string m_strManualRenameDialogTitle;
var const localized string m_strRenameDialogAccept;
var const localized string m_strRenameDialogCancel;
var const localized string m_strRenameDialogText;
var const localized string m_strRenameDialogTitle;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

simulated function LWCE_Init(XComPlayerController _controller, UIFxsMovie _manager, LWCE_XGShip kShip)
{
    BaseInit(_controller, _manager);
    manager.LoadScreen(self);
    m_kNavBar = Spawn(class'UINavigationHelp', self);
    m_kNavBar.Init(_controller, _manager, self, UpdateButtonHelp);
    m_kCEShip = kShip;
}

simulated function GoToView(int iView)
{
    if (!b_IsInitialized)
    {
        return;
    }

    switch (iView)
    {
        case eHangarView_MainMenu:
        case eHangarView_Hire:
        case eHangarView_Transfer:
            break;
        case eHangarView_ShipList:
            if (XComPresentationLayerBase(Owner).IsInState('State_HangarShipSummary'))
            {
                `HQPRES.PopState();
            }

            break;
        case eHangarView_ShipSummary:
            Show();
            break;
        case eHangarView_Table:
            Hide();
            `LWCE_HQPRES.LWCE_UIHangarShipLoadout(m_kCEShip);
            break;
    }
}

simulated function OnDismissShip()
{
    local XGParamTag kTag;
    local TDialogueBoxData kData;

    if (m_kCEShip.GetStatus() == eShipStatus_OnMission || m_kCEShip.GetStatus() == eShipStatus_Transfer)
    {
        GetMgr().PlayBadSound();
        return;
    }
    else
    {
        GetMgr().PlayOpenSound();
    }

    kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    kTag.StrValue0 = m_kCEShip.GetCallsign();

    kData.eType = eDialog_Warning;
    kData.strTitle = m_strDismissShipBtnHelp;
    kData.strText = class'XComLocalizer'.static.ExpandString(m_strDismissShipConfirmDialogText);
    kData.strAccept = m_strDismissShipConfirmDialogAcceptText;
    kData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
    kData.fnCallback = OnDismissDialogConfirm;

    `HQPRES.UIRaiseDialog(kData);
}

simulated function OnEditLoadout()
{
    if (!LWCE_XGStrategyAI(GetMgr().AI()).IsXComBeingAttacked())
    {
        GetMgr().OnChangeWeapons();
    }
}

simulated function OnInit()
{
    super.OnInit();
    GetMgr().m_kShip = m_kCEShip;
    UpdateData();
    `HQPRES.GetStrategyHUD().ShowBackButton(OnMouseCancel);

    if (!manager.IsMouseActive())
    {
        RealizeSelected(0);
    }
}

simulated function XGHangarUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGHangarUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGHangarUI', self, 1));
    }

    return m_kLocalMgr;
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

simulated function OnLoseFocus()
{
    // LWCE issue #75: hide the ship summary screen while an item/ship card is open, so it's not interactable
    super(UI_FxsPanel).OnLoseFocus();
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ClearButtonHelp();
    Hide();
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

function UpdateButtonHelp()
{
    local bool bIsXComAttackImminent, bCanEditLoadout, bCanDismissShip;

    bIsXComAttackImminent = LWCE_XGStrategyAI(GetMgr().AI()).IsXComBeingAttacked();
    bCanEditLoadout = !bIsXComAttackImminent && (m_kCEShip.GetStatus() == eShipStatus_Repairing || m_kCEShip.GetStatus() == eShipStatus_Ready);
    bCanDismissShip = m_kCEShip.GetStatus() != eShipStatus_Transfer && m_kCEShip.GetStatus() != eShipStatus_OnMission;

    m_kNavBar.ClearButtonHelp();

    if (manager.IsMouseActive())
    {
        m_kNavBar.AddLeftHelp(m_strWeaponInfoBtnHelp, "", OnMouseWeaponInfo);
        m_kNavBar.AddRightHelp(m_strShipInfoBtnHelp, "", OnMouseShipInfo);
    }
    else
    {
        m_kNavBar.AddRightHelp(m_strWeaponInfoBtnHelp, "Icon_LSCLICK_L3", OnMouseWeaponInfo);
    }

    AS_SetWeaponHelp(0, m_strEditLoadoutBtnHelp, class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon(), !bCanEditLoadout);
    AS_SetWeaponHelp(1, m_strDismissShipBtnHelp, class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon(), !bCanDismissShip);
    AS_SetWeaponHelp(2, m_strDismissShipConfirmDialogTitle, class'UI_FxsGamepadIcons'.static.GetAdvanceButtonIcon(), false);

    if (!manager.IsMouseActive())
    {
        RealizeSelected(0);
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