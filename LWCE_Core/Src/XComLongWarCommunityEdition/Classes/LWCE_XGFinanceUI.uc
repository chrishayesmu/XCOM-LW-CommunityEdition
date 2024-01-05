class LWCE_XGFinanceUI extends XGFinanceUI
    dependson(LWCE_XGFacility_Hangar);

function TFinanceSection BuildCraftUI()
{
    local LWCEShipTemplate kShipTemplate;
    local LWCE_XGFacility_Hangar kHangar;
    local TFinanceSection kUI;
    local TLabeledText ltxtItem;
    local LWCE_TShipCount kTCount;
    local int Index;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kTCount = kHangar.GetShipCountsByType();

    // Total cost across all ships
    kUI.ltxtTitle.StrValue = ConvertCashToString(HANGAR().GetShipMaintenanceCost());
    kUI.ltxtTitle.strLabel = m_strCraftMaintenance;

    for (Index = 0; Index < kTCount.arrShipTypes.Length; Index++)
    {
        kShipTemplate = `LWCE_SHIP(kTCount.arrShipTypes[Index]);

        ltxtItem.strLabel = kTCount.arrShipCounts[Index] $ "x " $ kShipTemplate.strName;
        ltxtItem.StrValue = ConvertCashToString(kShipTemplate.GetMaintenanceCost(class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM) * kTCount.arrShipCounts[Index]);

        kUI.arrItems.AddItem(ltxtItem);
    }

    return kUI;
}

function TFinanceSection BuildFacilityUI()
{
    local LWCEFacilityTemplate kFacilityTemplate;
    local LWCEFacilityTemplateManager kTemplateMgr;
    local LWCE_XGHeadquarters kHQ;
    local TFinanceSection kUI;
    local TLabeledText ltxtItem;
    local int iFacility, iMonthlyCost, iNumFacilities;

    kHQ = LWCE_XGHeadquarters(HQ());
    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    kUI.ltxtTitle.StrValue = ConvertCashToString(kHQ.GetFacilityMaintenanceCost());
    kUI.ltxtTitle.strLabel = m_strFacilityMaintenance;

    for (iFacility = 0; iFacility < kHQ.m_arrCEBaseFacilities.Length; iFacility++)
    {
        iNumFacilities = kHQ.m_arrCEBaseFacilities[iFacility].Count;

        if (iNumFacilities > 0)
        {
            kFacilityTemplate = kTemplateMgr.FindFacilityTemplate(kHQ.m_arrCEBaseFacilities[iFacility].Facility);
            iMonthlyCost = kFacilityTemplate.GetMonthlyCost();

            if (iMonthlyCost != 0)
            {
                ltxtItem.strLabel = iNumFacilities $ "x" @ kFacilityTemplate.strName;
                ltxtItem.StrValue = ConvertCashToString(-iMonthlyCost * iNumFacilities);
                kUI.arrItems.AddItem(ltxtItem);
            }
        }
    }

    return kUI;
}