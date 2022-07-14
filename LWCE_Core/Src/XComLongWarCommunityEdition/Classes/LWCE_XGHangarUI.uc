class LWCE_XGHangarUI extends XGHangarUI;

var array<LWCE_TItem> m_arrCEItems;
var UIShipSummary m_kShipSummaryScreen;

function XGHangarUI.TTableItemSummary BuildItemSummary(TItem kItem)
{
    local XGHangarUI.TTableItemSummary kSummary;

    `LWCE_LOG_DEPRECATED_CLS(BuildItemSummary);

    return kSummary;
}

function XGHangarUI.TTableItemSummary LWCE_BuildItemSummary(LWCE_TItem kItem)
{
    local XGHangarUI.TTableItemSummary kSummary;

    kSummary.txtTitle.StrValue = kItem.strName;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;
    kSummary.imgOption.strPath = kItem.ImagePath;

    return kSummary;
}

static function TItemCard BuildShipWeaponCard(EItemType eWeapon)
{
    local TItemCard kItemCard;

    `LWCE_LOG_DEPRECATED(BuildShipWeaponCard);

    return kItemCard;
}

static function LWCE_TItemCard LWCE_BuildShipWeaponCard(int iWeaponId, optional XGShip_Interceptor kShip)
{
    local LWCE_TItemCard kItemCard;
    local TShipWeapon kWeapon;

    kWeapon = `HQGAME.GetGameCore().GetHQ().SHIPWEAPON(class'LWCE_XGFacility_Hangar'.static.LWCE_ItemTypeToShipWeapon(iWeaponId));

    kItemCard.iCardType = eItemCard_ShipWeapon;
    kItemCard.strName = kWeapon.strName;
    kItemCard.iBaseDamage = GetShipWeaponDamageBin(kWeapon.iDamage);
    kItemCard.shipWpnRange = GetShipWeaponRangeBin(kWeapon.iRange);
    kItemCard.shipWpnHitChance = kWeapon.iToHit;

    if (kShip != none)
    {
        kItemCard.shipWpnHitChance += Clamp(3 * kShip.m_iConfirmedKills, 0, 30);
    }

    kItemCard.shipWpnArmorPen = GetShipWeaponArmorPenetrationBin(kWeapon.iAP);
    kItemCard.shipWpnFireRate = GetShipWeaponFiringRateBin(kWeapon.fFiringTime);
    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XGLocalizedData'.default.ShipWeaponFlavorTxt[kWeapon.eType]);
    kItemCard.iItemId = iWeaponId;

    return kItemCard;
}

function TTableMenuOption BuildTableItem(TItem kItem)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildTableItem);

    return kOption;
}

function TTableMenuOption LWCE_BuildTableItem(LWCE_TItem kItem)
{
    local LWCE_XGStorage kStorage;
    local TTableMenuOption kOption;

    kStorage = `LWCE_STORAGE;

    kOption.arrStrings[0] = kItem.strName;
    kOption.arrStates[0] = eUIState_Normal;
    kOption.arrStrings[1] = kStorage.LWCE_IsInfinite(kItem.iItemId) ? "" : ("x" $ string(kStorage.GetNumItemsAvailable(kItem.iItemId)));
    kOption.arrStates[1] = eUIState_Normal;

    if (!HANGAR().CanEquip(kItem.iItemId, XGShip_Interceptor(m_kShip), kOption.strHelp))
    {
        kOption.iState = eUIState_Disabled;
    }

    return kOption;
}

