class LWCE_UISoldierLoadout extends UISoldierLoadout;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    local XGSoldierUI kMgr;
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

    GetMgr().m_kLocker.bIsSelected = false;

    m_kSoldierHeader = Spawn(class'LWCE_UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kAbilityList = Spawn(class'LWCE_UIStrategyComponent_SoldierAbilityList', self);
    m_kAbilityList.Init(GetMgr(), _controllerRef, _manager, self);

    m_iLockerSelectionWatchHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariableStructMember(GetMgr(), 'm_kLocker', 'bIsSelected', self, ListFocusUpdated);

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
        RealizeSelected();
    }

    // For MECs in suits, the camera has to be moved to accommodate their size
    if (m_kSoldier.IsAugmented())
    {
        if (m_kSoldier.m_kChar.kInventory.iArmor != `LW_ITEM_ID(BaseAugments))
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
    local LWCE_XGSoldierUI kMgr;
    local TInventoryOption kOption;

    Invoke("ClearInventoryList");
    kMgr = LWCE_XGSoldierUI(GetMgr());
    Length = kMgr.m_kGear.arrOptions.Length;

    `LWCE_LOG_CLS("UpdateInventoryList: kMgr.m_kGear.arrOptions.Length = " $ kMgr.m_kGear.arrOptions.Length);

    for (I = 0; I < Length; I++)
    {
        kOption = kMgr.m_kGear.arrOptions[I];

        `LWCE_LOG_CLS("Option " $ I $ ": iOptionType = " $ kOption.iOptionType $ "; iState = " $ kOption.iState $ "; iSlot = " $ kOption.iSlot $ "; iItem = " $ kOption.iItem);
        `LWCE_LOG_CLS("txtName = " $ kOption.txtName.strValue $ "; txtLabel = " $ kOption.txtLabel.StrValue);

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

        imgPath = kOption.imgItem.strPath;
        AS_AddInventoryItem(Type, kOption.txtName.StrValue, imgPath, kMgr.LWCE_GetItemCharges(kOption.iItem, true), GetMecArmorIconsArray(kOption.iItem));
    }
}

simulated function UpdateLockerList(optional int InventorySlot = 0)
{
    local int I, Length;
    local string quantityText;
    local TInventoryOption kOption;

    Invoke("ClearLockerList");
    GetMgr().m_kLocker.iHighlight = 0;
    Length = GetMgr().m_kLocker.arrOptions.Length;

    for (I = 0; I < Length; I++)
    {
        kOption = GetMgr().m_kLocker.arrOptions[I];
        quantityText = (kOption.bInfinite ? "" : "x" $ kOption.txtQuantity.StrValue);

        AS_AddLockerItem(kOption.txtName.StrValue, quantityText, kOption.imgItem.strPath, kOption.iState == eUIState_Disabled, kOption.bShowItemCard, kOption.txtLabel.StrValue, GetMecArmorIconsArray(kOption.iItem));
    }
}