class LWCE_XGCyberneticsUI extends XGCyberneticsUI
    dependson(LWCE_XGFacility_CyberneticsLab);

// TODO: remove EItemType from everywhere in this class

struct LWCE_TUIDamagedInventoryItem
{
    var name ItemName;
    var string strName;
    var int iState;
    var bool bCanRepair;
    var string strCostLabel;
    var string strDescription;
    var array<TLabeledText> arrCost;
};

var array<LWCE_TUIDamagedInventoryItem> m_arrRepairingItems;

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int soldierListIndex)
{
    local TTableMenuOption kOption;
    local LWCE_XGStrategySoldier kCESoldier;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (!kCESoldier.CanBeAugmented())
    {
        kOption.iState = eUIState_Disabled;
    }
    else
    {
        kOption.iState = eUIState_Good;
    }

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 7:
                if (kCESoldier.m_kCEChar.iClassId == 0 || kCESoldier.GetRank() < 2)
                {
                    strCategory = m_strRookieState;
                    iState = eUIState_Disabled;
                }
                else
                {
                    strCategory = kCESoldier.GetStatusString();
                    iState = kCESoldier.GetStatusUIState();
                }

                break;
            case 0:
                strCategory = string(kCESoldier.m_kSoldier.iCountry);
                break;
            case 1:
                strCategory = string(kCESoldier.GetRank());
                break;
            case 2:
                strCategory = string(kCESoldier.GetEnergy());
                break;
            case 3:
                strCategory = kCESoldier.GetClassName();
                break;
            case 4:
                strCategory = kCESoldier.GetName(8); // exp I think
                break;
            case 5:
                strCategory = kCESoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kCESoldier.GetName(eNameType_Nick);
                break;
            case 8:
                if (kCESoldier.HasAvailablePerksToAssign())
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 9:
                if (kCESoldier.HasAvailablePerksToAssign(true))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 10:
                if (kCESoldier.m_kChar.bHasPsiGift)
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 11:
                if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 13:
                iState = kCESoldier.GetSHIVRank();
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kCESoldier.m_arrMedals);
                break;
            case 14:
                strCategory = string(soldierListIndex);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function UpdateInventory()
{
    local array<LWCEItemTemplate> arrDamagedItems;
    local LWCEItemTemplate kItem;
    local LWCE_TRepairingItem kRepairingItem;
    local LWCE_TUIDamagedInventoryItem kUIDamagedItem;
    local int iItemCount;

    m_arrRepairingItems.Length = 0;

    kUIDamagedItem.arrCost = GetRepairCosts(none, true);
    kUIDamagedItem.strName = m_strBuildNewMEC;
    kUIDamagedItem.strCostLabel = "";
    kUIDamagedItem.iState = eUIState_Normal;

    m_arrRepairingItems.AddItem(kUIDamagedItem);

    arrDamagedItems = `LWCE_STORAGE.LWCE_GetDamagedItemsInCategory('All');

    foreach arrDamagedItems(kItem)
    {
        for (iItemCount = `LWCE_STORAGE.LWCE_GetNumDamagedItems(kItem.GetItemName()); iItemCount > 0; iItemCount--)
        {
            m_arrRepairingItems.AddItem(GenerateDamagedItem(kItem));
        }
    }

    foreach LWCE_XGFacility_CyberneticsLab(CYBERNETICSLAB()).m_arrRepairingItems(kRepairingItem)
    {
        m_arrRepairingItems.AddItem(GenerateRepairingItem(kRepairingItem));
    }
}

simulated function LWCE_TUIDamagedInventoryItem GenerateDamagedItem(LWCEItemTemplate kItem)
{
    local LWCE_TUIDamagedInventoryItem kUIItem;
    local int iCost;

    kUIItem.strName = class'UIUtilities'.static.GetHTMLColoredText(m_strLabelDamaged, eUIState_Bad) @ kItem.strName;
    kUIItem.iState = eUIState_Normal;
    kUIItem.ItemName = kItem.GetItemName();
    kUIItem.strCostLabel = m_strRepairCostLabel;
    kUIItem.arrCost = GetRepairCosts(kItem, false);
    kUIItem.bCanRepair = true;

    for (iCost = 0; iCost < kUIItem.arrCost.Length; iCost++)
    {
        if (kUIItem.arrCost[iCost].iState == eUIState_Bad)
        {
            kUIItem.iState = eUIState_Disabled;
            kUIItem.bCanRepair = false;
            break;
        }
    }

    kUIItem.strDescription = GenerateItemDescription(kItem);

    return kUIItem;
}

simulated function string GenerateItemDescription(LWCEItemTemplate kItem)
{
    return class'UIUtilities'.static.CapsCheckForGermanScharfesS(kItem.strName) $ "||" $ kItem.strBriefSummary $ "||Repair";
}

