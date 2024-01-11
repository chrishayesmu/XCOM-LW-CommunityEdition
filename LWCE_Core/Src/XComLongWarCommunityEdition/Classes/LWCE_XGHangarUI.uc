class LWCE_XGHangarUI extends XGHangarUI
    dependson(LWCETypes, LWCE_XGFacility_Hangar);

var const localized string m_strShipStatDisclaimer;

var array<LWCE_TContinentInfo> m_arrCEContinents;
var array<LWCEShipWeaponTemplate> m_arrCEItems;
var array<LWCE_TItemProject> m_arrCEShipProjects;
var UIShipSummary m_kShipSummaryScreen;

function XGHangarUI.TTableItemSummary BuildItemSummary(TItem kItem)
{
    local XGHangarUI.TTableItemSummary kSummary;

    `LWCE_LOG_DEPRECATED_CLS(BuildItemSummary);

    return kSummary;
}

function XGHangarUI.TTableItemSummary LWCE_BuildItemSummary(LWCEItemTemplate kItem)
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

    `LWCE_LOG_DEPRECATED_CLS(BuildShipWeaponCard);

    return kItemCard;
}

static function LWCE_TItemCard LWCE_BuildShipWeaponCard(name ItemName, optional LWCE_XGShip kShip)
{
    local LWCE_TItemCard kItemCard;
    local LWCEShipWeaponTemplate kShipWeapon;

    kShipWeapon = `LWCE_SHIP_WEAPON(ItemName);

    kItemCard.iCardType = eItemCard_ShipWeapon;
    kItemCard.strName = kShipWeapon.strName;
    kItemCard.ItemName = ItemName;
    kItemCard.iBaseDamage = kShipWeapon.GetDamage(kShip);
    kItemCard.shipWpnRange = GetShipWeaponRangeBin(kShipWeapon.iRange);
    kItemCard.shipWpnHitChance = kShipWeapon.GetHitChance(kShip);
    kItemCard.shipWpnArmorPen = kShipWeapon.GetArmorPen(kShip);
    kItemCard.shipWpnFiringTime = kShipWeapon.GetFiringTime(kShip);
    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(kShipWeapon.strTacticalText);

    // TODO centralize this math somewhere
    if (kShip != none)
    {
        kItemCard.iBaseDamage *= (1 + kShip.m_iConfirmedKills / 100.0f);
        kItemCard.shipWpnHitChance += Clamp(3 * kShip.m_iConfirmedKills, 0, 30);
        kItemCard.strFlavorText = class'UIUtilities'.static.GetHTMLColoredText(default.m_strShipStatDisclaimer, eUIState_Warning) $ kItemCard.strFlavorText;
    }

    return kItemCard;
}

function TTableMenuOption BuildTableItem(TItem kItem)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildTableItem);

    return kOption;
}

function TTableMenuOption LWCE_BuildTableItem(LWCEShipWeaponTemplate kShipWeapon)
{
    local LWCE_XGStorage kStorage;
    local TTableMenuOption kOption;

    kStorage = `LWCE_STORAGE;

    kOption.arrStrings[0] = kShipWeapon.strName;
    kOption.arrStates[0] = eUIState_Normal;

    kOption.arrStrings[1] = kShipWeapon.IsInfinite() ? "" : ("x" $ kStorage.LWCE_GetNumItemsAvailable(kShipWeapon.GetItemName()));
    kOption.arrStates[1] = eUIState_Normal;

    // Added param to pass the rearm time, since we don't have access to the template in the UI layer
    kOption.arrStrings[2] = string(LWCE_XGShip(m_kShip).IsType('Firestorm') ? kShipWeapon.iFirestormArmingTimeHours : kShipWeapon.iInterceptorArmingTimeHours);
    kOption.arrStates[2] = eUIState_Normal;

    if (!LWCE_XGFacility_Hangar(HANGAR()).LWCE_CanEquip(kShipWeapon.GetItemName(), LWCE_XGShip(m_kShip), kOption.strHelp))
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

function LWCE_TItemCard LWCE_HANGARUIGetItemCard(optional name nmContinent = '', optional int iShip = 0, optional int viewOverride = -1)
{
    local int iContinent, iView;
    local LWCE_TItemCard kItemCard;
    local LWCE_XGShip kShip;

    iView = viewOverride == -1 ? m_iCurrentView : viewOverride;

    if (iView == eHangarView_ShipSummary)
    {
        kItemCard = LWCE_BuildShipWeaponCard(LWCE_XGShip(m_kShip).GetWeaponAtIndex(0), LWCE_XGShip(m_kShip));
    }
    else if (iView == eHangarView_ShipList)
    {
        if (m_iCurrentView == eHangarView_ShipSummary)
        {
            kShip = LWCE_XGShip(m_kShip);
        }
        else if (nmContinent != '')
        {
            iContinent = m_arrCEContinents.Find('nmContinent', nmContinent);

            if (m_arrCEContinents[iContinent].iNumShips > 0)
            {
                kShip = m_arrCEContinents[iContinent].arrShips[iShip];
            }
        }

        if (kShip != none)
        {
            kItemCard.iCardType = eItemCard_Interceptor;
            kItemCard.strName = kShip.m_kTemplate.strName;
            kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(kShip.m_kTemplate.strDescription);
            kItemCard.strImage = kShip.m_kTemplate.strHangarImage;
        }
    }

    return kItemCard;
}

simulated function int GetNumPendingInterceptors(int iContinent)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetNumPendingInterceptors);

    return -100;
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
        `LWCE_HANGAR.LWCE_EquipWeapon(m_arrCEItems[iOption].GetItemName(), LWCE_XGShip(m_kShip));
        GoToView(eHangarView_ShipSummary);
    }
}

function OnChooseTransferInterceptor(int iDestContinent)
{
    local LWCE_XGFacility_Hangar kHangar;
    local name nmContinent;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    nmContinent = m_arrCEContinents[iDestContinent].nmContinent;

    if (kHangar.LWCE_GetFreeHangarSpots(nmContinent) <= 0)
    {
        PlayBadSound();
    }
    else
    {
        PlayGoodSound();
        kHangar.LWCE_TransferShip(LWCE_XGShip(m_kShip), nmContinent);
        GoToView(eHangarView_ShipList);
    }
}

function OnChooseTransferInterceptorOption(int iOption)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnChooseTransferInterceptorOption);
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

    iInterceptorCost = `LWCE_ITEM('Item_Interceptor').kCost.iCash;

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
    local TShipSummary kSummary;
    local TShipUIInfo kInfo;
    local LWCEShipWeaponTemplate kWeapon;

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

    kWeapon = `LWCE_SHIP_WEAPON(LWCE_XGShip(m_kShip).GetWeaponAtIndex(0));

    kSummary.txtWeaponLabel.StrValue = m_strLabelWeaponsSystem;
    kSummary.txtWeapon.StrValue = kWeapon.strName;

    kSummary.txtWeaponDamage.strLabel = m_strLabelDamage;
    kSummary.txtWeaponDamage.StrValue = string(float(kWeapon.iDamage) / kWeapon.fFiringTime) @ m_strPerSecond;

    kSummary.txtWeaponRange.strLabel = m_strLabelRange;
    kSummary.txtWeaponRange.StrValue = kWeapon.iRange $ "km";

    m_kShipSummary = kSummary;
}

function UpdateShipList()
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGWorld kWorld;
    local array<LWCE_TContinentInfo> arrContinentList;
    local name nmContinent, nmHQContinent;
    local int iContinent;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kWorld = LWCE_XGWorld(WORLD());
    nmHQContinent = LWCE_XGHeadquarters(HQ()).m_nmContinent;

    for (iContinent = 0; iContinent < kWorld.m_arrContinents.Length; iContinent++)
    {
        nmContinent = LWCE_XGContinent(kWorld.m_arrContinents[iContinent]).m_nmContinent;

        if (nmContinent == nmHQContinent)
        {
            arrContinentList.InsertItem(0, kHangar.LWCE_GetContinentInfo(nmContinent));
        }
        else
        {
            arrContinentList.AddItem(kHangar.LWCE_GetContinentInfo(nmContinent));
        }
    }

    m_arrCEContinents = arrContinentList;
}

function UpdateShipWeaponView(XGShip_Interceptor kShip, EShipWeapon eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateShipWeaponView);
}

function LWCE_UpdateShipWeaponView(LWCEShipWeaponTemplate kShipWeapon)
{
    LWCE_XGFacility_Hangar(HANGAR()).LWCE_UpdateWeaponView(kShipWeapon.GetItemName());
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
    m_arrCEItems = kHangar.LWCE_GetUpgrades();

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