function TItemCard HANGARUIGetItemCard(optional int iContinent = 0, optional int iShip = 0, optional int viewOverride = -1)
{
    local TItemCard kItemCard;

    `LWCE_LOG_DEPRECATED_CLS(HANGARUIGetItemCard);

    return kItemCard;
}

function LWCE_TItemCard LWCE_HANGARUIGetItemCard(optional int iContinent = 0, optional int iShip = 0, optional int viewOverride = -1)
{
    local int iView;
    local LWCE_TItemCard kItemCard;
    local XGShip_Interceptor kShip;

    iView = viewOverride == -1 ? m_iCurrentView : viewOverride;

    if (iView == eHangarView_ShipSummary)
    {
        kItemCard = LWCE_BuildShipWeaponCard(XGShip_Interceptor(m_kShip).GetWeapon(), XGShip_Interceptor(m_kShip));
    }
    else if (iView == eHangarView_ShipList)
    {
        if (m_iCurrentView == eHangarView_ShipSummary)
        {
            kShip = XGShip_Interceptor(m_kShip);
        }
        else if (m_arrContinents[iContinent].iNumShips > 0)
        {
            kShip = m_arrContinents[iContinent].arrCraft[iShip];
        }

        if (kShip != none)
        {
            kItemCard.iCardType = eItemCard_Interceptor;
            kItemCard.strName = ITEMTREE().ShipTypeNames[kShip.m_kTShip.eType];
            kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(ITEMTREE().ShipTypeFlavorTxt[kShip.m_kTShip.eType]);
            kItemCard.iItemId = HANGAR().ShipTypeToItemType(kShip.m_kTShip.eType);
        }
    }

    return kItemCard;
}

function OnChooseTableOption(int iOption)
{
    if (m_kTable.mnuOptions.arrOptions[iOption].iState == eUIState_Disabled)
    {
        PlayBadSound();
    }
    else
    {
        `HQPRES.m_kShipSummary.m_bUpdateDataOnReceiveFocus = true;
        `LWCE_HANGAR.LWCE_EquipWeapon(m_arrCEItems[iOption].iItemId, XGShip_Interceptor(m_kShip));
        GoToView(eHangarView_ShipSummary);
    }
}

function UpdateHireDisplay()
{
    local bool bCanAfford;
    local int iInterceptorCost, iTotalCost, iNumInterceptorsWanted, I, iOrderIndex, iTotalOrders;
    local TContinentInfo kInfo;

    kInfo = HANGAR().GetContinentInfo(EContinent(m_iContinentHiringInto));

    for (I = 0; I < kInfo.m_arrInterceptorOrderIndexes.Length; I++)
    {
        iOrderIndex = kInfo.m_arrInterceptorOrderIndexes[I];
        iTotalOrders += HQ().m_akInterceptorOrders[iOrderIndex].iNumInterceptors;
    }

    if (m_iContinentHiringInto == `HQGAME.GetGameCore().GetHQ().GetContinent())
    {
        iTotalOrders += ENGINEERING().GetNumFirestormsBuilding();
    }

    iInterceptorCost = `LWCE_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    m_iNumInterceptors = kInfo.arrCraft.Length;
    m_iNumInterceptorsOnOrder = iTotalOrders;

    m_iMaxCapacity = HANGAR().GetTotalInterceptorCapacity(kInfo.eCont);
    iNumInterceptorsWanted = m_iNumInterceptorsOnOrder + m_iNumInterceptors + m_iNumHiring;

    iTotalCost = iInterceptorCost * m_iNumHiring;
    bCanAfford = iTotalCost <= GetResource(eResource_Money);

    m_kHiring.txtTitle.StrValue = m_strLabelHireInterceptors;

    m_kHiring.txtFacilityCap.strLabel = m_strLabelHangarCap;
    m_kHiring.txtFacilityCap.StrValue = iNumInterceptorsWanted $ "/" $ m_iMaxCapacity;
    m_kHiring.txtFacilityCap.iState = iNumInterceptorsWanted > m_iMaxCapacity ? eUIState_Bad : eUIState_Normal;

    m_kHiring.txtMaintenance.strLabel = m_strLabelHireMonthlyCost;
    m_kHiring.txtMaintenance.StrValue = ConvertCashToString(-1 * HANGAR().GetCraftMaintenanceCost(eShip_Interceptor) * m_iNumHiring);
    m_kHiring.txtMaintenance.iState = eUIState_Warning;

    m_kHiring.txtCost.strLabel = m_strLabelHireCost;
    m_kHiring.txtCost.StrValue = ConvertCashToString(iTotalCost);
    m_kHiring.txtCost.iState = bCanAfford ? eUIState_Cash : eUIState_Bad;

    m_kHiring.txtNumToHire.StrValue = string(m_iNumHiring);
    m_kHiring.txtNumToHire.iState = bCanAfford ? eUIState_Normal : eUIState_Bad;

    m_kHiring.txtButtonHelp.StrValue = m_strLabelIncreaseOrder;
    m_kHiring.txtButtonHelp.iButton = 7;

    m_kHiring.txtMoney = GetResourceText(eResource_Money);

    m_kHiring.imgHire.iImage = eImage_Interceptor;
}

function UpdateInterceptorSummary()
{
    local LWCE_XGFacility_Hangar kHangar;
    local TShipSummary kSummary;
    local TShipUIInfo kInfo;
    local TShipWeapon kWeapon;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kInfo = m_kShip.GetUIInfo();

    kSummary.txtStatus.strLabel = m_strLabelStatus;
    kSummary.txtStatus.StrValue = kInfo.txtStatus.StrValue;
    kSummary.txtStatus.iState = kInfo.txtStatus.iState;
    kSummary.txtKills.strLabel = m_strLabelConfirmedKills;
    kSummary.txtKills.StrValue = kInfo.txtKills.StrValue;

    if (m_kShip.m_kTShip.eType == eShip_Interceptor)
    {
        kSummary.imgShip.iImage = eImage_Interceptor;
    }
    else
    {
        kSummary.imgShip.iImage = eImage_Firestorm;
    }

    kSummary.txtDestroyButton.iButton = 3;
    kSummary.txtDestroyButton.StrValue = m_strLabelElimiateShip;

    if (m_kShip.GetStatus() != eShipStatus_Ready)
    {
        kSummary.txtDestroyButton.iState = eUIState_Disabled;
    }

    kSummary.txtWeaponButton.iButton = 1;
    kSummary.txtWeaponButton.StrValue = m_strChangeLoadout;

    if (m_kShip.GetStatus() != eShipStatus_Ready)
    {
        kSummary.txtWeaponButton.iState = eUIState_Disabled;
    }

    kSummary.txtTransferButton.iButton = 2;
    kSummary.txtTransferButton.StrValue = m_strLabelTransfer;

    if (m_kShip.GetStatus() != eShipStatus_Ready)
    {
        kSummary.txtTransferButton.iState = eUIState_Disabled;
    }

    kWeapon = SHIPWEAPON(kHangar.LWCE_ItemTypeToShipWeapon(XGShip_Interceptor(m_kShip).GetWeapon()));
    kSummary.txtWeaponLabel.StrValue = m_strLabelWeaponsSystem;
    kSummary.txtWeapon.StrValue = kWeapon.strName;
    kSummary.txtWeaponDamage.strLabel = m_strLabelDamage;
    kSummary.txtWeaponDamage.StrValue = string(float(kWeapon.iDamage) / kWeapon.fFiringTime) @ m_strPerSecond;
    kSummary.txtWeaponRange.strLabel = m_strLabelRange;
    kSummary.txtWeaponRange.StrValue = string(kWeapon.iRange) $ "km";
    m_kShipSummary = kSummary;
}

function UpdateTableMenu()
{
    local LWCE_XGFacility_Hangar kHangar;
    local THangarTable kTable;
    local TTableMenu kTableMenu;
    local int iMenuItem;

    kHangar = `LWCE_HANGAR;

    kTableMenu.arrCategories.AddItem(2);
    kTableMenu.arrCategories.AddItem(4);
    m_arrCEItems = kHangar.LWCE_GetUpgrades(XGShip_Interceptor(m_kShip));

    for (iMenuItem = 0; iMenuItem < m_arrCEItems.Length; iMenuItem++)
    {
        kTableMenu.arrOptions.AddItem(LWCE_BuildTableItem(m_arrCEItems[iMenuItem]));
        kTable.arrSummaries.AddItem(LWCE_BuildItemSummary(m_arrCEItems[iMenuItem]));
    }

    kTableMenu.kHeader.arrStrings = GetHeaderStrings(kTableMenu.arrCategories);
    kTableMenu.kHeader.arrStates = GetHeaderStates(kTableMenu.arrCategories);
    kTableMenu.bTakesNoInput = false;

    kTable.mnuOptions = kTableMenu;
    m_kTable = kTable;
}