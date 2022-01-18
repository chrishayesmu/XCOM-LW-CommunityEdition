class Highlander_XGHangarUI extends XGHangarUI;

var array<HL_TItem> m_arrHLItems;
var UIShipSummary m_kShipSummaryScreen;

function XGHangarUI.TTableItemSummary BuildItemSummary(TItem kItem)
{
    local XGHangarUI.TTableItemSummary kSummary;

    `HL_LOG_DEPRECATED_CLS(BuildItemSummary);

    return kSummary;
}

function XGHangarUI.TTableItemSummary HL_BuildItemSummary(HL_TItem kItem)
{
    local XGHangarUI.TTableItemSummary kSummary;

    kSummary.txtTitle.StrValue = kItem.strName;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;
    kSummary.imgOption.strPath = kItem.imagePath;

    return kSummary;
}

static function TItemCard BuildShipWeaponCard(EItemType eWeapon)
{
    local TItemCard kItemCard;

    `HL_LOG_DEPRECATED(BuildShipWeaponCard);

    return kItemCard;
}

static function HL_TItemCard HL_BuildShipWeaponCard(int iWeaponId, optional XGShip_Interceptor kShip)
{
    local HL_TItemCard kItemCard;
    local TShipWeapon kWeapon;

    kWeapon = `HQGAME.GetGameCore().GetHQ().SHIPWEAPON(class'Highlander_XGFacility_Hangar'.static.HL_ItemTypeToShipWeapon(iWeaponId));

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

    `HL_LOG_DEPRECATED_CLS(BuildTableItem);

    return kOption;
}

function TTableMenuOption HL_BuildTableItem(HL_TItem kItem)
{
    local Highlander_XGStorage kStorage;
    local TTableMenuOption kOption;

    kStorage = `HL_STORAGE;

    kOption.arrStrings[0] = kItem.strName;
    kOption.arrStates[0] = eUIState_Normal;
    kOption.arrStrings[1] = kStorage.HL_IsInfinite(kItem.iItemId) ? "" : ("x" $ string(kStorage.GetNumItemsAvailable(kItem.iItemId)));
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

    `HL_LOG_DEPRECATED_CLS(HANGARUIGetItemCard);

    return kItemCard;
}

function HL_TItemCard HL_HANGARUIGetItemCard(optional int iContinent = 0, optional int iShip = 0, optional int viewOverride = -1)
{
    local int iView;
    local HL_TItemCard kItemCard;
    local XGShip_Interceptor kShip;

    iView = viewOverride == -1 ? m_iCurrentView : viewOverride;

    if (iView == eHangarView_ShipSummary)
    {
        kItemCard = HL_BuildShipWeaponCard(XGShip_Interceptor(m_kShip).GetWeapon(), XGShip_Interceptor(m_kShip));
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
        `HL_HANGAR.HL_EquipWeapon(m_arrHLItems[iOption].iItemId, XGShip_Interceptor(m_kShip));
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

    iInterceptorCost = `HL_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    m_iNumInterceptors = kInfo.arrCraft.Length;
    m_iNumInterceptorsOnOrder = iTotalOrders;

    m_iMaxCapacity = HANGAR().GetTotalInterceptorCapacity(kInfo.eCont);
    iNumInterceptorsWanted = m_iNumInterceptorsOnOrder + m_iNumInterceptors + m_iNumHiring;

    iTotalCost = iInterceptorCost * m_iNumHiring;
    bCanAfford = iTotalCost <= GetResource(eResource_Money);

    m_kHiring.txtTitle.StrValue = m_strLabelHireInterceptors;

    m_kHiring.txtFacilityCap.strLabel = m_strLabelHangarCap;
    m_kHiring.txtFacilityCap.StrValue = string(iNumInterceptorsWanted) $ "/" $ string(m_iMaxCapacity);
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

    m_kHiring.txtMoney = GetResourceText(0);

    m_kHiring.imgHire.iImage = eImage_Interceptor;
}

function UpdateInterceptorSummary()
{
    local Highlander_XGFacility_Hangar kHangar;
    local TShipSummary kSummary;
    local TShipUIInfo kInfo;
    local TShipWeapon kWeapon;

    kHangar = Highlander_XGFacility_Hangar(HANGAR());
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

    kWeapon = SHIPWEAPON(kHangar.HL_ItemTypeToShipWeapon(XGShip_Interceptor(m_kShip).GetWeapon()));
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
    local Highlander_XGFacility_Hangar kHangar;
    local THangarTable kTable;
    local TTableMenu kTableMenu;
    local int iMenuItem;

    kHangar = `HL_HANGAR;

    kTableMenu.arrCategories.AddItem(2);
    kTableMenu.arrCategories.AddItem(4);
    m_arrHLItems = kHangar.HL_GetUpgrades(XGShip_Interceptor(m_kShip));

    for (iMenuItem = 0; iMenuItem < m_arrHLItems.Length; iMenuItem++)
    {
        kTableMenu.arrOptions.AddItem(HL_BuildTableItem(m_arrHLItems[iMenuItem]));
        kTable.arrSummaries.AddItem(HL_BuildItemSummary(m_arrHLItems[iMenuItem]));
    }

    kTableMenu.kHeader.arrStrings = GetHeaderStrings(kTableMenu.arrCategories);
    kTableMenu.kHeader.arrStates = GetHeaderStates(kTableMenu.arrCategories);
    kTableMenu.bTakesNoInput = false;

    kTable.mnuOptions = kTableMenu;
    m_kTable = kTable;
}