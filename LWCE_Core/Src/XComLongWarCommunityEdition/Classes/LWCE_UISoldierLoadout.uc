class LWCE_UISoldierLoadout extends UISoldierLoadout
    dependson(LWCE_XGSoldierUI);

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    local LWCE_XGSoldierUI kMgr;
    local int iView;

    BaseInit(_controllerRef, _manager, OnFlashCommand);
    iView = 5;
    m_kSoldier = kSoldier;

    if (!XComHQPresentationLayer(controllerRef.m_Pres).IsMgrRegistered(class'LWCE_XGSoldierUI'))
    {
        kMgr = Spawn(class'LWCE_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
        kMgr.m_kInterface = self;
        kMgr.m_kSoldier = kSoldier;

        XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);
        kMgr.Init(iView);
        m_kLocalMgr = kMgr;
    }

    kMgr = LWCE_XGSoldierUI(GetMgr());

    kMgr.m_kCELocker.bIsSelected = false;

    m_kSoldierHeader = Spawn(class'LWCE_UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kAbilityList = Spawn(class'LWCE_UIStrategyComponent_SoldierAbilityList', self);
    m_kAbilityList.Init(GetMgr(), _controllerRef, _manager, self);

    m_iLockerSelectionWatchHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariableStructMember(GetMgr(), 'm_kCELocker', 'bIsSelected', self, ListFocusUpdated);

    foreach AllActors(class'SkeletalMeshActor', m_kCameraRig)
    {
        if (m_kCameraRig.Tag == 'UICameraRig_SoldierLoadout')
        {
            m_kCameraRigDefaultLocation = m_kCameraRig.Location;
            break;
        }
    }

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSoldierUI', self));
    }

    return m_kLocalMgr;
}

simulated function GFxObject GetMecArmorIconsArray(int iArmorItem)
{
    // Long War made most of this function not fire, but it still contains a deprecated function call
    // so we just boil it down to this
    return manager.CreateArray();
}

simulated function ListFocusUpdated()
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (!kMgr.m_kCELocker.bIsSelected)
    {
        Invoke("HighlightInventoryList");
    }
    else
    {
        Invoke("HighlightLockerList");
    }

    if (kMgr.m_kCEGear.bDataDirty)
    {
        kMgr.m_kCEGear.bDataDirty = false;
        UpdateData();
    }
}

