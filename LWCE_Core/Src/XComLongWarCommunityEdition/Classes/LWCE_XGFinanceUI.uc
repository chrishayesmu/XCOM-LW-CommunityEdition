class LWCE_XGFinanceUI extends XGFinanceUI;

function TFinanceSection BuildCraftUI()
{
    local LWCE_XGStorage kStorage;
    local TFinanceSection kUI;
    local TLabeledText ltxtItem;

    kStorage = LWCE_XGStorage(STORAGE());

    kUI.ltxtTitle.StrValue = ConvertCashToString(HANGAR().GetShipMaintenanceCost());
    kUI.ltxtTitle.strLabel = m_strCraftMaintenance;

    if (kStorage.LWCE_GetNumItemsAvailable('Item_Interceptor') > 0)
    {
        ltxtItem.strLabel = kStorage.LWCE_GetNumItemsAvailable('Item_Interceptor') $ "x" @ `LWCE_ITEM('Item_Interceptor').strName;
        ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Interceptor) * kStorage.LWCE_GetNumItemsAvailable('Item_Interceptor'));
        kUI.arrItems.AddItem(ltxtItem);
    }

    if (kStorage.LWCE_GetNumItemsAvailable('Item_Firestorm') > 0)
    {
        ltxtItem.strLabel = kStorage.LWCE_GetNumItemsAvailable('Item_Firestorm') $ "x" @ `LWCE_ITEM('Item_Firestorm').strName;
        ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Firestorm) * kStorage.LWCE_GetNumItemsAvailable('Item_Firestorm'));
        kUI.arrItems.AddItem(ltxtItem);
    }

    ltxtItem.strLabel = kStorage.LWCE_GetNumItemsAvailable('Item_Skyranger') $ "x" @ `LWCE_ITEM('Item_Skyranger').strName;
    ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Skyranger));
    kUI.arrItems.AddItem(ltxtItem);

    return kUI;
}