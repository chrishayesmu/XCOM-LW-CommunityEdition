class LWCE_UIShipList extends UIShipList
    dependson(LWCETypes, LWCE_XGFacility_Hangar);

simulated function OnLoseFocus()
{
    // LWCE issue #75: hide the ship list screen while a ship card is open, so it's not interactable
    super(UI_FxsPanel).OnLoseFocus();
    XComHQPresentationLayer(controllerRef.m_Pres).m_kStrategyHUD.ClearButtonHelp();
    Hide();
}

protected simulated function UpdateData()
{
    local int iContinentIndex, iOrderIndex, I, iDays, iStatusState, iShipState, iShipType;
    local string strContinentCapacity, tmpStr;
    local name nmResultingShip;
    local XGParamTag kTag;
    local LWCEItemTemplateManager kItemTemplateMgr;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGHangarUI kMgr;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;
    local LWCE_TContinentInfo kContinentInfo;
    local LWCE_TShipOrder kOrderInfo;
    local LWCE_TItemProject kProject;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kItemTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;
    kMgr = LWCE_XGHangarUI(GetMgr());
    kHQ = LWCE_XGHeadquarters(kMgr.HQ());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    Invoke("ClearAll");

    for (iContinentIndex = 0; iContinentIndex < kMgr.m_arrCEContinents.Length; iContinentIndex++)
    {
        kContinentInfo = kMgr.m_arrCEContinents[iContinentIndex];
        strContinentCapacity = "(" $ kContinentInfo.iNumShips $ "/" $ class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent $ ")";

        for (I = 0; I < kContinentInfo.arrShips.Length; I++)
        {
            kShip = kContinentInfo.arrShips[I];
            iShipState = eUIState_Normal;
            iStatusState = eUIState_Good;

            switch (kShip.GetStatus())
            {
                case eShipStatus_Damaged:
                case eShipStatus_Repairing:
                case eShipStatus_Destroyed:
                    iShipState = eUIState_Disabled;
                    iStatusState = eUIState_Bad;
                    break;
                case eShipStatus_Transfer:
                case eShipStatus_Rearming:
                case eShipStatus_Refuelling:
                    iShipState = eUIState_Disabled;
                    iStatusState = eUIState_Warning;
                    break;
            }

            if (manager.IsMouseActive() && (kShip.GetStatus() == eShipStatus_Ready || kShip.GetStatus() == eShipStatus_Repairing))
            {
                AS_AddShip(iContinentIndex, "<img src='img:///" $ (kShip.IsType('Interceptor') ? "LongWar.Icons.IC_Raven" : "LongWar.Icons.IC_Firestorm") $ "' height='16' width='16'>" $ kShip.m_strCallsign, "          " $ kShip.GetWeaponString(), class'UIUtilities'.static.GetHTMLColoredText(kShip.GetStatusString(), iStatusState), m_bTransferingShip ? m_strCancelTransferButtonHelp : m_strTransferShipButtonHelp, iShipState);
            }
            else
            {
                AS_AddShip(iContinentIndex, "<img src='img:///" $ (kShip.IsType('Interceptor') ? "LongWar.Icons.IC_Raven" : "LongWar.Icons.IC_Firestorm") $ "' height='16' width='16'>" $ kShip.m_strCallsign, "          " $ kShip.GetWeaponString(), class'UIUtilities'.static.GetHTMLColoredText(kShip.GetStatusString(), iStatusState), "", iShipState);
            }
        }

        foreach kContinentInfo.m_arrShipOrderIndexes(iOrderIndex)
        {
            kOrderInfo = kHQ.m_arrCEShipOrders[iOrderIndex];
            iDays = kOrderInfo.iHours / 24;

            if ((kOrderInfo.iHours % 24) > 0)
            {
                iDays += 1;
            }

            kTag.StrValue0 = string(iDays);
            tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strPendingOrderRemainingDays), eUIState_Warning);

            for (I = 0; I < kOrderInfo.iNumShips; I++)
            {
                // The Flash layer apparently expects a ship type, so for now, everything is interceptors or firestorms
                iShipType = kOrderInfo.nmShipType == 'Interceptor' ? eShip_Interceptor : eShip_Firestorm;

                if (manager.IsMouseActive())
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingInterceptorInfo, tmpStr, I == 0 ? m_strCancelHireButtonHelp : "", iShipType);
                }
                else
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingInterceptorInfo, tmpStr, "", iShipType);
                }
            }
        }

        if (kContinentInfo.nmContinent == kHQ.m_nmContinent)
        {
            kMgr.m_arrCEShipProjects.Length = 0;

            foreach kEngineering.m_arrCEItemProjects(kProject)
            {
                nmResultingShip = kItemTemplateMgr.FindItemTemplate(kProject.ItemName).nmResultingShip;

                if (nmResultingShip == '')
                {
                    continue;
                }

                iDays = kEngineering.LWCE_GetItemProjectHoursRemaining(kProject) / 24;

                if ((kProject.iHoursLeft % 24) > 0)
                {
                    iDays += 1;
                }

                kTag.StrValue0 = string(iDays);
                tmpStr = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strPendingOrderRemainingDays), eUIState_Warning);

                kMgr.m_arrCEShipProjects.AddItem(kProject);

                for (I = 0; I < kProject.iQuantity; I++)
                {
                    AS_AddPendingShip(iContinentIndex, m_strPendingFirestormInfo, tmpStr, "", eShip_Firestorm);
                }
            }
        }

        if (kContinentInfo.iNumShips < class'LWCE_XGFacility_Hangar'.default.iNumShipSlotsPerContinent)
        {
            if (manager.IsMouseActive())
            {
                AS_AddShip(iContinentIndex, m_strEmptySlotLabel, "", "", m_bTransferingShip ? m_strTransferShipHereButtonHelp : m_strHireShipButtonHelp, -1);
            }
            else
            {
                AS_AddShip(iContinentIndex, m_strEmptySlotLabel, "", "", "", -1);
            }

            AS_SetContinentTitle(iContinentIndex, kContinentInfo.strContinentName.StrValue @ strContinentCapacity);
        }
        else
        {
            tmpStr = class'UIUtilities'.static.GetHTMLColoredText(strContinentCapacity @ m_strFullContinentLabel, eUIState_Bad);
            AS_SetContinentTitle(iContinentIndex, kContinentInfo.strContinentName.StrValue @ tmpStr);
        }
    }
}