simulated function NextSoldier()
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (`HQPRES.m_kSoldierSummary.NextSoldier(true))
    {
        kMgr.m_kCEGear.iHighlight = 0;
        kMgr.m_kCELocker.iHighlight = 0;
        kMgr.m_kCELocker.bIsSelected = false;

        UpdateData();

        m_kSoldierStats.UpdateData();
        m_kSoldierHeader.m_kSoldier = kMgr.m_kSoldier;
        m_kSoldierHeader.UpdateData();
        m_kAbilityList.UpdateData();
    }
}

simulated function OnFlashCommand(string Cmd, string Arg)
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (Cmd == "InventoryItemsLoaded")
    {
        LWCE_RealizeSelected();
    }
    else if (Cmd == "LockerMouseSelectionChanged")
    {
        kMgr.m_kCELocker.bIsSelected = true;
        kMgr.m_kCELocker.iHighlight = int(Arg);
    }
    else if (Cmd == "InventoryMouseSelectionChanged")
    {
        kMgr.m_kCELocker.bIsSelected = false;
    }
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local string targetList;
    local bool bInventory, bLocker;
    local int iTargetItem;
    local LWCE_XGSoldierUI kMgr;

    // Only interested in mouse up events, consume the rest
    if (Cmd != class'UI_FxsInput'.const.FXS_L_MOUSE_UP)
    {
        return true;
    }

    kMgr = LWCE_XGSoldierUI(GetMgr());
    targetList = args[4];
    bInventory = targetList == "inventoryListMC";
    bLocker = targetList == "lockerListMC";

    if (bInventory)
    {
        kMgr.m_kCELocker.bIsSelected = false;
        kMgr.m_kCEGear.iHighlight = int(args[6]);

        if (args[args.Length - 1] == "clickableButton0")
        {
            ShowItemCard();
        }
        else if (args[args.Length - 1] == "clickableButton1")
        {
            OnUnequip();
        }
        else if (args[args.Length - 1] == "hitAreaMC")
        {
            iTargetItem = int(args[args.Length - 2]);

            if (kMgr.m_kCELocker.bIsSelected)
            {
                OnCancel();
            }

            kMgr.OnClickGear(iTargetItem);
            OnAccept();
            RealizeSelected_Inventory();
            UpdateLockerList(kMgr.m_kCEGear.iHighlight);
            ListFocusUpdated();
        }
    }
    else if (bLocker)
    {
        kMgr.m_kCELocker.bIsSelected = true;
        kMgr.m_kCELocker.iHighlight = int(args[6]);

        if (args[args.Length - 1] == "clickableButton0")
        {
            ShowItemCard();
        }
        else if (args[args.Length - 1] == "hitAreaMC")
        {
            iTargetItem = int(args[args.Length - 2]);
            kMgr.OnClickGear(iTargetItem);
            OnAccept();
            RealizeSelected_Locker();
            UpdateLockerList(kMgr.m_kCEGear.iHighlight);
            ListFocusUpdated();
        }
    }

    return true;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (!IsVisible() || `HQPRES.GetStateName() == 'State_ItemCard')
    {
        return false;
    }

    if ( (Arg & class'UI_FxsInput'.const.FXS_ACTION_PREHOLD_REPEAT) != 0 || (Arg & class'UI_FxsInput'.const.FXS_ACTION_POSTHOLD_REPEAT) != 0 || (Arg & class'UI_FxsInput'.const.FXS_ACTION_HOLD) != 0 )
    {
        if (Cmd == class'UI_FxsInput'.const.FXS_VIRTUAL_RSTICK_RIGHT)
        {
            m_kSoldier.m_kPawn.RotateInPlace(-1);
            return true;
        }
        else if (Cmd == class'UI_FxsInput'.const.FXS_VIRTUAL_RSTICK_LEFT)
        {
            m_kSoldier.m_kPawn.RotateInPlace(1);
            return true;
        }
    }

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return true;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
        case class'UI_FxsInput'.const.FXS_KEY_W:
            kMgr.OnGearUp();
            LWCE_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_KEY_S:
            kMgr.OnGearDown();
            LWCE_RealizeSelected();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_LBUMPER:
        case class'UI_FxsInput'.const.FXS_KEY_LEFT_SHIFT:
            PrevSoldier();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_RBUMPER:
        case class'UI_FxsInput'.const.FXS_KEY_TAB:
            NextSoldier();
            break;
        case class'UI_FxsInput'.const.FXS_MOUSE_4:
            OnMousePrevSoldier();
            break;
        case class'UI_FxsInput'.const.FXS_MOUSE_5:
            OnMouseNextSoldier();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            if (!kMgr.m_kCELocker.bIsSelected || kMgr.m_kCELocker.arrOptions[kMgr.m_kCELocker.iHighlight].bShowItemCard == true)
            {
                ShowItemCard();
            }

            break;
        case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
        case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_RIGHT:
        case class'UI_FxsInput'.const.FXS_KEY_D:
            if (!kMgr.m_kCELocker.bIsSelected)
            {
                OnAccept();
            }

            break;
        case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
        case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_LEFT:
        case class'UI_FxsInput'.const.FXS_KEY_A:
            if (kMgr.m_kCELocker.bIsSelected)
            {
                OnCancel();
            }

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
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_SQUARE:
        case class'UI_FxsInput'.const.FXS_KEY_X:
            OnUnequip();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_TRIANGLE:
        case class'UI_FxsInput'.const.FXS_KEY_Y:
            break;
        case class'UI_FxsInput'.const.FXS_MOUSE_SCROLL_DOWN:
            if (!XComInputBase(controllerRef.PlayerInput).TestMouseConsumedBy3DFlash())
            {
                m_kSoldier.m_kPawn.RotateInPlace(-1);
            }

            break;
        case class'UI_FxsInput'.const.FXS_MOUSE_SCROLL_UP:
            if (!XComInputBase(controllerRef.PlayerInput).TestMouseConsumedBy3DFlash())
            {
                m_kSoldier.m_kPawn.RotateInPlace(1);
            }

            break;
        default:
            return true;
    }

    return true;
}