simulated function LWCE_TUIDamagedInventoryItem GenerateRepairingItem(LWCE_TRepairingItem kRepairingItem)
{
    local LWCE_TUIDamagedInventoryItem kUIItem;
    local LWCEItemTemplate kItem;
    local XGParamTag kTag;

    kItem = `LWCE_ITEM(kRepairingItem.ItemName);

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = kItem.strName;
    kTag.IntValue0 = kRepairingItem.iHoursLeft / 24;

    kUIItem.strName = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strLabelRepairing), eUIState_Warning);
    kUIItem.iState = eUIState_Normal;
    kUIItem.ItemName = kRepairingItem.ItemName;
    kUIItem.bCanRepair = false;
    kUIItem.strDescription = GenerateItemDescription(kItem);

    return kUIItem;
}

// Updated version of GetMecCosts, which was hacked pretty heavily by LW 1.0 to support item repairs
simulated function array<TLabeledText> GetRepairCosts(LWCEItemTemplate kItem, bool bIsRepairAll)
{
    local array<TLabeledText> arrCosts;
    local TLabeledText kResourceText;
    local LWCE_XGFacility_CyberneticsLab kCyberneticsLab;
    local LWCE_XGStorage kStorage;
    local float fMecRepairCostMod;
    local int iAlloyCost, iEleriumCost, iMeldCost, iMoneyCost, iHours, Index;

    kStorage = LWCE_XGStorage(STORAGE());
    kCyberneticsLab = LWCE_XGFacility_CyberneticsLab(CYBERNETICSLAB());
    fMecRepairCostMod = class'XGFacility_CyberneticsLab'.default.m_fMecRepairCostMod;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(MiracleWorkers)))
    {
        if (!bIsRepairAll)
        {
            iHours = kCyberneticsLab.GetHoursToRepairItem(kItem.GetItemName()) / 24;
            kResourceText.StrValue = string(iHours);
            kResourceText.strLabel = m_strLabelDays;
            kResourceText.iState = eUIState_Normal;
            arrCosts.AddItem(kResourceText);
        }

        return arrCosts;
    }

    if (bIsRepairAll)
    {
        // Sum up costs across all damaged items
        for (Index = 0; Index < kStorage.m_arrCEDamagedItems.Length; Index++)
        {
            kItem = `LWCE_ITEM(kStorage.m_arrCEDamagedItems[Index].ItemName);

            iAlloyCost   += int(float(kItem.kCost.iAlloys)  * fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iEleriumCost += int(float(kItem.kCost.iElerium) * fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iMeldCost    += int(float(kItem.kCost.iMeld)    * fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iMoneyCost   += int(float(kItem.kCost.iCash)    * fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
        }
    }
    else
    {
        // Just get costs for the requested item
        iAlloyCost   = int(float(kItem.kCost.iAlloys)  * fMecRepairCostMod);
        iEleriumCost = int(float(kItem.kCost.iElerium) * fMecRepairCostMod);
        iMeldCost    = int(float(kItem.kCost.iMeld)    * fMecRepairCostMod);
        iMoneyCost   = int(float(kItem.kCost.iCash)    * fMecRepairCostMod);
    }

    if (iMoneyCost > 0)
    {
        kResourceText.StrValue = ConvertCashToString(iMoneyCost);
        kResourceText.iState = iMoneyCost <= GetResource(eResource_Money) ? eUIState_Cash : eUIState_Bad;
        arrCosts.AddItem(kResourceText);
    }

    if (iMeldCost > 0)
    {
        kResourceText.iState = iMeldCost <= GetResource(eResource_Meld) ? eUIState_Meld : eUIState_Bad;
        kResourceText.StrValue = string(iMeldCost);
        kResourceText.strLabel = "#MELDTAG";
        arrCosts.AddItem(kResourceText);
    }

    if (iEleriumCost > 0)
    {
        kResourceText.iState = iEleriumCost <= GetResource(eResource_Elerium) ? eUIState_Normal : eUIState_Bad;
        kResourceText.StrValue = string(iEleriumCost);
        kResourceText.strLabel = GetResourceLabel(eResource_Elerium);
        arrCosts.AddItem(kResourceText);
    }

    if (iAlloyCost > 0)
    {
        kResourceText.iState = iAlloyCost <= GetResource(eResource_Alloys) ? eUIState_Normal : eUIState_Bad;
        kResourceText.StrValue = string(iAlloyCost);
        kResourceText.strLabel = GetResourceLabel(eResource_Alloys);
        arrCosts.AddItem(kResourceText);
    }

    if (!bIsRepairAll)
    {
        iHours = kCyberneticsLab.GetHoursToRepairItem(kItem.GetItemName()) / 24;
        kResourceText.StrValue = string(iHours);
        kResourceText.strLabel = m_strLabelDays;
        kResourceText.iState = eUIState_Normal;
        arrCosts.AddItem(kResourceText);
    }

    return arrCosts;
}

function bool OnChooseSoldier(int iOption)
{
    local int soldierListIndex;

    if (m_kSoldierTable.mnuSoldiers.arrOptions[iOption].iState == eUIState_Good)
    {
        soldierListIndex = int(m_kSoldierTable.mnuSoldiers.arrOptions[iOption].arrStrings[14]);
        PRES().UISoldierAugmentation(BARRACKS().m_arrSoldiers[soldierListIndex]);
        PlayGoodSound();
        return true;
    }
    else
    {
        PlayBadSound();
        return false;
    }
}

function OnChooseSlot(int iSlot)
{
    if (iSlot < CYBERNETICSLAB().m_arrPatients.Length)
    {
        PlayBadSound();
    }
    else
    {
        GoToView(eCyberneticsLabView_Add);
        `HQPRES.UISoldierList(class'LWCE_UISoldierList_CyberneticsLab');
        PlayGoodSound();
    }
}

simulated function RepairAll()
{
    local int Index;
    local LWCE_XGFacility_CyberneticsLab kCyberneticsLab;
    local LWCE_XGStorage kStorage;

    kCyberneticsLab = LWCE_XGFacility_CyberneticsLab(CYBERNETICSLAB());
    kStorage = LWCE_XGStorage(STORAGE());

    for (Index = 0; Index < kStorage.m_arrCEDamagedItems.Length; Index++)
    {
        kCyberneticsLab.AddItemForRepair(kStorage.m_arrCEDamagedItems[Index].ItemName, kStorage.m_arrCEDamagedItems[Index].iQuantity);
    }

    UpdateView();
}