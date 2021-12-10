class Highlander_XGFinanceUI extends XGFinanceUI;

function TFinanceSection BuildCraftUI()
{
    local TFinanceSection kUI;
    local TLabeledText ltxtItem;

    kUI.ltxtTitle.StrValue = ConvertCashToString(HANGAR().GetShipMaintenanceCost());
    kUI.ltxtTitle.strLabel = m_strCraftMaintenance;

    if (STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Interceptor)) > 0)
    {
        ltxtItem.strLabel = string(STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Interceptor))) $ "x" @ `HL_ITEM(`LW_ITEM_ID(Interceptor)).strName;
        ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Interceptor) * STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Interceptor)));
        kUI.arrItems.AddItem(ltxtItem);
    }

    if (STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Firestorm)) > 0)
    {
        ltxtItem.strLabel = string(STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Firestorm))) $ "x" @ `HL_ITEM(`LW_ITEM_ID(Firestorm)).strName;
        ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Firestorm) * STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Firestorm)));
        kUI.arrItems.AddItem(ltxtItem);
    }

    ltxtItem.strLabel = string(STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(Skyranger))) $ "x" @ `HL_ITEM(`LW_ITEM_ID(Skyranger)).strName;
    ltxtItem.StrValue = ConvertCashToString(HANGAR().GetCraftMaintenanceCost(eShip_Skyranger));
    kUI.arrItems.AddItem(ltxtItem);

    return kUI;
}