simulated function PrevSoldier()
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (`HQPRES.m_kSoldierSummary.PrevSoldier(true))
    {
        kMgr.m_kCEGear.iHighlight = 0;
        kMgr.m_kCELocker.iHighlight = 0;
        kMgr.m_kCELocker.bIsSelected = false;

        UpdateData();

        m_kSoldierStats.UpdateData();
        m_kSoldierHeader.m_kSoldier = kMgr.m_kSoldier;
        m_kSoldierHeader.UpdateData();
        m_kAbilityList.UpdateData();
    }
}

// LWCE_ prefix because original function is final
simulated function LWCE_RealizeSelected()
{
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    if (!kMgr.m_kCELocker.bIsSelected)
    {
        RealizeSelected_Inventory();
        UpdateLockerList(kMgr.m_kCEGear.iHighlight);
    }
    else
    {
        RealizeSelected_Locker();
    }
}

simulated function RealizeSelected_Locker()
{
    AS_SetSelectedIndex_LockerList(LWCE_XGSoldierUI(GetMgr()).m_kCELocker.iHighlight);
}

simulated function RealizeSelected_Inventory()
{
    AS_SetSelectedIndex_InventoryList(LWCE_XGSoldierUI(GetMgr()).m_kCEGear.iHighlight);
}

simulated function ShowItemCard()
{
    local LWCE_TItemCard cardData;

    if (m_bItemCardActive)
    {
        return;
    }

    cardData = LWCE_XGSoldierUI(GetMgr()).LWCE_SOLDIERUIGetItemCard();

    if (cardData.iCardType != 0)
    {
        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
        `LWCE_HQPRES.LWCE_UIItemCard(cardData);
        m_bItemCardActive = true;
    }
    else
    {
        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
    }
}

simulated function UpdateData()
{
    local Vector kCameraOffset;

    UpdateInventoryList();
    UpdateLockerList();

    if (!manager.IsMouseActive())
    {
        LWCE_RealizeSelected();
    }

    // For MECs in suits, the camera has to be moved to accommodate their size
    if (m_kSoldier.IsAugmented())
    {
        if (LWCE_XGStrategySoldier(m_kSoldier).m_kCEChar.kInventory.nmArmor != 'Item_BaseAugments')
        {
            kCameraOffset += (TransformVectorByRotation(m_kCameraRig.Rotation, vect(0.0, 0.0, 1.0)) * m_kCameraRigMecVerticalOffset);
        }
    }

    m_kCameraRig.SetLocation(m_kCameraRigDefaultLocation - kCameraOffset);
    `HQPRES.CAMLookAtNamedLocation(m_strCameraTag, 1.0);
}

simulated function UpdateInventoryList()
{
    local int I, Length, Type;
    local string imgPath;
    local LWCEEquipmentTemplate kEquipment;
    local LWCE_XGStrategySoldier kSoldier;
    local LWCE_XGSoldierUI kMgr;
    local LWCE_TInventoryOption kOption;

    Invoke("ClearInventoryList");

    kMgr = LWCE_XGSoldierUI(GetMgr());
    kSoldier = LWCE_XGStrategySoldier(kMgr.m_kSoldier);
    Length = kMgr.m_kCEGear.arrOptions.Length;

    for (I = 0; I < Length; I++)
    {
        kOption = kMgr.m_kCEGear.arrOptions[I];

        switch (kOption.iOptionType)
        {
            case 0:
                Type = 1;
                break;
            case 1:
                Type = 2;
                break;
            case 2:
                if (m_kSoldier.IsAugmented() && kOption.iSlot > 0)
                {
                    Type = 3;
                }
                else
                {
                    Type = 2;
                }
                break;
            case 3:
                Type = 3;
                break;
        }

        kEquipment = LWCEEquipmentTemplate(`LWCE_ITEM(kOption.ItemName));

        imgPath = kOption.imgItem.strPath;
        AS_AddInventoryItem(Type, kOption.txtName.StrValue, imgPath, kEquipment != none ? kEquipment.GetClipSize(kSoldier.m_kCEChar) : 0, GetMecArmorIconsArray(0));
    }
}

simulated function UpdateLockerList(optional int InventorySlot = 0)
{
    local int I, Length;
    local string quantityText;
    local LWCE_TInventoryOption kOption;
    local LWCE_XGSoldierUI kMgr;

    kMgr = LWCE_XGSoldierUI(GetMgr());

    Invoke("ClearLockerList");
    kMgr.m_kCELocker.iHighlight = 0;
    Length = kMgr.m_kCELocker.arrOptions.Length;

    for (I = 0; I < Length; I++)
    {
        kOption = kMgr.m_kCELocker.arrOptions[I];
        quantityText = (kOption.bInfinite ? "" : "x" $ kOption.txtQuantity.StrValue);

        AS_AddLockerItem(kOption.txtName.StrValue, quantityText, kOption.imgItem.strPath, kOption.iState == eUIState_Disabled, kOption.bShowItemCard, kOption.txtLabel.StrValue, GetMecArmorIconsArray(0));
    }
}